local math_Round	= math.Round
local CurTime		= CurTime

local PLAYER = FindMetaTable 'Player'

function PLAYER:NameID()
	return self:Name() .. '(' .. self:SteamID() .. ')'
end

function PLAYER:GetDAVar(k)
	if (SERVER) then
		if not (self:DAData().sVars) then
			da.player.InitializeVars(self:SteamID())
		end
	end

	return SERVER and self:DAData().sVars[k] or self:GetNetVar(k)
end

function PLAYER:GetUserGroup()
	return self:GetNetVar 'rank' or 'user'
end

function PLAYER:GetSecondaryUserGroup()
	return self:GetNetVar 'srank'
end

function PLAYER:IsUserGroup(group)
	return (self:GetUserGroup() == group) or (self:GetSecondaryUserGroup() == group)
end

function PLAYER:GetAdminmode()
	return self:GetDAVar 'adminmode' or false
end

function PLAYER:GetGroup()
	return da.groups.Get(self:GetUserGroup())
end

function PLAYER:GetSecondaryGroup()
	if self:GetSecondaryUserGroup() then
		return da.groups.Get(self:GetSecondaryUserGroup())
	end
end

function PLAYER:GetWeight()
	if not self:GetGroup() then return 0 end
	if self:GetSecondaryGroup() and (self:GetGroup():GetWeight() < self:GetSecondaryGroup():GetWeight()) then return self:GetSecondaryGroup():GetWeight() end
	return self:GetGroup():GetWeight()
end

PLAYER.GetGroupWeight 	= PLAYER.GetWeight
PLAYER.GetGroupPower	= PLAYER.GetWeight

function PLAYER:Compare(pl)
	return da.player.Compare(self, pl)
end

function PLAYER:HasAccess(weight)
	return (self:GetWeight() >= weight)
end

PLAYER.HasPower = PLAYER.HasAccess

function PLAYER:IsSuperAdmin()
	return (self:GetWeight() >= da.cfg.SuperAdminWeight)
end

function PLAYER:IsAdmin()
	return (self:GetWeight() >= da.cfg.AdminWeight)
end

function PLAYER:GetTime()
	return self:GetDAVar 'playtime' + self:GetSessionTime()
end

function PLAYER:GetJoinTime()
	return self:GetDAVar 'jointime'
end

function PLAYER:GetSessionTime()
	return math_Round(CurTime() - self:GetJoinTime())
end

function PLAYER:IsJailed()
	local var = self:GetDAVar 'jail'
	return var and var.Jailed or false
end

function PLAYER:GetUnjailTime()
	local var = self:GetDAVar 'jail'
	return var and var.UnjailTime
end

function PLAYER:JailTimeLeft()
	local var = self:GetDAVar 'jail'
	return var and (var.UnjailTime - CurTime())
end

function PLAYER:GetFrozen()
	return self:GetDAVar 'frozen'
end