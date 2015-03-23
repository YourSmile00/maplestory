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
local HeroPart = require("app/entity/hero/HeroPart")
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
    self.direction = 0
    self.isMoving = false
    self.partIdx = 1
    self.roadLevel = 1
    self.targetY = -1
    
    self:initParts()
    self:initState()
    self:initEvent()
end

function Hero:initParts()
    self.keys = {}
    self.parts = {}
    self.head = HeroPart:create(HP_HEAD)
                :addTo(self,3)
    self.face = HeroPart:create(HP_FACE)
                :addTo(self,4)

    self.body = HeroPart:create(HP_BODY)
                :addTo(self,1)
    self.arm  = HeroPart:create(HP_ARM)
                :addTo(self,2)
    table.insert(self.parts,self.head)
    table.insert(self.parts,self.face)
    table.insert(self.parts,self.body)
    table.insert(self.parts,self.arm)
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
		self:forceSwithParts(self.stateMachine.currentState.type)
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
        self:forceSwithParts(curStateType)
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

function Hero:switchParts(state,maxIdx)

    local direction = self.direction
    if self.partIdx >= maxIdx then
        self.partIdx = 1
    end
    for _,part in ipairs(self.parts) do
       
        local index = part.states[state].indexes[self.partIdx] --显示的sprite的索引
           part.curSprite:setVisible(false)
           part.curSprite = part.sprites[index]
           
        local pos = part.states[state].positions[self.partIdx]
        if direction == 1 then
             part.curSprite:setFlippedX(false)
        elseif direction == 2 then
            part.curSprite:setFlippedX(true)
            pos = {x=-pos.x,y=pos.y}
        end
        if part.curSprite == nil then

            --print("index",part.curIdx,maxIdx)
           end
           part.curSprite:setPosition(pos)
          
           part.curSprite:setVisible(true)
           
           
        end
        self.partIdx = self.partIdx +1
end

function Hero:forceSwithParts(state)
    local direction = self.direction
    if state == HS_JUMP_DOWN then 
        state = HS_JUMP
    end
    for _,part in ipairs(self.parts) do
        local index = part.states[state].indexes[1] --显示的sprite的索引
        part.curSprite:setVisible(false)
        part.curSprite = part.sprites[index]
        local pos = part.states[state].positions[1]
        if direction == 1 then
            part.curSprite:setFlippedX(false)
        elseif direction == 2 then
            part.curSprite:setFlippedX(true)
            pos = {x=-pos.x,y=pos.y}
        end
        part.curSprite:setPosition(pos)
        part.curSprite:setVisible(true)
    end
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
            if self.roadLevel < #self:getParent().terrains then 
                self.roadLevel = self.roadLevel + 1
                self.stateMachine:changeState(self.stateMachine.states[HS_JUMP_DOWN])
            end
        end
	end
end

function Hero:collisionDetect()
    local delta = cc.Director:getInstance():getDeltaTime()
	local scene = self:getParent()
    local targetY = scene:getCollisionTargetY(self)
    self.targetY = targetY
   
   self.velocity = cc.pAdd(self.velocity,cc.p(0,Gravity*delta))
    --print(baseEntity.velocity.y)
    local posTemp = cc.p(self:getPositionX()+self.velocity.x*delta,
                           self:getPositionY()+self.velocity.y*delta)
    if self.stateMachine.currentState.type == HS_JUMP then
        print("targetY..",targetY)
    end
    if posTemp.y<targetY then
        
        if self.stateMachine.currentState.type ~= HS_JUMP then
            self:setPosition(posTemp.x,targetY)
            self.velocity = cc.p(0,0)
        else
            if self.velocity.y <= 0 then
                self:setPosition(posTemp.x,targetY)
            else
                self:setPosition(posTemp)
            end
        end
    else
       self:setPosition(posTemp) 
    end
    --print("posy",self:getPositionY())
end

return Hero