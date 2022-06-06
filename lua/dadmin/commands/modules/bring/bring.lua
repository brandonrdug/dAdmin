da.commands:Command 'bring'
	:Desc 'Bring a player'
	:Category 'Teleportation'
	:Weight(da.cfg.AdminWeight)
	:Adminmode(true)
	:CheckWeight(true)
	:Args({DA_PLAYER, 'Name', true})