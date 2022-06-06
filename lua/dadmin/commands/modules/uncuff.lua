da.commands:Command 'uncuff'
	:Desc 'Force uncuff a player'
	:Category 'DarkRP'
	:Weight(da.cfg.AdminWeight)
	:Adminmode(true)
	:Args({DA_PLAYER, 'Target', true})
:Callback(function(cmd, pl, args, suppress)
	if not (args[1].Restrained) then
		da.sendmsg(pl, args[1], ' isn\'t cuffed.')
		return
	end

	pl:RHCRestrain(pl)

	if not (suppress) then
		da.amsg('# uncuffed #.')
			:Insert(pl)
			:Insert(args[1])
			:Send()
	end
end)