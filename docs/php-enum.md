---
layout: blueprint
---
# Enumerated type for PHP

* [What is Enum?](#what-is-enum)
* [Why use Enums instead of Constants?](#why-use-enums-instead-of-constants)
* [Usage of php-enum](#usage-of-php-enum)
    * [Enum declaration](#enum-declaration)
    * [Enum usage](#enum-usage)
    * [Tips & Tricks](#tips--tricks)
* [How to install](#how-to-install)


## What is Enum?

> In computer programming, an **enumerated type** (also called **enumeration** or **enum**, or **factor** in the R programming language, and a **categorical variable** in statistics) is a data type consisting of a set of named values called **elements**, **members**, **enumeral**, or **enumerators** of the type. The enumerator names are usually identifiers that behave as constants in the language. A variable that has been declared as having an enumerated type can be assigned any of the enumerators as a value. In other words, an *enumerated type has values that are different from each other*, and that can be compared and assigned, but which are not specified by the programmer as having any particular concrete representation in the computer's memory; compilers and interpreters can represent them arbitrarily.
-- [Enumerated type - Wikipedia, The Free Encyclopedia]


## Why use Enums instead of Constants?

Because **it is safer and less scary** than using constants. Don't trust me? Let see at this code:

```php
<?php

class MyBoolean
{
    const MY_TRUE = 1;
    const MY_FALSE = 2;
}

function isTrue($myBoolean)
{
    switch($myBoolean) {
        case MyBoolean::MY_TRUE:
            return true;
        case MyBoolean::MY_FALSE:
            return false;
    }
}

isTrue(MyBoolean::MY_TRUE);  // returns true - OK
isTrue(MyBoolean::MY_FALSE); // returns false - OK
isTrue(1);                   // returns true - OK
isTrue(2);                   // returns false - scary, but OK
isTrue(true);                // returns true - OK
isTrue(false);               // returns null - WTF?
```

And now the **same code with Enum** instead of Constants:

```php
<?php

class MyBoolean extends \PetrKnap\Php\Enum\Enum
{
    protected function members()
    {
        return [
            "MY_TRUE" => 1,
            "MY_FALSE" => 2
        ];
    }
}

function isTrue(MyBoolean $myBoolean)
{
    switch($myBoolean) {
        case MyBoolean::MY_TRUE():
            return true;
        case MyBoolean::MY_FALSE():
            return false;
    }
}

isTrue(MyBoolean::MY_TRUE());  // returns true - OK
isTrue(MyBoolean::MY_FALSE()); // returns false - OK
isTrue(1);                     // uncaught type error - OK
isTrue(2);                     // uncaught type error - OK
isTrue(true);                  // uncaught type error - OK
isTrue(false);                 // uncaught type error - OK
```


## Usage of php-enum

### Enum declaration
```php
<?php

class DayOfWeek extends \PetrKnap\Php\Enum\Enum
{
    protected function members()
    {
        return [
            "SUNDAY" => 0,
            "MONDAY" => 1,
            "TUESDAY" => 2,
            "WEDNESDAY" => 3,
            "THURSDAY" => 4,
            "FRIDAY" => 5,
            "SATURDAY" => 6
        ];
    }
}
```

### Enum usage
```php
<?php

if (DayOfWeek::FRIDAY() == DayOfWeek::FRIDAY()) {
    echo "This is OK.";
}

if (DayOfWeek::FRIDAY() == DayOfWeek::MONDAY()) {
    echo "We are going to Hell!";
}

function isWeekend(DayOfWeek $dayOfWeek)
{
   switch ($dayOfWeek) {
       case DayOfWeek::SATURDAY():
       case DayOfWeek::SUNDAY():
           return true;
       default:
           return false;
   }
}

if (date('w') == DayOfWeek::FRIDAY()->getValue()) {
    echo "Finally it is Friday!";
}
// or
if (DayOfWeek::getEnumByValue(date('w')) == DayOfWeek::FRIDAY()) {
    echo "Finally it is Friday!";
}
```

### Tips & Tricks

Enum is capable to carry any data type as values, including another enum instance.

```php
<?php

class MixedValues extends \PetrKnap\Php\Enum\Enum
{
    protected function members()
    {
        return [
            "null" => null,
            "boolean" => true,
            "integer" => 1,
            "float" => 1.0,
            "string" => "s",
            "array" => [],
            "object" => new \stdClass(),
            "callable" => function() {}
        ];
    }
}
```

You can simply convert value to Enum instance and vice versa.

```php
<?php

/**
 * @ORM\Entity
 */
class MyEntity
{
    /**
     * @ORM\Column(type="integer")
     * @var int
     */
    private $dayOfWeek;

    /**
     * @return DayOfWeek
     */
    public function getDayOfWeek()
    {
        return DayOfWeek::getEnumByValue($this->dayOfWeek);
    }

    /**
     * @param DayOfWeek $dayOfWeek
     */
    public function setDayOfWeek(DayOfWeek $dayOfWeek)
    {
        $this->dayOfWeek = $dayOfWeek->getValue();
    }
}
```


{% include docs/how-to-install.md %}



[Enumerated type - Wikipedia, The Free Encyclopedia]:https://en.wikipedia.org/w/index.php?title=Enumerated_type&oldid=701057934
