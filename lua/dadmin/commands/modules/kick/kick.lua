da.commands:Command 'kick'
	:Desc 'Kick a player'
	:Category 'Administration'
	:Weight(da.cfg.AdminWeight)
	:CheckWeight(true)
	:Adminmode(true)
	:Args({DA_PLAYER, 'Target', true},
		  {DA_STRING, 'Reason', true})