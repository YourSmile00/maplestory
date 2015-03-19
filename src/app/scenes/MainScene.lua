
local MainScene = class("MainScene", function()
    return display.newScene("MainScene")
end)

function MainScene:ctor()
    local scene = cc.CSLoader:createNode("map1.0.0.0.csb")
                :addTo(self)
                :pos(0,0)
    self.scene = scene
    local hero = require("app/entity/hero/Hero"):create()
                :addTo(self)
                :pos(display.cx,display.cy)
    self.hero = hero
    -- print(display.contentScaleFactor)          
    self.map = scene:getChildByName("Map_1")
    
    local update = function (dt)
        local maxLX = display.width*3/5
        local maxRX = display.width*2/5
        
        if hero.direction==2 and hero:getPositionX() > maxLX and 
        -self.scene:getPositionX()+ display.width < self.map:getContentSize().width then
            local offsetX = hero:getPositionX()- maxLX
            scene:setPositionX(scene:getPositionX()-offsetX)
            hero:setPositionX(maxLX)
        elseif hero.direction == 1 and hero:getPositionX()< maxRX and
        self.scene:getPositionX() <0 then
            local offsetX = hero:getPositionX()-maxRX
            scene:setPositionX(scene:getPositionX()-offsetX)
            hero:setPositionX(maxRX)
        end
        
        local targetY = self:getCollisionTargetY(hero:getPosition())
        if hero:getPositionY()> targetY then
            hero:setPositionY(hero:getPositionY()-1)
            hero.targetY = targetY
        elseif hero:getPositionY()<targetY then
            if hero.stateMachine.currentState.type ~= HS_JUMP then
                hero:setPositionY(targetY)
            end
            hero.targetY = targetY
        end
    end
    self:scheduleUpdateWithPriorityLua(update,1)
    self.terrains = {}
    for i,v in ipairs(self.map:getObjectGroup("terrain"):getObjects()) do
    	   local terrain = {}
    	   for _,v2 in ipairs(v.polylinePoints) do
    	       table.insert(terrain,{x=v.x+v2.x,y=-v2.y+v.y})
    	   end
    	   table.insert(self.terrains,terrain)
    end
end

function MainScene:onEnter()
end

function MainScene:onExit()
end

function MainScene:getCollisionTargetY(x,y)
	
	--for idx,v in ipairs(self.terrains) do
	   local roadLevel = self.hero.roadLevel
	   if roadLevel > #self.terrains then
	   	roadLevel = #self.terrains
	   	self.hero.roadLevel = roadLevel
	   end
	   local v
	   if roadLevel > 1 and 
	   self.hero.stateMachine.currentState.type == HS_JUMP then
	       for i = roadLevel-1,roadLevel do
	           v = self.terrains[i]
	           for i,pos in ipairs(v) do
                   local offsetX = -self.scene:getPositionX()
                --print(offsetX+x)
	               if pos.x > x+offsetX then
	                   local targetY = 
	                   self:_getTargetY(x+offsetX,v[i-1],v[i])
	           -- print(targetY)
	                   self.hero.roadLevel = i
	                   print(targetY)
	       	           return targetY
	               end
	           end
	       end
	   else
           v = self.terrains[roadLevel]
           for i,pos in ipairs(v) do
            local offsetX = -self.scene:getPositionX()
            --print(offsetX+x)
            if pos.x > x+offsetX then
                local targetY = 
                    self:_getTargetY(x+offsetX,v[i-1],v[i])
                print(targetY)
                return targetY
            end
        end
	   end
end

function MainScene:_getTargetY(x,pos1,pos2)
    
	return (x-pos2.x)/(pos1.x-pos2.x)*(pos1.y-pos2.y)+pos2.y
end

return MainScene
