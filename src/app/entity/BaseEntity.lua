local BaseEntity = class("BaseEntity",function ()
	return display.newNode()
end)

function BaseEntity:create()
	local entity = BaseEntity.new()
	entity:init()
	return entity
end

function BaseEntity:init()
	
end

return BaseEntity