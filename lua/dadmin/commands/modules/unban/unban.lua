da.commands:Command 'unban'
	:Desc 'Unban a player'
	:Category 'Administration'
	:Weight(da.cfg.AdminWeight)
	:Args({DA_STRING, 'SteamID', true},
		  {DA_STRING, 'Reason', true})