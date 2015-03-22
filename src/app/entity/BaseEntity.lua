local BaseEntity = class("BaseEntity",function ()
	return display.newNode()
end)

function BaseEntity:create()
	local entity = BaseEntity.new()
	entity:init()
	return entity
end

function BaseEntity:init()
	self:addNodeEventListener(cc.NODE_ON_ENTER,function(event)
	   if event.name == "enter" then
	       self:onEnter()
	   elseif event.name == "exit" then
	       self:onExit()
	   end
	end
	)
end

function BaseEntity:onEnter()
	print("BaseEntity enter")
end

function BaseEntity:onExit()
	print("BaseEntity exit")
end

return BaseEntity