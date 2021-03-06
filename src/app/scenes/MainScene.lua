require("lsqlite3")

local MainScene = class("MainScene", function()
    return display.newScene("MainScene")
end)

function cc.pFromString(str)
	local comma = string.find(str,",")
	return cc.p(tonumber(string.sub(str,1,comma-1)),
	            tonumber(string.sub(str,comma+1,-1)))
end

function MainScene:ctor()
    local scene = cc.CSLoader:createNode("map1.0.0.0.csb")
                :addTo(self)
                :pos(0,0)
    self.scene = scene
    --[[local hero = require("app/entity/hero/Hero"):create()
                :addTo(self)
                :pos(display.cx,display.cy)
    self.hero = hero
    -- print(display.contentScaleFactor)          
    self.map = scene:getChildByName("Map_1")
    
    --获取路线--分级
    self.terrains = {}
    local terrain = {}
    local roadlevel = 1
    for _,v in ipairs(self.map:getObjectGroup("terrain"):getObjects()) do
           if tonumber(v.roadlevel) == roadlevel then
    	       local road = {}
    	       for _,v2 in ipairs(v.polylinePoints) do
    	           table.insert(road,{x=v.x+v2.x,y=-v2.y+v.y})
    	       end
    	   table.insert(terrain,road)
    	   else 
    	       table.insert(self.terrains,terrain)
    	       roadlevel = roadlevel + 1
    	       terrain = {}
    	       if tonumber(v.roadlevel) == roadlevel then
               local road = {}
               for _,v2 in ipairs(v.polylinePoints) do
                   table.insert(road,{x=v.x+v2.x,y=-v2.y+v.y})
               end
               table.insert(terrain,road)
               end
    	  end
    end
    table.insert(self.terrains,terrain)]]
    
end

function MainScene:onEnter()
end

function MainScene:onExit()
end

-- make use of tile propery to get collisionY 

function MainScene:getRoadY(entity)
    local x,y = entity:getPosition()
    local rx,ry = x-self.scene:getPositionX(),y-self.scene:getPositionY()
    local tiledx = math.floor(rx/30)
    local tempy = math.floor(ry/30)
    local tiledy = self.map:getMapSize().height-1-tempy
    entity.tiledCoor = cc.p(tiledx,tiledy)
    local gid = self.map:getLayer("collision"):getTileGIDAt(cc.p(tiledx,tiledy))
    entity.tileGID = gid
    if gid == 0 then
        return 0
    end
    local dic = self.map:getPropertiesForGID(gid) 
    local leftp = cc.pFromString(dic.leftp)
    local rightp = cc.pFromString(dic.rightp)
    --print(rightp.x,rightp.y)
    local rTargetY = self:_getTargetY(rx-tiledx*30,leftp,rightp)
    --print(rTargetY)
    if rTargetY < 0 then return 0 end
    return rTargetY + tempy * 30
end

function MainScene:getCollisionTargetY(entity,roadlevel)
	
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
	                   --print("roadlevel",i)
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
                --print("roadlevel",roadLevel)
                return targetY
            end
        end
	   end
end

function MainScene:_getTargetY(x,pos1,pos2)
    if pos1.y == pos2.y then
        if x>=pos1.x and x <= pos2.x then
            return pos1.y
        else
            return -1
        end 
    end
	return (x-pos2.x)/(pos1.x-pos2.x)*(pos1.y-pos2.y)+pos2.y
end

function MainScene:canJumpDownAtTile(gid)
	if gid == 0 then
		return false
	end
	local dic = self.map:getPropertiesForGID(gid)
	if dic.candown == "0" then
		return false
    else
        return true
	end
end

return MainScene
