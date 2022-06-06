da.commands:Command 'respawn'
	:Desc 'Respawn a player.'
	:Category 'Administration'
	:Weight(da.cfg.AdminWeight)
	:CheckWeight(true)
	:Adminmode(true)
	:Args({DA_PLAYER, 'Player', true})
	:Callback(function(cmd, pl, args, suppress)
		local targ = args[1]

		targ:Spawn()

		if not (suppress) then
			da.amsg '# respawned #.'
				:Insert(pl)
				:Insert(targ)
				:Send()
		end
	end)