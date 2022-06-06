da.commands:Command 'blind'
	:Desc 'Set a player\'s blindness'
	:Category 'Misc'
	:Weight(da.cfg.AdminWeight)
	:CheckWeight(true)
	:Adminmode(true)
	:Args({DA_PLAYER, 'Target', true},
		  {DA_NUMBER, 'Amount (0-255)', true})
:Callback(function(cmd, pl, args, suppress)
	net.Start 'dadmin.blind'
		net.WriteUInt(args[2], 9)
	net.Send(args[1])

	if not (suppress) then
		da.amsg('# set #\'s blindness to #.')
			:Insert(pl)
			:Insert(args[1])
			:Insert(args[2])
			:Send()
	end
end)

if (SERVER) then
	util.AddNetworkString 'dadmin.blind'
end

if (CLIENT) then
	local blind

	net('dadmin.blind', function()
		blind = net.ReadUInt(9)
			blind = (blind == 0) and nil or math.Clamp(blind, 0, 255)
	end)

	hook('HUDPaint', 'dadmin.blind', function()
		if (blind) then
			lib.DrawRect(0, 0, ScrW(), ScrH(), color_white, blind)
		end
	end)
end