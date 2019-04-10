---
layout: blog.post
title: "Add month can skip next month in some #PHP cases"
category: backend
keywords:
    - php
    - DateTime
    - DateInterval
---

If you are using `new DateInterval('P1M')` for adding month to date to get next month, do not do that.
There is huge **difference between adding to begin and end of the month**.
It does sense, but it is against semblance at first sight of `P1M`.

```php
$begin = new DateTime('2019-03-01');
$begin->add(new DateInterval('P1M'));
echo $begin->format('Y-m'); // 2019-04
```

```php
$end = new DateTime('2019-03-31');
$end->add(new DateInterval('P1M'));
echo $end->format('Y-m'); // 2019-05
```

## How to get next month

```php
$date = new DateTime('2019-03-31');
$date->modify('first day of next month');
echo $date->format('Y-m'); // 2019-04
```

The `first day of next month` is longer string than `P1M`, but it's self-explanatory and works every time as you expect.
