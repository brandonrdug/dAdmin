local da 	= da
local lib 	= lib

local table_HasValue	= table.HasValue
local string_Explode 	= string.Explode
local string_upper		= string.upper
local team_GetColor		= team.GetColor
local table_remove		= table.remove
local table_insert		= table.insert
local table_concat		= table.concat
local math_abs			= math.abs
local net_WriteEntity	= net.WriteEntity
local net_WriteString	= net.WriteString
local net_WriteTable	= net.WriteTable
local net_WriteBool		= net.WriteBool
local net_Broadcast		= net.Broadcast
local net_Start			= net.Start
local net_Send			= net.Send
local hook_Run			= hook.Run

local tonumber 	= tonumber
local IsValid	= IsValid

local color_gray = Color(230, 230, 230)

util.AddNetworkString 'dadmin.commands.ClientCallback'
util.AddNetworkString 'dadmin.commands.BroadcastCLCallback'

function da.commands.ExecuteCommand(cmd, pl, args, suppress)
	local obj = istable(cmd) and cmd or da.commands:Command(cmd)

	if (obj.callback) then
		obj.callback(obj, pl, args, suppress)
	end

	if (obj.clcallback) then
		net_Start 'dadmin.commands.ClientCallback'
			net_WriteString(obj:GetID())
			net_WriteEntity(pl)
			net_WriteTable(args)
			net_WriteBool(suppress)
		net_Send(pl)
	end

	if (obj.broadcastcallback) then
		net_Start 'dadmin.commands.BroadcastCLCallback'
			net_WriteString(obj:GetID())
			net_WriteEntity(pl)
			net_WriteTable(args)
			net_WriteBool(suppress)

		if (obj.filter) then
			net_Send(isfunction(obj.filter) and obj.filter() or obj.filter)
		else
			net_Broadcast()
		end
	end

	hook_Run('DACommandRan', obj, pl, args, suppress)
end

