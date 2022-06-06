da.commands:Command 'strip'
:Callback(function(cmd, pl, args, suppress)
	args[1]:StripWeapons()

	if not (suppress) then
		da.amsg '# stripped #\'s weapons.'
			:Insert(pl)
			:Insert(targ)
			:Send()
	end
end)