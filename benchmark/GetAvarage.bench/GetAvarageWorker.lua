local GetAvarageWorker = require(game:GetService("ReplicatedStorage").Threader).ThreadWorker.new()

function GetAvarageWorker:OnWork(data)
	local sum = 0
	local iter = 0

	for _, num: number in data do
		sum += num
		iter += 1
	end

	return sum / iter
end

return GetAvarageWorker
