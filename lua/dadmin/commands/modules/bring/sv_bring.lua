da.commands:Command 'bring':
Callback(function(cmd, pl, args, suppress)
	local targ = args[1]

	if targ:InVehicle() then targ:ExitVehicle() end
	if not targ:Alive() then targ:Spawn() end

	targ.dareturnpos = targ:GetPos()
	targ:SetPos(pl:GetPos() + pl:GetForward() * 50 + Vector(0, 0, 20))

	if not (suppress) then
		da.amsg '# brought #'
			:Insert(pl)
			:Insert(targ)
			:Send()
	end
end)