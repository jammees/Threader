-- base generation by: https://www.youtube.com/watch?v=yA210k9ie8Y

local gridSize = 250
local resolution = 100
local frequency = 5
local magnitude = 15
local seed = 2
local height = 15

local randomNumberGenerator = Random.new(seed)
local waterHeight = randomNumberGenerator:NextNumber()

local cells = {}

local guide = Instance.new("Part")
guide.Name = "Guide"
guide.Size = Vector3.new(gridSize, 1, gridSize)
guide.Position = Vector3.new(gridSize / 2 + 0.5, height, gridSize / 2 + 0.5)
guide.Color = Color3.fromRGB(255, 200, 33)
guide.Transparency = 0.8
guide.Anchored = true
guide.Parent = workspace

task.wait(3)

local t1 = os.clock()

local function GenerateTree(x, y, z)
	local tree = Instance.new("Model")
	tree.Name = "Tree"
	tree.Parent = workspace.Terrain

	local trunk = Instance.new("Part")
	trunk.Color = Color3.fromRGB(176, 86, 26)
	trunk.Size = Vector3.new(0.273, 1.5, 0.273)
	trunk.Anchored = true
	trunk.Name = "Trunk"
	trunk.Parent = tree

	local foliage = Instance.new("Part")
	foliage.Shape = Enum.PartType.Ball
	foliage.Color = Color3.fromRGB(75, 151, 75)
	foliage.Name = "Foliage"
	foliage.Anchored = true
	foliage.Position = Vector3.yAxis * trunk.Size.Y - Vector3.yAxis * 0.345
	foliage.TopSurface = Enum.SurfaceType.Smooth
	foliage.Parent = tree

	tree.PrimaryPart = trunk

	local offsetX = randomNumberGenerator:NextNumber(-0.3, 0.3)
	local offsetY = randomNumberGenerator:NextNumber(-0.4, 0.3)
	local offsetZ = randomNumberGenerator:NextNumber(-0.3, 0.3)

	tree:SetPrimaryPartCFrame(CFrame.new(x + offsetX, y + offsetY, z + offsetZ))

	local collidingParts = foliage:GetTouchingParts()
	for _, part in collidingParts do
		if not (part.Name == "Foliage") then
			continue
		end

		tree:Destroy()
	end
end

local function GenerateTrees()
	for x = 1, gridSize do
		for z = 1, gridSize do
			local treeNoiseValue = math.noise(x / resolution, z / resolution, 5 / (seed - 0.01)) + 0.5

			local partTerrain: Part = cells[`{x},{z}`]
			local partNoise = (partTerrain.Position.Y + 1 - height) / magnitude

			local distanceFromWaterLevel = partNoise - waterHeight
			if distanceFromWaterLevel > 0.15 and distanceFromWaterLevel < 0.4 then
				if treeNoiseValue > 0.25 then
					GenerateTree(x, partTerrain.Position.Y + partTerrain.Size.Y - 1, z)
				end
			end
		end
	end
end

for x = 1, gridSize do
	for z = 1, gridSize do
		local noiseY = math.noise(x / resolution * frequency, z / resolution * frequency, 13 / (seed - 0.01))
		noiseY += 0.5

		local part = Instance.new("Part")
		part.Size = Vector3.one + Vector3.yAxis * 2
		part.Position = Vector3.new(x, noiseY * magnitude + height - 1, z)
		part.Anchored = true

		local distanceFromWaterLevel = noiseY - waterHeight

		-- above water
		if distanceFromWaterLevel > 0.1 then
			part.Color = Color3.fromRGB(13, 134, 17)
		-- below water
		elseif distanceFromWaterLevel < 0 then
			part.Color = Color3.fromRGB(176, 86, 26)
		-- at edge
		else
			part.Color = Color3.fromRGB(208, 204, 91)
		end

		cells[`{x},{z}`] = part

		part.Parent = workspace.Terrain
	end
end

local waterBlock = Instance.new("Part")
waterBlock.Name = "Water"
waterBlock.Size = Vector3.new(gridSize, 1, gridSize)
waterBlock.Position = Vector3.new(gridSize / 2 + 0.5, height + waterHeight * magnitude, gridSize / 2 + 0.5)
waterBlock.Color = Color3.fromRGB(41, 109, 255)
waterBlock.Transparency = 0.6
waterBlock.Anchored = true
waterBlock.Parent = workspace

GenerateTrees()

guide:Destroy()

warn(`Finished generating a {gridSize}x{gridSize} terrain in {os.clock() - t1} ms!`)
