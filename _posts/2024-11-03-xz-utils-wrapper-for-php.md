---
layout: blog.post
title: "XZ Utils wrapper for #PHP"
category: backend
keywords:
    - development
    - web
    - compression
    - decompression
    - xz utils
    - xz
pull_request_id: 8
---

I took a liking to [the **xz compression** format](https://en.wikipedia.org/wiki/XZ_Utils#The_xz_format) a long time ago.
It is a **very handy** format that is **available almost everywhere**, unfortunately not in PHP.
So I decided it is time to fix that and write an [XZ Utils (wrapper)](https://github.com/petrknap/php-xz-utils).

It is a simple piece of code that can be used either:
* PHP-usually, through functions that return a falsable string, `xzencode('my uncompressed data')`,
* or normally, with strict typing and exceptions, `(new Xz())->compress('my uncompressed data')`.

You're welcome, have fun. :)
