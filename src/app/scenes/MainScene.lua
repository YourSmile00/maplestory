
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

function MainScene:getCollisionTargetY(entity)
	
	--for idx,v in ipairs(self.terrains) do
	local x,y = entity:getPosition()
	   local roadLevel = entity.roadLevel
	   if roadLevel > #self.terrains then
	   	roadLevel = #self.terrains
	   	entity.roadLevel = roadLevel
	   end
	   local v
	   if roadLevel > 1 and 
	   entity.stateMachine.currentState.type == HS_JUMP then
	       for i = roadLevel-1,roadLevel do
	           v = self.terrains[i]
	           for i,pos in ipairs(v) do
                   local offsetX = -self.scene:getPositionX()
                --print(offsetX+x)
	               if pos.x > x+offsetX then
	                   local targetY = 
	                   self:_getTargetY(x+offsetX,v[i-1],v[i])
	           -- print(targetY)
	                   entity.roadLevel = i
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
                --print(targetY)
                return targetY
            end
        end
	   end
end

function MainScene:_getTargetY(x,pos1,pos2)
    
	return (x-pos2.x)/(pos1.x-pos2.x)*(pos1.y-pos2.y)+pos2.y
end

return MainScene
