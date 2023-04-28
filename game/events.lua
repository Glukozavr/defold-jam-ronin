-- Put functions in this file to use them in several other scripts.
-- To get access to the functions, you need to put:
-- require "my_directory.my_file"
-- in any script using the functions.
local M = {}
M.EVENTS = {}

M.EVENTS.PLAYER_BORN = hash("player_born")
M.EVENTS.ENEMY_AWAKEN = hash("enemy_awaken")
M.EVENTS.DISCOVERY = hash("discovery_started")
M.EVENTS.FIGHT = hash("fight_started")
M.EVENTS.APPROACH = hash("approach") -- expects { position }
M.EVENTS.DETECTED = hash("player_detected") -- expects { shadow_url }
M.EVENTS.READY = hash("enemy_ready")

return M