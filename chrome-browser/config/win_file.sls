# -*- coding: utf-8 -*-
# vim: ft=sls
#
{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as chrome with context %}

{%- set policy_path = 'C:/Windows/PolicyDefinitions' %}
{%- set source_root = 'C:/Windows/Temp/Chrome/full_extract/windows/admx' %}
{%- set ChromeTmp = 'C:/Windows/Temp/Chrome' %}
{%- set no_update_value = chrome.policy_extras.settings.no_update | string | lower %}
{%- set hklm_root = 'HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Google\Chrome' %}
{%- set chrome_files = {
    'google_admx': {'src': source_root ~ '/google.admx', 'dest': policy_path ~ '/google.admx'},
    'chrome_admx': {'src': source_root ~ '/chrome.admx', 'dest': policy_path ~ '/chrome.admx'},
    'chrome_adml': {'src': source_root ~ '/en-US/chrome.adml', 'dest': policy_path ~ '/en-US/chrome.adml'}
  }
%}

Cleanup Chrome Temp Directory:
  file.absent:
    - name: '{{ ChromeTmp }}'
    - require:
    {%- for id in chrome_files.keys() %}
      - file: 'Deploy file {{ id }}'
    {%- endfor %}

{%- if chrome.policy_extras.settings.home_page %}
Configure Chrome Homepage:
  reg.present:
    - name: '{{ hklm_root }}'
    - vname: 'HomepageLocation'
    - vdata: '{{ chrome.policy_extras.settings.home_page }}'
    - vtype: REG_SZ
    - require:
    {%- for id in chrome_files.keys() %}
      - file: 'Deploy file {{ id }}'
    {%- endfor %}
{%- endif %}

{%- if chrome.policy_extras.settings.managed_bookmarks_enabled | string | lower == 'true' and chrome.policy_extras.settings.managed_bookmarks %}
Configure Managed Bookmarks:
  reg.present:
    - name: '{{ hklm_root }}'
    - vname: 'ManagedBookmarks'
    - vdata: {{ chrome.policy_extras.settings.managed_bookmarks | json }}
    - vtype: REG_SZ
    - require:
    {%- for id in chrome_files.keys() %}
      - file: 'Deploy file {{ id }}'
    {%- endfor %}
{%- endif %}

{%- for id, paths in chrome_files.items() %}
Deploy file {{ id }}:
  file.copy:
    - name: '{{ paths.dest }}'
    - source: '{{ paths.src }}'
    - force: True
    - makedirs: True
    - require:
      - archive: 'Extract Chrome Bundle'
{%- endfor %}

{%- if no_update_value == 'true' %}
Disable Chrome Auto-Update:
  reg.present:
    - name: '{{ hklm_root | replace('\\Chrome', '\\Update') }}'
    - vname: 'UpdateDefault'
    - vdata: 0
    - vtype: REG_DWORD
    - require:
    {%- for id in chrome_files.keys() %}
      - file: 'Deploy file {{ id }}'
    {%- endfor %}
{%- endif %}

{%- if chrome.policy_extras.settings.password_manager_enabled | string | lower == 'false' %}
Disable Chrome Password Manager:
  reg.present:
    - name: '{{ hklm_root }}'
    - vname: 'PasswordManagerEnabled'
    - vdata: 0
    - vtype: REG_DWORD
    - require:
    {%- for id in chrome_files.keys() %}
      - file: 'Deploy file {{ id }}'
    {%- endfor %}
{%- endif %}

Ensure Chrome TempDir Exists:
  file.directory:
    - name: '{{ ChromeTmp }}'
    - makedirs: True

Extract Chrome Bundle:
  archive.extracted:
    - name: '{{ ChromeTmp }}/full_extract'
    - source: 'https://dl.google.com/dl/edgedl/chrome/policy/policy_templates.zip'
    - skip_verify: True
    - enforce_toplevel: False
    - overwrite: True
    - require:
      - file: 'Ensure Chrome TempDir Exists'
