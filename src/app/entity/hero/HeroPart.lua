require("app/data/hpdata")
local HeroPart = class("HeroPart",function ()
	return display.newNode()
end)


function HeroPart:create(type)
	local part = HeroPart.new()
	part:init(type)
	return part
end

function HeroPart:init(type)
	local partData = HPDATA[type]
    self.sprites = {}
	--if type(part) == "table" then
       for _,v in ipairs(partData.files) do 
		  local sprite = display.newSprite(v)
		              :addTo(self)
		  sprite:setVisible(false)
		  table.insert(self.sprites,sprite)

		end
		
        self.states = partData.states
		self.curIdx = 1
		self.curSprite = self.sprites[1]
		self.curSprite:setVisible(true)
		self.curSprite:setPosition(self.states[1].positions[1])
	
	--end
end

return HeroPart
