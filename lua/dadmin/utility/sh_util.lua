local da = da

local util_SteamIDTo64	= util.SteamIDTo64
local player_GetAll 	= player.GetAll

function da.GetServerID()
	return da.cfg.ServerID
end

function da.GetServerName()
	return da.cfg.ServerIDs[da.GetServerID()]
end

function da.FindPlayer(findby)
	findby = findby

	for i, p in ipairs(player_GetAll()) do
		if p:Nick():lower():find(findby:lower(), 1, true) then
			return p
		elseif (p:SteamID() == findby) then
			return p
		elseif (p:SteamID64() == findby) then
			return p
		end
	end
end

function da.IsValidSteamID(steamid)
	if (util_SteamIDTo64(steamid) == '0') then
		return false
	end

	return true
end