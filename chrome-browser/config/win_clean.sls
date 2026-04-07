# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- set policy_path = 'C:/Windows/PolicyDefinitions' %}
{%- set hklm_root = 'HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Google\Chrome' %}

Remove Chrome ADML:
  file.absent:
    - name: '{{ policy_path }}/en-US/chrome.adml'

Remove Chrome ADMX:
  file.absent:
    - name: '{{ policy_path }}/chrome.admx'

Remove Chrome Policy Registry Keys:
  reg.absent:
    - name: '{{ hklm_root }}'

Remove Chrome Update Registry Keys:
  reg.absent:
    - name: '{{ hklm_root | replace('\\Chrome', '\\Update') }}'

Remove Google ADMX:
  file.absent:
    - name: '{{ policy_path }}/google.admx'
