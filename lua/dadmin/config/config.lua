da.cfg.ServerID = 1
da.cfg.ServerIDs = {
	[1] = 'DarkRP',
}

da.cfg.MoTDURL = ''

da.cfg.DefaultGroup		= 'user'

da.cfg.SuperAdminWeight	= 255
da.cfg.BypassWeight		= 100
da.cfg.AdminWeight		= 55
da.cfg.NoClipWeight 	= da.cfg.AdminWeight

da.cfg.CancelEchoCharacter 	= '~'
da.cfg.CancelEchoWeight		= 255

da.cfg.IgnoredCommands = {
	['sitcount']  	= true,
	['fspectate']	= true,
	['cancel']  	= true, 
	['open']    	= true, -- freqs
	['donate']  	= true,
	['hits']  		= true,
	['placehit']  	= true,
	['party']  		= true,
	['logs']  		= true,
	['rdmanager']  	= true,
	['zrewards']  	= true,
	['flip']  		= true,
	['flips']  		= true,
	['createflip']  = true,
	['createflips'] = true,
	['cf']  		= true,
	['poll']  		= true,
	['polladmin']  	= true,
	['titles']  	= true,
	['titlesadmin'] = true,
	['dropmoney'] 	= true,
	['drop'] 		= true,
	['snap']		= true,
	['p']           = true,
	['party']       = true,
	['parties']     = true,
	['sparties']    = true,
	['buddy']       = true,
	['buddies']     = true,
	['nitro']       = true,
}

da.cfg.CommandWeight = {
	['reload']      = 255,
	['adminchat']   = da.cfg.AdminWeight,
	['ban']         = da.cfg.AdminWeight,
	['bring']       = da.cfg.AdminWeight,
	['return']      = da.cfg.Adminweight,
	['adminmode']   = da.cfg.Adminweight,
	['freeze']      = 55,
	['goto']        = 55,
	['jail']        = 55,
	['setgroup']    = 100,
	['setsecgroup'] = 100,
	['unban']       = 85,
	['unfreeze']    = 55,
	['unjail']      = 55,
	['help']        = 0,
	['gag']        	= 55,
	['kick']        = 55,
	['mute']        = 55,
	['adminchat']   = 55,
	['announce']    = 90,
	['arrest']      = 75,
	['blind']       = 90,
	['setarmor']    = 75,
	['sethealth']   = 65,
	['unarrest']    = 55,
	['unarrestall'] = 65,
	['selldoor']	= 65,
}

da.cfg.DefaultAdminmodeModel = 'models/player/combine_super_soldier.mdl'

da.cfg.AdminmodeModels = {
	--['group'] = 'model'
}

da.cfg.AdminmodeWeapons = {
    'staff_lockpick',
    'weapon_keypadchecker',
    'stunstick',
    'unarrest_stick',
    'e2_hud',
}

da.cfg.BanLimits = {
	['superadmin'] 		= 0, -- perma
	['manager'] 		= 0, -- perma
	['senioradmin'] 	= 0, -- perma
	['council'] 		= 0, -- perma
	['headadmin'] 		= 0, -- perma
	['admin'] 			= 60 * 60 * 24 * 70, -- 10 weeks
	['seniormod'] 		= 60 * 60 * 24 * 14, -- 2 weeks
	['moderator'] 		= 60 * 60 * 24 * 2,	 -- 2 days
	['trialmod'] 		= 60 * 60 * 16, 	 -- 16 hours
}

da.cfg.BanMessage = [[------------

-- Banned --
Banned by: {Admin}
Unban time: {Time}
Reason: {Reason}
------------]]

da.cfg.Adverts = {
---------------------------------------------------------------------------------------------------------------------------------

	{
		Time = 325,	
		Repos = 0,
		Message = {Color(3,169,244), "[Server]",  Color(255,255,255), " Wish to support the server? ",  Color(105,240,174), "contribute via ", Color(0,230,118), "!donate"},
	},

---------------------------------------------------------------------------------------------------------------------------------

	{

		Time = 700,

		Repos = 0,

		Message = {Color(3,169,244), "[Server]",  Color(255,255,255), " Use @ to contact an administrator!"},

	}
}

da.cfg.JailPosition = Vector(-727.302368, 28.460270, 12288.031250)

da.cfg.JailReturnDistance = 5000 
-- how far can they move from the original jail position before they get set back?