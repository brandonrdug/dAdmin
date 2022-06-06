da.time = {}

local math_Round 	= math.Round
local os_time 		= os.time

local CurTime = CurTime

function da.time.InitPlayer(pl, data)
	pl:SetDAVar('playtime', data.Time, false, true)
	pl:SetDAVar('jointime', CurTime(), false, true)

	local TimerID = 'da.timesave' .. pl:SteamID()

	timer.Create(TimerID, 300, 0, function()
		if not IsValid(pl) then timer.Remove(TimerID) return end
		data.Time = data.Time + 300
		da.mysql.query("UPDATE `da_players` SET `Time` = `Time` + 300 WHERE `SteamID` = '" .. pl:SteamID() .. "'")
	end)
end