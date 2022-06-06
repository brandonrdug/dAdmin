local da = da

local string_format = string.format
local table_insert	= table.insert

da.punishments = {}
	da.punishments.cache = {}

local function cache()
	return da.mysql.query('SELECT * FROM `da_punishments`', function(data)
		for k, v in ipairs(data) do
			da.punishments.cache[v.SteamID] = da.punishments.cache[v.SteamID] or {}
			da.punishments.cache[v.SteamID][v.ID] = v
		end
	end)
end

cache():wait()
timer.Create('da.punishments.cache', 60, 0, cache)

function da.punishments.GetPunishments(id)
	return da.punishments.cache[id]
end

function da.punishments.GetPunishment(steamid, id)
	return da.punishments.GetPunishments(steamid)[id]
end

function da.punishments.PunishID(steamid, admin, type, reason)
	local adminid, reason = da.mysql.db:escape(reason)

	da.mysql.query(string_format("CALL PunishID('%s', '%s', %s, %s, '%s')",
		steamid, adminid, da.GetServerID(), type, reason),
	function(data)
		local punishmentID = data['LAST_INSERT_ID()']

		da.punishments.cache[steamid][punishmentID] = {
			ID			= punishmentID,
			SteamID 	= steamid,
			AdminID 	= adminid,
			ServerID 	= da.GetServerID(),
			Type		= Type,
			Reason		= reason
		}
	end)
end

function da.punishments.RemovePunishment(steamid, id)
	if not da.punishments.GetPunishment(steamid, id) then
		return
	end

	da.mysql.query("CALL RemovePunishment('" .. steamid .. "', " .. id .. ")")
	da.punishments.cache[steamid][id] = nil
end

function da.punishments.ClearPunishments(steamid)
	da.mysql.query("CALL ClearPunishments('" .. steamid .. "')")
	da.punishments.cache[steamid] = {}
end