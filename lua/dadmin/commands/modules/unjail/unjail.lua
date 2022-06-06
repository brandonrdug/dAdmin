da.commands:Command 'unjail'
	:Desc 'Unjail a player'
	:Category 'Administration'
	:Weight(da.cfg.AdminWeight)
	:Adminmode(true)
	:Args({DA_STRING, 'Name/SteamID', true})