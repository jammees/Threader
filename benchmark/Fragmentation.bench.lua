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

return {
	ParameterGenerator = function()
		-- This function is called before running your function (outside the timer)
		-- and the return(s) are passed into your function arguments (after the Profiler). This sample
		-- will pass the function a random number, but you can make it pass
		-- arrays, Vector3s, or anything else you want to test your function on.
		return table.create(10000, 1), 5
	end,

	Functions = {
		["TaskDistributor"] = function(Profiler: Profiler, Data, ChunkSize) -- You can change 'Sample A' to a descriptive name for your function
			local function GetDataSize(tbl)
				local size = 0

				for _ in tbl do
					size += 1
				end

				return size
			end

			Profiler.Begin("Init values")
			local dataChunk = {}
			local iteration = 1
			local chunkIteration = 1
			local chunkSize = math.ceil(GetDataSize(Data) / ChunkSize)

			dataChunk[chunkIteration] = {}
			Profiler.End()

			Profiler.Begin("Fragmentation")
			for _, objectData in Data do
				Profiler.Begin("Check chunk size")
				if iteration > chunkSize then
					chunkIteration += 1
					iteration = 1
					dataChunk[chunkIteration] = {}
				end
				Profiler.End()

				Profiler.Begin("Write")
				dataChunk[chunkIteration][iteration] = objectData
				Profiler.End()

				Profiler.Begin("Increment counter")
				iteration += 1
				Profiler.End()
			end
			Profiler.End()
		end,

		["Threader"] = function(Profiler: Profiler, Data, ChunkSize)
			Profiler.Begin("Init values")
			local dataSize = table.getn(Data)
			local dataChunkSize = math.ceil(dataSize / ChunkSize)

			local fragmentedData = {}
			Profiler.End()

			Profiler.Begin("Fragmentation")
			for i = 1, ChunkSize do
				Profiler.Begin("Get Min and Max range")
				local min = dataChunkSize * (i - 1) + 1
				local max = dataChunkSize * i
				Profiler.End()

				Profiler.Begin("Write")
				fragmentedData[i] = {}
				table.move(Data, min, max, 1, fragmentedData[i])
				Profiler.End()
			end
			Profiler.End()
		end,

		-- You can add as many functions as you like!
	},
}
