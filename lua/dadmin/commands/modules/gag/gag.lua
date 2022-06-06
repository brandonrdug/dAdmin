da.commands:Command 'gag'
	:Desc 'Gag a player (prevent them from speaking)'
	:Category 'Administration'
	:Weight(da.cfg.AdminWeight)
	:CheckWeight(true)
	:Adminmode(true)
	:Args({DA_PLAYER, 'Player', true},
		  {DA_NUMBER, 'Minutes', false})

da.commands:Command 'ungag'
	:Desc 'Ungag a player'
	:Category 'Administration'
	:Weight(da.cfg.AdminWeight)
	:Adminmode(true)
	:Args({DA_PLAYER, 'Player', true})

-- Gags are handled in players/sv_player.lua, this is just the command setup