local Threader = require(game:GetService("ReplicatedStorage").Threader :: any)

local NumThreader = Threader.new(5, script.NumWorker)

local workTable = {}
for i = 1, 10000 do
	workTable[i] = i
end

local t1 = os.clock()
NumThreader:Dispatch(workTable)
	:andThen(function(results)
		print(`[Client] Finished work in {os.clock() - t1}`, results)
	end)
	:catch(warn)
