---
address: {{ address }}
location: {{ location }}
title: {{ title }}
image: {{ image }}
published: {{ published }}
capacity: {{ capacity }}
links: {% for link in links %}
  {{ link[0] }}: {{ link[1] }}
{%- endfor %}
buttons: {% for button in buttons %}
  {{ button[0] }}: {{ button[1] }}
{%- endfor %}
policies: {% for link in policies %}
  {{ link[0] }}: {{ link[1] }}
{%- endfor %}
features: {% for feature in features %}
  - {{ feature }}
{%- endfor %}
technology: {% for item in equipment %}
  {{ item[0] }}: {{ item[1] }}
{%- endfor %}
type: {{ type }}
keywords: {% for keyword in keywords %}
  {{ keyword }}
{%- endfor %}
help: {% for item in help %}
  {{ item[0] }}: {{ item[1] }}
{%- endfor %}
libanswers: {% for item in libanswers %}
  {{ item[0] }}: {{ item[1] }}
{%- endfor %}
---

{{ body }}
