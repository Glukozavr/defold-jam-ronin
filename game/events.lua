-- Put functions in this file to use them in several other scripts.
-- To get access to the functions, you need to put:
-- require "my_directory.my_file"
-- in any script using the functions.
local M = {}
M.EVENTS = {}

M.EVENTS.DISCOVERY = hash("discovery_started")
M.EVENTS.FIGHT = hash("fight_started")
M.EVENTS.APPROACH = hash("approach")
M.EVENTS.PREPARE = hash("prepare")
M.EVENTS.PERFORM = hash("perform")
M.EVENTS.SHOW_COUNTER = hash("show_counter")
M.EVENTS.SHOW_ATTACK = hash("show_attack")
M.EVENTS.SHOW_ROUND = hash("show_round")
M.EVENTS.DAMAGE_RECEIVED = hash("damage_received")
M.EVENTS.CANCEL = hash("cancel")
M.EVENTS.USE_STAMINA = hash("use_stamina")
M.EVENTS.RESET_STAMINA = hash("reset_stamina")
M.EVENTS.DIE = hash("die")

M.EVENTS.PLAYER_BORN = hash("player_born")

M.EVENTS.ENEMY_AWAKEN = hash("enemy_awaken")
M.EVENTS.DETECTED = hash("player_detected")
M.EVENTS.READY = hash("enemy_ready")

M.EVENTS.COUNTER_SUCCESS = hash("conter_success")
M.EVENTS.COUNTER_FAILURE = hash("counter_failure")
M.EVENTS.ATTACK_DONE = hash("attack_done")

return M