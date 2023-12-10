--[[
	Threader

	Threader is a library made to extend the functionality of `Actors` to make working with them
	easier.

	When Threader had been required for the first time, it will create a container folder called *_Threads* that 
	is placed in either `ServerStorage` if *server* environment, `PlayerScripts` if *client environment* or 
	`itself` if neither.

	Under the MIT license.
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

local Promise = require(script.Parent.Promise) :: any
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

--[=[
	## State
	
	```lua
	Threader.States = {
		Standby = "Standby",
		Working = "Working",
	}
	```

	State is used in Threader to convey what is the library doing currently.
	It can be either *Standby* or *Working* state. All of the states can
	be accessed with **Threader.States**:

	Using **Threader.States** is not necessary and everything can be used
	without it. By providing the value itself as a string.
]=]
Threader.States = table.freeze({
	Standby = "Standby",
	Working = "Working",
})

--[=[
	## Promise

	```lua
	Threader.Promise = Promise
	```

	Reference to Promise for quality-of-life.
]=]
Threader.Promise = Promise

--[=[
	## ThreadWorker

	```lua
	Threader.ThreadWorker = ThreadWorkerClass
	```
		
	ThreadWorkers provide a 2-way communication between the thread and the
	main thread while also processing the data on request. If required
	ThreadWorkers can also be cancelled at any time.
]=]
Threader.ThreadWorker = ThreadWorkerClass

--[=[
	## Threader.new()

	```lua
	Threader.new(amountThreads: number, workerModule: ModuleScript)
	```

	Constructs a new Threader class and creates a container folder for the
	threads under the *_Threads* folder with the name of the caller. Sets up
	*amountThreads* amount of threads.

	In the documentation a class made with `Threader.new` will be referred to
	as *ThreaderClass*.

	```lua
	local Threader = require(PATH.TO.THREADER)

	-- Creates a new ThreaderClass
	local SumThreader = Threader.new(5, PATH.TO.WORKER_MODULE)
	```
]=]
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

--[=[
	## Threader:_GenerateWorkers()

	```lua
	Threader:_GenerateWorkers(amountThreads: number)
	```

	:::danger Private
	This method is used internally and is generally discouraged to use
	such methods, otherwise unexpected side-effects may occur during use!
	:::

	Sets up *amountThreads* amount of threads.
]=]
function Threader._GenerateWorkers(self: Threader, amountThreads: number)
	for _ = 1, amountThreads do
		local threadIndex = #self._Threads + 1

		local thread = self._ThreadPool:Get()
		local worker = self._WorkerModule:Clone()

		worker.Name = "ThreadWorker"
		thread.Name = `Actor-{threadIndex}`

		worker.Parent = thread
		thread.Parent = self._Container

		if isServer then
			thread.ThreadHandlerServer.Disabled = false
		else
			thread.ThreadHandlerClient.Disabled = false
		end

		self._Threads[threadIndex] = thread
	end
end

--[=[
	## Threader:_FragmentWorkData()

	```lua
	Threader:_FragmentWorkData(workData: { [any]: any })
	```

	:::danger Private
	This method is used internally and is generally discouraged to use
	such methods, otherwise unexpected side-effects may occur during use!
	:::

	Fragments the data, splitting it up based on how many threads are in-use.
]=]
function Threader._FragmentWorkData(self: Threader, workData: { [any]: any })
	local dataChunkSize = math.ceil(#workData / #self._Threads)
	local fragmentedData = {}

	for i = 1, #self._Threads do
		local min = dataChunkSize * (i - 1) + 1
		local max = dataChunkSize * i

		fragmentedData[i] = {}
		table.move(workData, min, max, 1, fragmentedData[i])
	end

	return fragmentedData
end

--[=[
	## Threader:Dispatch()

	```lua
	Threader:Dispatch(workData: { [any]: any }): Promise
	```

	:::warning
	Calling `:Dispatch` while the Threader class is already running will throw an
	error. In later updates this behaviour might change in favour of just caching
	said request and waiting for the class to finish and then scheduling that work
	instead.
	:::

	:::danger workData incompatibility
	Since Threader passes the data to threads by calling `:SendMessage` on the actors, limits
	the kind of data that can be passed around back-and-forth. For example: a table of numbers
	is completely fine, however a table of metatables such as a Promise library will result in
	an error. **Only pass *workData* tables that only contain primitive or serializable values**.
	:::

	Starts the processing of the data specified in *workData*. The *workData*
	must always be a table and generally structured to be easily groupped together. Reason is, 
	Threader always fragments it to be distributed across all of the threads currently set either by `
	.new` or `:SetThreads`. Returns a Promise that will resolve once all of the threads have completed 
	their jobs or one encountered an error.

	When calling `:Cancel` while the Threader class is running will result in
	the Promise rejecting, not returning the data that was done before the
	call.

	```lua
	local Threader = require(PATH.TO.THREADER)
	local SumThreader = Threader.new(5, PATH.TO.WORKER_MODULE)

	-- Dispatches the data and prints it once it is done. Or warns
	-- if an error occured.
	SumThreader:Dispatch({ 1, 2, 3, 4, 5 })
		:andThen(function(data)
			print(data)
		end)
		:catch(function(errorMessage)
			warn(errorMessage)
		end)
	```
]=]
function Threader.Dispatch(self: Threader, workData: { [any]: any })
	Assert(typeof(workData) == "table", `Expected table, got; {typeof(workData)}!`)

	-- TODO: make Threader batch requests together
	-- or actually don't I'm completely fine with not having it
	-- honestly would just make the code so much more unreadable
	if self.State == Threader.States.Working then
		error("Can not call :Dispatch while it is still running!")
	end

	self.State = Threader.States.Working

	return Promise.new(function(resolve, reject)
		local fragmentedData = self:_FragmentWorkData(workData)
		local threadPromises = {}

		--debug.profilebegin("Setup threadPromises")
		for index, thread: Thread in self._Threads :: { Thread } do
			threadPromises[#threadPromises + 1] = Promise.fromEvent(thread.ThreadDone.Event)
				:andThen(function(returnCode: number, data)
					Assert(typeof(returnCode) == "number", `Expected to get number, got; {typeof(returnCode)}!`)

					if returnCode == 0 then
						return data
					end

					return reject(`Thread #{index} has been cancelled for the following reason:\n{data}`)
				end)
				:catch(function(...)
					reject(...)
				end)

			thread:SendMessage("Dispatch", (fragmentedData :: {})[index])
		end
		--debug.profileend()

		Promise.all(threadPromises):andThen(function(...)
			self.State = Threader.States.Standby

			resolve(...)
		end)
	end)
end

--[=[
	## Threader:Cancel()

	```lua
	Threader:Cancel()
	```

	:::warning
	Calling `:Cancel` while the Threader class is already running will yield the
	current thread until the state will equal to **Threader.States.Standby**!
	:::

	Cancels the current Threader class if the state is **Threader.States.Working**. Else it will return with
	no errors. Sets the current state to **Threader.States.Standby** if successful.

	Cancelling a ThreaderClass that completes faster than the time it takes to cancel will still
	result in the ThreaderClass's Promise resolve with the processed data.

	```lua
	local Threader = require(PATH.TO.THREADER)
	local SumThreader = Threader.new(5, PATH.TO.WORKER_MODULE)

	SumThreader:Dispatch({ 1, 2, 3, 4, 5 })
		:andThen(function(data)
			print(data)
		end)
		:catch(function(errorMessage)
			warn(errorMessage)
		end)

	-- Even if we called `:Cancel` here, SumThreader's Promise would
	-- still resolve with the processed data.
	SumThreader:Cancel()
	```
]=]
function Threader.Cancel(self: Threader)
	if not (self.State == Threader.States.Working) then
		return
	end

	for _, thread: Thread in self._Threads :: { Thread } do
		thread:SendMessage("CancelDispatch")
	end

	self.State = Threader.States.Standby
end

--[=[
	## Threader:SetThreads()

	```lua
	Threader:SetThreads(amountThreads: number)
	```

	Sets the availabe threads to *amountThreads*. If the delta
	between the current amount and the new amount is:

	- smaller: will remove *delta* amount
	- bigger: will add *delta* amount
	- equals: will return out

	It is not recommended to call `:SetThreads` so often. This is becase under
	the hood Threader re-parents those threads into the container folder or
	under itself, destroying the `workerModule` and disabling the handler. This
	by itself is not perfomance heavy, however calling it multiple times can add
	up!

	Uses [Threader:_GenerateWorkers()](./Threader#_generateworkers) internally when delta is bigger.

	```lua
	local Threader = require(PATH.TO.THREADER)
	local SumThreader = Threader.new(5, PATH.TO.WORKER_MODULE)

	-- Will set the threads to 10 instead of 5 we set initially.
	SumThreader:SetThreads(10)
	```
]=]
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
		--debug.profilebegin("Create threads")
		self:_GenerateWorkers(delta)
		--debug.profileend()
	elseif delta < 0 then
		--debug.profilebegin("Destroy threads")
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
		--debug.profileend()
	end
end

--[=[
	## Threader:AwaitState()

	```lua
	Threader:AwaitState(awaitState: string): Promise
	```

	When called will return a `Promise` that will resolve once the
	state equals to `awaitState`.

	```lua
	local Threader = require(PATH.TO.THREADER)
	local SumThreader = Threader.new(5, PATH.TO.WORKER_MODULE)

	-- Will print "SumThreader is now in standby!" once the state
	-- equals to Threader.States.Standby.
	SumThreader:AwaitState(Threader.States.Standby):andThen(function()
		print("SumThreader is now in standby!")
	end)

	SumThreader:Dispatch({ 1, 2, 3, 4, 5 })
		:andThen(function(data)
			print(data)
		end)
		:catch(function(errorMessage)
			warn(errorMessage)
		end)
	```
]=]
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

--[=[
	## Threader:Destroy()

	```lua
	Threader:Destroy()
	```

	Destroys the Threader class. Once called will wait
	until ThreaderClass is Standby.

	```lua
	local Threader = require(PATH.TO.THREADER)
	local SumThreader = Threader.new(5, PATH.TO.WORKER_MODULE)

	-- Destroys SumThreader making it no longer usable.
	SumThreader:Destroy()
	```
]=]
function Threader.Destroy(self: Threader)
	self:AwaitState(Threader.States.Standby):andThen(function()
		for _, thread in self._ThreadPool.Objects do
			self._ThreadPool:Retire(thread.Object)
			thread.Object:Destroy()
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
