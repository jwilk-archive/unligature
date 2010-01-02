p = unligature

UNICODE_DATA = /usr/share/unicode/UnicodeData.txt

CC = gcc
CFLAGS = -Wall -O2 -g

.PHONY: all
all: unligature

.PHONY: clean
clean:
	rm -f $(p) $(p).l $(p).c $(p).py[co]

$(p).l: $(p).py $(UNICODE_DATA)
	python $(<) < $(UNICODE_DATA) > $(@)

# vim:ts=4 sw=4 noet
