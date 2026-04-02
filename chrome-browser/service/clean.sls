# -*- coding: utf-8 -*-
# vim: ft=sls

{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as chrome with context %}

chrome-service-clean-service-dead:
  test.show_notification:
    - text: |-
        ---------------------------------------------
        Chrome has no services to stop or disable
        ---------------------------------------------
