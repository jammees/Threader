local Promise = require(script.Parent.Parent.Promise) :: any

type ThreadWorkerProperties = {
	Promise: typeof(Promise),
}

local ThreadWorkerClass = {}
ThreadWorkerClass.__index = ThreadWorkerClass

type ThreadWorker = typeof(setmetatable({} :: ThreadWorkerProperties, ThreadWorkerClass))

function ThreadWorkerClass.new(): ThreadWorker
	return setmetatable({
		Promise = Promise,
	}, ThreadWorkerClass)
end

return ThreadWorkerClass
