net.Receive('dadmin.commands.ClientCallback', function()
	local id 		= net.ReadString()	
	local pl 		= net.ReadEntity()
		pl = IsValid(pl) and pl or CONSOLE
	local args 		= net.ReadTable()
	local suppress 	= net.ReadBool()


	local cmd = da.commands.GetCommand(id)
	cmd.clcallback(cmd, pl, args, suppress)
end)

net.Receive('dadmin.commands.BroadcastCLCallback', function()
	local id 		= net.ReadString()
	local pl 		= net.ReadEntity()
		pl = IsValid(pl) and pl or CONSOLE
	local args 		= net.ReadTable()
	local suppress 	= net.ReadBool()


	local cmd = da.commands.GetCommand(id)
	cmd.broadcastcallback(cmd, pl, args, suppress)
end)