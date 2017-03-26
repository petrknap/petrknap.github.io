---
layout: blueprint.php
---
# Available packages

{% for package in site.pages %}
{% if package.path contains "php/" and package.name contains ".md" and package.name != "index.md" %}
* [petrknap/php-{{ package.name | remove: ".md" }}]({{ package.url }}.html)
{% endif %}
{% endfor %}
