local Threader = require(game:GetService("ReplicatedStorage").Threader)

local NumThreader = Threader.new(5, script.NumWorker)

local workTable = {}
for i = 1, 10000 do
	workTable[i] = i
end

local startTime = os.clock()
NumThreader:DoWork(workTable)
	:andThen(function(results)
		print(`[Client] Finished work in {os.clock() - startTime}`, results)
	end)
	:catch(warn)
