da.commands:Command 'setsecgroup'
:Callback(function(cmd, pl, args, suppress)
	local id, group 	= args[1], args[2]:lower()
	local expt, expto	= args[3], args[4] and args[4]:lower()

	local group_data = da.groups.Get(group)
	if not (group_data) then 
		da.sendcmderr(pl, cmd, '"' .. group .. '" is an invalid group.') 
		return
	end

	if not pl:IsSuperAdmin() and (group_data:GetWeight() >= pl:GetWeight()) then
		da.sendcmderr(pl, cmd, 'The group "' .. group .. '" has a higher or equal weight to your own group.')
		return
	end

	if (expt) then
		expto = expto or da.cfg.DefaultGroup

		local ex_group = da.groups.Get(expto)
		if not (ex_group) then
			da.sendcmderr(pl, cmd, '"' .. expto .. '" is an invalid group to expire to.')
			return
		end

		if not pl:IsSuperAdmin() and (ex_group:GetWeight() >= pl:GetWeight()) then
			da.sendcmderr(pl, cmd, 'The group "' .. expto .. '" has a higher or equal weight to your own group.')
			return
		end
	end

	local data = da.player.DAData(id)
	local targ = (id == '^') and pl or da.FindPlayer(id)

	if (targ) and not (data) then
		data = targ:DAData()
	elseif not (targ) and not (data) then
		da.sendcmderr(pl, cmd, 'Couldn\'t find "' .. id .. '".')
		return
	end

	if (data.SRank == group) then
		da.sendcmderr(pl, cmd, '"' .. id .. '"\'s secondary group is already "' .. group .. '"')
		return
	end

	if not pl:IsSuperAdmin() and (pl:GetWeight() <= da.player.GetIDWeight(id)) then
		da.sendcmderr(pl, cmd, '"' .. id .. '"\'s group weight is greater than or equal to yours.')

		if (targ) then
			targ:Message('# tried to set your secondary group to "#"')
				:Insert(pl)
				:Insert(group_data)
				:Send(DA_ERROR)
		end

		return
	end

	if (targ) then
		da.groups.SetPlayerSecondaryGroup(targ, group, expt, expto)
		if not (suppress) then
			da.amsg('# set # secondary group to "#".#')
				:Insert(pl)
				:Insert(targ)
				:Insert(group_data)
				:Insert((expt) and (' Duration: ' .. expt .. ' seconds. Expiring to: "' .. expto .. '"'))
				:Send()
		end
	else
		da.groups.SetSteamIDSecondaryGroup(id:upper(), group, expt, expto)
		if not (suppress) then
			da.amsg('# set # secondary group to "#".#')
				:Insert(pl)
				:Insert(Color(140, 140, 140), id)
				:Insert(group_data)
				:Insert((expt) and (' Duration: ' .. expt .. ' seconds. Expiring to: "' .. expto .. '"'))
				:Send()
		end
	end
end)