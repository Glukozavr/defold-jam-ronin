-- Fight Manager is responsible for fight logic

-- It is expected that game objects use this module for interaction in a fight

local M = {}

local next_turn = 0
local total_fighters = 0

M.start = function(fighters_count)
	next_turn = 0
	total_fighters = fighters_count 
end

M.next = function()
	local this_turn = next_turn
	next_turn = next_turn + 1
	if next_turn >= total_fighters then
		next_turn = 0
	end
	
	return {
		id = this_turn,
		action = "attack"
	}
end

return M