local Promise = require(script.Parent.Parent.Parent.Promise)
local ThreadWorker = nil
local ThreadPromise = nil

local threadDone: BindableEvent = script.Parent.ThreadDone
local threadActor = script:GetActor()

threadActor:BindToMessage("Dispatch", function(data: any)
	ThreadWorker = require(script.Parent.ThreadWorker :: any)

	ThreadPromise = Promise.try(function()
		return ThreadWorker["OnWork"](ThreadWorker, data)
	end)
		:andThen(function(processedData)
			threadDone:Fire(0, processedData)
		end)
		:catch(function(errorMessage: string)
			threadDone:Fire(-1, tostring(errorMessage))
		end)
end)

threadActor:BindToMessage("CancelDispatch", function()
	if ThreadPromise:getStatus() == Promise.Status.Resolved then
		return
	end

	if typeof(ThreadWorker["OnCancel"]) == "function" then
		ThreadWorker["OnCancel"]()
	end

	ThreadPromise:cancel()
	threadDone:Fire(-1, "Cancelled work.")
end)
