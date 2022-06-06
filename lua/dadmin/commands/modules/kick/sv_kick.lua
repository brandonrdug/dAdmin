da.commands:Command 'kick'
:Callback(function(cmd, pl, args, suppress)
	local targ = args[1]
	local reason = args[2]

	if not (suppress) then
		da.amsg('# kicked # for #')
			:Insert(pl)
			:Insert(targ)
			:Insert(reason)
			:Send()
	end

	targ:Kick(string.format('Kicked by %s for: %s', pl:NameID(), reason))
end)