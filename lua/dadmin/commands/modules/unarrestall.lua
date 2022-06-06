da.commands:Command 'unarrestall'
	:Desc 'Force unarrest a player'
	:Category 'DarkRP'
	:Weight(da.cfg.AdminWeight)
	:Adminmode(true)
:Callback(function(cmd, pl, args, suppress)
	for k, v in ipairs(player.GetAll()) do
		if v:isArrested() or (v.RHC_IsArrested and v:RHC_IsArrested()) then
			v:unArrest()
		end
	end

	if not (suppress) then
		da.amsg('# unarrested everyone.')
			:Insert(pl)
			:Send()
	end
end)