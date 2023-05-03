local M = {}

-- A call to update animation based on physics variables
M.msg_command_update_animation = hash("command_update_animations") -- { velocity, ground_contact, wall_contact }
-- A call to perfrom an action
M.msg_command_action = hash("command_action") -- { type }, where type is a string name
-- A call to notify an action is completed
M.msg_command_action_completed = hash("command_action_completed")
M.msg_command_input_lock = hash("command_input_lock")
M.msg_command_input_unlock = hash("command_input_unlock")
M.msg_command_walk = hash("command_walk") -- { value }, where value is a direction 1 or -1
M.msg_command_jump = hash("command_jump")
M.msg_command_crouch = hash("command_crouch")
M.msg_command_abort_jump = hash("command_abort_jump")
M.msg_abort = hash("command_abort")

M.msg_command_show_stats = hash("command_show_stats")
M.msg_command_hide_stats = hash("command_hide_stats")
M.msg_command_update_stats = hash("command_update_stats") -- { health, stamina }

return M