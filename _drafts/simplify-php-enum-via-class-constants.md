---
layout: blog.post
title: "Simplify #PHP #enum via class constants"
category: backend
keywords:
    - PHP
    - enum
    - constants
    - backend development
---

Are you using my implementation of [Enumerated type for PHP](/docs/php-enum.html)?
If yes, then you should be interested in [version 2.1](https://github.com/petrknap/php-enum/releases/tag/v2.1.0).
Now **it's possible to use constants as members** over `ConstantsAsMembers` trait.

```php
<?php

class MyBoolean extends PetrKnap\Php\Enum\Enum
{
    use PetrKnap\Php\Enum\ConstantsAsMembers;

    const MY_TRUE = 1;
    const MY_FALSE = 2;
}
```

Creation of simply enum is now really simply. (idea by @halaxa)
