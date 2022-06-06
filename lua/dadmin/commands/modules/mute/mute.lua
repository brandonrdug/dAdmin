da.commands:Command 'mute'
	:Desc 'Mute a player'
	:Category 'Administration'
	:Weight(da.cfg.AdminWeight)
	:CheckWeight(true)
	:Adminmode(true)
	:Args({DA_PLAYER, 'Player', true},
		  {DA_NUMBER, 'Minutes', false})

da.commands:Command 'unmute'
	:Desc 'Unmute a player'
	:Category 'Administration'
	:Weight(da.cfg.AdminWeight)
	:Adminmode(true)
    :Args({DA_PLAYER, 'Player', true})
    
-- Mutes are handled in sv_commands.lua, this is just the command setup.