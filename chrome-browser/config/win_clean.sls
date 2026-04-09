# -*- coding: utf-8 -*-
# vim: ft=sls

{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as chrome with context %}

{%- for key in chrome.policy_extras.registry_keys %}
Remove Registry Key {{ loop.index }}:
  reg.absent:
    - name: {{ key }}
    - onchanges:
      - cmd: Uninstall Google Chrome
{%- endfor %}

{%- for id, path in chrome.policy_extras.policy_files.items() %}
Remove Chrome Policy File "{{ id }}":
  file.absent:
    - name: {{ path }}
    - onchanges:
      - cmd: Uninstall Google Chrome
{%- endfor %}
