local Threader = require(game:GetService("ReplicatedStorage").Threader :: any)

local TerrainGenerationThreader = Threader.new(10, script.TerrainGeneratorWorker)

local terrainSize = 200 -- terrainSize^2
local seed = 2
local resolution = 100
local frequency = 5
local magnitude = 15
local waterHeight = Random.new(seed):NextNumber()
local extraHeigt = 15

local terrainPositions = {}

for x = 1, terrainSize do
	for z = 1, terrainSize do
		table.insert(terrainPositions, {
			x = x,
			z = z,
			seed = seed,
			resolution = resolution,
			frequency = frequency,
			magnitude = magnitude,
			waterHeight = waterHeight,
			extraHeigt = extraHeigt,
		})
	end
end

task.wait(3)

TerrainGenerationThreader:Dispatch(terrainPositions):andThen(function()
	local waterBlock = Instance.new("Part")
	waterBlock.Name = "Water"
	waterBlock.Size = Vector3.new(terrainSize, 1, terrainSize)
	waterBlock.Position =
		Vector3.new(terrainSize / 2 + 0.5, extraHeigt + waterHeight * magnitude, terrainSize / 2 + 0.5)
	waterBlock.Color = Color3.fromRGB(41, 109, 255)
	waterBlock.Transparency = 0.6
	waterBlock.Anchored = true
	waterBlock.Parent = workspace
end)
