p = unligature

UNICODE_DATA = /usr/share/unicode/UnicodeData.txt

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

.PHONY: clean
clean:
	rm -f $(p) $(p).l $(p).c $(p).py[co]

$(p).l: $(p).py $(UNICODE_DATA)
	python $(<) < $(UNICODE_DATA) > $(@)

# vim:ts=4 sts=4 sw=4 noet
