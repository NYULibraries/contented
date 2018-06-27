---
address: {{ address }}
title: {{ title }}
capacity: {{ capacity }}
links: {% for link in links %}
  {{ link[0] }}: {{ link[1] }}
{%- endfor %}
image: {{ image }}
departments: {{ departments }}
floor: {{ floor }}
published: {{ published }}
buttons: {% for button in buttons %}
  {{ button[0] }}: {{ button[1] }}
{%- endfor %}
features: {% for feature in features %}
  - {{ feature }}
{%- endfor %}
technology: {% for item in equipment %}
  {{ item[0] }}: {{ item[1] }}
{%- endfor %}
policies: {% for policy in policies %}
  {{ policy[0] }}: {{ policy[1] }}
{%- endfor %}
description: {{ description }}
type: {{ type }}
keywords: {% for keyword in keywords %}
  {{ keyword }}
{%- endfor %}
help: {% for item in help %}
  {{ item[0] }}: {{ item[1] }}
{%- endfor %}
access: {{ access }}
---

{{ body }}
