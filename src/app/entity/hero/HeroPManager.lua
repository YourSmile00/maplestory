local HeroPManager = class("HeroPManager")
local HeroPart = require("app/entity/hero/HeroPart")
function HeroPManager:ctor(hero)
	self.hero = hero
    self.partIdx = 1
    
    self.parts = {}
    self.head = HeroPart:create(HP_HEAD)
        :addTo(hero,3)
    self.face = HeroPart:create(HP_FACE)
        :addTo(hero,4)

    self.body = HeroPart:create(HP_BODY)
        :addTo(hero,1)
    self.arm  = HeroPart:create(HP_ARM)
        :addTo(hero,2)
    table.insert(self.parts,self.head)
    table.insert(self.parts,self.face)
    table.insert(self.parts,self.body)
    table.insert(self.parts,self.arm)
end

function HeroPManager:switchParts(state,maxIdx)
    local hero = self.hero
    local direction = hero.direction
    if self.partIdx >= maxIdx then
        self.partIdx = 1
    end
    for _,part in ipairs(self.parts) do
        if part.states[state] ~= nil then
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
        
            part.curSprite:setPosition(pos)

            part.curSprite:setVisible(true)
        end
    end
    self.partIdx = self.partIdx +1
end

function HeroPManager:forceSwithParts(state)
    local hero = self.hero
    local direction = hero.direction
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

return HeroPManager