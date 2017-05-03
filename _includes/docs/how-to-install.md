## How to install

Run `composer require petrknap/{{ page.name | remove: ".md" }}` or merge this JSON code with your project `composer.json` file manually and run `composer install`. Instead of `dev-master` you can use [one of released versions].

```json
{
    "require": {
        "petrknap/{{ page.name | remove: ".md" }}": "dev-master"
    }
}
```

Or manually clone this repository via `git clone https://github.com/petrknap/{{ page.name | remove: ".md" }}.git` or download [this repository as ZIP] and extract files into your project.



[one of released versions]:https://github.com/petrknap/{{ page.name | remove: ".md" }}/releases
[this repository as ZIP]:https://github.com/petrknap/{{ page.name | remove: ".md" }}/archive/master.zip
