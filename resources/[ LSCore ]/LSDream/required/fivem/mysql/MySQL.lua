local Ox = exports.LSDream
local Store = {}

local function safeArgs(query, parameters, cb, transaction)
	if type(query) == 'number' then query = Store[query] end
	if transaction then
		assert(type(query) == 'table', ('A table was expected for the transaction, but instead received %s'):format(query))
	else
		assert(type(query) == 'string', ('A string was expected for the query, but instead received %s'):format(query))
	end
	if cb then
		assert(type(cb) == 'function', ('A callback function was expected, but instead received %s'):format(cb))
	end
	local type = parameters and type(parameters)
	if type and type ~= 'table' and type ~= 'function' then
		assert(nil, ('A %s was expected, but instead received %s'):format(cb and 'table' or 'function', parameters))
	end
	return query, parameters, cb
end

MySQL = {Async = {}, Sync = {}}

MySQL.Async.execute = function(query, parameters, cb)
	Ox:update(safeArgs(query, parameters, cb))
end

MySQL.Async.fetchAll = function(query, parameters, cb)
	Ox:execute(safeArgs(query, parameters, cb))
end

MySQL.Async.fetchScalar = function(query, parameters, cb)
	Ox:scalar(safeArgs(query, parameters, cb))
end

MySQL.Async.fetchSingle = function(query, parameters, cb)
	Ox:single(safeArgs(query, parameters, cb))
end

MySQL.Async.insert = function(query, parameters, cb)
	Ox:insert(safeArgs(query, parameters, cb))
end

MySQL.Async.transaction = function(queries, parameters, cb)
	Ox:transaction(safeArgs(queries, parameters, cb, true))
end

MySQL.Async.store = function(query, cb)
	assert(type(query) == 'string', 'The SQL Query must be a string')
	local store = #Store+1
	Store[store] = query
	cb(store)
end

MySQL.Sync.execute = function(query, parameters)
	query, parameters = safeArgs(query, parameters)
	local promise = promise.new()
	Ox:update(query, parameters, function(result)
		promise:resolve(result)
	end)
	return Citizen.Await(promise)
end

MySQL.Sync.fetchAll = function(query, parameters)
	query, parameters = safeArgs(query, parameters)
	local promise = promise.new()
	Ox:execute(query, parameters, function(result)
		promise:resolve(result)
	end)
	return Citizen.Await(promise)
end

MySQL.Sync.fetchScalar = function(query, parameters)
	query, parameters = safeArgs(query, parameters)
	local promise = promise.new()
	Ox:scalar(query, parameters, function(result)
		promise:resolve(result)
	end)
	return Citizen.Await(promise)
end

MySQL.Sync.fetchSingle = function(query, parameters)
	query, parameters = safeArgs(query, parameters)
	local promise = promise.new()
	Ox:single(query, parameters, function(result)
		promise:resolve(result)
	end)
	return Citizen.Await(promise)
end

MySQL.Sync.insert = function(query, parameters)
	query, parameters = safeArgs(query, parameters)
	local promise = promise.new()
	Ox:insert(query, parameters, function(result)
		promise:resolve(result)
	end)
	return Citizen.Await(promise)
end

MySQL.Sync.transaction = function(queries, parameters)
	queries, parameters = safeArgs(queries, parameters, false, true)
	local promise = promise.new()
	Ox:transaction(queries, parameters, function(result)
		promise:resolve(result)
	end)
	return Citizen.Await(promise)
end

MySQL.Sync.store = function(query)
	assert(type(query) == 'string', 'The SQL Query must be a string')
	local store = #Store+1
	Store[store] = query
	return store
end

MySQL.ready = function(cb)
	CreateThread(function()
		repeat
			Wait(50)
		until GetResourceState('oxmysql') == 'started'
		cb()
	end)
end
