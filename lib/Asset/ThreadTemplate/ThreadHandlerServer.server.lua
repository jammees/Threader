local Promise = nil
local ThreadWorker = nil
local ThreadPromise = nil

local threadDone: BindableEvent = script.Parent.ThreadDone
local threadActor = script:GetActor()

threadActor:BindToMessage("Dispatch", function(data: any)
	ThreadWorker = require(script.Parent.ThreadWorker :: any)

	-- Here is some big brain stuff happening
	-- since ThreadWorker is guaranteed to have a Promise
	-- reference we can use that instead of trying to find A promise
	-- library that is not even 100% will be the right version.
	Promise = ThreadWorker.Promise

	ThreadPromise = Promise.try(function()
		return ThreadWorker["OnDispatch"](ThreadWorker, data)
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
