da.commands:Command 'motd'
	:Desc 'Opens the MoTD'
	:Category 'Misc'
	

da.commands:Command 'forcemotd'
	:Desc 'Force the MoTD on a player'
	:Category 'Misc'
	:Weight(da.cfg.AdminWeight)
	:CheckWeight()
	:Adminmode(true)
	:Args({DA_PLAYER, 'Player', true})

if (SERVER) then 
	local PLAYER = FindMetaTable 'Player'

	util.AddNetworkString 'dadmin.OpenMoTD' 

	function PLAYER:ForceMoTD()
		net.Start 'dadmin.OpenMoTD'
		net.Send(self)
	end

	da.commands:Command('forcemotd'):Callback(function(cmd, pl, args, suppress)
		args[1]:ForceMoTD()

		if not (suppress) then
			da.amsg '# forced the MoTD on #.'
				:Insert(pl)
				:Insert(args[1])
				:Send()
		end
	end)
else
	local fr

	function da.OpenMoTD()
		if IsValid(fr) then return end
		
		fr = vgui.Create('DFrame')
		fr:SetTitle('MoTD')
		fr:SetSize(ScrW() * 0.9, ScrH() * 0.9)
		fr:Center()
		fr:MakePopup()

		local html = vgui.Create('DHTML', fr)
		html:SetPos(5, 30)
		html:SetSize(fr:GetWide() - 10, fr:GetTall() - 90)
		html:OpenURL(da.cfg.MoTDURL)

		local cls = vgui.Create('DButton', fr)
		cls:SetPos(fr:GetWide()/2 - 75, fr:GetTall() - 55)
		cls:SetSize(150, 50)
		cls:SetText('Close')

		cls.DoClick = function(self)
			fr:Remove()
		end
	end

	function da.CloseMoTD()
		if IsValid(fr) then fr:Remove() end
	end

	net('dadmin.OpenMoTD', function()
		da.OpenMoTD()
	end)
end

da.commands:Command('motd'):ClientCallback(da.OpenMoTD or function() end)