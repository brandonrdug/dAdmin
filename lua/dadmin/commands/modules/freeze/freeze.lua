da.commands:Command 'freeze'
	:Desc 'Freeze a player'
	:Category 'Administration'
	:Weight(da.cfg.AdminWeight)
	:CheckWeight(true)
	:Adminmode(true)
	:Args({DA_PLAYER, 'Player', true},
		  {DA_NUMBER, 'Seconds', false})

da.commands:Command 'unfreeze'
	:Desc 'Unfreeze a player'
	:Category 'Administration'
	:Weight(da.cfg.AdminWeight)
	:Adminmode(true)
	:Args({DA_PLAYER, 'Player', true})