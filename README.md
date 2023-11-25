<div align="center">
    <img height=150 src="./docs/static/img/SVG Threader logo dark.svg#gh-light-mode-only">
    <img height=150 src="./docs/static/img/SVG Threader logo light.svg#gh-dark-mode-only">
    
    <h3>Promise based Actor wrapper.</h3>

    Version: <b>1.0.0</b>
</div>


## Showcase

### Creating a Threader Class

Creating a Threader class is very simple. The first argument is always 
how many threads are there initially and the last one is the ThreadWorker itself.

```lua
local Threader = require(game:GetService("ReplicatedStorage").Threader)

local myThreader = Threader.new(5, PATH.TO.WORKER.MODULE)
```

### Creating a ThreadWorker

A ThreadWorker is a ModuleScript that is used to process the data in all of the threads 
once `Threader:Dispatch()` was called.

```lua
local myThreadWorker = Threader.ThreadWorker.new()

function myThreadWorker:OnDispatch(data)
    return data
end

function myThreadWorker:OnCancel()
    print("Cancelled!")
end

return myThreadWorker
```

### Get the Data Back

Getting the data back from all of the threads is very simple! Since Threader is Promise 
based after calling Threader:Dispatch() a Promise will be returned that will resolve 
once all of the threads had completed or gets rejected if any error occurs!

#### Main script

```lua
local myThreader = Threader.new(5, script.MyThreadWorkerModule)

myThreader:Dispatch(table.create(1000, 1)):andThen(function(results)
    print(results)
end)
```

#### ThreadWorker

```lua
local MyThreadWorker = Threader.ThreadWorker.new()

function MyThreadWorker:OnDispatch(data)
    local sum = 0

    for _, num in data do
        sum += num
    end

    return sum
end

return MyThreadWorker
```