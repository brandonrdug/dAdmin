da      = da 		or {}
da.cfg  = da.cfg 	or {}

DA_COLOR	= Color(3, 169, 244)
DA_PLAYER   = 1
DA_STRING   = 2
DA_NUMBER   = 3
DA_UNUMBER  = 4

color_gray = Color(210, 210, 210)

function da.print(...)
	MsgC(DA_COLOR, ' | ', color_gray, ..., '\n')
end

include_sh 'dadmin/config/config.lua'

include_sh 'dadmin/utility/sh_util.lua'
include_sv 'dadmin/utility/sv_util.lua'
include_cl 'dadmin/utility/cl_util.lua'

include_sv 'dadmin/config/mysql.lua'
include_sv 'dadmin/mysql/sql.lua'

include_sh 'dadmin/groups/sh_groups.lua'
include_sv 'dadmin/groups/sv_groups.lua'
include_sh 'dadmin/config/groups.lua'

include_sv 'dadmin/bans/sv_bans.lua'

include_sv 'dadmin/jails/sv_jail.lua'

include_sh 'dadmin/commands/sh_commands.lua'
include_sv 'dadmin/commands/sv_commands.lua'
include_cl 'dadmin/commands/cl_commands.lua'

include_sh 'dadmin/player/console.lua'
include_sh 'dadmin/player/sh_playervars.lua'
include_sh 'dadmin/player/sh_player.lua'
include_sh 'dadmin/player/sh_player_meta.lua'
include_sv 'dadmin/player/sv_player.lua'
include_sv 'dadmin/player/sv_time.lua'
include_sv 'dadmin/player/sv_player_meta.lua'

include_sh 'dadmin/config/limits.lua'
include_sv 'dadmin/limits/sv_limits_meta.lua'
include_sv 'dadmin/limits/sv_limits.lua'

local dir 				= 'dadmin/commands/modules/'
local files, folders 	= file.Find(dir .. '*', 'LUA')

for k, v in ipairs(files) do
	include_sh(dir .. v)
end

for k, v in ipairs(folders) do
	files = file.Find(dir .. v .. '/*.lua', 'LUA')
	
	for _, f in ipairs(files) do
		local rl = f:sub(1, 2)

		if (rl == 'sv') then
			include_sv(dir .. v .. '/' .. f)
		elseif (rl == 'cl') then
			include_cl(dir .. v .. '/' .. f)
		else
			include_sh(dir .. v .. '/' .. f)
		end
	end
end

timer.Create('da.timer', 1, 0, function()
	for k, v in ipairs(player.GetAll()) do
		hook.Run('DAPlayerTimer', v)
	end
end)

local dir 			= 'dadmin_modules/'
local _, folders 	= file.Find(dir .. '*', 'LUA')

for k, v in ipairs(folders) do
	include_sh(dir .. v .. '/module.lua')
end