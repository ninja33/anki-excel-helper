# -*- coding: utf-8 -*-
#!/usr/bin/env python

# Copyright (C) 2016  Alex Yatskov <alex@foosoft.net>
# Author: Alex Yatskov <alex@foosoft.net>
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.


import codecs
import json
import optparse
import os.path
import re
from bs4 import BeautifulSoup

PARSED_TAGS = {
    'abbr.',
    'adj.',
    'adv.',
    'comp.',
    'conj.',
    'int.',
    'n.',
    'pref.',
    'vi.',
    'vt.',
    'v.'
}


def load_definitions(path):
    print('Parsing "{0}"...'.format(path))
    with codecs.open(path, encoding='utf-8') as fp:
        return filter(lambda x: x and x[0] != '#', fp.read().splitlines())


def parse_edict(path):
    results = []
    for line in load_definitions(path):
        segments = line.split('\t', 1)

        expression = segments[0]
        
        #reading_match = re.search(r'\[([^\]]+)\]', segments[1])
        #reading = None if reading_match is None else reading_match.group(1)

        defs = []
        tags = []

        soup = BeautifulSoup(segments[1],'lxml')
        def_segments = soup.select('.explanation_box')

        for index, dfn in enumerate(filter(None, def_segments)):
            tags = dfn.select('.explanation_label')[0].getText().strip()
            gloss_cn = dfn.select('.text_blue')[0].getText().strip()
            for span in dfn.select('span'):
                span.extract()
            gloss_en = dfn
            gloss = gloss_cn.join(gloss_en)
            if len(gloss) == 0:
                continue

            if index == 0 > 0:
                defs.append([gloss])
            else:
                defs[-1].append(gloss)

        result = [expression, '', ' '.join(tags)]
        result += map(lambda x: '; '.join(x), defs)

        results.append(result)

    indices = {}
    for i, d in enumerate(results):
        for key in d[:2]:
            if key is not None:
                values = indices.get(key, [])
                values.append(i)
                indices[key] = values

    return {'defs': results, 'indices': indices}


def output_dict_json(output_dir, input_file, parser):
    if input_file is not None:
        base = os.path.splitext(os.path.basename(input_file))[0]
        with open(os.path.join(output_dir, base) + '.json', 'w') as fp:
             json.dump(parser(input_file), fp, separators=(',', ':'))


def build_db_json(dict_dir, edict, enamdict):
    if edict is not None:
        output_dict_json(dict_dir, edict, parse_edict)
    if enamdict is not None:
        output_dict_json(dict_dir, enamdict, parse_edict)


def main():
    parser = optparse.OptionParser()
    parser.add_option('--edict', dest='edict')
    parser.add_option('--enamdict', dest='enamdict')

    options, args = parser.parse_args()

    if len(args) == 1:
        build_db_json(args[0], options.edict, options.enamdict)
    else:
        parser.print_help()

if __name__ == '__main__':
    main()
