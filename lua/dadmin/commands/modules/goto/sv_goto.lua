da.commands:Command 'goto':
Callback(function(cmd, pl, args, suppress)
	local targ = args[1]

	if pl:InVehicle() then pl:ExitVehicle() end
	if not pl:Alive() then pl:Spawn() end

	pl.dareturnpos = pl:GetPos()
	pl:SetPos(targ:GetPos() + targ:GetForward() * 50 + Vector(0, 0, 20))

	if not (suppress) then
		da.amsg '# went to #'
			:Insert(pl)
			:Insert(targ)
			:Send()
	end
end)