# -*- coding: utf-8 -*-
# vim: ft=sls
{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as chrome with context %}
{%- set chrome_dir = 'C:/Program Files/Google Chrome/' %}
{%- set reg_keys = [
    'HKEY_LOCAL_MACHINE\\SOFTWARE\\Google',
    'HKEY_LOCAL_MACHINE\\SOFTWARE\\GooglePlugins'
  ]
%}

{#- Calculate GUID without going stoopid-wide #}
{%- set ps_base = 'Get-ItemProperty HKLM:\\SOFTWARE\\Microsoft\\' %}
{%- set ps_path = 'Windows\\CurrentVersion\\Uninstall\\* | ' %}
{%- set ps_filt = 'Where-Object {$_.DisplayName -eq "Google Chrome"} | ' %}
{%- set ps_sel  = 'Select-Object -ExpandProperty PSChildName' %}
{%- set ps_cmd  = ps_base ~ ps_path ~ ps_filt ~ ps_sel %}
{%- set installed_guid = salt.cmd.run(ps_cmd, shell='powershell').strip() %}

{%- for reg_key in reg_keys %}
Delete {{ reg_key }} from registry:
  reg.absent:
    - name: '{{ reg_key }}'
    - require:
      - pkg: 'Uninstall Chrome application'
{%- endfor %}

Nuke the Chrome install-directory contents:
  file.directory:
    - name: '{{ chrome_dir }}'
    - clean: True
    - require:
      - pkg: 'Uninstall Chrome application'

Nuke the Chrome install-directory:
  file.absent:
    - name: '{{ chrome_dir }}'
    - require:
      - file: 'Nuke the Chrome install-directory contents'

Uninstall Chrome application:
  pkg.removed:
    - name: '{{ installed_guid if installed_guid else "Google Chrome" }}'
    - onlyif: 'powershell -command "if (''{{ installed_guid }}'') {exit 0}"'
