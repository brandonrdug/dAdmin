nw.Register 'rank'
	:Write(net.WriteString, 32)
	:Read(net.ReadString, 32)
	:SetPlayer()

nw.Register 'srank'
	:Write(net.WriteString, 32)
	:Read(net.ReadString, 32)
	:SetPlayer()

nw.Register 'adminmode'
	:Write(net.WriteBool)
	:Read(net.ReadBool)
	:SetPlayer()

nw.Register 'playtime'
	:Write(net.WriteUInt, 32)
	:Read(net.ReadUInt, 32)
	:SetPlayer()

nw.Register 'jointime'
	:Write(net.WriteUInt, 32)
	:Read(net.ReadUInt, 32)
	:SetPlayer()

nw.Register 'jail'
	:Write(function(v)
		if (v) then
			net.WriteBool(v.Jailed)
			net.WriteUInt(v.UnjailTime, 32)
		end
	end)
	:Read(function()
		local v = { 
			Jailed = net.ReadBool(), 
			UnjailTime = net.ReadUInt(32)
		}

		return v.Jailed and v
	end)
	:SetPlayer()

nw.Register 'frozen'
	:Write(net.WriteBool)
	:Read(net.ReadBool)
	:SetPlayer()

nw.Register 'gagged'
	:Write(net.WriteBool)
	:Read(net.ReadBool)
	:SetPlayer()

nw.Register 'muted'
	:Write(net.WriteBool)
	:Read(net.ReadBool)
	:SetPlayer()