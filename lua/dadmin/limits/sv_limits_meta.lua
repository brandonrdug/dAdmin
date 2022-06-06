local PLAYER = FindMetaTable 'Player'

function PLAYER:GetLimit(type)
	local limits = da.cfg.Limits[self:GetUserGroup()] or da.cfg.Limits.default
	if (limits == -1) then return -1 end

	local limit = limits[type]

	if self:GetSecondaryUserGroup() then
		local slimits = da.cfg.Limits[self:GetSecondaryUserGroup()] or da.cfg.Limits.default
		if (slimits == -1) then return -1 end

		local slimit = slimits[type]
		limit = slimit > limit and slimit or limit
	end

	if ( limit > -1 and self.credits and self.credits.propCount ) then
		limit = limit + self.credits.propCount
	end

	return (limit)
end