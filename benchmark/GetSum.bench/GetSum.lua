local GetAvarageWorker = require(game:GetService("ReplicatedStorage").Threader).ThreadWorker.new()

function GetAvarageWorker:OnWork(data)
	task.desynchronize()

	debug.profilebegin("Init")
	local sum = 0
	debug.profileend()

	debug.profilebegin("Sum")
	for _, num: number in data do
		sum += num
	end
	debug.profileend()

	return sum
end

return GetAvarageWorker
