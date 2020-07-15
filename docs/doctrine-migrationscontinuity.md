---
layout: blueprint
---
# Continuity checker for Doctrine Migrations

Implemented as external event subscriber due to [doctrine/migrations#1036](https://github.com/doctrine/migrations/issues/1036).
Don't forget to [follow documentation to register this subscriber](https://www.doctrine-project.org/projects/doctrine-migrations/en/latest/reference/events.html).
You can use helper `ContinuityChecker::init` to do this.


## Symfony

```php
<?php // src/Kernel.php
// ...
use PetrKnap\Doctrine\MigrationsContinuity\ContinuityChecker;
// ...
class Kernel extends BaseKernel
{
    // ...
    public function boot()
    {
        parent::boot();
        // ...
        if (in_array(PHP_SAPI, ['cli', 'phpdbg', 'embed'], true)) {
            ContinuityChecker::init($this->container->get('doctrine.dbal.default_connection'));
        }
    }
    // ...
}
```


{% include docs/how-to-install.md %}
