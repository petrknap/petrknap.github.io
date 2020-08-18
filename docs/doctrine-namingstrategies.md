---
layout: blueprint
---
# Naming strategies for Doctrine


## `PetrKnap\Doctrine\NamingStrategies\Orm\Mapping\UnderscoreNamingStrategy`

Underscore naming strategy with support for namespaces and prefixes.

| Class    | Original  | This      | This with prefix `Foo` | This with prefix `Foo` and allowed root class `DateTime` |
|----------|-----------|-----------|------------------------|----------------------------------------------------------|
| Bar      | bar       | bar       | -                      | -                                                        |
| Foo\Bar  | bar       | foo__bar  | bar                    | bar                                                      |
| DateTime | date_time | date_time | -                      | date_time                                                |


{% include docs/how-to-install.md %}
