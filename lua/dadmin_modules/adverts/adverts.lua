for k, v in ipairs(da.cfg.Adverts) do
	timer.Create('da.cfg.Adverts' .. k, v.Time or 120, v.Reps or 0, function()
		chat.AddText(unpack(v.Message))
	end)
end