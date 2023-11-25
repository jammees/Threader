local Threader = require(game:GetService("ReplicatedStorage").Threader)
local ThreadWorker = Threader.ThreadWorker

local NumWorker = ThreadWorker.new()

function NumWorker:OnWork(data)
	task.desynchronize()

	debug.profilebegin("Number operations")
	debug.profilebegin("Init")
	local sumOfData = 0
	local subOfData = 0
	local mulOfData = 0
	local divOfData = 0
	local powOfData = 0
	local sinOfData = 0
	local cosOfData = 0
	local tanOfData = 0
	debug.profileend()

	debug.profilebegin("Do sum")
	for _, num in data do
		sumOfData += num
	end
	debug.profileend()

	debug.profilebegin("Do sub")
	for _, num in data do
		subOfData -= num
	end
	debug.profileend()

	debug.profilebegin("Do mul")
	for _, num in data do
		mulOfData *= num
	end
	debug.profileend()

	debug.profilebegin("Do div")
	for _, num in data do
		divOfData /= num
	end
	debug.profileend()

	debug.profilebegin("Do pow")
	for _, num in data do
		powOfData ^= num
	end
	debug.profileend()

	debug.profilebegin("Do sin")
	for _, num in data do
		sinOfData += math.sin(num)
	end
	debug.profileend()

	debug.profilebegin("Do cos")
	for _, num in data do
		cosOfData += math.cos(num)
	end
	debug.profileend()

	debug.profilebegin("Do tan")
	for _, num in data do
		tanOfData += math.tan(num)
	end
	debug.profileend()
	debug.profileend()

	return {
		sumOfData = sumOfData,
		subOfData = subOfData,
		mulOfData = mulOfData,
		divOfData = divOfData,
		powOfData = powOfData,
		sinOfData = sinOfData,
		cosOfData = cosOfData,
		tanOfData = tanOfData,
	}
end

function NumWorker:OnCancel()
	print("cancelled")
end

return NumWorker
