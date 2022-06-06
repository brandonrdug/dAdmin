da.commands:Command 'selldoor'
:Callback(function(cmd, pl, args, suppress)
	local door = pl:GetEyeTrace().Entity

	if not IsValid(door) or not door:isDoor() then
		da.sendmsg(pl, 'You\'re not looking at a door.')
		return
	end

	if not door:isKeysOwned() then
		da.sendmsg(pl, 'The door you\'re looking at isn\'t owned.')
		return
	end

	door:removeAllKeysExtraOwners()
	door:removeAllKeysAllowedToOwn()
	door:Fire("unlock", "", 0)
	door:keysUnOwn(door:getDoorOwner())
	door:setKeysTitle(nil)

	da.sendmsg(pl, 'You sold the door you\'re looking at.')
end)