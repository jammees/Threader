local Threader = require(game:GetService("ReplicatedStorage").Threader)

local NumThreader = Threader.new(5, script.NumWorker)

local workTable = {}
for i = 1, 10000 do
	workTable[i] = i
end

local t1 = os.clock()
NumThreader:DoWork(workTable)
	:andThen(function(results)
		print(`[Server] Finished work in {os.clock() - t1}`, results)
	end)
	:catch(warn)
