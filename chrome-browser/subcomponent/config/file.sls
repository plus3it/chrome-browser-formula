# -*- coding: utf-8 -*-
# vim: ft=sls
#
# This file does nothing: Chrome does not have subcomponents that need to be
# configured
#
################################################################################
{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split('/')[0] %}
{%- set sls_config_file = tplroot ~ '.config.file' %}
{%- from tplroot ~ "/map.jinja" import mapdata as chrome with context %}
{%- from tplroot ~ "/libtofs.jinja" import files_switch with context %}

include:
  - {{ sls_config_file }}

