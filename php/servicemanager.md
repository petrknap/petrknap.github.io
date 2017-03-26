---
layout: blueprint.php
---
# Service manager for PHP

* [What is service locator pattern?](#what-is-service-locator-pattern)
* [Why use service locator?](#why-use-service-locator)
* [Usage of php-servicemanager](#usage-of-php-servicemanager)
    * [Service manager configuration](#service-manager-configuration)
    * [Service manager usage](#service-manager-usage)
* [How to install](#how-to-install)


## What is service locator pattern?

> The **service locator** pattern is a design pattern used in software development **to encapsulate** the processes involved in obtaining **a service with a strong abstraction layer**. This pattern uses a central registry known as the "service locator", which on request returns the information necessary to perform a certain task.
-- [Service locator pattern - Wikipedia, The Free Encyclopedia]


## Why use service locator?

Because **it is easier than not to used it**. Don't trust me? Let see at this code:

```php
<?php // classes.php

class MyDatabase
{
   public function __construct($dsn, $user, $password) {/* ... */}
}

class MyWeb
{
   public function __construct(MyDatabase $database) {/* ... */}
}

class MyBlog
{
   public function __construct(MyWeb $web) {/* ... */}
   
   public function show($page) {/* ... */}
}

class MyAdmin
{
   public function __construct(MyWeb $web) {/* ... */}
   
   public function show($page) {/* ... */}
}
```

```php
<?php // index.php

require_once("classes.php");

$config = require("config.php");
$database = new MyDatabase($config["dsn"], $config["username"], $config["password"]);
$web = new MyWeb($database);
$blog = new MyBlog($web);
$blog->show("homepage");
```

```php
<?php // admin.php

require_once("classes.php");

$config = require("config.php");
$database = new MyDatabase($config["dsn"], $config["username"], $config["password"]);
$web = new MyWeb($database);
$admin = new MyAdmin($web);
$admin->show("dashboard");
```

And now the **same code with service locator**:

```php
<?php // classes.php

use PetrKnap\Php\ServiceManager\ServiceManager;
use Psr\Container\ContainerInterface;

class MyDatabase
{
   public function __construct($dsn, $user, $password) {/* ... */}
}

class MyWeb
{
   public function __construct(MyDatabase $database) {/* ... */}
}

class MyBlog
{
   public function __construct(MyWeb $web) {/* ... */}
   
   public function show($page) {/* ... */}
}

class MyAdmin
{
   public function __construct(MyWeb $web) {/* ... */}
   
   public function show($page) {/* ... */}
}

ServiceManager::setConfig([
   "factories" => [
      "MyDatabase" => function() {
         $config = require("config.php");
         return new MyDatabase($config["dsn"], $config["username"], $config["password"]);
      },
      "MyWeb" => function(ContainerInterface $container) {
         return new MyWeb($container->get("MyDatabase"));
      },
      "MyBlog" => function(ContainerInterface $container) {
         return new MyBlog($container->get("MyWeb"));
      },
      "MyAdmin" => function(ContainerInterface $container) {
         return new MyBlog($container->get("MyWeb"));
      }
   ]
]);
```

```php
<?php // index.php

use PetrKnap\Php\ServiceManager\ServiceManager;

require_once("classes.php");

ServiceManager::getInstance()->get("MyBlog")->show("homepage");
```

```php
<?php // admin.php

use PetrKnap\Php\ServiceManager\ServiceManager;

require_once("classes.php");

ServiceManager::getInstance()->get("MyAdmin")->show("dashboard");
```


## Usage of php-servicemanager

### Service manager configuration
```php
<?php

use PetrKnap\Php\ServiceManager\ConfigurationBuilder;
use PetrKnap\Php\ServiceManager\ServiceManager;
use Psr\Container\ContainerInterface;

class MyCoreClass
{
    /* ... */
}

class MyClass
{
    private $core;
    
    public function __construct(MyCoreClass $core)
    {
        $this->core = $core;
    }
}

$configBuilder = new ConfigurationBuilder();
$configBuilder->addInvokable("MyCoreClass", "MyCoreClass");
$configBuilder->setShared("MyCoreClass", true);
$configBuilder->addFactory("MyClass", function(ContainerInterface $container) {
    return new MyClass($container->get("MyCoreClass"));
});

ServiceManager::setConfig($configBuilder);
```

### Service manager usage
```php
<?php

use PetrKnap\Php\ServiceManager\ServiceManager;

$serviceManager = ServiceManager::getInstance();
$myClass = $serviceManager->get("MyClass");
```


{% include php/how-to-install.md %}



[Service locator pattern - Wikipedia, The Free Encyclopedia]:https://en.wikipedia.org/w/index.php?title=Service_locator_pattern&oldid=698489971
