local da = da

da.groups = {}
	da.groups.stored 	= {}

da.groups.meta = {}
	da.groups.meta.__index = da.groups.meta
	da.groups.meta.IsGroup = true

function da.groups.Get(group)
	return da.groups.stored[group]
end

function da.groups.Exists(group)
	return (da.groups.Get(group) ~= nil)
end

function da.groups.meta.__eq(lg, rg)
	return (lg:GetWeight() == rg:GetWeight())
end

function da.groups.meta.__lt(lg, rg)
	return (lg:GetWeight() < rg:GetWeight())
end

function da.groups.meta.__le(lg, rg)
	return (lg:GetWeight() <= rg:GetWeight())
end

function da.groups.meta:GetID()
	return self.id
end

function da.groups.meta:GetWeight()
	return self.weight
end

function da.groups.meta:Alias()
	return self.alias
end

function da.groups.meta:GetColor()
	return self.color or color_white
end

function da.groups.meta:ExtraCommands()
	return self.ecmds
end

function da.groups.Setup(groupid, alias, weight, color, ecmds)
	da.groups.stored[groupid] = {
		id		= groupid,
		alias 	= alias,
		weight 	= weight,
		color	= color,
		ecmds 	= ecmds
	}
	setmetatable(da.groups.stored[groupid], da.groups.meta)
end