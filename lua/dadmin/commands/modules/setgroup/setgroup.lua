da.commands:Command 'setgroup'
	:Desc 'Sets a player\'s group'
	:Category 'Administration'
	:Weight(da.cfg.SuperAdminWeight)
	:CheckWeight(true)
	:Args({DA_STRING, 'Name/SteamID', true},
		  {DA_STRING, 'Group', true},
		  {DA_UNUMBER, 'Expire time', false},
		  {DA_STRING, 'Group to expire to', false})