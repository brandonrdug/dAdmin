da.commands:Command 'unban'
:Callback(function(cmd, pl, args, suppress)
	local id, reason = args[1], args[2]
	local succ = da.bans.UnbanID(id, reason)

	if not (succ) then
		da.sendcmderr(pl, cmd, id .. ' isn\'t banned.')
		return
	end

	da.sendmsg(pl, 'Unbanned player.')

	if not (suppress) then
		da.amsg('# unbanned # because "#".')
			:Insert(pl)
			:Insert(Color(140, 140, 140), id)
			:Insert(reason)
			:Send()
	end
end)