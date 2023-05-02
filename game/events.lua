-- Put functions in this file to use them in several other scripts.
-- To get access to the functions, you need to put:
-- require "my_directory.my_file"
-- in any script using the functions.
local M = {}
M.EVENTS = {}

M.EVENTS.DISCOVERY = hash("discovery_started")
M.EVENTS.FIGHT = hash("fight_started")
M.EVENTS.APPROACH = hash("approach") -- expects { position }
M.EVENTS.PREPARE = hash("prepare") -- expects { action }
M.EVENTS.PERFORM = hash("perform") -- expects { action }
M.EVENTS.SHOW_COUNTER = hash("show_counter") -- expects { action }
M.EVENTS.DAMAGE_RECEIVED = hash("damage_received") -- expects { action }
M.EVENTS.CANCEL = hash("cancel")

M.EVENTS.PLAYER_BORN = hash("player_born")

M.EVENTS.ENEMY_AWAKEN = hash("enemy_awaken")
M.EVENTS.DETECTED = hash("player_detected") -- expects { shadow_url }
M.EVENTS.READY = hash("enemy_ready")

M.EVENTS.SHOW_STATS = hash("show_stats")
M.EVENTS.HIDE_STATS = hash("hide_stats")
M.EVENTS.UPDATE_STATS = hash("update_stats") -- { health, stamina }

M.EVENTS.COUNTER_SUCCESS = hash("conter_success")
M.EVENTS.COUNTER_FAILURE = hash("counter_failure")

return M