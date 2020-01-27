# Copyright © 2010-2020 Jakub Wilk <jwilk@jwilk.net>
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

UNICODE_DATA = $(firstword $(wildcard /usr/share/unicode/UnicodeData.txt /usr/share/unicode/ucd/UnicodeData.txt) UnicodeData.txt)

PYTHON = python
CFLAGS = -Wall -O2 -g

PREFIX = /usr/local
DESTDIR =

bindir = $(PREFIX)/bin

.PHONY: all
all: unligature

.PHONY: install
install: unligature
	install -d $(DESTDIR)$(bindir)
	install -m755 $(<) $(DESTDIR)$(bindir)/$(<)

unligature.l: unligature.py $(UNICODE_DATA)
	$(PYTHON) $(<) < $(UNICODE_DATA) > $(@)

.PHONY: test
test: unligature
	prove -v

.PHONY: test-installed
test-installed: $(or $(shell command -v unligature;),$(bindir)/unligature)
	UNLIGATURE_TEST_TARGET=unligature prove -v

.PHONY: clean
clean:
	rm -f unligature unligature.l unligature.c *.py[co]

.error = GNU make is required

# vim:ts=4 sts=4 sw=4 noet
