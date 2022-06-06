require 'mysqloo'

local da = da

local string_format = string.format

da.mysql    	= {}
da.mysql.db 	= mysqloo.connect(da.cfg.MySQL.hostname, da.cfg.MySQL.username, da.cfg.MySQL.password, da.cfg.MySQL.database, da.cfg.MySQL.port)
da.mysql.gdb 	= mysqloo.connect(da.cfg.MySQL.hostname, da.cfg.MySQL.username, da.cfg.MySQL.password, da.cfg.MySQL.globaldb, da.cfg.MySQL.port)

local db = da.mysql.db

function db:onConnected()
	da.print 'Database successfully connected.'
	hook.Run 'DADatabaseConnected'
end

function db:onConnectionFailed(err)
	print('Database connection failed! error:\n' .. err)
end

function da.mysql.query(querystr, callback)
	local query = db:query(querystr)
	
	function query:onSuccess(data)
        if (callback) then
			callback(data)
		end
	end

	function query:onError(err, sql)
		print('query failed! error:\n' .. err .. '\n> ' .. sql)
	end

	query:start()
	return query
end

db:connect()

local db = da.mysql.gdb

function db:onConnected()
	da.print 'Global database successfully connected.'
	hook.Run 'DAGlobalDatabaseConnected'
end

function db:onConnectionFailed(err)
	print('Global database connection failed! error:\n' .. err)
end

function da.mysql.gquery(querystr, callback)
	local query = db:query(querystr)
	
	function query:onSuccess(data)
        if (callback) then
			callback(data)
		end
	end

	function query:onError(err, sql)
		print('global query failed! error:\n' .. err .. '\n> ' .. sql)
	end

	query:start()
	return query
end

db:connect()