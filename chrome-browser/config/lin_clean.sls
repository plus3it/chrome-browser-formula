# -*- coding: utf-8 -*-
# vim: ft=sls

{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as chrome with context %}
{%- set repo_dir = '/etc/yum.repos.d' %}
{%- set repo_name = 'google-chrome' %}

Ensure Chrome flags for Wayland are removed:
  file.absent:
    - name: /etc/profile.d/chrome_flags.sh

Remove Chrome desktop-icon customizations are removed:
  file.absent:
    - name: '/usr/local/share/applications/google-chrome.desktop'

Remove custom Chrome repo:
  file.absent:
    - name: '{{ repo_dir }}/{{ repo_name }}.repo'
