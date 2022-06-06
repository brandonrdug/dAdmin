local da = da
local os = os

local player_GetBySteamID = player.GetBySteamID

function da.groups.SetSteamIDGroup(id, group, expiretime, expireto) -- don't call if player is present on server
	if not da.groups.Exists(group) then
		error ("(dAdmin) Unable to change id's group because group isn't registered. [id]: " .. id)
		return
	end

	if not da.player.SteamIDExists(id) then
		error("(dAdmin) Unable to change id's group because id isn't registered. [id]: " .. id)
		return
	end

	local data = da.player.DAData(id)

	da.player.InitializeVars(id)

	if (expiretime) then
		expireto = expireto or data.Rank

		da.player.SetVar(id, 'expiretime', os.time() + expiretime, true)
		da.player.SetVar(id, 'expireto', expireto, true)
	elseif da.player.GetVar(id, 'expiretime') then
		da.player.SetVar(id, 'expiretime', nil, true)
		da.player.SetVar(id, 'expireto', nil, true)
	end

	data.Rank = group
	da.mysql.query("UPDATE `da_players` SET `Rank` = '" .. group .. "' WHERE `SteamID` = '" .. id .. "'")
end

function da.groups.SetPlayerGroup(pl, group, expiretime, expireto)
	if not da.groups.Exists(group) then
		error ("(dAdmin) Unable to change id's group because group isn't registered. [id]: " .. id)
		return
	end

	local id	= pl:SteamID()
	local data 	= da.player.DAData(id)

	if (expiretime) then
		expireto = expireto or data.Rank

		pl:SetDAVar('expiretime', os.time() + expiretime, true)
		pl:SetDAVar('expireto', expireto, true)
	elseif pl:GetDAVar('expiretime') then
		pl:SetDAVar('expiretime', nil, true)
		pl:SetDAVar('expireto', nil, true)
	end

	data.Rank = group
	da.mysql.query("UPDATE `da_players` SET `Rank` = '" .. group .. "' WHERE `SteamID` = '" .. id .. "'")
	pl:SetNetVar('rank', group)
end

function da.groups.SetSteamIDSecondaryGroup(id, group, expiretime, expireto)
	if not da.groups.Exists(group) and (group ~= nil) then
		error ("(dAdmin) Unable to change id's secondary group because group isn't registered. [id]: " .. id)
		return
	end

	if not da.player.SteamIDExists(id) then
		error("(dAdmin) Unable to change id's secondary group because id isn't registered. [id]: " .. id)
		return
	end

	if (group == da.cfg.DefaultGroup) then
		group = nil
	end

	local data = da.player.DAData(id)

	da.player.InitializeVars(id)

	if (expiretime) then
		expireto = expireto or data.SRank

		da.player.SetVar(id, 'sexpiretime', os.time() + expiretime, true)
		da.player.SetVar(id, 'sexpireto', expireto, true)
	elseif da.player.GetVar(id, 'sexpiretime') then
		da.player.SetVar(id, 'sexpiretime', nil, true)
		da.player.SetVar(id, 'sexpireto', nil, true)
	end

	data.SRank = group
	da.mysql.query("UPDATE `da_players` SET `SRank` = " .. ((group == nil) and 'NULL' or "'" .. group .. "'") .. " WHERE `SteamID` = '" .. id .. "'")
end

function da.groups.SetPlayerSecondaryGroup(pl, group, expiretime, expireto)
	if not da.groups.Exists(group) and (group ~= nil) then
		error ("(dAdmin) Unable to change id's group because group isn't registered. [id]: " .. id)
		return
	end

	if (group == da.cfg.DefaultGroup) then
		group = nil
	end

	local id	= pl:SteamID()
	local data 	= da.player.DAData(id)

	if (expiretime) then
		expireto = expireto or data.SRank

		pl:SetDAVar('sexpiretime', os.time() + expiretime, true)
		pl:SetDAVar('sexpireto', expireto, true)
	elseif pl:GetDAVar('sexpiretime') then
		pl:SetDAVar('sexpiretime', nil, true)
		pl:SetDAVar('sexpireto', nil, true)
	end

	data.SRank = group
	da.mysql.query("UPDATE `da_players` SET `SRank` = " .. ((group == nil) and 'NULL' or "'" .. group .. "'") .. " WHERE `SteamID` = '" .. id .. "'")
	pl:SetNetVar('srank', group)
end

function da.groups.ExpireCheck(pl)
	local expiretime = pl:GetDAVar('expiretime')

	if (expiretime) then
		if (os.time() >= expiretime) then
			da.groups.SetPlayerGroup(pl, pl:GetDAVar('expireto'))
			da.sendmsg(pl, "Your rank has expired and you've been set to: " .. pl:GetUserGroup())
		end
	end

	expiretime = pl:GetDAVar('sexpiretime')

	if (expiretime) then
		if (os.time() >= expiretime) then
			da.groups.SetPlayerSecondaryGroup(pl, pl:GetDAVar('sexpireto'))
			da.sendmsg(pl, "Your secondary rank has expired and has been set to: " .. pl:GetUserGroup())
		end
	end
end

function da.groups.InitPlayer(pl, data)
	da.groups.ExpireCheck(pl)
	pl:SetNetVar('rank', data.Rank)
	pl:SetNetVar('srank', data.SRank)
end

hook('DAPlayerTimer', 'da.groups', da.groups.ExpireCheck)