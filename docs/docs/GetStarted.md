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

<Tabs>
  <TabItem value="source" label="Downloading Source" default>
    Downloading the source is the messiest way to
    install Threader into any codebase. It has the
    negative downside of having the full repository and then
    manually extracting the **lib** folder including the **vendors/Promise**
    library with it.

    Installation steps:

    1. Head over to Threader's repository  
    2. Click on the `<> Code` dropdown
    3. Click on **Download ZIP**
    4. Extract the **lib** and the **vendors/Promise** folder
    5. Put the **vendors/Promise** folder into the **lib** folder
  </TabItem>
  <TabItem value="git" label="Git" default>
    Installing Threader with git is one of the more convenient
    way to do so. All it requires is this single command:

    ```
    git clone --recurse-submodules https://github.com/jammees/Threader.git PATH
    ```

    The PATH argument will determine where git places the now copied Threader repository, for example:

    ```
    git clone --recurse-submodules https://github.com/jammees/Threader.git vendors/Threader
    ```

    This will result in Threader with all if its dependencies getting cloned and put into the now
    created **vendors** folder with the name of **Threader**.

  </TabItem>
  <TabItem value="marketplace" label="Roblox Marketplace">
    Getting the module from the Roblox Marketplace is probably
    the easiest way to install Threader, however this method is not for rojo
    managed projects but rather for studio.

    LINK: Coming soon.
  </TabItem>
  <TabItem value="wally" label="Wally">
    Wally installation method coming soon!
  </TabItem>
</Tabs>