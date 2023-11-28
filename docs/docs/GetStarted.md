---
title: Get started
sidebar_position: 1
---

import Tabs from '@theme/Tabs';
import TabItem from '@theme/TabItem';

## Installation

Here are a couple of diffent ways how to install Threader
into your codebase. However, before doing so please consider
whether the advantages of using multi-threading outweight the
disadvantages. By disadvantages, multiple threads taking longer
to process the data than just a single thread.

:::warning Promise
  Threader requires version 4.0.0 of Promise! Later versions of module was
  not tested and are not guaranteed to work!
:::

:::danger Rojo
  An up-to-date version of Rojo is required from version `7.3.0`! Later versions
  of Rojo does not support the `RunContext` property in scripts!

  If using aftman to manage Rojo:

  ```
  rojo = "rojo-rbx/rojo@7.3.0"
  ```
:::

<Tabs>
  <TabItem value="source" label="Downloading Source" default>
    1. Head over to Threader's repository  
    2. Click on the `<> Code` dropdown
    3. Click on **Download ZIP**
    4. Extract the **lib** and **vendors/Promise** folder and import into project
    5. Sync in both folders:
    
    ```json
    {
      "Threader": { "$path": PATH.TO.THREADER.FOLDER },
      "Promise": { "$path": PATH.TO.PROMISE.FOLDER },
    }
    ```
  </TabItem>
  <TabItem value="git" label="Git" default>
    1. Run:
    ```
    git clone --recurse-submodules https://github.com/jammees/Threader.git PATH
    ```

    The PATH argument will determine where git places the now copied Threader repository, for example:

    ```
    git clone --recurse-submodules https://github.com/jammees/Threader.git vendors/Threader
    ```

    2. Sync in **lib** and **vendors/Promise**

    ```json
    {
      "Threader": { "$path": PATH.TO.THREADER.FOLDER },
      "Promise": { "$path": PATH.TO.PROMISE.FOLDER },
    }
    ```
  </TabItem>
  <TabItem value="marketplace" label="Roblox Marketplace">
    1. Head over to [Threader's Marketplace Page](https://create.roblox.com/marketplace/asset/15491412765)
    2. Click on `Get`
    3. In Studio import it place it under ReplicatedStorage
    4. Head over to [Promise's Github Page](https://github.com/evaera/roblox-lua-promise/releases/tag/v4.0.0)
    5. Install **Promise.lua**
    6. In studio import Promise place it next to Threader
  </TabItem>
  <TabItem value="wally" label="Wally">
    1. Head over to [Threader's Wally Page](https://wally.run/package/jammees/threader?version=1.0.0)
    2. Chose desired version and copy
    3. Insert now copied data into the **wally.toml** file
    4. Run:

    ```
    wally install
    ```

    Most up-to-date version of Threader:
    ```
    threader = "jammees/threader@^1.0.0"
    ```

    To install wally follow this [guide](https://wally.run/install) on their website!
  </TabItem>
</Tabs>