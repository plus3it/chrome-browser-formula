# -*- coding: utf-8 -*-
# vim: ft=sls
{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as chrome with context %}
{%- if salt.grains.get('cpuarch') == "AMD64" %}
  {%- set temp_exe = 'C:/Windows/Temp/ChromeStandaloneSetup64.exe' %}
{%- else %}
  {%- set temp_exe = 'C:/Windows/Temp/ChromeStandaloneSetup32.exe' %}
{%- endif %}

Clean staged Chrome Standalone EXE-based installer:
  file.absent:
    - name: '{{ temp_exe }}'
    - require:
      - cmd: 'Install Google Chrome EXE'

Download Chrome Standalone EXE-based installer:
  file.managed:
    - name: '{{ temp_exe }}'
    - source: '{{ chrome.pkg.installer_uri }}'
    - skip_verify: True
    - makedirs: True

Install Google Chrome EXE:
  cmd.run:
    - name: |
        Start-Process "{{ temp_exe }}" -ArgumentList '/silent /install' -Wait
        Start-Sleep -Seconds 5
    - require:
      - file: 'Download Chrome Standalone EXE-based installer'
    - shell: powershell
    - success_retcodes: [
        0,
        3010
      ]
    - unless: 'if (Test-Path "${env:ProgramFiles}\Google\Chrome\Application\chrome.exe") { exit 0 } else { exit 1 }'
