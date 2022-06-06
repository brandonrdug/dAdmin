local surface_GetTextSize 	= surface.GetTextSize
local surface_SetFont		= surface.SetFont
local draw_RoundedBoxEx		= draw.RoundedBoxEx
local string_Explode		= string.Explode
local table_insert 			= table.insert
local table_remove			= table.remove
local draw_DrawText			= draw.DrawText
local CurTime 				= CurTime

local DrawRect = lib.DrawRect
local DrawText = lib.DrawText

local accent = CreateClientConVar("exhibition_color_accent", "0 190 230")

da.announcement_ui = {
	cache 	= {},
	values 	= {
		width 	= 300,
		font	= 'lib.cstd22',
		nfont	= 'lib.cstd18'
	}
}

da.cfg.AnnouncementTime = 10

function da.announcement_ui:Insert(text, plname)
	table_insert(da.announcement_ui.cache, {
		text 	= rp.textWrap(text, da.announcement_ui.values.font, da.announcement_ui.values.width - 10),
		plname 	= plname
	})
end

function da.announcement_ui.HUDPaint()
	local announcement = da.announcement_ui.cache[1]

	if (announcement) then
		announcement.time = announcement.time or CurTime()

		local clr = string_Explode(' ', accent:GetString())
		local accent = Color(clr[1], clr[2], clr[3])

		local timeSince = CurTime() - announcement.time
		local x, y = ScrW() / 2 - da.announcement_ui.values.width / 2, 100

		surface_SetFont(da.announcement_ui.values.font)
		local textw, texth = surface_GetTextSize(announcement.text)
		local h = texth + 57

		BSHADOWS.BeginShadow()
		draw_RoundedBoxEx(5, x, y, da.announcement_ui.values.width, h, Color(0, 0, 0, 160), true, true)
		BSHADOWS.EndShadow(1, 2, 2)
		draw_RoundedBoxEx(5, x, y, da.announcement_ui.values.width, 24, accent, true, true)
		DrawRect(x, y + h - 5, da.announcement_ui.values.width * (1 - timeSince / da.cfg.AnnouncementTime), 5, accent)

		DrawText('ANNOUNCEMENT', 'lib.cstd24', x + da.announcement_ui.values.width / 2, y, color_white, 1)
		draw_DrawText(announcement.text, da.announcement_ui.values.font, x + 5, y + 29, color_white)
		DrawText('-' .. announcement.plname, da.announcement_ui.values.nfont, x + da.announcement_ui.values.width - 5, y + h - 28, color_white, 2)

		if (timeSince > da.cfg.AnnouncementTime) then
			table_remove(da.announcement_ui.cache, 1)
		end
	end
end

hook('HUDPaint', 'dadmin.announcement_ui', da.announcement_ui.HUDPaint)