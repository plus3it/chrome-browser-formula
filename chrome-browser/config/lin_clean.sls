# -*- coding: utf-8 -*-
# vim: ft=sls

{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as chrome with context %}
{%- set repo_name = 'google-chrome' %}

Clean DNF Cache:
  cmd.run:
    - name: dnf clean all
    - onchanges:
      - pkgrepo: 'Nuke Chrome DNF repository-definition'

Ensure Dekstop Icon File is gone:
  file.absent:
    - name: '/usr/local/share/applications/google-chrome.desktop'

Nuke Chrome DNF repository-definition:
  pkgrepo.absent:
    - name: '{{ repo_name }}'

Nuke Watchmaker-installed, Chrome-related /etc/profile.d/ contents:
  file.absent:
    - name: '/etc/profile.d/chrome_flags.sh'
