local da = da

local util_SteamIDFrom64	= util.SteamIDFrom64
local util_JSONToTable		= util.JSONToTable
local util_TableToJSON		= util.TableToJSON
local table_HasValue		= table.HasValue
local table_Copy 			= table.Copy

if not (da.player.queried) then
	da.mysql.query('SELECT * FROM `da_players`', function(data)
		for k, v in ipairs(data) do
			da.player.cache[v.SteamID] = v
		end

		da.player.queried = true
	end):wait()
end

local function ipcache()
	return da.mysql.gquery('SELECT * FROM `da_ipcache`', function(data)
		for k, v in ipairs(data) do
			local cached = da.player.cache[v.SteamID]
			if (cached) then
				cached.IPCache = cached.IPCache or {}
				cached.IPCache[v.IP] = v.LastTime
			end
		end
	end)
end

if not (da.player.ipsqueried) then
	ipcache():wait()
	da.player.ipsqueried = true
end

timer.Create('dadmin.ipcache', 7200, 0, ipcache)

function da.player.DAData(id)
	return da.player.cache[id]
end

function da.player.SteamIDExists(id)
	return (da.player.DAData(id) ~= nil)
end

function da.player.InitializeVars(id)
	local data = da.player.DAData(id)

	if not (data) then
		return
	end

	local vars 		= data.pVars or data.Vars and util_JSONToTable(data.Vars) or {}
	data.pVars 		= vars
	data.sVars 		= table_Copy(vars)
end

function da.player.GetVar(id, key, value)
	if da.player.SteamIDExists(id) then
		da.player.InitializeVars(id)
		return da.player.DAData(id).sVars[key]
	end
end

function da.player.SetVar(id, key, value, persist)
	if not da.player.SteamIDExists(id) then
		return
	end

	local data = da.player.DAData(id)
	if not data.pVars then da.player.InitializeVars(id) end

	data.sVars[key] = value

	if (persist) then
		data.pVars[key] = value
		da.mysql.query("CALL UpdateVars('" .. id .. "', '" .. da.mysql.db:escape(util_TableToJSON(data.pVars)) .. "');")
	end
end

function da.player.GetIDGroup(id)
	if (id == 'Console') then
		return dadmin.console:GetGroup()
	end

	local data = da.player.DAData(id)
	if (data) then
		return da.groups.Get(data.Rank)
	end
end

function da.player.GetIDSecondaryGroup(id)
	if (id == 'Console') then
		return
	end

	local data = da.player.DAData(id)
	if (data) and (data.SRank) then
		return da.groups.Get(data.SRank)
	end
end

function da.player.GetIDWeight(id)
	if (id == 'Console') then
		return dadmin.console:GetWeight()
	end

	local data = da.player.DAData(id)
	if (data) then
		local group, sgroup = da.player.GetIDGroup(id), da.player.GetIDSecondaryGroup(id)
		return sgroup and (group:GetWeight() > sgroup:GetWeight() and group:GetWeight() or sgroup:GetWeight()) or group:GetWeight()
	end
end

function da.player.CompareIDs(id, id2)
	if (id == 'Console') then
		return true
	elseif (id2 == 'Console') then
		return false
	end

	local weight, weight2 = da.player.GetIDWeight(id), da.player.GetIDWeight(id2)
	return (weight >= da.cfg.SuperAdminWeight) or (weight >= weight2)
end

function da.player.GetCachedIPs(sid)
	local data = da.player.DAData(sid)

	if (data) and (data.IPCache) then
		return data.IPCache
	end
end

function da.player.IsIPCached(sid, ip)
	local cachedIPs = da.player.GetCachedIPs(sid)

	if (cachedIPs) then
		return cachedIPs[ip]
	end

	return false
end

function da.player.CacheIP(sid, ip)
	local time = os.time()

	if da.player.IsIPCached(sid, ip) then
		da.player.GetCachedIPs(sid)[ip] = time
		da.mysql.gquery("UPDATE `da_ipcache` SET `LastTime` = " 
			.. time .. " WHERE `SteamID` = '" .. sid .. "' AND `IP` = '" .. ip .. "'")
	else
		da.player.GetCachedIPs(sid)[ip] = time
		da.mysql.gquery("INSERT INTO `da_ipcache` VALUES ('" .. sid .. "', '" 
			.. ip .. "', " .. time .. ")")
	end
end

function da.player.CheckPassword(id64, ip, svp, clp, name)
	local id 	= util_SteamIDFrom64(id64)
	local time 	= os.time()

	if da.player.SteamIDExists(id) then
		local data = da.player.DAData(id)
			data.Name 		= name
			data.IP			= ip
			data.IPCache	= data.IPCache or {}

		da.mysql.query("CALL UpdateData('" .. id ..
			"', '" 	.. da.mysql.db:escape(name) ..
			"', '" 	.. ip ..
			"', " 	.. time .. ");")
	else
		da.player.cache[id] = {
			SteamID 	= id,
			Name 		= name,
			IP 			= ip,
			Rank 		= da.cfg.DefaultGroup,
			Time		= 0,
			TimeJoined 	= time,
			LastTime	= time,
			IPCache		= {}
		}

		da.mysql.query("CALL CreateData('" .. id .. 
			"', '" .. da.mysql.db:escape(name) .. 
			"', '" .. ip .. 
			"', '" .. da.cfg.DefaultGroup .. 
			"', "  .. time .. ");")
	end

	da.player.CacheIP(id, ip)

	local isbanned, data = da.bans.IsBanned(id)
	if (isbanned) then
		return false, da.bans.GetBanMessage(data)
	end

	da.player.InitializeVars(id)
