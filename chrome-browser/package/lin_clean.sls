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

Nuke Watchmaker-installed, Chrome-related /etc/profile.d/ contents:
  file.absent:
    - name: '/etc/profile.d/chrome_flags.sh'
    - require:
      - pkg: 'Uninstall Chrome Package'

Ensure Dekstop Icon File is gone:
  file.absent:
    - name: '/usr/share/applications/google-chrome.desktop'
    - require:
      - pkg: 'Uninstall Chrome Package'


Nuke Chrome DNF repository-definition:
  pkgrepo.absent:
    - name: 'google-chrome'
    - require:
      - pkg: 'Uninstall Chrome Package'

clean_dnf_cache:
  cmd.run:
    - name: dnf clean all
    - onchanges:
      - pkgrepo: 'Nuke Chrome DNF repository-definition'
