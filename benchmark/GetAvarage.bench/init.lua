--[[

|WARNING| THESE TESTS RUN IN YOUR REAL ENVIRONMENT. |WARNING|

If your tests alter a DataStore, it will actually alter your DataStore.

This is useful in allowing your tests to move Parts around in the workspace or something,
but with great power comes great responsibility. Don't mess up your stuff!

---------------------------------------------------------------------

Documentation and Change Log:
https://devforum.roblox.com/t/benchmarker-plugin-compare-function-speeds-with-graphs-percentiles-and-more/829912/1

--------------------------------------------------------------------]]

type Profiler = {
	Begin: (label: string) -> (),
	End: () -> (),
}

local Threader = require(game:GetService("ReplicatedStorage").Threader)
local AvarageThreader = Threader.new(1, script.GetAvarageWorker)

return {
	ParameterGenerator = function()
		AvarageThreader:AwaitState(Threader.States.Standby):await()

		return table.create(1000, 10)
	end,

	Functions = {
		["1 thread"] = function(Profiler: Profiler, RandomNumbers)
			Profiler.Begin("Set threads")
			AvarageThreader.IsWorking = false
			AvarageThreader:SetThreads(1)
			Profiler.End()

			Profiler.Begin("Work")
			AvarageThreader:Dispatch(RandomNumbers)
			Profiler.End()
		end,

		["2 thread"] = function(Profiler: Profiler, RandomNumbers)
			Profiler.Begin("Set threads")
			AvarageThreader.IsWorking = false
			AvarageThreader:SetThreads(2)
			Profiler.End()

			Profiler.Begin("Work")
			AvarageThreader:Dispatch(RandomNumbers)
			Profiler.End()
		end,

		["5 thread"] = function(Profiler: Profiler, RandomNumbers)
			Profiler.Begin("Set threads")
			AvarageThreader.IsWorking = false
			AvarageThreader:SetThreads(5)
			Profiler.End()

			Profiler.Begin("Work")
			AvarageThreader:Dispatch(RandomNumbers)
			Profiler.End()
		end,

		["10 thread"] = function(Profiler: Profiler, RandomNumbers)
			Profiler.Begin("Set threads")
			AvarageThreader.IsWorking = false
			AvarageThreader:SetThreads(10)
			Profiler.End()

			Profiler.Begin("Work")
			AvarageThreader:Dispatch(RandomNumbers)
			Profiler.End()
		end,
	},
}
