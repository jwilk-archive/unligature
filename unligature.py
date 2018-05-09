#!/usr/bin/env python
# encoding=UTF-8

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

from __future__ import print_function

import sys

b''  # Python >= 2.6 is required

class Ligatures(dict):

    def __setattr__(self, key, value):
        if key.startswith('_'):
            dict.__setattr__(self, key)
        self[key] = value

    def __getattr__(self, key):
        return dict.__getitem__(self, key)

def read_unicode_data(fp, categories):
    for line in fp:
        code, name, _, _, _, decomposition, _ = line.split(';', 6)
        if not decomposition:
            continue
        for category, ligature_dict in categories.iteritems():
            if name.startswith(category + ' LIGATURE '):
                needle = unichr(int(code, 16))
                replacement = decomposition.split()
                if replacement[0].startswith('<'):
                    del replacement[0]
                replacement = ''.join(unichr(int(r, 16)) for r in replacement)
                ligature_dict[needle] = replacement
                break
        else:
            if 'LIGATURE' in name:
                print('Warning: U+%(code)s (%(name)s) is not supported' % locals(), file=sys.stderr)

def hex_escape(text):
    text = text.encode('UTF-8')
    return ''.join('\\x%02x' % ord(ch) for ch in text)

def write_code(ligatures):
    print('%option noyywrap')
    print('%{')
    print('#include <stdio.h>')
    for category in ligatures.iterkeys():
        print('#define %s 1' % category)
    # TODO: support for turning on only selected categories
    print('%}')
    print('%%')
    for category, ligatures in ligatures.iteritems():
        for needle, replacement in ligatures.iteritems():
            needle_c = '"%s"' % hex_escape(needle)
            replacement_c = '"%s"' % hex_escape(replacement)
            print('%(needle_c)s fputs(%(category)s ? %(replacement_c)s : %(needle_c)s, yyout);' % locals())
    print('%%')
    print('''\
int main(int argc, char **argv)
{
    yylex();
    return 0;
}
''')


def main():
    ligatures = Ligatures()
    ligatures.arabic = {}
    ligatures.armenian = {}
    ligatures.hebrew = {}
    ligatures.latin = {}
    categories = {
        'ARABIC': ligatures.arabic,
        'ARABIC SMALL HIGH': ligatures.arabic,
        'ARMENIAN SMALL': ligatures.armenian,
        'HEBREW': ligatures.hebrew,
        'LATIN CAPITAL': ligatures.latin,
        'LATIN SMALL': ligatures.latin,
    }
    read_unicode_data(sys.stdin, categories)
    write_code(ligatures)

if __name__ == '__main__':
    main()

# vim:ts=4 sts=4 sw=4 et
