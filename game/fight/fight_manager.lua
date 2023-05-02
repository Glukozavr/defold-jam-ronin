-- Fight Manager is responsible for fight logic

-- It is expected that game objects use this module for interaction in a fight

local M = {}

local next_turn = 0
local total_fighters = 0

local attack_action = { anim_id = "attack", delay = 1, damage = 1, counter_id = "block", counter_sequence = { hash("block") } }
local forward_attack_action = { anim_id = "attack", delay = 1, damage = 2, counter_id = "back-block", counter_sequence = { hash("left"), hash("block") } }
local down_attack_action = { anim_id = "attack", delay = 1, damage = 1, counter_id = "down-block", counter_sequence = { hash("down"), hash("block") } }
local up_attack_action = { anim_id = "attack", delay = 1, damage = 1, counter_id = "up-block", counter_sequence = { hash("up"), hash("block") } }

local function get_attack_action()
	local random_number = math.random()
	if random_number < 0.25 then
		return attack_action
	elseif random_number < 0.5 then
		return forward_attack_action
	elseif random_number < 0.75 then
		return down_attack_action
	else
		return up_attack_action
	end
end

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
		action = get_attack_action()
	}
end

return M