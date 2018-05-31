---
address: {{ building_address }}
title: {{ room_title }}
subtitle: {{ room_subtitle }}
capacity: {{ room_capacity }}
links:
  Room Instructions: {{ room_instructions }}
  Software list:
    {{% for software in room_softwares -%}}
      - {{ software }}
    {{%- endfor -%}}
image: {{ room_image }}
departments: {{ room_departments }}
floor: {{ room_floor }}
published: {{ room_published }}
buttons:
  Reserve Equipment for this Room: {{ constants_form_url }}
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
  text: {{ room_help_text }}
  phone: {{ room_help_phone }}
  email: {{ room_help_email }}
access: {{ room_access }}
---

{{ room_notes }}
