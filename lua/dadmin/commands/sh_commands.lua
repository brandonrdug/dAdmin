local table_Copy    = table.Copy

da.commands = {
	stored = {}
}

function da.commands.GetStored()
	return da.commands.stored
end

function da.commands.GetCommand(cmd)
	return da.commands.stored[cmd]
end

local meta = {}
	meta.__index		= meta
	meta.IsCommand		= true
	meta.type			= 'da'
	meta.category		= 'Misc'
	meta.arguments		= {}
	meta.adminmode		= false
	meta.checkweight	= false
	meta.color			= color_white
	meta.weight			= 0

function meta:GetID()
	return self.id
end

function meta:Type(type)
	self.type = type
	return self
end

function meta:GetType()
	return self.type
end

function meta:Category(cat)
	self.category = cat
	return self
end

function meta:GetCategory()
	return self.category
end

function meta:Adminmode(bool)
	self.adminmode = bool
	return self
end

function meta:RequiresAdminmode()
	return self.adminmode
end

function meta:Color(col)
	self.color = col
	return self
end

function meta:GetColor()
	return self.color
end

function meta:Desc(desc)
	self.desc = desc
	return self
end

function meta:GetDesc()
	return self.desc
end

function meta:Weight(int)
	self.weight = int
	return self
end

function meta:GetWeight()
	return da.cfg.CommandWeight[self.id] or self.weight
end

function meta:CheckWeight(bool)
	self.checkweight = bool
	return self
end

function meta:ShouldCheckWeight()
	return self.checkweight or false
end

function meta:Args(...)
	self.arguments = {...}
	return self
end

function meta:GetArgs()
	return self.arguments
end

function meta:Aliases(...)
	self.aliases = {...}

	for k, v in ipairs(self.aliases) do
		if (v ~= self:GetID()) then
			da.commands.stored[v] = self
			da.commands.stored[v].IsAlias = true
		end
	end

	return self
end

function meta:GetAliases()
	return self.aliases
end

function meta:Callback(func)
	self.callback = func
	return self
end

function meta:ClientCallback(func)
	self.clcallback = func
	return self
end

function meta:Filter(func) -- only works with broadcast callbacks
	self.filter = func
	return self
end

function meta:BroadcastCallback(func)
	self.broadcastcallback = func
	return self
end

function da.commands:Command(cmd)
	if (self.stored[cmd]) then return self.stored[cmd] end
	cmd = cmd:lower()
	self.stored[cmd] = setmetatable({}, meta)
	self.stored[cmd].id = cmd
	return self.stored[cmd]
end