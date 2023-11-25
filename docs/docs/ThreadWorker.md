---
sidebar_position: 3
---

ThreadWorker is a simple class that is used within a *ModuleScript*
(referenced as the **WorkerModule**) when passing it into the [Threader.new()](./Threader#new) constructor.
A ThreadWorker consists of only three methods, once of which is optional.

## Promise

Just like in the Threader class a Promise refernce is passed into a ThreadWorker
class.

## API

### .new

```lua
ThreadWorker.new()
```

Constructs a new ThreadWorker class. Inside of a WorkerModule:
```lua
local Threader = require(game:GetService("ReplicatedStorage").Threader)

local SumWorker = Threader.ThreadWorker.new()

return SumWorker
```

### \:OnDispatch

```lua
ThreadWorker:OnDispatch(data: any)
```

Used to process the *data*. Threader does not automatically desynchronize
the thread. Always should return the processed data to be returned to the
caller.

This WorkerModule sums all of the numbers. However, what if
[Threader:Cancel()](./Threader#cancel) had been called while it was still
working? [:OnCancel](./ThreadWorker#oncancel) is the solution for this
problem.

```lua
local Threader = require(game:GetService("ReplicatedStorage").Threader)

local SumWorker = Threader.ThreadWorker.new()

function SumWorker:OnWork(data: { number })
    task.desynchronize()

    local summedNumber = 0

    for _, num in data do
        summedNumber += num
    end

    return summedNumber
end

return SumWorker
```

### \:OnCancel

```lua
ThreadWorker:OnCancel()
```

Optional method, called before the thread is cancelled by calling
[Threader:Cancel()](./Threader#cancel). Useful to stop any loops on-going
or disconnect from certain events.

This WorkerModule now stops summing up numbers and returns out of the
function when *isIterating* is set to false.

```lua
local Threader = require(game:GetService("ReplicatedStorage").Threader)

local SumWorker = Threader.ThreadWorker.new()

SumWorker.isIterating = true

function SumWorker:OnWork(data: { number })
    task.desynchronize()

    local summedNumber = 0

    for _, num in data do
        if not self.isIterating then
            return
        end

        summedNumber += num
    end

    return summedNumber
end

function SumWorker:OnCancel()
    self.isIterating = false
end

return SumWorker
```