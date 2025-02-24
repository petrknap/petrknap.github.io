---
layout: blog.post
title: "#Laravel - #PHP #Framework of #BadDesign and #Frustration"
category: backend
keywords:
    - development
    - web
    - php
    - framework
    - laravel
    - symfony
    - orm
    - dbal
    - eloquent
    - doctrine
pull_request_id: 9
---

If we've ever chatted, you've likely noticed that **[Laravel] isn't exactly my favorite PHP framework**.
There are quite a few reasons for this, but most of them can be demonstrated with just a few straightforward examples from its documentation.
Are you wondering **what bothers me so much** about [Laravel]?


## Properties All Around

In [Artisan], the first entrypoint to the [Laravel] world, we see the first example of a bad-design that permeates the entire framework.
```php
class SendEmails extends Command {
    protected $signature = 'mail:send';
    protected $description = 'Send e-mails';
    public function handle(Mailer $mailer): void { /* ...*/ }
}
```

The authors decided that the `signature`, `description`, and other seemingly **constant values** of the command **should actually be variable**.
Interesting idea, right?
Well, not quite.

### Why Does This Bother Me?

Let's look under the hood:
```php
class Command extends SymfonyCommand {
    protected $description;
    /* ... */
    public function __construct() {
        /* ... */
        if (!isset($this->description)) { /* ... */ } else {
            $this->setDescription((string) $this->description);
        }
        /* ... */
    }
    /* ... */
    protected function execute(InputInterface $input, OutputInterface $output): int {
        /* ... */
        $method = method_exists($this, 'handle') ? 'handle' : '__invoke';
        /* ... */
    }
    /* ... */
}
```

Yes, even the `handle` method is not abstract (or on interface), **you have to guess right method name**.

If these clearly constant values were provided by methods and methods were provided by interfaces or abstracts, we could **implement interfaces** and **overload methods** instead of guessing what to do.
Or even better, why not **use attributes**?
In all of these cases, it's safe to **have own property** named `signature` and **clear how to implement** the command.
```php
#[AsCommand(name: 'mail:send', description: 'Send e-mails')]
class SendEmails extends Command {
    public function __construct(
        private readonly Mailer $mailer,
        private readonly string $signature,
    ) { /* ...*/ }
    protected function execute(InputInterface $input, OutputInterface $output): int { /* ... */ }
}
```

The decision to use properties and "dynamic" methods instead of interfaces (or abstracts) is very bad, and I think it's the main reason why **working with [Laravel] is so frustrating**.

**Sad Fact:**
[Laravel] is built on the [Symfony], which, as you can see above, is well-designed.
This means that considerable efforts have been made to make [Artisan] worse.


## Unusable Constructors, Inconsistencies, and Collisions Everywhere

[Eloquent] (and many other components) takes this bad-design a few more steps further and adds some extras as some things **can be protected** while others **must be public**, some are **properties** while others are **constants**, but other others are even **methods**, and there's more of it...
```php
class Flight extends Model {
    const CREATED_AT = 'created_at';
    public $incrementing = true;
    public $timestamps = false;
    protected $table = 'flights';
    protected $primaryKey = 'id';
    public function createdBy(): HasOne { /* ... */ }
}
```

[Eloquent] "ORM" is in nutshell a database abstraction layer (DBAL, not ORM) that represents table rows as **self-managing 1:1 models**.
What does this imply?
- You can't use a constructor because the **model must be instantiable without data** as it is its own repository and manager too.
- If your table contains columns named `table`, `incrementing`, `original`,... **you'll face conflicts with the model's properties**.
- If you have multi-word properties (e.g. `created_at` and `created_by_id` columns) and adhere to the [PSR] (or to the [Eloquent] documentation), you must define a method like `createdBy` on the model to have working relation.
  This results in **properties `created_at` and `createdBy` coexisting in the model**.

### Why Does This Bother Me?

- **Blocked Constructor:** If I have an object with a required property, I can't enforce it - I have a blocked constructor.
  Anyone can call `new Flight()` and create an invalid instance.
- **Property Conflicts:** I can't have own property named for example `original` to refer to original data, or `signature` to store e-mail signature.
- **Unrestricted Changes:** Anyone can execute `$flight->incrementing = false`, but why should they be able to?
- **Messy Code Style:** The code is crazy...
  ```php
  $flight = new Flight();
  $flight->created_at = $now;
  $flight->created_by_id = $user->id;
  // ...
  if ($flight->created_at == $now && $flight->createdBy == $user) { /* ... */ }
  ```

