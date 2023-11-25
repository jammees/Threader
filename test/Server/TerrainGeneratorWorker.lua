local ServerScriptService = game:GetService("ServerScriptService")

local TerrainDataType = require(ServerScriptService.ThreaderServer.TerrainDataType)
local Threader = require(game:GetService("ReplicatedStorage").Threader)

local TerrainGeneratorWorker = Threader.ThreadWorker.new()

function TerrainGeneratorWorker:OnDispatch(terrainSet: { TerrainDataType.TerrainData })
	local randomNumberGenerator = Random.new(terrainSet[1].seed)

	for _, terrainData in terrainSet do
		task.desynchronize()

		local noiseY = math.noise(
			terrainData.x / terrainData.resolution * terrainData.frequency,
			terrainData.z / terrainData.resolution * terrainData.frequency,
			13 / (terrainData.seed - 0.01)
		) + 0.5

		local partSize = Vector3.one + Vector3.yAxis * 2
		local partPosition =
			Vector3.new(terrainData.x, noiseY * terrainData.magnitude - 1 + terrainData.extraHeigt, terrainData.z)
		local partColor = nil

		local distanceFromWaterLevel = noiseY - terrainData.waterHeight

		-- above water
		if distanceFromWaterLevel > 0.1 then
			partColor = Color3.fromRGB(13, 134, 17)
		-- below water
		elseif distanceFromWaterLevel < 0 then
			partColor = Color3.fromRGB(176, 86, 26)
		-- at edge
		else
			partColor = Color3.fromRGB(208, 204, 91)
		end

		task.synchronize()

		local part = Instance.new("Part")
		part.Size = partSize
		part.Position = partPosition
		part.Anchored = true
		part.Color = partColor
		part.Parent = workspace.Terrain

		-- Tree generation
		local treeDistanceWater = noiseY - terrainData.waterHeight
		if not (treeDistanceWater > 0.15 and treeDistanceWater < 0.5) then
			continue
		end

		task.desynchronize()

		local offsetX = randomNumberGenerator:NextNumber(-0.3, 0.3)
		local offsetY = randomNumberGenerator:NextNumber(-0.4, 0.3)
		local offsetZ = randomNumberGenerator:NextNumber(-0.3, 0.3)

		local trunkSize = 1.5

		local foliagePosition = Vector3.yAxis * trunkSize - Vector3.yAxis * 0.345
		local treePosition =
			CFrame.new(terrainData.x + offsetX, part.Position.Y + part.Size.Y - 1 + offsetY, terrainData.z + offsetZ)

		task.synchronize()

		local tree = Instance.new("Model")
		tree.Name = "Tree"
		tree.Parent = workspace.Terrain

		local trunk = Instance.new("Part")
		trunk.Color = Color3.fromRGB(176, 86, 26)
		trunk.Size = Vector3.new(0.273, trunkSize, 0.273)
		trunk.Anchored = true
		trunk.Name = "Trunk"
		trunk.Parent = tree

		local foliage = Instance.new("Part")
		foliage.Shape = Enum.PartType.Ball
		foliage.Color = Color3.fromRGB(75, 151, 75)
		foliage.Name = "Foliage"
		foliage.Anchored = true
		foliage.Position = foliagePosition
		foliage.TopSurface = Enum.SurfaceType.Smooth
		foliage.Parent = tree

		tree.PrimaryPart = trunk

		tree:SetPrimaryPartCFrame(treePosition)

		local collidingParts = foliage:GetTouchingParts()
		for _, collideTree in collidingParts do
			if not (collideTree.Name == "Foliage") then
				continue
			end

			tree:Destroy()
		end
	end
end

return TerrainGeneratorWorker
