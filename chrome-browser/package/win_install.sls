# -*- coding: utf-8 -*-
# vim: ft=sls
{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as chrome_browser with context %}
{%- set versions = chrome_browser.winrepo.versions %}

Install Chrome:
  pkg.installed:
    # Use the ACTUAL Windows Display Name
    - name: 'Google Chrome'
    {%- for version, params in versions.items() %}
    {%- if loop.first %}
    - version: {{ chrome_browser.pkg.version }}
    - source: '{{ params.installer }}'
    {%- endif %}
    {%- endfor %}
    - installer_hashes: {{ chrome_browser.pkg.installer_hashes | default('') }}
    # Tell Salt to ignore the Winrepo database and use the source provided
    - skip_verify: True
