-- Rewrite of ObjectPool
-- This rewrite aims to be less confusing and easier to use.
type ObjectData = {
	Object: Instance,
	ID: string,
}

local HTTPService = game:GetService("HttpService")

local function CreateContainer(kind: string | Instance)
	local folder = Instance.new("Folder")
	folder.Name = typeof(kind) == "Instance" and kind.Name or tostring(kind)
	folder.Parent = script

	return folder
end

---@class PoolClass
local PoolClass = {}
PoolClass.__index = PoolClass

function PoolClass.new(kind: string | Instance, starterAmount: number?, recycle: boolean?, extensionSize: number?)
	local self = setmetatable({}, PoolClass)

	self.Container = CreateContainer(kind)
	self.Kind = kind
	self.StarterAmount = starterAmount or 1
	self.ExtensionSize = extensionSize or 1
	self.Objects = {}
	self.Available = {}
	self.Busy = {}
	self.Recycle = recycle or false

	for _ = 1, starterAmount or 0 do
		self:CreatePoolObject()
	end

	return self
end

---Creates a new pool object
---@within PoolClass
---@return table
function PoolClass:CreatePoolObject()
	local poolObject = typeof(self.Kind) == "Instance" and self.Kind:Clone() or Instance.new(self.Kind :: string)
	poolObject.Parent = self.Container

	local data = {
		Object = poolObject,
		ID = HTTPService:GenerateGUID(false),
	}

	self.Objects[data.ID] = data
	self.Available[#self.Available + 1] = data.ID

	return data
end

---Returns an object from the pool
---@within PoolClass
---@return any
function PoolClass:Get()
	local objectID = self.Available[1]

	if objectID == nil then
		if self.Recycle then
			local oldestObject = self.Objects[self.Busy[1]].Object
			self:Return(oldestObject)
			return self:Get()
		end

		for _ = 1, self.ExtensionSize do
			self:CreatePoolObject()
		end

		return self:Get()
	end

	self.Busy[#self.Busy + 1] = objectID
	table.remove(self.Available, table.find(self.Available, objectID))

	return self.Objects[objectID].Object
end

---Returns the object to the pool
---@within PoolClass
---@param object any
function PoolClass:Return(object: Instance)
	for _, objectID in self.Busy do
		if not (self.Objects[objectID].Object == object) then
			continue
		end

		self.Available[#self.Available + 1] = objectID
		table.remove(self.Busy, table.find(self.Busy, objectID))

		local poolObject = self.Objects[objectID].Object
		poolObject.Parent = self.Container

		return
	end
end

---Retires the object from the pool
---@within PoolClass
---@param object Instance
function PoolClass:Retire(object: Instance)
	for index, objectID in self.Busy do
		local poolReference = self.Objects[objectID]

		if not (poolReference.Object == object) then
			continue
		end

		table.remove(self.Busy, index)
		self.Objects[objectID] = nil
	end
end

local ObjectPool = {}
ObjectPool.__index = ObjectPool
ObjectPool.Class = PoolClass

---@class ObjectPool
function ObjectPool.new(objectList: { [string]: number })
	local poolClasses = {}

	for kind, amount in objectList do
		poolClasses[kind] = PoolClass.new(kind, amount)
	end

	return setmetatable({
		PoolClasses = poolClasses,
	}, ObjectPool)
end

-- TODO: If kind is non-existent create a new pool class with the
-- specified kind

---Returns an object from a pool, which handles the specified kind
---If `kind` does not exist, creates a new pool with the specified kind
---@within PoolClass
---@param kind string
---@return any
function ObjectPool:Get(kind: string)
	if not self.PoolClasses[kind] then
		error(`Could not get PoolClass with the following kind: {kind}!`)

		return
	end

	return self.PoolClasses[kind]:Get()
end

---Returns an object to the pool, which handles the specified object
---@within PoolClass
---@param object any
function ObjectPool:Return(object: any)
	self.PoolClasses[object.ClassName]:Return(object)
end

---Retires the object from the pool, which handles the specified object
---@within PoolClass
---@param object any
function ObjectPool:Retire(object: any)
	self.PoolClasses[object.ClassName]:Retire(object)
end

return ObjectPool
