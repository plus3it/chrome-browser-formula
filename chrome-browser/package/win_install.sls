# -*- coding: utf-8 -*-
# vim: ft=sls

{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as chrome with context %}

{#- Keep URL specification within 80 columns #}
{%- set url = 'https://dl.google.com/tag/s/appguid%3D%7B8A69D345-D564-463C' ~
    '-AFF1-A69D9E530F96%7D%26iid%3D%7B69E813F4-98F1-4467-8A73-5D9B0A34D21B' ~
    '%7D%26lang%3Den%26browser%3D4%26usagestats%3D0%26appname%3DGoogle%2520' ~
    'Chrome%26needsadmin%3Dtrue%26ap%3Dx64-stable-statsdef_1%26installdat' ~
    'aindex%3Ddefaultbrowser/chrome/install/ChromeStandaloneSetup64.exe'
%}
{%- set temp_exe = 'C:/Windows/Temp/ChromeStandaloneSetup64.exe' %}

Download Chrome Standalone EXE:
  file.managed:
    - name: '{{ temp_exe }}'
    - source: '{{ url }}'
    - skip_verify: True
    - makedirs: True

Install Google Chrome EXE:
  cmd.run:
    - name: '"{{ temp_exe }}" /silent /install'
    - require:
      - file: 'Download Chrome Standalone EXE'
    - unless: |
        if (
          Test-Path "${env:ProgramFiles}\Google\Chrome\Application\chrome.exe"
        ) {
          exit 0
        } else {
          exit 1
        }

