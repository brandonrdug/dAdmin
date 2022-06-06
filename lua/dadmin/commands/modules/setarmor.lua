da.commands:Command 'setarmor'
	:Desc 'Set a player\'s armor'
	:Category 'Misc'
	:Weight(da.cfg.AdminWeight)
	:CheckWeight(true)
	:Adminmode(true)
	:Args({DA_PLAYER, 'Target', true},
		  {DA_NUMBER, 'Amount', true})
:Callback(function(cmd, pl, args, suppress)
	args[1]:SetArmor(args[2])

	if not (suppress) then
		da.amsg('# set #\'s armor to #.')
			:Insert(pl)
			:Insert(args[1])
			:Insert(args[2])
			:Send()
	end
end)