---
layout: blueprint
---
# Nette Bootstrap and Test-Case for PHPUnit

## Container

Base bootstrap class is self-explanatory, just use it naturally.

```php
Bootstrap::getContainer()->getByType("Nette\\Application\\Application")->run();
```


## Testing

### Special configuration for unit testing

If you need special configuration for unit testing (f.e. different database connection) you can simply modify `Bootstrap::getConfigFiles` method.

```php
<?php

class Bootstrap extends \PetrKnap\Nette\Bootstrap\Bootstrap
{
    protected function getConfigFiles()
    {
        return array(
            __DIR__ . "/cfg/config.neon",
            self::getOption(self::OPTION_IS_TEST_RUN) ? __DIR__ . "/cfg/test.neon" : __DIR__ . "/cfg/local.neon"
        );
    }
}
```

You can modify any other method the same way if you need different log dir, etc.

### Test Case

There is prepared NetteTestCase, base class for your unit tests. This class requires defined constant `NETTE_BOOTSTRAP_CLASS`, you can defined it in your `phpunit.xml`:

```xml
<phpunit>
    <php>
      <const name="NETTE_BOOTSTRAP_CLASS" value="Bootstrap"/>
    </php>
</phpunit>
```

or in your own test case:

```php
<?php

class NetteTestCase extends \PetrKnap\Nette\Bootstrap\PhpUnit\NetteTestCase
{
    const NETTE_BOOTSTRAP_CLASS = "Bootstrap";
}
```

#### Container access

For access to application container in test use method `NetteTestCase::getContainer`.

#### Presenter testing

*Test case simulates `Application\Request` instead of `Http\Request`.*

For presenter testing use method `NetteTestCase::runPresenter`.

```php
<?php

class NetteTestCase extends \PetrKnap\Nette\Bootstrap\PhpUnit\NetteTestCase
{
    public function testHelloWorld()
    {
        /** @var \Nette\Application\Responses\TextResponse $response */
        $response = $this->runPresenter("World", "hello"); // calls WorldPresenter::actionHello
        $html = (string) $response->getSource(); // renders output
        $this->assertContains("Hello, world!", $html);
    }
}
```


{% include docs/how-to-install.md %}



[Nette]:https://nette.org/
[PHPUnit]:https://phpunit.de/
[Petr Knap]:http://petrknap.cz/
[this repository as ZIP]:https://github.com/petrknap/nette-bootstrap/archive/master.zip
