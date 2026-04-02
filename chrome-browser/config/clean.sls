# -*- coding: utf-8 -*-
# vim: ft=sls

{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split('/')[0] %}
{%- set sls_service_clean = tplroot ~ '.service.clean' %}
{%- from tplroot ~ "/map.jinja" import mapdata as chrome with context %}

include:
  - {{ sls_service_clean }}
{%- if grains.kernel == "Linux" %}
  - .lin_clean
{%- elif grains.kernel == "Windows" %}
  - .win_clean
{%- endif %}
