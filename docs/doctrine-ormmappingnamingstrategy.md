---
layout: blueprint
---
# Naming strategies for `doctrine/orm`

## `PetrKnap\Doctrine\OrmMappingNamingStrategy\UnderscoreNamingStrategy`

Underscore naming strategy with support for namespaces and prefixes.

| Class   | Original | This     | This with prefix `Foo` |
|---------|----------|----------|------------------------|
| Bar     | bar      | bar      | -                      |
| Foo\Bar | bar      | foo__bar | bar                    |


{% include docs/how-to-install.md %}
