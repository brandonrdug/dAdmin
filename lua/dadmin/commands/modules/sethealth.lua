da.commands:Command 'sethealth'
	:Desc 'Set a player\'s health'
	:Category 'Misc'
	:Weight(da.cfg.AdminWeight)
	:CheckWeight(true)
	:Adminmode(true)
	:Args({DA_PLAYER, 'Target', true},
		  {DA_NUMBER, 'Amount', true})
:Callback(function(cmd, pl, args, suppress)
	args[1]:SetHealth(args[2])

	if not (suppress) then
		da.amsg('# set #\'s health to #.')
			:Insert(pl)
			:Insert(args[1])
			:Insert(args[2])
			:Send()
	end
end)