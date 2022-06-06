da.commands:Command 'return':
Callback(function(cmd, pl, args, suppress)
	local targ = args[1]

	if targ:InVehicle() then targ:ExitVehicle() end
	if not targ:Alive() then targ:Spawn() end

	if not (targ.dareturnpos) then
		da.sendmsg(pl, 'There\'s no-where to return the target to!')
		return
	end

	targ:SetPos(targ.dareturnpos)
	targ.dareturnpos = nil	

	if not (suppress) then
		da.amsg '# returned #'
			:Insert(pl)
			:Insert(targ)
			:Send()
	end
end)