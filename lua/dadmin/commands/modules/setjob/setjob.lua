da.commands:Command 'setjob'
	:Desc 'Set a player\'s job'
	:Category 'DarkRP'
	:Weight(75)
	:CheckWeight(true)
	:Adminmode(true)
	:Args({DA_PLAYER, 'Player', true},
		  {DA_STRING, 'Job', true})