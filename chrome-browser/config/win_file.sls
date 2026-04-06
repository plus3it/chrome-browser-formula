{% set policy_path = 'C:/Windows/PolicyDefinitions' %}
{% set source_root = 'C:/Windows/Temp/Chrome/full_extract/windows/admx' %}
{% set ChromeTmp = 'C:/Windows/Temp/Chrome' %}

{% set chrome_files = {
    'google_admx': {'src': source_root ~ '/google.admx', 'dest': policy_path ~ '/google.admx'},
    'chrome_admx': {'src': source_root ~ '/chrome.admx', 'dest': policy_path ~ '/chrome.admx'},
    'chrome_adml': {'src': source_root ~ '/en-US/chrome.adml', 'dest': policy_path ~ '/en-US/chrome.adml'}
  }
%}

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

{% for id, paths in chrome_files.items() %}
Deploy file {{ id }}:
  file.copy:
    - name: '{{ paths.dest }}'
    - source: '{{ paths.src }}'
    - force: True
    - makedirs: True
    - require:
      - archive: 'Extract Chrome Bundle'
{% endfor %}

Cleanup Chrome Temp Directory:
  file.absent:
    - name: '{{ ChromeTmp }}/full_extract'
    - require:
{% for id in chrome_files.keys() %}
      - file: 'Deploy file {{ id }}'
{% endfor %}
