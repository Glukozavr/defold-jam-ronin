-- Fight Manager is responsible for fight logic

-- It is expected that game objects use this module for interaction in a fight
-- Well... It's a Jam project, don't expect much

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
local attack_level = 1
local attacks_history = {}
local function table_to_string(table)
	local result = ""
	for i=1, #table do
		result = result .. table[i]
	end
	return result
end
local function store_attack(attack)
	attack = table_to_string(attack)
	table.insert(attacks_history, 1, attack)
	local limit = attack_level
	if limit > 3 then
		limit = 3
	end
	if #attacks_history > limit then
		local index = limit + 1
		local a = attacks_history[index]
		while not (a == nil) do
			attacks_history[index] = nil
			index = index + 1
			a = attacks_history[index]
		end
	end
	print("history contains now")
	for i=1, #attacks_history do
		print(attacks_history[i])
	end
end
local function reset_history()
	attacks_history = {}
end
local function is_stored(attack)
	print("history contains")
	for i=1, #attacks_history do
		print(attacks_history[i])
	end
	attack = table_to_string(attack)
	return M.contains(attacks_history, attack)
end

local attacks = {
	{ 
		{ hash("block") }
	},
	{ 
		{ hash("block") },
		{ hash("left"), hash("block") }
	},
	{ 
		{ hash("block") },
		{ hash("left"), hash("block") },
		{ hash("down"), hash("block") },
		{ hash("up"), hash("block") }
	},
	{ 
		{ hash("block") },
		{ hash("left"), hash("block") },
		{ hash("down"), hash("block") },
		{ hash("up"), hash("block") },
		{ hash("right"), hash("block") }
	},
	{ 
		{ hash("block") },
		{ hash("left"), hash("block") },
		{ hash("down"), hash("block") },
		{ hash("up"), hash("block") },
		{ hash("right"), hash("block") }
	}
}

local function get_random_attack(stamina)
	if stamina < 2 then
		return attacks[attack_level][1]
	end
	local index = math.floor(1 + math.random() * #attacks[attack_level] )
	return attacks[attack_level][index]
end

local function get_attack_action(is_player, sequence)
	local attack_sequence = sequence
	local cost = #attack_sequence
	if cost < 1 then
		cost = 2
	end
	return {
		id = M.actions.attack_id,
		type = attack_sequence,
		cost = cost,
		damage = #attack_sequence,
		is_player = is_player
	}
end

local function get_delay()
	return 1.2 - (0.5 * (attack_level / 5))
end

local function get_attack_actions(char, other_char)
	-- first let's decide the action
	if is_player then
		-- if it's a player action, then input is required
		is_waiting_player = true
		input_requested = {
			id = M.actions.input_attack_id,
			stamina = char.stamina,
			delay = get_delay()
		}
		return {
			{
				id = M.actions.prepare_id,
				is_player = is_player
			},
			input_requested
		}
	else
		action = get_attack_action(false, get_random_attack(char.stamina))
		-- is it's npc fighter, then action and cost are pre-defined
		is_waiting_player = true
		input_requested = {
			id = M.actions.input_counter_id,
			stamina = other_char.stamina,
			sequence = action.type,
			delay = get_delay()
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
				value = action.counter.cost,
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

local function get_enemy_counter_action(action, stamina)
	local is_attack_failed = #action.type == 0
	if is_attack_failed then
		action.counter = { status = true, cost = 0 }
		return get_counter_actions(action)
	end
	if stamina < 1 then
		action.counter = {
			status = false,
			cost = 0
		}
		return get_counter_actions(action)
	end
	local player_attack = action.type;
	local is_used = is_stored(player_attack)
	if is_used then
		action.counter = {
			status = true,
			cost = 1
		}
	else
		action.counter = {
			status = false,
			cost = 0
		}
	end
	store_attack(player_attack)
	-- local random_value = math.random()
	-- if random_value < 0.5 then
		-- enemy blocked
	-- 	action.counter = {
	-- 		status = true,
	-- 		cost = 1
	-- 	}
	-- else
		-- enemy failed to block
	-- 	if random_value < 0.75 then
			-- didn't even try
	--		action.counter = {
	--			status = false,
	--			cost = 0
	--		}
	--	else
			-- attempted
	--		action.counter = {
	--			status = false,
	--			cost = 0
	--		}
	--	end
	--end

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
		local other = player
		if is_player then
			current = player
			other = enemy
		end

		if current.stamina > 0 then
			-- current fighter is capable to continue

			return get_attack_actions(current, other)
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
			local counter_actions_list = get_enemy_counter_action(local_action, enemy.stamina)
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

M.start = function(level)
	reset_history()
	attack_level = level
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
				cost = 0
			}
			
		else
			action.counter = {
				status = false,
				cost = 1
			}
			--if params.attempt then
			--	action.cost = 1
			--end
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