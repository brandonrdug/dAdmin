local da = da
local db = da.mysql.db

local string_format = string.format
local string_gsub	= string.gsub
local table_insert 	= table.insert
local table_Merge	= table.Merge
local os_date		= os.date
local os_time 		= os.time

local ipairs = ipairs

da.bans = da.bans or {
	cache = {}
}

if not (da.bans.queried) then
	da.mysql.query('SELECT * FROM `da_bans`', function(data)
		for k, v in ipairs(data) do
			da.bans.cache[v.SteamID] = da.bans.cache[v.SteamID] or {}
			table_insert(da.bans.cache[v.SteamID], v)
		end

		da.bans.queried = true
	end):wait()
end

function da.bans.IsBanned(steamid)
	local cached = da.bans.cache[steamid]

	if not (cached) then
		return false
	end

	local time = os_time()

	for k, v in ipairs(cached) do
		if not (v.UnbanReason) then
			if (v.Length == 0) then
				return true, v
			end

			if (v.Time + v.Length) > time then
				return true, v
			end
		end
	end

	return false
end

function da.bans.GetBanMessage(data)
	return string.gsub(da.cfg.BanMessage, '{Admin}', ((data.SteamID == 'Console') and data.SteamID) or data.AName .. '(' .. data.ASteamID .. ')')
		:gsub('{Time}', data.Length == 0 and 'Never' or os_date('%m/%d/%Y - %H:%M:%S', data.Time + data.Length))
		:gsub('{Reason}', data.Reason)
end

function da.bans.BanID(targid, admin, length, reason, name)
	local cached 	= da.bans.cache[targid]
	local time		= os_time()

	if (cached) then
		local isbanned, data = da.bans.IsBanned(targid)

		if (isbanned) then
			da.mysql.query(string_format("UPDATE `da_bans` SET `ASteamID` = '%s', `AName` = '%s', `Time` = %s, `Length` = %s, `Reason` = '%s' WHERE `SteamID` = '%s' AND `Time` = %s",
				admin:SteamID(), db:escape(admin:Name()), time, length, db:escape(reason), targid, data.Time))

			table_Merge(data, {
				ASteamID 	= admin:SteamID(),
				AName		= admin:Name(),
				Time		= time,
				Length 		= length,
				Reason		= reason
			})

			return true, data
		end
	end

	da.bans.cache[targid] = da.bans.cache[targid] or {}
	local cached = da.bans.cache[targid]

	da.mysql.query(string_format("INSERT INTO `da_bans` (`SteamID`, `Name`, `ASteamID`, `AName`, `Time`, `Length`, `Reason`) VALUES ('%s', %s, '%s', '%s', %s, %s, '%s')",
		targid, name and ("'" .. db:escape(name) .. "'") or 'NULL', admin:SteamID(), db:escape(admin:Name()), time, length, db:escape(reason)))

	local i = table_insert(cached, {
		SteamID 	= targid,
		Name		= name,
		ASteamID 	= admin:SteamID(),
		AName		= admin:Name(),
		Time		= time,
		Length		= length,
		Reason		= reason
	})

	// depends on exhibition lib
	Exhibition.Lib:HTTP(Exhibition.Lib.Config.APIEndpoint .. "/bans/add", "POST", {Authorization = "HEADER_TOKEN"}, util.TableToJSON({
		["sid"] = util.SteamIDTo64(targid),
		["name"] = name,
		["reason"] = reason,
		["length"] = string.NiceTime(time),
		["admin"] = admin:Name(),
		["adminsid"] = admin:SteamID64(),
		["server"] = da.GetServerName()
	}))

	return false, cached[i]
end

function da.bans.BanPlayer(targ, admin, length, reason)
	local update, data = da.bans.BanID(targ:SteamID(), admin:SteamID(), length, reason, targ:Name())
	targ:Kick(da.bans.GetBanMessage(data))
	return update, data
end

function da.bans.UnbanID(targid, reason)
	local banned, data = da.bans.IsBanned(targid)
	if not banned then return banned end
	da.mysql.query("UPDATE `da_bans` SET `UnbanReason` = '" .. db:escape(reason) .. "' WHERE `SteamID` = '" .. targid .. "' AND `Time` = " .. data.Time)
	data.UnbanReason = reason
	return true
end