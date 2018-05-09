# Copyright © 2010-2018 Jakub Wilk <jwilk@jwilk.net>
#
# This file is part of unligature.
#
# unligature is free software; you can redistribute it and/or modify it under
# the terms of the GNU General Public License version 2 as published by the
# Free Software Foundation.
#
# unligature is distributed in the hope that it will be useful, but WITHOUT ANY
# WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
# FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more
# details.

UNICODE_DATA = /usr/share/unicode/UnicodeData.txt

PYTHON = python
CC = gcc
CFLAGS = -Wall -O2 -g

PREFIX = /usr/local
DESTDIR =

.PHONY: all
all: unligature

.PHONY: install
install: unligature
	install -d $(DESTDIR)$(PREFIX)/bin
	install -m755 $(<) $(DESTDIR)$(PREFIX)/bin/$(<)

unligature.l: unligature.py $(UNICODE_DATA)
	$(PYTHON) $(<) < $(UNICODE_DATA) > $(@)

.PHONY: clean
clean:
	rm -f unligature unligature.l unligature.c *.py[co]

# vim:ts=4 sts=4 sw=4 noet
