local string_NiceTime 	= string.NiceTime
local table_HasValue	= table.HasValue

local units = {}
	units['seconds'] 	= 'second'
	units['minutes'] 	= 'minute'
	units['hours'] 		= 'hour'
	units['days'] 		= 'day'
	units['weeks'] 		= 'week'
	units['months'] 	= 'month'
	units['years'] 		= 'year'

	-- abbreviations
	units['p']			= 'permanent'
	units['perm']		= 'permanent'
	units['s']			= 'second'
	units['secs']		= 'second'
	units['sec']		= 'second'
	units['m']			= 'minute'
	units['mins']		= 'minute'
	units['min']		= 'minute'
	units['h']			= 'hour'
	units['hr']			= 'hour'
	units['hrs']		= 'hour'
	units['mo']			= 'month'

local time = {}
	time['permanent']	= 0
	time['second'] 		= 1
	time['minute']		= 60
	time['hour']		= 60 * 60
	time['day']			= 60 * 60 * 24
	time['week']		= 60 * 60 * 24 * 7
	time['month']		= 60 * 60 * 24 * 30

da.commands:Command 'jail'
:Callback(function(cmd, pl, args, suppress)
	local id, length, unit, reason = 
		args[1], args[2], args[3], args[4]

	if (length == 0) then da.sendcmderr(pl, cmd, 'Your length must be greater than 0.') return end
	if (units[unit]) then unit = units[unit] end
	if not table_HasValue(units, unit) then da.sendcmderr(pl, cmd, 'Invalid unit of time.') return end

	length = length * time[unit]

	local data = da.player.DAData(id)
	local targ = (id == '^') and pl or da.FindPlayer(id)

	if not (data) then
		if (targ) then
			data = targ:DAData()
			id = targ:SteamID()
		else
			da.sendcmderr(pl, cmd, 'Invalid target "' .. id .. '".')
			return
		end
	end

	if not da.player.CompareIDs(pl:SteamID(), id) then
		da.sendcmderr(pl, cmd, targ and targ or id, '\'s group weight is greater than or equal to yours.')

		if (targ) then
			targ:Message('# tried to jail you for # for "#".')
				:Insert(pl)
				:Insert(string_NiceTime(length))
				:Insert(reason)
				:Send(DA_ERROR)
		end

		return
	end

	if (targ) then
		da.jail.JailPlayer(targ, length)
		da.sendmsg(pl, 'Jailed player.')

		if not (suppress) then
			da.amsg('# jailed # for # for "#".')
				:Insert(pl)
				:Insert(targ)
				:Insert(string_NiceTime(length))
				:Insert(reason)
				:Send()
		end
	else
		local update, jaildata = da.bans.JailID(id, length)

		if (update) then
			da.sendmsg(pl, 'Updated jailtime.')

			if not (suppress) then
				da.amsg('# updated #\'s jailtime to # for "#".')
					:Insert(pl)
					:Insert(data.Name, '(' .. id .. ')')
					:Insert(string_NiceTime(length))
					:Insert(reason)
					:Send()
			end
		else
			da.sendmsg(pl, 'Jailed id.')

			if not (suppress) then
				da.amsg('# jailed # for # for "#".')
					:Insert(pl)
					:Insert(data.Name, '(' .. id .. ')')
					:Insert(string_NiceTime(length))
					:Insert(reason)
					:Send()
			end
		end
	end
end)