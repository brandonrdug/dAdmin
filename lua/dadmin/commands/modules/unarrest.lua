da.commands:Command 'unarrest'
	:Desc 'Force unarrest a player'
	:Category 'DarkRP'
	:Weight(da.cfg.AdminWeight)
	:Adminmode(true)
	:Args({DA_PLAYER, 'Target', true})
:Callback(function(cmd, pl, args, suppress)
	args[1]:unArrest()

	if not (suppress) then
		da.amsg('# unarrested #.')
			:Insert(pl)
			:Insert(args[1])
			:Send()
	end
end)