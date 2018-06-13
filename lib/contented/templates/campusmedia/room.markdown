---
address: {{ address }}
title: {{ title }}
capacity: {{ capacity }}
links:
  Room Instructions: {{ instructions }}
  Software List: {{ software }}
image: {{ image }}
departments: {{ departments }}
floor: {{ floor }}
published: {{ published }}
buttons:
  Reserve Equipment for this Room: {{ form_url }}
features: {% for feature in features %}
  - {{ feature }}
{%- endfor %}
technology: {% for item in equipment %}
  {{ item[0] }}: {{ item[1] }}
{%- endfor %}
policies:
  Policies: {{ policies_url }}
description: {{ description }}
type: {{ type }}
keywords: {% for keyword in keywords %}
  {{ keyword }}
{%- endfor %}
help:
  text: {{ help_text }}
  phone: {{ help_phone }}
  email: {{ help_email }}
access: {{ access }}
---

{{ notes }}
