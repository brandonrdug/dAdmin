local util_SteamIDTo64	= util.SteamIDTo64
local string_NiceTime 	= string.NiceTime
local table_HasValue	= table.HasValue
local team_GetColor		= team.GetColor
local game_KickID		= game.KickID

local units = {}
	units['seconds'] 	= 'second'
	units['minutes'] 	= 'minute'
	units['hours'] 		= 'hour'
	units['days'] 		= 'day'
	units['weeks'] 		= 'week'
	units['months'] 	= 'month'
	units['years'] 		= 'year'

	-- abreviations
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
	time['year']		= 60 * 60 * 24 * 365

da.commands:Command 'ban'
:Callback(function(cmd, pl, args, suppress)
	local id, length, unit, reason = 
		args[1], args[2], args[3], args[4]

	if isstring(length) then
		length, unit, reason = 0, length, unit
	end

	local limit = da.cfg.BanLimits[pl:GetUserGroup()] or 960

	if (units[unit]) then unit = units[unit] end
	if not table_HasValue(units, unit) then da.sendcmderr(pl, cmd, 'Invalid unit of time.') return end

	length = length * time[unit]

	if not (limit == 0) and (length > (limit)) then
		da.sendcmderr(pl, cmd, 'That length exceeds your ban limit. Your ban limit is ' .. string_NiceTime(limit))
		return
	elseif (length == 0) and (limit ~= 0) then
		da.sendcmderr(pl, cmd, 'You can\'t permanently ban people.')
		return
	end

	local data = da.player.DAData(id)
	local targ = da.FindPlayer(id)

	if not (data) then
		if (targ) then
			data = targ:DAData()
			id = targ:SteamID()
		elseif not da.IsValidSteamID(id) then
			da.sendcmderr(pl, cmd, 'Invalid target "' .. id .. '".')
			return
		end
	end

	if data and not da.player.CompareIDs(pl:SteamID(), id) then
		da.sendcmderr(pl, cmd, targ and targ or id, '\'s group weight is greater than or equal to yours.')

		if (targ) then
			targ:Message('# tried to ban you for # with the reason "#"')
				:Insert(pl)
				:Insert(string_NiceTime(length))
				:Insert(reason)
				:Send(DA_ERROR)
		end

		return
	end

	local update, bandata = da.bans.BanID(id, pl, length, reason, data and data.Name)
	if (targ) then targ:Kick(da.bans.GetBanMessage(bandata)) else game_KickID(id, 'Banned') end
	-- KickID just incase the steamid is connecting already

	if (update) then
		da.sendmsg(pl, 'Updated ban.')
		
		if not (suppress) then
			local msg = da.amsg('# updated #\'s ban to # for "#".'):Insert(pl)
			if (targ) then 
				msg:Insert(targ) 
			else 
				msg:Insert(data and data.Name or nil, data and ('(' .. id .. ')') or id)
			end

			msg:Insert((length == 0) and 'permanent' or string_NiceTime(length))
			   :Insert(reason)
			   :Send()
		end
	else
		da.sendmsg(pl, 'Banned player.')

		if not (suppress) then
			if (length == 0) then
				local msg = da.amsg('# banned # permanently for "#".'):Insert(pl)
				if (targ) then 
					msg:Insert(targ) 
				else 
					msg:Insert(data and data.Name or nil, data and ('(' .. id .. ')') or id)
				end

				msg:Insert(reason)
				   :Send()
			else
				local msg = da.amsg('# banned # for # for "#".'):Insert(pl)
				if (targ) then
					msg:Insert(targ)
				else
					msg:Insert(data and data.Name or nil, data and ('(' .. id .. ')') or id)
				end

				msg:Insert(string_NiceTime(length))
				   :Insert(reason)
				   :Send()
			end
		end
	end
end)