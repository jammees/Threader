local Promise = require(script.Parent.Promise)

type ThreadWorkerProperties = {
	Promise: typeof(Promise),
	OnCancel: (self: ThreadWorker) -> ()?,
	OnWork: (self: ThreadWorker, data: any) -> (),
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
