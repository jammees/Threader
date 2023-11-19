--!strict
--[[
    Threader

    Another implementation of an Actor wrapper
    to make it easier to work with them. Now you may ask
	this amazing question: Why does this exist? I would
	most likely reply: It is an excuse for me to not
	work on Rethink.

	On the talk of Rethink. Have you ever tried to make a 2D
	game engine but backed down because ROBLOX does not come
	with pre-made tools to aid developers in such styled games?
	Well Rethink might be the tool for you: A versatile, easy-to-use
	2D game engine! It's 3:37 AM as of writing this. Why am I not
	going to bed and better yet why am I still writing thi-
]]

type Thread = Actor & {
	Worker: ModuleScript,
	ThreadDone: BindableEvent,
	ThreadHandlerClient: Script,
	ThreadHandlerServer: Script,
}

local threadTemplate = script.Asset.ThreadTemplate
local threadsContainer: Folder = nil

local RunService = game:GetService("RunService")
local ServerStorage = game:GetService("ServerStorage")
local Players = game:GetService("Players")

local Promise = require(script.Promise)
local ThreadWorkerClass = require(script.ThreadWorkerClass)
local PoolClass = require(script.ObjectPool).Class

local isServer = RunService:IsServer()
local isClient = RunService:IsClient()
local containerPath = (isServer and ServerStorage) or (isClient and Players.LocalPlayer.PlayerScripts) or script

Promise.try(function()
	return containerPath["_Threads"]
end)
	:andThen(function(path)
		threadsContainer = path
	end)
	:catch(function()
		threadsContainer = Instance.new("Folder")
		threadsContainer.Name = "_Threads"
		threadsContainer.Parent = containerPath

		if containerPath == script then
			warn(`Could not identify client/server context!`)
		end
	end)

