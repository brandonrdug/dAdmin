da.commands:Command 'announce'
	:Desc 'Make an announcement'
	:Category 'Misc'
	:Weight(da.cfg.SuperAdminWeight)
	:Args({DA_STRING, 'Announcement', true})
:BroadcastCallback(function(cmd, pl, args, suppress)
	da.announcement_ui:Insert(args[1], pl:Name())
	chat.AddText(Color(239, 83, 80), ' | ANNOUNCEMENT: ', color_gray, args[1], '\n-' .. pl:Name())
end)