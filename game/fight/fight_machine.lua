-- Fight Manager is responsible for fight logic

-- It is expected that game objects use this module for interaction in a fight

local M = {}

M.KEYS = { hash("attack"), hash("block"), hash("left"), hash("right"), hash("up"), hash("down") }
M.BLOCK_KEYS = { hash("block") }
M.ATTACK_KEYS = { hash("attack") }

M.contains = function(tab, val)
	for index, value in ipairs(tab) do
		-- We grab the first index of our sub-table instead
		if value == val then
			return true
		end
	end
	return false
end

M.actions = {
	input_attack_id = "input_attack",
	input_counter_id = "input_counter",
	prepare_id = "prepare",
	attack_id = "attack",
	fail_id = "fail",
	counter_id = "counter",
	damage_id = "damage",
	tire_id = "tire",
	reset_stamina_id = "reset_stamina",
	die_id = "die",
	next_round_id = "next_round",
	finish_id = "finish"
}

local round = 0
local action = nil
local is_player = 0
local is_waiting_player = false
local input_requested = nil


local attacks = { 
	{ hash("block") },
	{ hash("left"), hash("block") },
	{ hash("down"), hash("block") },
	{ hash("up"), hash("block") }
}

local function get_random_attack()
	local index = math.floor(1 + math.random() * #attacks)
	return attacks[index]
end

local function get_attack_action(is_player, sequence)
	local attack_sequence = sequence
	if attack_sequence == nil then
		attack_sequence = get_random_attack()
	end
	local cost = #attack_sequence
	if cost < 1 then
		cost = 2
	end
	return {
		id = M.actions.attack_id,
		type = attack_sequence,
		cost = cost,
		damage = 1,
		delay = 1,
		is_player = is_player
	}
end

local function get_attack_actions(char)
	-- first let's decide the action
	if is_player then
		-- if it's a player action, then input is required
		is_waiting_player = true
		input_requested = {
			id = M.actions.input_attack_id,
			value = char.stamina
		}
		return {
			{
				id = M.actions.prepare_id,
				is_player = is_player
			},
			input_requested
		}
	else
		action = get_attack_action(false)
		-- is it's npc fighter, then action and cost are pre-defined
		is_waiting_player = true
		input_requested = {
			id = M.actions.input_counter_id,
			sequence = action.type
		}
		return {
			{
				id = M.actions.prepare_id,
				is_player = false
			},
			input_requested
		}
	end
end

local function get_counter_actions(action)
	if action.counter.status then
		-- counter is succesful
		return {
			{
				id = M.actions.tire_id,
				value = action.cost,
				is_player = action.is_player
			},
			{
				id = M.actions.tire_id,
				value = 1,
				is_player = not action.is_player
			},
			{
				id = M.actions.counter_id,
				is_player = not action.is_player
			},
			{
				id = M.actions.fail_id,
				is_player = action.is_player
			}
		}
	else
		-- counter is failed
		if action.counter.attempt then
			-- counter attempted
			return {
				{
					id = M.actions.tire_id,
					value = action.cost,
					is_player = action.is_player
				},
				{
					id = M.actions.tire_id,
					value = 1,
					is_player = not action.is_player
				},
				{
					id = M.actions.damage_id,
					value = action.damage,
					is_player = not action.is_player
				},
				{
					id = M.actions.attack_id,
					is_player = action.is_player
				}
			}
		else
			-- counter is not even attempted
			return {
				{
					id = M.actions.tire_id,
					value = action.cost,
					is_player = action.is_player
				},
				{
					id = M.actions.damage_id,
					value = action.damage,
					is_player = not action.is_player
				},
				{
					id = M.actions.attack_id,
					is_player = action.is_player
				}
			}
		end
	end
end

local function get_enemy_counter_action(action)
	local is_attack_failed = #action.type == 0
	if is_attack_failed then
		action.counter = { status = true, cost = 0 }
		return get_counter_actions(action)
	end
	local player_attack = action.type;
	local random_value = math.random()
	if random_value < 0.5 then
		-- enemy blocked
		action.counter = {
			status = true,
			cost = 1
		}
	else
		-- enemy failed to block
		if random_value < 0.75 then
			-- didn't even try
			action.counter = {
				status = false,
				cost = 0
			}
		else
			-- attempted
			action.counter = {
				status = false,
				cost = 0
			}
		end
	end

	return get_counter_actions(action)
end

local function get_actions(player, enemy)
	if action == nil then
		-- new action required

		-- check if dead
		if player.health == 0 then
			return {
				{
					id = M.actions.die_id,
					is_player = true
				}
			}
		elseif enemy.health == 0 then
			return {
				{
					id = M.actions.die_id,
					is_player = false
				},
				{
					id = M.actions.finish_id,
					is_player = false
				}
			}
		end

		local current = enemy
		if is_player then
			current = player
		end

		if current.stamina > 0 then
			-- current fighter is capable to continue

			return get_attack_actions(current)
		else
			-- current fighter is done and fight goes to next round
			round = round + 1
			is_player = not is_player
			return {
				{
					id = M.actions.reset_stamina_id,
					is_player = is_player
				},
				{
					id = M.actions.reset_stamina_id,
					is_player = not is_player
				},
				{
					id = M.actions.next_round_id,
					is_player = is_player
				}
			}
		end
	else
		-- continue current action
		if action.counter == nil then
			-- player has chosen attack
			local local_action = action
			action = nil
			local counter_actions_list = get_enemy_counter_action(local_action)
			table.insert(counter_actions_list, {
				id = M.actions.next_round_id,
				is_player = is_player
			})
			return counter_actions_list
		else
			-- counter phase is due, we can be here only if is_player false
			local local_action = action
			action = nil
			local counter_actions_list = get_counter_actions(local_action)
			table.insert(counter_actions_list, {
				id = M.actions.next_round_id,
				is_player = is_player
			})
			return counter_actions_list
		end
	end
end

M.start = function()
	round = 1
	action = nil
	is_waiting_player = false
	--local random_number = math.random()
	--if random_number >= 0.5 then
	--	next_char = player
	--else
	is_player = true
	--end
end

M.next = function(player, enemy)
	if is_waiting_player then
		return {
			round = round,
			actions = { input_requested }
		}
	end

	return {
		round = round,
		actions = get_actions(player, enemy)
	}
end

M.send_input = function(input, params)
	is_waiting_player = false
	input_requested = nil
	if input == M.actions.input_counter_id then
		if params.status then
			action.counter = {
				status = true,
				cost = 1
			}
			
		else
			action.counter = {
				status = false,
				cost = 0
			}
			if params.attempt then
				action.cost = 1
			end
		end
	elseif input == M.actions.input_attack_id then
		-- check if attach succesful
		local is_success = M.contains(M.ATTACK_KEYS, params.sequence[#params.sequence])
		print("So, ", params.sequence[#params.sequence], "is", is_success)
		if is_success then
			action = get_attack_action(true, params.sequence)
		else
			action = get_attack_action(true, {})
		end
	end
end

return M