end

function da.player.InitPlayer(pl)
	local data = pl:DAData()

	da.groups.InitPlayer(pl, data)
	da.time.InitPlayer(pl, data)
	da.jail.InitPlayer(pl, data)

	if pl:IsFirstSession() then
		da.amsg('# has connected for the first time.')
			:Insert(pl)
			:Send()
	else
		da.amsg('# has connected. Last seen: #')
			:Insert(pl)
			:Insert(Color(140, 140, 140), os.date('%m/%d/%Y - %H:%M:%S', data.LastTime))
			:Send()
	end

	data.LastTime = os.time()
end

function da.player.PlayerSpawn(pl)
	if pl:IsBot() and not pl:DAData() then
		local id, ip, time, name = pl:SteamID(), pl:IPAddress(), os.time(), pl:Name()

		if da.player.SteamIDExists(id) then
			local data = da.player.DAData(id)
				data.Name 		= name
				data.IP			= ip
	
			da.mysql.query("CALL UpdateData('" .. id ..
				"', '" 	.. da.mysql.db:escape(name) ..
				"', '" 	.. ip ..
				"', " 	.. time .. ");")
		else
			da.player.cache[id] = {
				SteamID 	= id,
				Name 		= name,
				IP 			= ip,
				Rank 		= da.cfg.DefaultGroup,
				Time		= 0,
				TimeJoined 	= time,
				LastTime	= time
			}
	
			da.mysql.query("CALL CreateData('" .. id .. 
				"', '" .. da.mysql.db:escape(name) .. 
				"', '" .. ip .. 
				"', '" .. da.cfg.DefaultGroup .. 
				"', "  .. time .. ");")
		end

		da.player.InitializeVars(id)
	end
end

function da.player.PlayerDisconnected(pl)
	da.amsg('# disconnected.')
		:Insert(pl)
		:Send()
end

function da.player.SetAdminmode(pl, mode)
	pl:SetDAVar('adminmode', mode, false, true)

	if (mode) then
		pl:SetModel(da.cfg.AdminmodeModels[pl:GetUserGroup()] or da.cfg.DefaultAdminmodeModel)
		
		for k, v in ipairs(da.cfg.AdminmodeWeapons) do
			pl:Give(v)
		end

		if (pl.unArrest) then
			pl:unArrest()
		end

		pl:GodEnable()
	else
		if (DarkRP) then
			local model = RPExtraTeams[pl:Team()].model
			pl:SetModel(istable(model) and model[1] or model)

			for k, v in ipairs(da.cfg.AdminmodeWeapons) do
				if not table_HasValue(pl:getJobTable().weapons, v) then
					pl:StripWeapon(v)
				end
			end
		end

		pl:unArrest()
		pl:GodDisable()
	end

	pl:SwitchToDefaultWeapon()
end

function da.player.PlayerShouldTakeDamage(pl, ent)
	if pl:GetAdminmode() then
		return false
	end
end

function da.player.PhysgunDrop(pl, ent)
	if ent:IsPlayer() then
		if not ent:GetFrozen() then ent:UnLock() end
		ent:SetMoveType(MOVETYPE_WALK)

		if pl:KeyDown(IN_ATTACK2) then
			if ent:GetFrozen() then
				da.commands.ExecuteCommand('unfreeze', pl, {ent}, true)
			else
				da.commands.ExecuteCommand('freeze', pl, {ent}, true)
			end
		elseif ent:GetFrozen() then
			da.commands.ExecuteCommand('unfreeze', pl, {ent}, true)
		end
	end
end

function da.player.PlayerCanHearPlayersVoice(listener, speaker)
	if speaker:IsGagged() then
		return false
	end
end

function da.player.playerCanChangeTeam(pl, team)
	if pl:GetAdminmode() then
		pl:SetAdminmode(true)
	end
end

hook('playerCanChangeTeam', 'da.player.adminmode', da.player.playerCanChangeTeam)
hook('CheckPassword', 'da.player', da.player.CheckPassword)
hook('PlayerAuthed', 'da.player', da.player.InitPlayer)
hook('PlayerSpawn', 'da.player', da.player.PlayerSpawn)
hook('PlayerDisconnected', 'da.player', da.player.PlayerDisconnected)
hook('PlayerShouldTakeDamage', 'da.player', da.player.PlayerShouldTakeDamage)
hook('PhysgunDrop', 'da.player', da.player.PhysgunDrop)
hook('PlayerCanHearPlayersVoice', 'da.player', da.player.PlayerCanHearPlayersVoice)