require("app/data/hpdata")
local HeroPart = class("HeroPart",function ()
	return display.newNode()
end)


function HeroPart:create(type,complexion)
	local part = HeroPart.new()
	part:init(type,complexion)
	return part
end

function HeroPart:init(type,complexion)
	local partData = HPDATA[type]
    self.sprites = {}
	--if type(part) == "table" then
       for _,v in ipairs(partData.files) do
          local name 
          if complexion ~= nil then
             name = string.format("%d/",complexion)..v
          else name = v
          end 
		  local sprite = display.newSprite(name)
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
