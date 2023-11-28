---
sidebar_position: 2
---

Threader is a library made to extend the functionality of `Actors` to make working with them
easier.

When Threader had been required for the first time, it will create a container folder called *_Threads* that 
is placed in either `ServerStorage` if *server* environment, `PlayerScripts` if *client environment* or 
`itself` if neither.

## State

State is used in Threader to convey what is the library doing currently.
It can be either *Standby* or *Working* state. All of the states can
be accessed with **Threader.States**:

```lua
Threader.States = {
    Standby = "Standby",
    Working = "Working",
}
```

Using **Threader.States** is not necessary and everything can be used
without it.

## Promise

Threader has a reference to Promise and can be accessed with **Threader.Promise** for quality-of-life.

## ThreadWorker

Reference to [ThreadWorker](./ThreadWorker) class. ThreadWorker is a simple class that is used within a *workerModule* when
passing it into `.new`.

## API

### .new

```lua
Threader.new(amountThreads: number, workerModule: ModuleScript)
```

Constructs a new Threader class and creates a container folder for the
threads under the *_Threads* folder with the name of the caller. Sets up
*amountThreads* amount of threads.

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
must always be a table and generally structured to be easily groupped together. Reason is, Threader always fragments it to be distributed across all of the threads currently set either by `.new` or `:SetThreads`. Returns
a Promise that will resolve once all of the threads have completed their jobs
or one encountered an error.

When calling `:Cancel` while the Threader class is running will result in
the Promise rejecting, not returning the data that was done before the
call.

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

### \:AwaitState

```lua
Threader:AwaitState(awaitState: string): Promise
```

When called will return a `Promise` that will resolve once the
state equals to `awaitState`.

### \:Destroy

```lua
Threader:Destroy()
```

Destroys the Threader class.