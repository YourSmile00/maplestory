local HeroState = class("HeroState",function()
    return require("app/FSM/YZLState").new()
end
)

function HeroState:ctor()
	self.frameDelta = 0
end

function HeroState:onStateEnter(baseEntity)
end

function HeroState:onStateExit(baseEntity)

end

function HeroState:excute(baseEntity)

end 

---------global state ---------

local HeroGlobal = class("HeroGlobal",function ()
	return HeroState.new()
end)

function HeroGlobal:onStateEnter(baseEntity)
	
end

function HeroGlobal:onStateExit(baseEntity)
	
end

function HeroGlobal:execute(baseEntity)
    local maxLX = display.width*3/5
    local maxRX = display.width*2/5
    local scene = baseEntity:getParent()
    if baseEntity.direction==2 and baseEntity:getPositionX() > maxLX and 
        -scene.scene:getPositionX()+ display.width < scene.map:getContentSize().width then
        local offsetX = baseEntity:getPositionX()- maxLX
        scene.scene:setPositionX(scene.scene:getPositionX()-offsetX)
        baseEntity:setPositionX(maxLX)
        
    elseif baseEntity.direction == 1 and baseEntity:getPositionX()< maxRX and
        scene.scene:getPositionX() <0 then
        local offsetX = baseEntity:getPositionX()-maxRX
        scene.scene:setPositionX(scene.scene:getPositionX()-offsetX)
        baseEntity:setPositionX(maxRX)
    end
   -- print("heropos",baseEntity:getPositionX())
    
    
   -- baseEntity:collisionDetect()
end

---------stand-start-----------

local HeroStand = class("HeroStand",function()
    return HeroState.new()
end
)

function HeroStand:ctor()
	self.type = HS_STAND
end

function HeroStand:onStateEnter(baseEntity)
    self.frameDelta =0
    baseEntity:switchParts(HS_STAND,5)
    baseEntity.isMoving = false
end

function HeroStand:onStateExit(baseEntity)
    
end

function HeroStand:execute(baseEntity)
    self.frameDelta = cc.Director:getInstance():getDeltaTime()+self.frameDelta
    if self.frameDelta >= HS_STAND_DELTA then
        self.frameDelta = 0
        baseEntity:switchParts(HS_STAND,5)
    	
    end
end 
------------stand-end----------

------------walk-start-----------

local HeroWalk = class("HeroWalk",function ()
	return HeroState.new()
end)    

function HeroWalk:ctor()
    self.type = HS_WALK
end

function HeroWalk:onStateEnter(baseEntity)
	self.frameDelta = HS_WALK_DELTA
    baseEntity:switchParts(HS_WALK,5)
    baseEntity.isMoving = true
end

function HeroWalk:onStateExit(baseEntity)
	
end

function HeroWalk:execute(baseEntity)
    self.frameDelta = cc.Director:getInstance():getDeltaTime()+self.frameDelta
    if self.frameDelta >= HS_WALK_DELTA then
        self.frameDelta = 0
        baseEntity:switchParts(HS_WALK,5)
    end
    local x = 1
    if baseEntity.direction == 1 then
        x = -1
    end
    baseEntity:setPositionX(baseEntity:getPositionX()+x)
end
------------walk-end---------

-----jump-start-----

local HeroJump = class("HeroJump",function ()
	return HeroState.new()
end)

function HeroJump:ctor()
	self.type = HS_JUMP
end

function HeroJump:onStateEnter(baseEntity)
    
	baseEntity.velocity = cc.p(0,350)
    baseEntity:switchParts(HS_JUMP,1)
end

function HeroJump:onStateExit(baseEntity)
	
end

function HeroJump:execute(baseEntity)
	if baseEntity.targetY >= baseEntity:getPositionY() and 
	baseEntity.velocity.y<=0 then
	print("targetY",baseEntity.targetY)
	print("y",baseEntity:getPositionY())
	   local key = baseEntity.keys[1]
	   if key == left_key then
	       baseEntity.direction = 1
           baseEntity.stateMachine:changeState(baseEntity.stateMachine.states[HS_WALK])
	   elseif key == right_key then
	       baseEntity.direction = 2
	       baseEntity.stateMachine:changeState(baseEntity.stateMachine.states[HS_WALK])
	   else
		   baseEntity.stateMachine:changeState(baseEntity.stateMachine.states[HS_STAND])
	   end
	end
    local x = 0
    if baseEntity.isMoving  then
        x = 1
        if baseEntity.direction == 1 then
            x = -1
        end
    end
    baseEntity:setPositionX(baseEntity:getPositionX()+x)
end
--------jump end--------

--------xia jiang ------------

local HeroJumpDown = class("HeroJumpDown",function ()
	return HeroState.new()
end)

function HeroJumpDown:ctor()
	self.type = HS_JUMP_DOWN
end

function HeroJumpDown:onStateEnter(baseEntity)
    --baseEntity:runAction(cc.MoveBy:create(.1,{x=0,y=-5}))
    baseEntity:setPositionY(baseEntity:getPositionY()-5)
    baseEntity:switchParts(HS_JUMP,1)
end

function HeroJumpDown:execute(baseEntity)
	if baseEntity.targetY >= baseEntity:getPositionY() then
		baseEntity:setPositionY(baseEntity.targetY)
		baseEntity.stateMachine:changeState(baseEntity.stateMachine.states[HS_STAND])
	end
end

function HeroJumpDown:onStateExit(baseEntity)
	
end

--------xia jiang end----------
return function (name)
    print(name)
	if name == "HeroStand" then 
	   return HeroStand
	elseif name == "HeroWalk" then
	   return HeroWalk
	elseif name == "HeroJump" then
	   return HeroJump
	elseif name == "HeroJumpDown" then
	   return HeroJumpDown
	elseif name == "HeroGlobal" then
	   return HeroGlobal
	end
end