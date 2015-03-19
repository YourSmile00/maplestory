local YZLState = {}

function YZLState.new()
	local state = {}
	
	setmetatable(state,YZLState)
	YZLState.__index = YZLState
    state:ctor()
	return state
end

function YZLState:ctor()
	
end

function YZLState:onStateEnter(baseEntity)
    
end

function YZLState:onStateExit(baseEntity)
	
end

function YZLState:excute(baseEntity)
	
end

return YZLState
