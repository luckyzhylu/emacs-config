## Process this file with automake to create Makefile.in
#
# Copyright (c) 2010 Tama Communications Corporation
#
# This file is free software; as a special exception the author gives
# unlimited permission to copy and/or distribute it, with or without
# modifications, as long as this notice is preserved.
#
# This program is distributed in the hope that it will be useful, but
# WITHOUT ANY WARRANTY, to the extent permitted by law; without even the
# implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
#
plugindir = ${libdir}/gtags
plugin_LTLIBRARIES = exuberant-ctags.la user-custom.la

exuberant_ctags_la_SOURCES = exuberant-ctags.c
exuberant_ctags_la_LDFLAGS = -module -avoid-version

# skeleton
user_custom_la_SOURCES = user-custom.c
user_custom_la_LDFLAGS = -module -avoid-version

AM_CPPFLAGS = @AM_CPPFLAGS@
