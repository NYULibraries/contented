---
address: {{ address }}
title: {{ title }}
capacity: {{ capacity }}
links:
  Room Instructions: {{ instructions }}
  Software list:
    {{ software }}
image: {{ image }}
departments: {{ departments }}
floor: {{ floor }}
published: {{ published }}
buttons:
  Reserve Equipment for this Room: {{ form_url }}
features:
  {% for item in features -%}
    - {{ item }}
  {{%- endfor -%}}
equipment:
  {% for item in equipment -%}
    - {{ item }}
  {{%- endfor -%}}
policies:
  Policies: {{ policies_url }}
description: {{ notes }}
type: {{ type }}
keywords:
  {% for keyword in keywords -%}
    - {{ keyword }}
  {{%- endfor -%}}
help:
  text: {{ help_text }}
  phone: {{ help_phone }}
  email: {{ help_email }}
access: {{ access }}
---

{{ room_notes }}
