da.commands:Command 'adminmode'
	:Desc 'Toggles you in and out of adminmode'
	:Weight(da.cfg.AdminWeight)
	:Callback(function(cmd, pl, args, suppress)
		pl:SetAdminmode(not pl:GetAdminmode())
		pl:Message('You went # adminmode.')
			:Insert(pl:GetAdminmode() and 'into' or 'out of')
			:Send()
	end)