local function ParseQuotes(args)
	local startk, endk

	for k, v in ipairs(args) do
		if (v[1] == '"') then
			startk = k
		elseif (startk and v[#v] == '"') then
			endk = k
			break
		end
	end

	if (startk and endk) then
		local num = endk - startk
		args[startk] = table_concat(args, " ", startk, endk):sub(2, -2)

		for i = 1, num do
			table_remove(args, startk + 1)
		end
		
		args = ParseQuotes(args)
	end
	
	return args
end

function da.commands.ProcessCommand(pl, cmd, args, suppress)
	local CMD = da.commands.GetCommand(cmd)

	if not pl:IsPlayer() then
		pl = da.console
	end

	if not (CMD) then
		da.sendmsg(pl, '"' .. cmd .. '" isn\'t a valid command. Use the help command for a list of valid commands.')
		return
	end

	if not pl.IsConsole and not pl:HasAccess(CMD:GetWeight()) then
		local hasAccess = false
		local group, sgroup = pl:GetGroup(), pl:GetSecondaryGroup()

		if not (group:ExtraCommands() and table_HasValue(group:ExtraCommands(), cmd)) and not (sgroup and sgroup:ExtraCommands() and table_HasValue(sgroup:ExtraCommands(), cmd)) then
			da.sendmsg(pl, 'You do not have access to this command.')
			return
		end
	end

	if CMD:RequiresAdminmode() and not pl:GetAdminmode() and (pl:GetWeight() < da.cfg.BypassWeight) then
		da.sendmsg(pl, 'You need to be in adminmode to use this command.')
		return
	end

	local nargs = {}
	local CMDArgs = CMD:GetArgs()

	if CMDArgs and CMDArgs[1] then
		local parsedArgs = ParseQuotes(args)
		local k = 1
		local i = 1

		repeat
			local v		= CMDArgs[k]
			local arg	= parsedArgs[i]
			local type 	= v[1]

			if not (arg) or (arg:Trim() == '') then
				if (v[3]) then
					da.sendcmderr(pl, CMD, 'Invalid arguments')
					return 
				end

				k = k + 1
				continue
			end

			if not (CMDArgs[k + 1]) and (parsedArgs[i + 1]) then
				arg = table_concat(parsedArgs, " ", i)
			end

			if (type == DA_PLAYER) then
				local targ

				if (arg == '@') then
					if not pl.IsConsole then
						local trace = pl:GetEyeTrace().Entity
						if IsValid(trace) and trace:IsPlayer() then
							targ = trace
						end
					end
				elseif (arg == '^') then
					targ = pl
				else
					targ = da.FindPlayer(arg)
				end

				if IsValid(targ) then
					if not pl.IsConsole and CMD:ShouldCheckWeight() then
						if (targ ~= pl) and not da.player.Compare(pl, targ) then
							da.sendcmderr(pl, CMD, 'Player\'s group weight is greater than yours.')
							targ:Message('# tried to run "#" on you.')
								:Insert(pl)
								:Insert(CMD)
								:Send(DA_ERROR)
							return
						end
					end

					table_insert(nargs, targ)
				elseif (v[3]) then
					da.sendcmderr(pl, CMD, 'Couldn\'t find player matching "' .. arg .. '"')
					return
				else
					k = k + 1
					continue
				end
			elseif (type == DA_NUMBER) then
				local num = tonumber(arg)

				if (num) then
					table_insert(nargs, num)
				elseif (v[3]) then
					da.sendcmderr(pl, CMD, 'invalid number at argument #' .. k)
					return
				else
					k = k + 1
					continue
				end
			elseif (type == DA_UNUMBER) then
				local num = tonumber(arg)

				if (num) then
					table_insert(nargs, math_abs(num))
				elseif (v[3]) then
					da.sendcmderr(pl, CMD, 'invalid number at argument #' .. k)
					return
				else
					k = k + 1
					continue
				end
			elseif (type == DA_STRING) then
				table_insert(nargs, arg)
			elseif (v[3]) then
				table_insert(nargs, arg)
			else
				k = k + 1
				continue
			end
		
			i = i + 1
			k = k + 1
		until (k > #CMDArgs)
	end

	local run, format, reasons = hook_Run('DARunCommand', CMD, pl, nargs, suppress)

	if (run == false) then
		if (format) then
			local msg = pl:Message(format)

			if (reasons) then
				for k, v in ipairs(reasons) do
					if istable(v) then
						msg:Insert(unpack(v))	
					else
						msg:Insert(v)
					end
				end
			end

			msg:Send(DA_ERROR)
		end

		return
	end

	da.commands.ExecuteCommand(CMD, pl, nargs, suppress)
end

function da.commands.PlayerSay(pl, msg)
	local prefix = msg:sub(1, 1)

	if (prefix == '@') then
		hook_Run('da.StaffRequest', pl, msg:sub(2))
		return ''
	end

	local suppress = false

	if not (prefix == '!' or prefix == '/') then
		if (prefix == da.cfg.CancelEchoCharacter) then
			local prefix2 = msg:sub(2, 2)

			if (prefix2 == '/') or (prefix2 == '!') then
				msg = msg:sub(2)

				if (pl:GetWeight() >= da.cfg.CancelEchoWeight) then
					suppress = true
				end
			end
		else
			if pl:IsMuted() then
				return ''
			end

			return
		end
	end

	local args		= string_Explode(' ', msg:sub(2))
	local cmd		= args[1]:lower()

	if (cmd == '') then
		da.commands.ProcessCommand(pl, 'help')
        return ''
    end

	if not da.commands.GetCommand(cmd) then
		if da.cfg.IgnoredCommands[cmd] or (rp and rp.getChatCommands and rp.getChatCommands()[cmd]) then if pl:IsMuted() then return '' end return end
		da.sendmsg(pl, '"' .. cmd .. '" isn\'t a valid command. Use the help command for a list of valid commands.')
        return ''
    end

	table_remove(args, 1)
	da.commands.ProcessCommand(pl, cmd, args, suppress)
    return ''
end

function da.commands.ConsoleCommand(pl, cmd, args)
	cmd = args[1] and args[1]:lower()

	if not (cmd) or (cmd:Trim() == '') then
		da.commands.ProcessCommand(pl, 'help')
        return
	end
	
	local sup = false

	if (cmd == 'suppress') then
		if (pl:GetWeight() >= da.cfg.CancelEchoWeight) then
			sup = true
		end

		cmd = args[2]
		table_remove(args, 1)
	end

	table_remove(args, 1)

	for k, v in ipairs(args) do
		if (string_upper(v) == 'STEAM_0') and (args[k + 4]) then
			args[k] = table_concat(args, '', k, k + 4)
			table_remove(args, k + 1)
			table_remove(args, k + 1)
			table_remove(args, k + 1)
			table_remove(args, k + 1)
			break
		end
	end

	da.commands.ProcessCommand(pl,  cmd, args, sup)
end

hook('PlayerSay', 'da.commands', da.commands.PlayerSay)
concommand('da', da.commands.ConsoleCommand)
concommand('dadmin', da.commands.ConsoleCommand)