---
layout: blog.post
title: "Is #SymfonyLock acquired if it is acquired? #Symfony"
category: backend
keywords:
    - symfony
    - symfony/lock
---

If you are using [`symfony/lock`] **you can see acquired lock as not acquired**.
Method `isAcquired` simply returns state of the instance.
If different instance acquired the lock, your instance will return `false`.

```php
use Symfony\Component\Lock\Factory;
use Symfony\Component\Lock\Lock;

/** @var Factory $factory */
$lock1 = $factory->createLock('lock');
$lock2 = $factory->createLock('lock');

$lock1->acquire(); // true
$lock1->isAcquired(); // true

$lock2->acquire(); // false - lock is already acquired
$lock2->isAcquired(); // false - THIS INSTANCE is not acquired

function isAcquired(Lock $lock): bool 
{
    if ($lock->isAcquired() || !$lock->acquire()) {
        return true;
    }
    $lock->release();
    return false;
}

isAcquired($lock1); // true
isAcquired($lock2); // true
```

The method `isAcquired` has **name that will confuse you**.
You can't use `isAcquired` if you need to know if lock is acquired.




[`symfony/lock`]:https://symfony.com/doc/current/components/lock.html
[`petrknap/symfony-interprocesslock`]:https://packagist.org/packages/petrknap/symfony-interprocesslock
