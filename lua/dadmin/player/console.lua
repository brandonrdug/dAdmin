da.console = {IsConsole = true}

CONSOLE = da.console

function da.console:IsValid()
	return false
end

function da.console:IsPlayer()
	return false
end

function da.console:GetUserGroup()
	return 'superadmin'
end

function da.console:GetGroup()
	return da.groups.Get 'superadmin'
end

function da.console:IsUserGroup(group)
	return true
end

function da.console:GetWeight()
	return 99999
end

function da.console:GetAdminmode()
	return true
end

function da.console:IsAdmin()
	return true
end

function da.console:IsSuperAdmin()
	return true
end

function da.console:Name()
	return 'Console'
end

function da.console:Nick()
	return 'Console'
end

function da.console:SteamID()
	return 'Console'
end

function da.console:SteamID64()
	return 'Console'
end

function da.console:NameID()
	return 'Console'
end

function da.console:Team()
	return TEAM_CITIZEN
end