Instead, consider a cleaner approach by [Doctrine]:
```php
$flight = new Flight(createdBy: $user);
// ...
if ($flight->getCreatedAt() == $now && $flight->getCreatedBy() == $user) { /* ... */ }
```
```php
#[ORM\Entity]
#[ORM\Table(name: 'flights')]
class Flight
{
    #[ORM\Id]
    #[ORM\Column(type: 'integer')]
    #[ORM\GeneratedValue]
    private int|null $id = null;

    #[ORM\Column(type: 'datetime')]
    private DateTimeInterface $createdAt;

    #[ORM\ManyToOne(targetEntity: User::class, inversedBy: 'createdFlights')]
    private User $createdBy;

    public function __construct(User $createdBy) {
        $this->createdAt = new DateTimeImmutable();
        $this->createdBy = $createdBy;
    }

    public function getCreatedAt(): DateTimeInterface {
        return $this->createdAt;
    }

    public function getCreatedBy(): User {
        return $this->createdBy;
    }
}
```

**Sad Fact:**
[Eloquent] was based on [Doctrine] until recently so it also **deviates from this clean design**.


## Magic Everywhere

Do you remember the `Flight` model?
If you look at the child and parent signatures, you will scratch your head as you **try to guess** why the following code is **runnable and correct**.
```php
Flight::whereCreatedAt($now)->first();
```

And if this was correct, why the following code is **runnable but incorrect**?
```php
Flight::whereCreatedAt($now)
    ->join('users', 'users.id', '=', 'flights.created_by_id')
    ->where('users.name', '=', 'John')
    ->first();
```

### Why Does This Bother Me?

There is **no property** `created_at`, **no method** `whereCreatedAt` and  **no reason** why column `created_at` is once magically converted to property `created_at` and once magically converted to method `whereCreatedAt`.
And also there is no reason why it is **impossible** to do a `join` after `whereCreatedAt` (it leads to error in SQL query).

The **lack of transparency and consistency** is increasing complexity when trying to understand or maintain the code.
It's **hard to trace the origin of certain behaviors** or property values.


## <q title="One for all, all for one">Unus pro omnibus, omnes pro uno</q>

What also frustrates me about [Laravel] is its **super-monolithic design**.
[Laravel] works as one big blob, making it **challenging to adhere to [SOLID principles]** and create a modular, maintainable application.
This monolithic approach means that components are tightly coupled, making it **difficult to isolate and maintain individual parts** of the system.

### Why Does This Bother Me?

As a result, **developing a well-designed and scalable application becomes a daunting task**.
We can also **trust nobody**, because if we provide, for example, just a model, it's **not just a data object**.
```php
function countPassengers(Flight $flight): int {
    $flight->ticket_price = 1;
    $flight->save();
    $flight->getConnection()->update('update users set email = ? where login = ?', ['your@attacker.here', 'admin']));
    return $flight->passengers->count();
}
```

**Why is this possible?**
The function has (at first look) only dependency on some data object.
On code review we are checking `$thirdPartyFlightService->countPassengers($flight)` which should be safe, but it is able to change ticket price and admin's e-mail.

**Sad Fact:**
This is irrelevant, because **everyone can do everything everywhere** via bad-design of something called "[Facades]".
And you need to use this nonsense as **you aren't able to use DI** as you can't use constructors in many situations.


## <q>And then?</q>

I could dissect [Laravel] component by component, package by package, but I want to keep it brief here.
So what is the **main problem**?
The entire framework looks like **the authors misunderstood the basic programming principles**, looked at the [Symfony] with [Doctrine], and then wrapped it up in a cumbersome, flawed blob that **brings numerous drawbacks**.

What frustrates me the most about [Laravel] is that **it's not a school project or at least a greenfield project**; it's a [Symfony] wrapper developed for years by so many people.
It's alarming **how much time has been spent crippling [Symfony]**.

If I may ask the [Laravel] authors and community for **one thing**:
> Please, kill it now - the world has suffered enough.


[Artisan]:https://laravel.com/docs/11.x/artisan
[Doctrine]:https://www.doctrine-project.org/
[Eloquent]:https://laravel.com/docs/11.x/eloquent
[Facades]:https://laravel.com/docs/11.x/facades
[Laravel]:https://laravel.com/
[PSR]:https://www.php-fig.org/psr/
[SOLID principles]:https://en.wikipedia.org/wiki/SOLID
[Symfony]:https://symfony.com/
