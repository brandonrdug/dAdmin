local da 	= da
local lib 	= lib

local util_SteamIDTo64	= util.SteamIDTo64
local string_Explode	= string.Explode
local team_GetColor		= team.GetColor
local table_insert		= table.insert

local ipairs        = ipairs
local unpack		= unpack

local color_yellow	= Color(255, 235, 59)
local color_dgray	= Color(140, 140, 140)
local color_red		= Color(239, 83, 80)

local function coolParse(...)
	local args 	= {...}
	local k = 1

	if (#args >= 1) then
		repeat
			local v = args[k]
			local i		

			if isentity(v) or (istable(v) and v.IsConsole) then
				if v:IsPlayer() or v.IsConsole then
					local color = v:IsValid() and ((v:Team() != TEAM_CONNECTING) and team_GetColor(v:Team())) or color_gray
					local name 	= v:Name()
					local id	= v:IsValid() and ('(' .. v:SteamID() .. ')') or nil

					args[k] = color
					i = table_insert(args, k + 1, name)
					i = table_insert(args, i + 1, color_dgray)
					i = id and table_insert(args, i + 1, id) or i
					k = table_insert(args, i + 1, color_gray)
				end
			elseif istable(v) then
				if (v.IsCommand) or (v.IsGroup) then
					args[k] = v:GetColor()
					i = table_insert(args, k + 1, v:GetID())
					k = table_insert(args, i + 1, color_gray)
				end
			elseif isstring(v) then
				if (v:find('STEAM_')) then
					local idstr = v

					if v:StartWith('(') then
						idstr = v:TrimLeft '(':TrimRight ')'
					end

					if (util_SteamIDTo64(idstr) ~= 0) then
						args[k] = color_dgray
						k = table_insert(args, k + 1, v)
					end
				end
			end

			k = k + 1
		until (k >= #args)
	end

	return unpack(args)
end

function da.sendcmderr(pl, cmd, ...)
	if (not pl:IsPlayer()) then
		da.print('Invalid usage of "' .. cmd:GetID() .. '": ', coolParse(...))
		return
	end

	lib.sendmsg(pl, color_red, ' | ', color_gray, 'Invalid usage of "', cmd:GetColor(), cmd:GetID(), color_gray, '": ', coolParse(...))

	if (cmd:GetArgs()[1]) then
		local args = {}

		for k, v in ipairs(cmd:GetArgs()) do -- ¯\_(ツ)_/¯
			table_insert(args, ' [' .. v[2] .. ':')
			table_insert(args, v[3] and color_red or color_yellow)
			table_insert(args, v[3] and 'required' or 'optional')
			table_insert(args, color_gray)
			table_insert(args, ']')
		end

		lib.sendmsg(pl, color_red, ' | ', color_gray, 'Valid usage: /' .. cmd:GetID(), unpack(args))
	end
end

function da.sendmsg(pl, ...)
	if (not pl:IsPlayer()) then
		da.print(...)
		return
	end

	lib.sendmsg(pl, DA_COLOR, ' | ', color_gray, ...)
end

function da.msgall(...)
	lib.msgall(DA_COLOR, ' | ', color_gray, coolParse(...))
end

DA_ERROR = 1

local obj = {}
    obj.__index = obj

function obj:Insert(...)
	local args 	= {...}
	local nargs = {}

	for k, v in pairs(args) do
		if (v ~= nil) then
			table_insert(nargs, v)
		end
	end

	if (nargs[1] ~= nil) then
		table_insert(self.ins, nargs)
	end

	return self
end

function obj:Send(type)
	local input = {}
	local split = string_Explode('#', self.str)

	for k, v in ipairs(split) do
		table_insert(input, color_gray)
		table_insert(input, v)
		
		if (self.ins[k]) then
			for _, nv in ipairs(self.ins[k]) do
				local parse = {coolParse(nv)}

				for _, cp in ipairs(parse) do
					table_insert(input, cp)
				end
			end
		end
	end

	if (self.pl) then
		lib.sendmsg(self.pl, (type == 1) and color_red or DA_COLOR, ' | ', unpack(input))
	else
		lib.msgall((type == 1) and color_red or DA_COLOR, ' | ', unpack(input))
	end
end

function da.amsg(pl, str)
    local msg = {}
        msg.ins = {}
        msg.str = str or pl
        msg.pl	= isentity(pl) and pl
        setmetatable(msg, obj)
	return msg
end

local meta = FindMetaTable 'Player'
	meta.Message = da.amsg