---
title: {{ person.title }}
subtitle: {{ person.nickname }}
job_title: {{ person.job_title }}
location: {{ person.location }}
address: {{ person.building_address_line_1 }}
parent_department: {{ person.parent_department }}
departments:
{% for department in person.departments %}
- {{ department }}
{% endfor %}
subject_specialties:
{% for subject_specialty_category in person.subject_specialties %}
  {{ subject_specialty_category[0] }}:
  {% for subject_specialty in subject_specialty_category[1] %}
  - {{ subject_specialty }}
  {% endfor %}
liaison_relationship:
{% for liaison_relationship in person.liaison_relationship %}
- {{ liaison_relationship }}
{% endfor %}
linkedin: {{ person.linkedin }}
email: {{ person.email_address }}
phone: {{ person.work_phone }}
twitter: {{ person.twitter }}
image: {{ person.image }}
buttons:
  Request an Appointment: {{ person.appointment_request_button }}
guides:
  libguides_account_ids: {{ person.libguides_account_id }}
  libguides_guide_ids: {{ person.guide_id_numbers }}
  link: {{ person.libguides_author_profile_url }}
publications:
  rss: {{ person.publications_rss }}
  link: {{ person.publications_url }}
blog:
  rss: {{ person.blog_rss }}
  title: {{ person.blog_title }}
  link: {{ person.blog_url }}
orcid_id: {{ person.orcid }}
keywords: {{ person.keywords }}
first_name: {{ person.first_name }}
last_name: {{ person.last_name }}
sort_title: {{ person.sort_title }}
---

{{ person.about_you }}
