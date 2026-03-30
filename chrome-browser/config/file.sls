# -*- coding: utf-8 -*-
# vim: ft=sls
#
# This file does nothing: this iteration of the chrome browser formula
# contents does not attempt to place any application-configuration files onto
# the installation-target host
#
################################################################################
{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split('/')[0] %}
{%- set sls_package_install = tplroot ~ '.package.install' %}
{%- from tplroot ~ "/map.jinja" import mapdata as chrome with context %}
{%- from tplroot ~ "/libtofs.jinja" import files_switch with context %}

include:
  - {{ sls_package_install }}
