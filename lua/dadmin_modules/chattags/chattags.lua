local util = util
local Color = Color
local net = net
local IsValid = IsValid
local string = string
local net = net
local file = file
local file = file
local IsValid = IsValid
local util = util

local tags = {
	['superadmin'] = {Color(255,255,255), '[', Color(229,57,53), 'Super Admin', Color(255,255,255), '] '},
	['admin'] = {Color(255,255,255), '[', Color(255,255,0), 'Administrator', Color(255,255,255), '] '},
	['moderator'] = {Color(255,255,255), '[', Color(255,255,102), 'Moderator', Color(255,255,255), '] '},
 	['user'] = {Color(255,255,255), '[', Color(117,117,117), 'User', Color(255,255,255), '] '},
}

local function AddToChat(bits)

	local prefixColor = Color(net.ReadUInt(8), net.ReadUInt(8), net.ReadUInt(8))
	local prefix = net.ReadString()
	local ply = net.ReadEntity()
	local textColor = Color(net.ReadUInt(8), net.ReadUInt(8), net.ReadUInt(8))
	local text = net.ReadString()

	ply = IsValid(ply) and ply or LocalPlayer()

	local tab = {}

	table.insert(tab, prefixColor)

	do
		local str = " " .. prefix .. " "
		local s, e = string.find(str, ply:Nick(), 1, true)

		if s then
			str = str:sub(0, s - 1) .. str:sub(e + 1)
		end

		local s, e = string.find(str, ply:Name(), 1, true)

		if s then
			str = str:sub(1, s - 1) .. str:sub(e + 1)
		end

		prefix = string.Trim(str) .. " "
	end

	table.insert(tab, prefix)

	if text == '' then
		table.insert(tab, 1, team.GetColor(ply:Team()))
		table.insert(tab, 2, ply:Name())
		
	else
		
		local tag = tags[ply:SteamID()] or tags[ply:GetUserGroup()]
		if tag then
			for k, v in ipairs(tag) do
				table.insert(tab, v)
			end
		end

		table.insert(tab, team.GetColor(ply:Team()))
		do
			table.insert(tab, ply:Name())
			table.insert(tab, textColor)
		end
		table.insert(tab, ': ' .. text)
		
	end

	chat.AddText(unpack(tab))
	chat.PlaySound()
  
end