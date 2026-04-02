# -*- coding: utf-8 -*-
# vim: ft=sls

{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split('/')[0] %}
{%- set sls_config_clean = tplroot ~ '.config.clean' %}
{%- from tplroot ~ "/map.jinja" import mapdata as chrome with context %}
{%- set repo_dir = chrome.pkg.repo_dir %}
{%- set repo_name = chrome.pkg.repo_name %}
{%- set chrome_type = salt.pillar.get('chrome-browser:lookup:elx:chrome_family')
    | default(chrome.pkg.name, true)
%}


include:
  - {{ sls_config_clean }}

Uninstall Chrome Package:
  pkg.removed:
    - pkgs:
      - {{ chrome.pkg.name }}
    - require:
      - sls: {{ sls_config_clean }}
