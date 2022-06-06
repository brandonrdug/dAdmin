da.commands:Command 'help'
	:Desc 'Sends you a list of commands you can run'
	:ClientCallback(function(cmd, pl, args, suppress)
		da.print('List of commands: \n')

		for k, v in pairs(da.commands.GetStored()) do
			local str = ''

			for _, a in ipairs(v:GetArgs()) do
				str = str .. '[' .. a[2] .. '] '
			end

			da.print(v:GetID() .. ' | ' .. v:GetDesc() .. '\n     Usage: /' .. v:GetID() .. ' ' .. str .. '\n')
		end
	end)