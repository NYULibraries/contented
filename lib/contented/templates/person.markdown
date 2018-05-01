---
title: {{ title }}
subtitle: {{ nickname }}
job_title: {{ job_title }}
location: {{ location }}
address: {{ building_address_line_1 }}
parent_department: {{ parent_department }}
departments:
{% for department in departments -%}
- {{ department }}
{% endfor -%}
subject_specialties:
{%- for subject_specialty_category in subject_specialties %}
  {{ subject_specialty_category[0] }}:
  {%- for subject_specialty in subject_specialty_category[1] %}
  - {{ subject_specialty }}
  {%- endfor -%}
{% endfor %}
liaison_relationship:
{% for liaison_relationship in liaison_relationships -%}
- {{ liaison_relationship }}
{% endfor -%}
linkedin: {{ linkedin }}
email: {{ email_address }}
phone: {{ work_phone }}
twitter: {{ twitter }}
image: {{ image }}
buttons:
{%- if appointment_request_button %}
  Request an Appointment: {{ appointment_request_button }}
{%- endif %}
{%- if libguides_account_id || guide_id_numbers || libguides_author_profile_url %}
guides:
  libguides_account_ids: {{ libguides_account_id }}
  libguides_guide_ids: {{ guide_id_numbers }}
  link: {{ libguides_author_profile_url }}
{%- endif %}
{%- if publications_rss || publications_url %}
publications:
  rss: {{ publications_rss }}
  link: {{ publications_url }}
{%- endif %}
{%- if blog_rss || blog_title || blog_url %}
blog:
  rss: {{ blog_rss }}
  title: {{ blog_title }}
  link: {{ blog_url }}
{%- endif %}
orcid_id: {{ orcid }}
keywords:
first_name: {{ first_name }}
last_name: {{ last_name }}
sort_title: {{ sort_title }}
---

{{ about_you }}
