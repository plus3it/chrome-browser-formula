# -*- coding: utf-8 -*-
# vim: ft=sls

{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as chrome with context %}
{%- set repo_dir = '/etc/yum.repos.d' %}
{%- set repo_name = 'google-chrome' %}

Ensure Chrome flags are set for Wayland:
  file.managed:
    - name: /etc/profile.d/chrome_flags.sh
    - contents: |
        # Force Chrome to use native Wayland if available, else fallback to X11
        export GOOGLE_CHROME_FLAGS="--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations"
    - mode: '0644'
    - user: root
    - group: root
    - require:
      - pkg: 'Install Chrome RPM'

Fix Chrome desktop-icon:
  file.replace:
    - name: '/usr/local/share/applications/google-chrome.desktop'
    - pattern: '^Exec=/usr/bin/google-chrome-stable %U'
    - repl: 'Exec=/usr/bin/google-chrome-stable --ozone-platform-hint=auto %U'
    - append_if_not_found: False
    - require:
      - pkg: 'Install Chrome RPM'

Install Chrome RPM:
  pkg.installed:
    - name: '{{ chrome.pkg.release_family }}'

{%- if chrome.pkg.private_repo_def %}
Install custom Chrome repo:
  file.managed:
    - contents: |
        {{ chrome.pkg.private_repo_def | indent(8) }}
    - group: root
    - mode: '0644'
    - name: '{{ repo_dir }}/{{ repo_name }}.repo'
    - require_in:
      - pkg: 'Install Chrome RPM'
    - user: root
{%- else %}
Install standard Chrome repo:
  pkgrepo.managed:
    - baseurl: http://dl.google.com/linux/chrome/rpm/stable/x86_64
    - enabled: 1
    - file: '{{ repo_dir }}/{{ repo_name }}.repo'
    - gpgcheck: 1
    - gpgkey: https://dl.google.com/linux/linux_signing_key.pub
    - name: '{{ repo_name }}'
    - require_in:
      - pkg: 'Install Chrome RPM'
{%- endif %}
