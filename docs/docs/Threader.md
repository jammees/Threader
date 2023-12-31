---
sidebar_position: 2
---

Threader is a library made to extend the functionality of `Actors` to make working with them
easier.

When Threader had been required for the first time, it will create a container folder called *_Threads* that 
is placed in either `ServerStorage` if *server* environment, `PlayerScripts` if *client environment* or 
`itself` if neither.

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

## Promise

```lua
Threader.Promise = Promise
```

Reference to Promise for quality-of-life.

## ThreadWorker

```lua
Threader.ThreadWorker = ThreadWorkerClass
```
    
ThreadWorkers provide a 2-way communication between the thread and the
main thread while also processing the data on request. If required
ThreadWorkers can also be cancelled at any time.

## API

### .new

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
-- highlight-next-line
local SumThreader = Threader.new(5, PATH.TO.WORKER_MODULE)
```

### \:_GenerateWorkers

```lua
Threader:_GenerateWorkers(amountThreads: number)
```

:::danger Private
This method is used internally and is generally discouraged to use
such methods, otherwise unexpected side-effects may occur during use!
:::

Sets up *amountThreads* amount of threads.

### \:_FragmentWorkData

```lua
Threader:_FragmentWorkData(workData: { [any]: any })
```

:::danger Private
This method is used internally and is generally discouraged to use
such methods, otherwise unexpected side-effects may occur during use!
:::

Fragments the data, splitting it up based on how many threads are in-use.

### \:Dispatch

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
-- highlight-next-line
SumThreader:Dispatch({ 1, 2, 3, 4, 5 })
    :andThen(function(data)
        print(data)
    end)
    :catch(function(errorMessage)
        warn(errorMessage)
    end)
```

### \:Cancel

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
-- highlight-next-line
SumThreader:Cancel()
```

### \:SetThreads

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
-- highlight-next-line
SumThreader:SetThreads(10)
```

### \:AwaitState

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
-- highlight-start
SumThreader:AwaitState(Threader.States.Standby):andThen(function()
    print("SumThreader is now in standby!")
end)
-- highlight-end

SumThreader:Dispatch({ 1, 2, 3, 4, 5 })
    :andThen(function(data)
        print(data)
    end)
    :catch(function(errorMessage)
        warn(errorMessage)
    end)
```

### \:Destroy

```lua
Threader:Destroy()
```

Destroys the Threader class. Once called will wait
until ThreaderClass is Standby.

```lua
local Threader = require(PATH.TO.THREADER)
local SumThreader = Threader.new(5, PATH.TO.WORKER_MODULE)

-- Destroys SumThreader making it no longer usable.
-- highlight-next-line
SumThreader:Destroy()