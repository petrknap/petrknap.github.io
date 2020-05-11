---
layout: blog.post
title: "Why @EA #theSims4 crashes on @AMDRyzen? #solved"
category: software
keywords:
    - Electronic Arts
    - game
    - AMD Zen
    - AMD Ryzen
    - the Sims 4
    - Battlefield 1
    - Origin
    - game crashed
    - hardware issue
---

I bought the Sims 4 a few weeks ago, and **I noticed that the game is extremely unstable**.
It simply crashes after short time of gameplay, but only if the CPU utilization is low.
After some testing I guess that I guess why it is crashing.
This problem probably occurs in many EA games on multi-CCX CPUs like **AMD Ryzen 5/7/9**, Threadrippers and EPYCs.

If you are just **regular player [skip to the "How to fix it"](#how-to-fix-it)**.



# Where is the problem

The problem is **outer-CCX core switching**.

```plain
+--------------------+
|           +------+ |
| +----+    | CCX0 | |
| |    |    +------+ |
| |    |    | CCX1 | |
| |    |    +------+ |
| | IO |             |
| |    |    +------+ |
| |    |    | CCX2 | |
| |    |    +------+ |
| +----+    | CCX3 | |
|           +------+ |
+--------------------+
```

AMD Ryzens are composed of IO interface and chiplets.
**Chiplets are composed of symmetric core complexes (CCX).**
And CCXes are composed of compute cores.
Current generation has **up to 4 cores** per CCX.

Problem is that some technologies can force outer-CCX core switch.
For example if first core hits high temperature algorithm can move its load to coolest core which probably sits in different CCX.

The biggest hint I found in [thread about Battlefield 1 "Battlefield 1 randomly crashes on AMD Ryzen"](https://forums.battlefield.com/en-us/discussion/144718/battlefield-1-randomly-crashes-on-amd-ryzen).
It contains advance to disable SMT - cutting threads to half reduces space for work of Cool'n'Quiet, etc.
As prove **I run CPU burner on 6 threads** which increases CCXes temperatures to same level and the **game becomes stable**.



# How to fix it

You can create an issue on EA support page and wait for patch.
Or you can run CPU burner in background to keep your CPU literally warmed up.
Or when you start the game:

1. Switch to **desktop**
2. Open **Task Manager** (and click to "More details")
3. Switch to **"Details" tab**
4. Right-click on **the game process** (f.e.: `ts4.exe`)
5. **Set affinity** to threads on same CCX

Threads **0-5 are on the same CCX** probably on all problematic CPUs with enabled SMT.

If you wish to have permanent solution (don't do that), go to the BIOS and disable all optimization technologies.
