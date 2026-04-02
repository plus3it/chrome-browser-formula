# -*- coding: utf-8 -*-
# vim: ft=sls

{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as chrome with context %}
{%- set repo_dir = '/etc/yum.repos.d' %}
{%- set repo_name = 'google-chrome' %}

Install Chrome RPM:
  pkg.installed:
    - name: '{{ chrome.pkg.release_family }}'
