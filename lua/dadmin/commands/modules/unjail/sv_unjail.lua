da.commands:Command 'unjail'
:Callback(function(cmd, pl, args, suppress)
	local id = args[1]

	local targ = (id == '^') and pl or da.FindPlayer(id)
	local data = (targ) and targ:DAData() or da.player.DAData(id)

	if not (data) then
		da.sendcmderr(pl, cmd, 'Invalid target "' .. id .. '"')
		return
	end

	if (targ) then
		da.jail.ReleasePlayer(targ)
		da.sendmsg(pl, 'Unjailed player.')

		if not (suppress) then
			da.amsg('# unjailed #.')
				:Insert(pl)
				:Insert(targ)
				:Send()
		end
	else
		local jaildata = da.jail.IsIDJailed(id)

		if (jaildata) then
			da.jail.ReleaseID(id)
			da.sendmsg(pl, 'Unjailed id.')

			if not (suppress) then
				da.amsg('# unjailed #.')
					:Insert(pl)
					:Insert(data.Name, '(' .. id .. ')')
					:Send()
			end
		else
			da.sendcmderr(pl, cmd, 'ID isn\'t jailed.')
			return
		end
	end
end)