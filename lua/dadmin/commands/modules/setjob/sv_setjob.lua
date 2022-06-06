da.commands:Command 'setjob'
	:Callback(function(cmd, pl, args, suppress)
		local targ = args[1]
		local job = rp.getJobByCommand(args[2])

		if not (job) then
			da.sendmsg(pl, '"' .. job .. '" isn\'t a valid job.')
			return
		end

		targ:changeTeam(job.team, true, true)

		if not (suppress) then
			da.amsg '# set #\'s job to "#".'
				:Insert(pl)
				:Insert(targ)
				:Insert(job.name)
				:Send()
		end
	end)