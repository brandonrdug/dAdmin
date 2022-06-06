da.commands:Command 'adminchat'
	:Aliases('asay', 'ac')
	:Desc 'Talk in admin chat'
	:Category 'Utility'
	:Weight(da.cfg.AdminWeight)
	:Args({DA_STRING, 'Message', true})
	:Filter(SERVER and da.player.GetOnlineStaff)
	:BroadcastCallback(function(cmd, pl, args)
		chat.AddText(DA_COLOR, 'STAFF | ', (pl == CONSOLE) and color_white or team.GetColor(pl:Team()), pl:Name(), Color(171, 71, 188), ': ' .. args[1])
	end)