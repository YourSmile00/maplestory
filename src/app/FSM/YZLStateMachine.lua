local StateMachine = {}

function StateMachine.new(entity)
	local machine = {entity = entity}
	setmetatable(machine,StateMachine)
	StateMachine.__index = StateMachine
	return machine
end

function StateMachine:update()
	if self.globalState then
		self.globalState:execute(self.entity)
	end
	if self.currentState then
		self.currentState:execute(self.entity)
	end
end

function StateMachine:changeState(state)
	if self.currentState then
		self.currentState:onStateExit(self.entity)
	end
	self.currentState = state
	self.currentState:onStateEnter(self.entity)
end

return StateMachine