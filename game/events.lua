-- I don't like strings, so I put them here for everybody to use in common messaging

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
M.EVENTS.GAME_OVER = hash("game_over")

M.EVENTS.PLAYER_BORN = hash("player_born")

M.EVENTS.ENEMY_AWAKEN = hash("enemy_awaken")
M.EVENTS.DETECTED = hash("player_detected")
M.EVENTS.READY = hash("enemy_ready")

M.EVENTS.COUNTER_SUCCESS = hash("conter_success")
M.EVENTS.COUNTER_FAILURE = hash("counter_failure")
M.EVENTS.ATTACK_DONE = hash("attack_done")

M.EVENTS.PLAY_MUSIC = hash("play_music")
M.EVENTS.PLAY_SOUND = hash("play_sound_id")

M.EVENTS.PORTAL_READY = hash("portal_ready")
M.EVENTS.SPAWN_NOW = hash("spawn_now")

return M