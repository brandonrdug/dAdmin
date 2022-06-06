local da = da

local string_format	= string.format
local timer_Destroy	= timer.Destroy
local timer_Create	= timer.Create
local timer_Exists	= timer.Exists
local table_Random 	= table.Random
local table_insert 	= table.insert
local table_Copy	= table.Copy

local ipairs = ipairs

da.jail = da.jail or {
	cache = {}
}

if not (da.jail.queried) then
	da.mysql.query('SELECT * FROM `da_jails`', function(data)
		for k, v in ipairs(data) do
			da.jail.cache[v.SteamID] = v
		end

		da.jail.queried = true
	end):wait()
end

function da.jail.JailPlayer(pl, time)
	local pos = istable(da.cfg.JailPosition) and table_Random(da.cfg.JailPosition) or da.cfg.JailPosition
	pl:SetPos(pos + VectorRand(1, 15))

	pl.JailPos 			= pos
	pl.JailWeaponCache 	= {}

	for k, v in pairs(pl:GetWeapons()) do
		table_insert(pl.JailWeaponCache, v:GetClass())
	end

	pl:StripWeapons(pl)
	pl:SetDAVar('jail', {Jailed = true, UnjailTime = CurTime() + time}, false, true)

	local timerid = 'Jail' .. pl:SteamID()
	timer_Create(timerid, 1, 0, function()
		if not IsValid(pl) then
			timer_Destroy(timerid)
			return
		end

		if (CurTime() >= pl:GetUnjailTime()) then
			da.jail.ReleasePlayer(pl)
			timer_Destroy(timerid)
			return
		end
	end)

	hook.Run('PlayerJailed', pl, time)
end

function da.jail.ReleasePlayer(pl)
	if not pl:IsJailed() then
		return
	end

	if timer_Exists('Jail' .. pl:SteamID()) then
		timer_Destroy('Jail' .. pl:SteamID())
	end

	pl:SetDAVar('jail', nil, false, true)
	pl:Spawn()

	for k, v in pairs(pl.JailWeaponCache) do
		pl:Give(v)
	end

	pl.JailWeaponCache, pl.JailPos = nil, nil

	hook.Run('PlayerReleasedFromJail', pl)
end

function da.jail.PlayerSpawn(pl)
	timer.Simple(1, function()
		if IsValid(pl) then
			if pl:IsJailed() then
				pl:StripWeapons()
				pl:SetPos(pl.JailPos)
			end
		end
	end)
end

function da.jail.IsIDJailed(id)
	local cached = da.jail.cache[id]
	return cached or false
end

function da.jail.JailID(id, time)
	local cached = da.jail.IsIDJailed(id)

	if (cached) then
		da.mysql.query("UPDATE `da_jails` SET `TimeLeft` = " .. time .. " WHERE `SteamID` = '" .. id .. "'")
		cached.TimeLeft = time
		
		return true, cached
	else
		da.mysql.query("INSERT INTO `da_jails` VALUES ('" .. id .. "', " .. time .. ")")
		da.jail.cache[id] = {
			SteamID 	= id,
			TimeLeft 	= time
		}

		return false, cached
	end
end

function da.jail.ReleaseID(id)
	if da.jail.IsIDJailed(id) then
		da.mysql.query("DELETE FROM `da_jails` WHERE `SteamID` = '" .. id .. "'")
		da.jail.cache[id] = nil
	end
end

function da.jail.InitPlayer(pl)
	timer.Simple(1, function()
		if IsValid(pl) then
			local data = da.jail.IsIDJailed(pl:SteamID())
			if (data) then
				da.jail.JailPlayer(pl, data.TimeLeft)
				da.jail.ReleaseID(pl:SteamID())
			end
		end
	end)
end

function da.jail.PlayerDisconnected(pl)
	if pl:IsJailed() then
		da.jail.JailID(pl:SteamID(), pl:JailTimeLeft())
	end
end

function da.jail.playerCanChangeTeam(pl, team, force)
	if pl:IsJailed() then
		return false, 'You cannot change teams while in jail.'
	end
end

function da.jail.canBuyCustomEntity(pl)
	if pl:IsJailed() then
		return false
	end
end

function da.jail.PlayerCanPickupWeapon(pl)
	if pl:IsJailed() then
		return false
	end
end

hook('PlayerSpawn', 'da.jail', da.jail.PlayerSpawn)
hook('PlayerDisconnected', 'da.jail', da.jail.PlayerDisconnected)
hook('playerCanChangeTeam', 'da.jail', da.jail.playerCanChangeTeam)
hook('canBuyCustomEntity', 'da.jail', da.jail.canBuyCustomEntity)