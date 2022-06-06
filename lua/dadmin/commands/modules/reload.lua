da.commands:Command 'reload'
	:Desc 'Reload the server'
	:Weight(255)
	:Callback(function(cmd, pl, args, suppress)
		RunConsoleCommand('changelevel', game.GetMap())
	end)