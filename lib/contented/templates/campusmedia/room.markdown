---
address: {{ address }}
title: {{ title }}
capacity: {{ capacity }}
links:
  Room Instructions: {{ instructions }}
  Software list:
    {{ software }}
image: {{ room_image }}
departments: {{ room_departments }}
floor: {{ room_floor }}
published: false
buttons:
  Reserve Equipment for this Room: {{ constant_form_url }}
features: {{ room_features }}
technology:
  {% for equipment in room_technologies -%}
    - {{ equipment }}
  {{%- endfor -%}}
policies:
  Policies: {{ constant_policies_url }}
description: {{ room_notes }}
type: {{ room_type }}
keywords:
help:
  text: {{ building_help_text }}
  phone: {{ building_help_phone }}
  email: {{ building_help_email }}
access: {{ building_access }}
---

{{ room_notes }}
