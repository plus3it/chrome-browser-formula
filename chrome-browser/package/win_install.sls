# -*- coding: utf-8 -*-
# vim: ft=sls
{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as chrome_browser with context %}

Install Chrome:
 pkg.installed:
   - allow_updates: True
   - name: '{{ chrome_browser.pkg.name }}'
