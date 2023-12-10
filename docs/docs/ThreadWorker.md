---
sidebar_position: 3
---

ThreadWorker is a simple class that is used within a *ModuleScript*
(referenced as the **WorkerModule**) when passing it into the [Threader.new()](./Threader#new) constructor.
ThreadWorkers provide a 2-way communication between the thread and the
main thread while also processing the data on request. If required
ThreadWorkers can also be cancelled at any time.

## Promise

```
ThreadWorker.Promise = Promise
```

Just like in the Threader class a Promise reference is passed into a ThreadWorker
class. Under the hood Threader uses the **ThreadWorker.Promise** reference when
handling ThreadWorkers.

## API

### .new

```lua
ThreadWorker.new()
```

Constructs a new ThreadWorker class.

```lua
-- In a ModuleScript:
local Threader = require(game:GetService("ReplicatedStorage").Threader)

-- Will construct a new ThreadWorker that can be used in
-- Threader.new
-- highlight-next-line
local SumWorker = Threader.ThreadWorker.new()

return SumWorker
```

### \:OnDispatch

```lua
ThreadWorker:OnDispatch(data: any)
```

:::warning
Calling `Threader:Dispatch()` when no `:OnDispatch()` method was defined
will error with the following message: *ThreadWorkerClass:OnDispatch() must be overridden!*
:::

Used to process the *data*. Threader does not automatically desynchronize
the thread. Returning the processed data to the main thread is optional.

```lua
local Threader = require(game:GetService("ReplicatedStorage").Threader)

local SumWorker = Threader.ThreadWorker.new()

-- When dispatched will sum up all of the
-- numbers found in the *data* table
-- Required
-- highlight-next-line
function SumWorker:OnDispatch(data: { number })
    task.desynchronize()

    local summedNumber = 0

    for _, num in data do
        summedNumber += num
    end

    -- Will return the data that will be accessible
    -- by the main thread
    return summedNumber
end

return SumWorker
```

### \:OnCancel

```lua
ThreadWorker:OnCancel()
```

:::warning
Calling `Threader:Cancel()` when no `:OnCancel()` method was defined
will warn with the following message: *Threader:Cancel() was called but the default method was not overridden!*
:::

Optional method, called before the thread is cancelled by calling
[Threader:Cancel()](./Threader#cancel). Useful to stop any loops on-going
or disconnect from certain events.

```lua
local Threader = require(game:GetService("ReplicatedStorage").Threader)

local SumWorker = Threader.ThreadWorker.new()

-- Adding properties to a ThreadWorker is allowed
SumWorker.isIterating = true

function SumWorker:OnWork(data: { number })
    task.desynchronize()

    local summedNumber = 0

    for _, num in data do
        -- If isIterating equals false will return out
        if not self.isIterating then
            return
        end

        summedNumber += num
    end

    return summedNumber
end

-- When cancelled will set isIterating to false
-- highlight-next-line
function SumWorker:OnCancel()
    self.isIterating = false
end

return SumWorker
```