local function GetCallerName()
	local stacktrace = debug.traceback()
	local splitByLines = string.split(stacktrace, "\n")
	local splitByDots = string.split(splitByLines[4], ".")
	return string.split(splitByDots[#splitByDots], ":")[1]
end

local function CreateThreadContainer()
	local folder = Instance.new("Folder")
	folder.Name = GetCallerName()
	folder.Parent = threadsContainer

	script.Promise:Clone().Parent = threadsContainer

	return folder
end

local function Assert(Predicate: boolean, errorMessage: string)
	if Predicate then
		return
	end

	error(errorMessage, 2)
end

local Threader = {}
Threader.__index = Threader
Threader.__tostring = function(self)
	return `Threader<{self._WorkerModule.Name}>`
end

type ThreaderProperties = {
	_WorkerModule: ModuleScript,
	_Threads: {},
	_Container: Folder,
	_ThreadPool: typeof(PoolClass),
	State: string,
}

type Threader = typeof(setmetatable({} :: ThreaderProperties, Threader))

Threader.Promise = Promise
Threader.ThreadWorker = ThreadWorkerClass

Threader.States = {
	Standby = "Standby",
	Working = "Working",
}

function Threader.new(amountThreads: number, workerModule: ModuleScript)
	Assert(typeof(amountThreads) == "number", `Expected number, got; {typeof(amountThreads)}!`)
	Assert(workerModule:IsA("ModuleScript"), `Expected ModuleScript, got; {workerModule.ClassName}!`)

	local self = setmetatable(
		{
			_WorkerModule = workerModule,
			_Threads = {},
			_Container = CreateThreadContainer(),
			_ThreadPool = PoolClass.new(threadTemplate, amountThreads, false, 5),

			State = Threader.States.Standby,
		} :: ThreaderProperties,
		Threader
	)

	self:_GenerateWorkers(amountThreads)

	return self
end

function Threader._GenerateWorkers(self: Threader, amountThreads: number)
	for _ = 1, amountThreads do
		local threadIndex = #self._Threads + 1

		local thread = self._ThreadPool:Get()
		local worker = self._WorkerModule:Clone()

		worker.Name = "ThreadWorker"
		thread.Name = `Actor-{threadIndex}`

		worker.Parent = thread
		thread.Parent = self._Container

		self._Threads[threadIndex] = thread
	end
end

function Threader._FragmentWorkData(self: Threader, workData: { [any]: any })
	local function GetDataSize(tbl)
		local size = 0

		for _ in tbl do
			size += 1
		end

		return size
	end

	-- Code from TaskDistributor
	local dataChunk = {}
	local iteration = 1
	local chunkIteration = 1
	local chunkSize = math.ceil(GetDataSize(workData) / #self._Threads)

	dataChunk[chunkIteration] = {}

	for _, objectData in workData do
		if iteration > chunkSize then
			chunkIteration += 1
			iteration = 1
			dataChunk[chunkIteration] = {}
		end

		dataChunk[chunkIteration][iteration] = objectData

		iteration += 1
	end

	return dataChunk
end

function Threader.DoWork(self: Threader, workData: { [any]: any })
	debug.profilebegin("Check args and state")
	Assert(typeof(workData) == "table", `Expected table, got; {typeof(workData)}!`)

	if self.State == Threader.States.Working then
		error(
			"Can not call :DoWork while it is still running! This is to prevent sudden freezing and exponentially longer execution times!"
		)
	end
	debug.profileend()

	debug.profilebegin("Set state as working")
	self.State = Threader.States.Working
	debug.profileend()

	debug.profilebegin("Fragment data")
	local workFragment = self:_FragmentWorkData(workData)
	debug.profileend()

	return Promise.new(function(resolve, reject)
		local threadPromises = {}

		debug.profilebegin("Setup threadPromises")
		for index, thread: Thread in self._Threads :: { Thread } do
			debug.profilebegin("Promise.fromEvent")
			threadPromises[#threadPromises + 1] = Promise.fromEvent(thread.ThreadDone.Event)
				:andThen(function(returnCode: number, data)
					if returnCode == 0 then
						return data
					end

					return reject(`Thread #{index} has been cancelled for the following reason:\n{data}`)
				end)
			debug.profileend()

			debug.profilebegin("Enable handler")
			if isServer then
				thread.ThreadHandlerServer.Disabled = false
			else
				thread.ThreadHandlerClient.Disabled = false
			end
			debug.profileend()

			debug.profilebegin("dispatch work")
			thread:SendMessage("DoWork", (workFragment :: {})[index])
			debug.profileend()
		end
		debug.profileend()

		Promise.all(threadPromises):andThen(function(...)
			debug.profilebegin("resolve")
			self.State = Threader.States.Standby

			resolve(...)
			debug.profileend()
		end)
	end)
end

function Threader.Cancel(self: Threader)
	if not (self.State == Threader.States.Working) then
		return
	end

	for _, thread: Thread in self._Threads :: { Thread } do
		thread:SendMessage("Cancel")
	end

	self.State = Threader.States.Standby
end

function Threader.SetThreads(self: Threader, amountThreads: number)
	Assert(typeof(amountThreads) == "number", `Expected number, got; {typeof(amountThreads)}!`)

	if self.State == Threader.States.Working then
		warn(`Threader class still under work! Awaiting...`)
		self:AwaitState(Threader.States.Standby):await()
	end

	local delta = amountThreads - #self._Threads

	if delta == 0 then
		return
	end

	if delta > 0 then
		debug.profilebegin("Create threads")
		self:_GenerateWorkers(delta)
		debug.profileend()
	elseif delta < 0 then
		debug.profilebegin("Destroy threads")
		for i = 0, math.abs(delta) - 1 do
			local index = #self._Threads - i
			local thread = self._Threads[index]

			if not thread then
				break
			end

			thread["ThreadWorker"]:Destroy()
			thread[isServer and "ThreadHandlerServer" or "ThreadHandlerClient"].Disabled = true
			self._ThreadPool:Return(thread)
			self._Threads[index] = nil
		end
		debug.profileend()
	end
end

function Threader.AwaitState(self: Threader, awaitState: string)
	Assert(Threader.States[awaitState], `Expected state enum, got; {typeof(awaitState)}`)

	return Promise.new(function(resolve)
		if self.State == awaitState then
			resolve()
		end

		while not (self.State == awaitState) do
			task.wait()
		end

		resolve()
	end)
end

function Threader.Destroy(self: Threader)
	self:AwaitState(Threader.States.Standby):andThen(function()
		for _, thread in self._ThreadPool.Objects do
			self._ThreadPool:Retire(thread)
			thread:Destroy()
		end

		self._WorkerModule = nil :: any -- the good old any keyword to silence the "it is not a ModuleScript you can't do this". Well guess what! Yes I can!!!

		self._Container:Destroy()

		setmetatable(self._ThreadPool, nil)
		table.clear(self._ThreadPool)

		setmetatable(self :: any, nil)
		table.clear(self :: any)
	end)
end

return Threader
