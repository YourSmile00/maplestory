require("app/constants/constants")

 left_key = cc.KeyCode.KEY_A + 3
 right_key = cc.KeyCode.KEY_D + 3
 jump_key = cc.KeyCode.KEY_K + 3
 down_key = cc.KeyCode.KEY_S + 3

local Hero = class("Hero",function()
    return require("app/entity/BaseEntity"):create()
end
)
local YZLStateMachine = require("app/FSM/YZLStateMachine")
local HeroPManager = require("app/entity/hero/HeroPManager")

local HeroStand = require("app/entity/hero/HeroState")("HeroStand")
local HeroWalk = require("app/entity/hero/HeroState")("HeroWalk")
local HeroJump = require("app/entity/hero/HeroState")("HeroJump")
local HeroJumpDown = require("app/entity/hero/HeroState")("HeroJumpDown")
local HeroGlobal = require("app/entity/hero/HeroState")("HeroGlobal")

function Hero:create()
    local hero = Hero.new()
    hero:init()
    return hero
end

function Hero:init()
    self.velocity = cc.p(0,0)
    self.direction = 0
    self.speed = .5
   
    self.isMoving = false
    
    
    self.targetY = -1
    self.keys = {}
    
    self:initParts()
    self:initState()
    self:initEvent()
end

function Hero:initParts()
    
   self.pManager = HeroPManager.new(self)
end

function Hero:initState()
    self.stateMachine = YZLStateMachine.new(self)
    self.stateMachine.states = {}
    local states = self.stateMachine.states
    states[HS_WALK] = HeroWalk.new()
    states[HS_STAND] = HeroStand.new()
    states[HS_JUMP] = HeroJump.new()
    states[HS_JUMP_DOWN] = HeroJumpDown.new()
    
    self.stateMachine.currentState = states[HS_STAND]
    self.stateMachine.globalState = HeroGlobal.new()
    self.stateMachine.currentState:onStateEnter(self)
       
   
end	

function Hero:initEvent()
	local function onKeyPressed(keyCode,event)
	    table.insert(self.keys,1,keyCode)
		self:handleInputKeys(self.keys)
		self.pManager:forceSwithParts(self.stateMachine.currentState.type)
		--self.stateMachine.currentState.frameDelta = 5 --make frameDelta max so next frame can change direction
	end
	local function onKeyReleased(keyCode,event)
	    for i,v in ipairs(self.keys) do
	       if v == keyCode then
	       	table.remove(self.keys,i)
	       	break
	       end
	    end
	    --print("keys",#self.keys)
	    local curKey = self.keys[1]
	    local curStateType = self.stateMachine.currentState.type
	    if curKey ~= null then
	       if curKey == left_key then
            self.direction = 1
            if curStateType == HS_STAND  then
              self.stateMachine:changeState(self.stateMachine.states[HS_WALK])
            end
           elseif curKey == right_key then
            self.direction = 2
          
            if curStateType == HS_STAND then
              self.stateMachine:changeState(self.stateMachine.states[HS_WALK])
            end
           elseif curKey == jump_key then
            self.stateMachine:changeState(self.stateMachine.states[HS_JUMP])
           end
        self.pManager:forceSwithParts(curStateType)
		else
		  if keyCode == left_key or keyCode == right_key then
            self.stateMachine:changeState(self.stateMachine.states[HS_STAND])
          end
        end
    end

    local dispatcher = cc.Director:getInstance():getEventDispatcher()
    local listener = cc.EventListenerKeyboard:create()
    listener:registerScriptHandler(onKeyPressed,cc.Handler.EVENT_KEYBOARD_PRESSED)
    listener:registerScriptHandler(onKeyReleased,cc.Handler.EVENT_KEYBOARD_RELEASED)
    dispatcher:addEventListenerWithSceneGraphPriority(listener,self)
end

function Hero:onEnter()
    local update = function (dt)
        self.stateMachine:update()
    end
    self:scheduleUpdateWithPriorityLua(update,1)
end



function Hero:handleInputKeys(keys)
    
	if #keys ==1 then
	   local keyCode = keys[1]
	   if keyCode == left_key then
            self.direction = 1
            if self.stateMachine.currentState.type == HS_STAND then
                self.stateMachine:changeState(self.stateMachine.states[HS_WALK])
            end
        elseif keyCode == right_key then
            self.direction = 2
            if self.stateMachine.currentState.type == HS_STAND then
              self.stateMachine:changeState(self.stateMachine.states[HS_WALK])
          end
        elseif keyCode == jump_key then
            self.stateMachine:changeState(self.stateMachine.states[HS_JUMP])
        end
    elseif #keys == 2 then
        local key1,key2 = keys[2],keys[1]
        if key1 == left_key  and key2 == jump_key then
            print("left jump")
            self.direction = 1
            self.stateMachine:changeState(self.stateMachine.states[HS_JUMP])
        elseif key1 == right_key  and key2 == jump_key then
            self.direction = 2
            self.stateMachine:changeState(self.stateMachine.states[HS_JUMP])
        elseif (key1 == left_key or key1 == right_key) and
               (key2 == left_key or key2 == right_key) then
            self:handleInputKeys({key2})
        elseif key1 == down_key and key2 == jump_key then
            local scene = self:getParent()
            if self.stateMachine.currentState.type == HS_STAND then
                local isdown = scene:canJumpDownAtTile(self.tileGID)
                print(isdown)
                if isdown then
                self.stateMachine:changeState(self.stateMachine.states[HS_JUMP_DOWN])
            end end
        end
	end
end

function Hero:collisionDetect()
    local delta = cc.Director:getInstance():getDeltaTime()
	local scene = self:getParent()
	local targetY = 0
	if self.isIgnoreTargetY == false then
     targetY = scene:getRoadY(self)
    end
   local velocity = cc.p(0,0)
   velocity = cc.pAdd(self.velocity,cc.p(0,Gravity*delta))
   if self:getPositionY() == targetY then
   velocity = cc.pAdd(velocity,cc.p(0,-Gravity*delta))
   end 
   self.velocity = velocity
   
    local posTemp = cc.p(self:getPositionX()+self.velocity.x*delta,
                           self:getPositionY()+self.velocity.y*delta)
    
    print(self:getPositionY())
    print(targetY)
    if posTemp.y<targetY then
        if 
             velocity.y<=0  then
            self.velocity = cc.p(0,0)
           
            posTemp.y = targetY
            --print(targetY)
        end
    else
    end
    self:setPosition(posTemp)
    if self.targetY ~= targetY then
        
        self.targetY = targetY
    end
    --print("posy",self:getPositionY())
end

return Hero