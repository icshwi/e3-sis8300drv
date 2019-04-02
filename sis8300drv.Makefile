#
#  Copyright (c) 2018 - Present  European Spallation Source ERIC
#
#  The program is free software: you can redistribute
#  it and/or modify it under the terms of the GNU General Public License
#  as published by the Free Software Foundation, either version 2 of the
#  License, or any newer version.
#
#  This program is distributed in the hope that it will be useful, but WITHOUT
#  ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
#  FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
#  more details.
#
#  You should have received a copy of the GNU General Public License along with
#  this program. If not, see https://www.gnu.org/licenses/gpl-2.0.txt
#
# 
# Author  : joaopaulomartins
#           Jeong Han Lee
# email   : joaopaulomartins@esss.se
#           jeonghan.lee@gmail.com
# Date    : Tuesday, September 11 13:47:34 CEST 2018
# version : 0.0.1
#

where_am_I := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))
include $(E3_REQUIRE_TOOLS)/driver.makefile
include $(E3_REQUIRE_CONFIG)/DECOUPLE_FLAGS

APP:=src/main/c
APPLIB:=$(APP)/lib
APPINC:=$(APP)/include
APPTOOL:=$(APP)/tools


USR_INCLUDES += -I$(where_am_I)$(APPINC)


SOURCES += $(APPLIB)/sis8300drv.c
SOURCES += $(APPLIB)/sis8300drv_utils.c
SOURCES += $(APPLIB)/sis8300drv_rtm.c
SOURCES += $(APPLIB)/sis8300drv_flash.c
SOURCES += $(APPLIB)/sis8300drv_ad9510.c 

HEADERS += $(APPLIB)/sis8300drv_list.h
HEADERS += $(APPLIB)/sis8300drv_utils.h
HEADERS += $(APPLIB)/sis8300drv_rtm.h
HEADERS += $(APPLIB)/sis8300drv_flash.h
HEADERS += $(APPLIB)/sis8300drv_ad9510.h

HEADERS += $(APPINC)/sis8300_defs.h
HEADERS += $(APPINC)/sis8300drv.h
HEADERS += $(APPINC)/sis8300_reg.h


BINS += $(wildcard $(APP)/sis8300drv_*_$(LIBVERSION))

USR_LIBS += udev

# BINS += $(wildcard $(IOCADMINDB)/*.substitutions)

## This RULE should be used in case of inflating DB files 
## db rule is the default in RULES_DB, so add the empty one
## Please look at e3-mrfioc2 for example.

db: 

.PHONY: db 
#
.PHONY: vlibs
vlibs:
#
