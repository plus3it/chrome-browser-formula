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

Uninstall Chrome application:
  cmd.run:
    - name: '"{{ chrome.pkg.uninstaller }}" /S /allusers'
    - shell: powershell
    - onlyif:
      - 'test -f {{ chrome.pkg.uninstaller }}'

Nuke the Chrome install-directory contents:
  file.directory:
    - name: '{{ chrome_install_dir }}'
    - clean: True
    - onlyif:
      - cmd: 'Uninstall Chrome application'

Nuke the Chrome install-directory:
  file.absent:
    - name: '{{ chrome_install_dir }}'
    - onlyif:
      - file: 'Nuke the Chrome install-directory contents'

{%- for reg_key in reg_keys %}
Delete {{ reg_key }} from registry:
  reg.absent:
    - name: {{ reg_key }}
    - onlyif:
      - cmd: 'Uninstall Chrome application'
{%- endfor %}
