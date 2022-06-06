local da = da

local timer_Simple = timer.Simple
local table_insert = table.insert

da.player = da.player or {
	cache = {}
}

function da.player.Compare(pl, pl2)
	return pl:IsSuperAdmin() or (pl:GetWeight() >= pl2:GetWeight())
end

function da.player.GetOnlineStaff()
	local staff = {}

	for k, v in ipairs(player.GetAll()) do
		if v:IsAdmin() then
			table_insert(staff, v)
		end
	end

	return staff
end

function da.player.PlayerNoClip(pl, state)
	return (not state) or (pl:GetAdminmode() or pl:GetWeight() >= da.cfg.BypassWeight) and (pl:GetWeight() >= da.cfg.NoClipWeight)
end

function da.player.PhysgunPickup(pl, ent)
	if ent:IsPlayer() then
		if pl:IsAdmin() and (pl:GetAdminmode() or pl:GetWeight() >= da.cfg.BypassWeight) and da.player.Compare(pl, ent) then
			if (SERVER) then
				ent:Lock()
			end

			ent:SetMoveType(MOVETYPE_NOCLIP)
			return true
		end
	end
end

hook('PlayerNoClip', 'da.player', da.player.PlayerNoClip)
hook('PhysgunPickup', 'da.player', da.player.PhysgunPickup)