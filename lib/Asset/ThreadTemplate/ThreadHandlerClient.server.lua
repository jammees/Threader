local Promise = require(script.Parent.Parent.Parent.Promise)
local ThreadWorker = nil
local ThreadPromise = nil

local threadDone: BindableEvent = script.Parent.ThreadDone
local threadActor = script:GetActor()

threadActor:BindToMessage("DoWork", function(data: any)
	debug.profilebegin("Get ThreadWorker")
	ThreadWorker = require(script.Parent.ThreadWorker :: any)
	debug.profileend()

	ThreadPromise = Promise.try(function()
		local returnedData = ThreadWorker["OnWork"](ThreadWorker, data)

		return returnedData
	end)
		:andThen(function(processedData)
			debug.profilebegin("Call ThreadDone with return code 0")
			threadDone:Fire(0, processedData)
			debug.profileend()
		end)
		:catch(function(errorMessage: string)
			debug.profilebegin("Call ThreadDone with return code 1")
			threadDone:Fire(-1, tostring(errorMessage))
			debug.profileend()
		end)
end)

threadActor:BindToMessage("Cancel", function()
	if ThreadPromise:getStatus() == Promise.Status.Resolved then
		return
	end

	if typeof(ThreadWorker["OnCancel"]) == "function" then
		ThreadWorker["OnCancel"]()
	end

	ThreadPromise:cancel()
	threadDone:Fire(-1, "Cancelled work.")
end)
