da.limits = {}

function da.limits.CheckLimit(pl, type)
	local limit = pl:GetLimit(type)

	if (limit == -1) then return true end
	if (pl:GetCount(type) < limit) then
		return true
	end

	pl:LimitHit(type)
	return false
end

hook('PlayerSpawnEffect', 'da.limits', function(pl)
	return da.limits.CheckLimit(pl, 'effects')
end)

hook('PlayerSpawnNPC', 'da.limits', function(pl)
	return da.limits.CheckLimit(pl, 'npcs')
end)

hook('PlayerSpawnProp', 'da.limits', function(pl)
	return da.limits.CheckLimit(pl, 'props')
end)

hook('PlayerSpawnRagdoll', 'da.limits', function(pl)
	return da.limits.CheckLimit(pl, 'ragdolls')
end)

hook('PlayerSpawnSENT', 'da.limits', function(pl)
	return da.limits.CheckLimit(pl, 'sents')
end)

hook('PlayerSpawnSWEP', 'da.limits', function(pl)
	return da.limits.CheckLimit(pl, 'sweps')
end)

hook('PlayerGiveSWEP', 'da.limits', function(pl)
	local limit = pl:GetLimit('sweps')
	return (limit != 0) and (limit != nil)
end)

hook('PlayerSpawnVehicle', 'da.limits', function(pl)
	return da.limits.CheckLimit(pl, 'vehicles')
end)