---
layout: blog.post
title: "Create multi-platform #CLI script for #Windows, #Linux & #MacOSX"
category: cli
keywords:
    - bash
    - batch
    - Unix
    - Windows
    - Linux
    - Mac OS X
    - multi-platform script
---

Do you need to make run **script which will work on multiple platforms**?
You can use my idea.
In my case it's run script which runs Java application and you can [found it here](https://github.com/petrknap/violetumleditor/blob/master/run.bat).
Interested in how it works?

## How it works?

It is **based on different line-braking** between Windows and Unix and bash presence on another systems.
It also expects that Unix system has not `GOTO` command and don't stop on error.

```bash
#!/bin/bash
^M
GOTO Windows^M

# Unix
ls
exit
^M
:Windows^M
dir^M
exit^M
```

The file must contains these parts:

1. `#!/bin/bash` for Unix to determine how to execute this file
1. An empty line for Windows to explode first and third line
1. `GOTO Windows` for Windows to skip Unix lines
1. An unix code and `exit`
1. `:Windows` the anchor for Windows
1. A Windows code and `exit`

Don't forget that **Unix lines must end with `\n`**, but **Windows lines must end with `\n\r`** (`^M` in example).
