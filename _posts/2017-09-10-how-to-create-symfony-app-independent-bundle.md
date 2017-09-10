---
layout: blog.post
title: "How to create #Symfony app independent #SymfonyBundle"
category: backend
keywords:
    - PHP
    - Symfony
    - Symfony bundle
    - backend development
    - Symfony Up!
---

If you wish to **create independent [Symfony Bundle](https://symfony.com/doc/current/bundles.html)** then you are on the *Highway to Hell*.
At [netpromotion] we take the ball and run with it.
Now we are ready to release our tool which solves the most common problems on the highway.
Please, take a seat and read more.


## Last things first - the tool

At the begin, please, let me to introduce you [Symfony Up!] - our tool which solves common problems with independent bundles.
You can simply **require it by `composer require netpromotion/symfony-up` command**.

You can **build minimal application by `vendor/bin/symfony-up` command** if you wish.


## Run tests without the target application

When you starts with bundles, you probably met the [Best Practices for Reusable Bundles].

> The test suite must be executable with a simple phpunit command run from a sample application;

Best practise is to create whole application to test your application independent bundle.

[Symfony Up!] provides you `UpTestCase` which requires only kernel.
So your **tests should be executed which only one additional class**.

```php
<?php

class YourBundle {/* ... */}

class YourKernel extends Netpromotion\SymfonyUp\UpKernel
{
    public function registerBundles()
    {
        return [
            /* ... */
            new YourBundle(),
        ];
    }
}

class YourBundleServiceTest extends Netpromotion\SymfonyUp\UpTestCase
{
    public static function getKernelClass()
    {
        return YourKernel::class;
    }
    
    public function testYourServiceWorks() {/* ... */}
}
```


## Create easily modifiable configuration

When you are ready to use *test-driven development* you need to create configuration.

> For simple configuration settings, rely on the default parameters entry of the Symfony configuration.

You **can't get control over parameters** - so you **must create configuration tree** over DI.

```php
<?php

class YourBundleConfiguration /* ... */ implements Symfony\Component\Config\Definition\ConfigurationInterface
{
    public function getConfigTreeBuilder()
    {
        $treeBuilder = new Symfony\Component\Config\Definition\Builder\TreeBuilder();
        $rootNode = $treeBuilder->root('your_bundle');

        $rootNode->children()
            ->scalarNode('scalar')
                ->defaultValue('value')
                ->end()
            ->arrayNode('strict_array')
                ->addDefaultsIfNotSet() // otherwise you don't get this key
                ->children()
                ->booleanNode('boolean')
                    ->defaultValue(false)
                    ->end()
                ->end()
            ->end()
            ->variableNode('dynamic_array')
                ->defaultValue(['key' => 'value'])
                ->end()
            ->end();

        return $treeBuilder;
    }
}

class YourBundleExtension extends Symfony\Component\DependencyInjection\Extension\Extension
{
    public function load(array $configs, Symfony\Component\DependencyInjection\ContainerBuilder $container)
    {
        $configuration = new YourBundleConfiguration();
        $config = $this->processConfiguration($configuration, $configs);

        /* ... */
    }
}

class YourBundle extends Symfony\Component\HttpKernel\Bundle\Bundle
{
    public function getContainerExtension()
    {
        return new YourBundleExtension();
    }
}
```

Now you have equivalent for:

```yaml
your_bundle:
  scalar: value
  strict_array:
    boolean: true
  dynamic_array:
    key: value
```


## Register services dependent on configuration

When you have configuration, you **need to use the values** in your services.

> Services should not use autowiring or autoconfiguration.
> Instead, all services should be defined explicitly.

It looks easy and it's easy - but you **can't use static definitions**.
Now you need to **create definitions dynamically during load** process. 

```php
<?php

class YourBundleService
{
    public function __construct(array $strictArray) {/* ... */}

    /* ... */
}

class YourBundleExtension extends Symfony\Component\DependencyInjection\Extension\Extension
{
    public function load(array $configs, Symfony\Component\DependencyInjection\ContainerBuilder $container)
    {
        /* ... */

        $container->setDefinition('your_bundle.service', new Symfony\Component\DependencyInjection\Definition(YourBundleService::class))
            ->setArguments([
                $config['strict_array'],
            ]);

        /* ... */
    }
}
```


## Register your configuration as service for controllers

If **you need to access your configuration in controllers**, you can use controller as service and register it the same way as regular service.
But it isn't practical, much better solution is to **register your configuration as service**.

```php
<?php

class YourBundleConfiguration extends ArrayObject implements Symfony\Component\Config\Definition\ConfigurationInterface
{
    public function getConfigTreeBuilder() {/* ... */}
}

class YourBundleExtension extends Symfony\Component\DependencyInjection\Extension\Extension
{
    public function load(array $configs, Symfony\Component\DependencyInjection\ContainerBuilder $container)
    {
        /* ... */

        $container->setDefinition('your_bundle.configuration', new Symfony\Component\DependencyInjection\Definition(YourBundleConfiguration::class))
            ->setArguments([
                $config,
            ]);
    }
}
```


## Create application independent reusable symfony bundle

Congratulation, now you are ready to create your own application independent reusable Symfony bundle.
You can follow [netpromotion] and [my GitHub account] if you wish to read real usages of this tips and hints.



[netpromotion]:https://github.com/netpromotion
[Symfony Up!]:https://netpromotion.github.io/symfony-up
[Best Practices for Reusable Bundles]:https://symfony.com/doc/current/bundles/best_practices.html
[my GitHub account]:https://github.com/petrknap
