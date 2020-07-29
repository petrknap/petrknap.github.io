---
layout: blueprint
---
# Unalterable migrations for Doctrine Migrations

This package provides simple way how to migrate unalterable objects like views and triggers.


## Example

### Create view

```php
<?php declare(strict_types=1);

namespace DoctrineMigrations;

use Doctrine\Migrations\AbstractMigration;
use PetrKnap\Doctrine\UnalterableMigrations\UnalterableMigrationInterface;
use PetrKnap\Doctrine\UnalterableMigrations\UnalterableMigrationTrait;

class Version1 extends AbstractMigration implements UnalterableMigrationInterface
{
    use UnalterableMigrationTrait;

    public function getUpSql(): string
    {
        return 'CREATE VIEW view_b AS (
            SELECT
                a.id
            FROM table_a a
        )';
    }

    public function getDownSql(): ?string
    {
        return 'DROP VIEW view_b';
    }
}
```

### Alter view

```php
<?php declare(strict_types=1);

namespace DoctrineMigrations;

use Doctrine\Migrations\AbstractMigration;
use PetrKnap\Doctrine\UnalterableMigrations\Patches;
use PetrKnap\Doctrine\UnalterableMigrations\UnalterableMigrationInterface;
use PetrKnap\Doctrine\UnalterableMigrations\UnalterableMigrationTrait;

class Version2 extends AbstractMigration implements UnalterableMigrationInterface
{
    use UnalterableMigrationTrait;

    public function getParentClassName(): ?string
    {
        return Version1::class;
    }

    public function getUpSql(): string
    {
        return Patches::on($this->getParent()->getUpSql())
            ->removeLine(2, 'a.id')
            ->insertLine(2, 'a.id,')
            ->insertLine(3, 'a.name')
            ->apply();
    }
}
```

### Rename view

```php
<?php declare(strict_types=1);

namespace DoctrineMigrations;

use Doctrine\Migrations\AbstractMigration;
use PetrKnap\Doctrine\UnalterableMigrations\Patches;
use PetrKnap\Doctrine\UnalterableMigrations\UnalterableMigrationInterface;
use PetrKnap\Doctrine\UnalterableMigrations\UnalterableMigrationTrait;

class Version3 extends AbstractMigration implements UnalterableMigrationInterface
{
    use UnalterableMigrationTrait;

    public function getParentClassName(): ?string
    {
        return Version2::class;
    }

    public function getUpSql(): string
    {
        return Patches::on($this->getParent()->getUpSql())
            ->removeLine(1, 'CREATE VIEW view_b AS (')
            ->insertLine(1, 'CREATE VIEW view_c AS (')
            ->apply();
    }

    public function getDownSql(): ?string
    {
        return 'DROP VIEW view_c;' . $this->getParent()->getUpSql();
    }
}
```

### Drop view

```php
<?php declare(strict_types=1);

namespace DoctrineMigrations;

use Doctrine\Migrations\AbstractMigration;
use PetrKnap\Doctrine\UnalterableMigrations\UnalterableMigrationInterface;
use PetrKnap\Doctrine\UnalterableMigrations\UnalterableMigrationTrait;

class Version4 extends AbstractMigration implements UnalterableMigrationInterface
{
    use UnalterableMigrationTrait;

    public function getParentClassName(): ?string
    {
        return Version3::class;
    }

    public function getUpSql(): string
    {
        return self::DROP_PARENT;
    }
}
```


{% include docs/how-to-install.md %}
