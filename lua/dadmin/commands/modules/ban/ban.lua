da.commands:Command 'ban'
	:Desc 'Ban a player'
	:Category 'Administration'
	:Weight(da.cfg.AdminWeight)
	:Adminmode(true)
	:Args({DA_STRING, 'Name/SteamID', true},
		  {DA_UNUMBER, 'Length', false},
		  {DA_STRING, 'Unit of time (seconds/minutes/hours/days/weeks/months/years/permanent)', true},
		  {DA_STRING, 'Reason', true})