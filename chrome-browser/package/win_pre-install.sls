# -*- coding: utf-8 -*-
# vim: ft=sls
{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as chrome with context %}
{%- set hklm_root = 'HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Active Setup\Installed Components' %}
{%- set hklm_path = 'SOFTWARE\Microsoft\Active Setup\Installed Components' %}
{%- set salt_reg_root = 'HKEY_LOCAL_MACHINE\' ~ hklm_path %}
{%- set ps_reg_root   = 'HKLM:\' ~ hklm_path %}

Capture Original IE ESC States:
  cmd.run:
    - name: |
        $admin = (Get-ItemProperty '{{ ps_reg_root }}\{A509B1A7-37EF-4b3f-8CFC-4F3A74704073}').IsInstalled
        $user  = (Get-ItemProperty '{{ ps_reg_root }}\{A509B1A8-37EF-4b3f-8CFC-4F3A74704073}').IsInstalled
        "$admin,$user" | Out-File 'C:/Windows/Temp/ie_esc_original_state.txt' -Encoding ascii
    - shell: powershell
    - creates: C:/Windows/Temp/ie_esc_original_state.txt

Disable IE ESC for Administrators:
  reg.present:
    - name: '{{ salt_reg_root }}\\{A509B1A7-37EF-4b3f-8CFC-4F3A74704073}'
    - require:
      - cmd: 'Capture Original IE ESC States'
    - vname: IsInstalled
    - vtype: REG_DWORD
    - vdata: 0

Disable IE ESC for Users:
  reg.present:
    - name: '{{ salt_reg_root }}\\{A509B1A8-37EF-4b3f-8CFC-4F3A74704073}'
    - require:
      - cmd: 'Capture Original IE ESC States'
    - vname: IsInstalled
    - vtype: REG_DWORD
    - vdata: 0
