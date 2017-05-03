---
layout: blueprint
---
# Available packages

{% for package in site.pages %}
{% if package.path contains "docs/" and package.name contains ".md" and package.name != "index.md" %}
* [petrknap/{{ package.name | remove: ".md" }}]({{ package.url }}.html)
{% endif %}
{% endfor %}
