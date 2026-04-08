# -*- coding: utf-8 -*-
# vim: ft=sls
{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as chrome with context %}
{%- set hklm_root = 'HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Active Setup\Installed Components' %}

Re-enable IE ESC for Administrators:
  reg.present:
    - name: '{{ hklm_root }}\{A509B1A7-37EF-4b3f-8CFC-4F3A74704073}'
    - vname: IsInstalled
    - vtype: REG_DWORD
    - vdata: 1
    - require:
      - cmd: 'Install Google Chrome EXE'
      - cmd: 'Revert IE ESC to Original States'

Re-enable IE ESC for Users:
  reg.present:
    - name: '{{ hklm_root }}\{A509B1A8-37EF-4b3f-8CFC-4F3A74704073}'
    - vname: IsInstalled
    - vtype: REG_DWORD
    - vdata: 1
    - require:
      - cmd: 'Install Google Chrome EXE'
      - cmd: 'Revert IE ESC to Original States'

Revert IE ESC to Original States:
  cmd.run:
    - name: |
        $s = (Get-Content 'C:/Windows/Temp/ie_esc_original_state.txt').Split(',')
        if ($s[0] -eq "1") { Set-ItemProperty '{{ hklm_root }}\{A509B1A7-37EF-4b3f-8CFC-4F3A74704073}' IsInstalled 1 }
        if ($s[1] -eq "1") { Set-ItemProperty '{{ hklm_root }}\{A509B1A8-37EF-4b3f-8CFC-4F3A74704073}' IsInstalled 1 }
        Remove-Item 'C:/Windows/Temp/ie_esc_original_state.txt'
    - shell: powershell
    - onlyif: Test-Path 'C:/Windows/Temp/ie_esc_original_state.txt'
    - require:
      - cmd: 'Install Google Chrome EXE'
