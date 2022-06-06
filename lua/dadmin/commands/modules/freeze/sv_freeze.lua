da.commands:Command 'freeze'
:Callback(function(cmd, pl, args, suppress)
	local targ = args[1]

	if targ:GetFrozen() then
		da.sendmsg(pl, targ, ' is already frozen.')
		return
	end

	targ:SetFrozen(true)

	if (args[2]) then
		timer.Create(pl:SteamID() .. ' da.freeze', args[2], 1, function()
			if IsValid(targ) then
				targ:SetFrozen(false)
			end
		end)
		
		da.sendmsg(pl, 'You froze ', targ, ' for ' .. args[2] .. ' seconds.')
	else
		da.sendmsg(pl, 'You froze ', targ, '.')
	end

	if not (suppress) then
		if (args[2]) then
			da.amsg('# froze # for # seconds.')
				:Insert(pl)
				:Insert(targ)
				:Insert(args[2])
				:Send()
		else
			da.amsg('# froze #.')
				:Insert(pl)
				:Insert(targ)
				:Send()
		end
	end
end)

da.commands:Command 'unfreeze'
:Callback(function(cmd, pl, args, suppress)
	local targ = args[1]

	if not targ:GetFrozen() then
		da.sendmsg(pl, targ, ' isn\'t frozen.')
		return
	end

	targ:SetFrozen(false)

	local id = pl:SteamID() .. ' da.freeze'
	if timer.Exists(id) then timer.Destroy(id) end

	da.sendmsg(pl, 'You unfroze ', targ, '.')

	if not (suppress) then
		da.amsg('# unfroze #.')
			:Insert(pl)
			:Insert(targ)
			:Send()
	end
end)