da.commands:Command 'arrest'
	:Desc 'Force arrest a player'
	:Category 'DarkRP'
	:Weight(da.cfg.AdminWeight)
	:CheckWeight(true)
	:Adminmode(true)
	:Args({DA_PLAYER, 'Target', true}, 
		  {DA_NUMBER, 'Seconds', true})
:Callback(function(cmd, pl, args, suppress)
	args[1]:arrest(args[2], pl)

	if not (suppress) then
		da.amsg('# arrested # for #.')
			:Insert(pl)
			:Insert(args[1])
			:Insert(string.NiceTime(args[2]))
			:Send()
	end
end)