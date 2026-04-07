# -*- coding: utf-8 -*-
# vim: ft=sls
{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as chrome with context %}
{%- set chrome_install_dir = 'C:/Program Files/Google Chrome/' %}
{%- set reg_keys = [
    'HKEY_LOCAL_MACHINE\SOFTWARE\Google',
    'HKEY_LOCAL_MACHINE\SOFTWARE\GooglePlugins'
  ]
%}

{%- for reg_key in reg_keys %}
Delete {{ reg_key }} from registry:
  reg.absent:
    - name: {{ reg_key }}
    - onchanges:
      - pkg: 'Uninstall Chrome application'
{%- endfor %}

Nuke the Chrome install-directory contents:
  file.directory:
    - name: '{{ chrome_install_dir }}'
    - clean: True
    - onchanges:
      - pkg: 'Uninstall Chrome application'

Nuke the Chrome install-directory:
  file.absent:
    - name: '{{ chrome_install_dir }}'
    - onchanges:
      - file: 'Nuke the Chrome install-directory contents'

Uninstall Chrome application:
  pkg.removed:
    - name: 'Google Chrome'
