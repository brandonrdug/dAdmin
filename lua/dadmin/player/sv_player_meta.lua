local PLAYER = FindMetaTable 'Player'

function PLAYER:DAData()
	return da.player.DAData(self:SteamID())
end

function PLAYER:SetDAVar(key, value, persist, network)
	da.player.SetVar(self:SteamID(), key, value, persist)

	if (network) then
		self:SetNetVar(key, value)
	end
end

function PLAYER:FirstConnectionTime()
	return self:DAData().TimeJoined
end

function PLAYER:LastConnectionTime()
	return self:DAData().LastTime
end

function PLAYER:IsFirstSession()
	return (self:FirstConnectionTime() == self:LastConnectionTime())
end

function PLAYER:SetAdminmode(mode)
	da.player.SetAdminmode(self, mode)
end

function PLAYER:SetUserGroup() end -- for some reason whenever this is setup the server sets the player to user on join
function PLAYER:Ban() end

function PLAYER:SetFrozen(bool)
	if (bool) then
		self:Lock()
		self:SetDAVar('frozen', true, false, true)
	else
		self:UnLock()
		self:SetDAVar('frozen', false, false, true)
	end
end

function PLAYER:GetFrozen()
	return self:GetDAVar 'frozen'
end

function PLAYER:SetGagged(bool)
	self:SetDAVar('gagged', bool, false, true)
end

function PLAYER:IsGagged()
	return self:GetDAVar 'gagged'
end

function PLAYER:SetMuted(bool)
	self:SetDAVar('muted', bool, false, true)
end

function PLAYER:IsMuted()
	return self:GetDAVar 'muted'
end