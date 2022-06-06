da.commands:Command 'jail'
	:Desc 'Jail a player'
	:Category 'Administration'
	:Weight(da.cfg.AdminWeight)
	:Adminmode(true)
	:Args({DA_STRING, 'Name/SteamID', true},
		  {DA_UNUMBER, 'Length', true},
		  {DA_STRING, 'Unit of time (seconds/minutes/hours/days/weeks/months)', true},
		  {DA_STRING, 'Reason', true})