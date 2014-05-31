#!/usr/bin/env python2
from optparse import OptionParser

import os.path
import os
import json
import parsers

osparser = OptionParser(usage='usage: %prog [options]')
osparser.add_option('-a', '--author', dest='author', default=None,
                  help='Specify author to prepare data.')
osparser.add_option('-d', '--data', dest='data_dir', default='../data/',
				  help='Specify data directory (default: ../data/)')
osparser.add_option('-w', '--wiki', dest='wiki_url',
				  help='Specify wiki URL')
osparser.add_option('-p', '--parser', dest='parser', default='brugel',
				  help='Specify parser. Default is \'brugel\'. Valid parsers are: ' + ', '.join(parsers.TYPES))

(options, args) = osparser.parse_args()

if options.parser not in parsers.TYPES:
	print 'Parser is not valid. Type -h for help.'
	exit(1)

if not options.author or not options.wiki_url:
	print 'Specify author and/or wiki url. Type -h for help.'
	exit(1)

author_path = os.path.join(options.data_dir, options.author)

if not os.path.exists(author_path):
	os.mkdir(author_path)

works = parsers.parse(options)
	
author = None
print 'Works processed:', len(works)

def year(something):
	return "".join(s for s in something.split() if s.isdigit())

with file(author_path + '.json', 'r') as fd:
	author = json.loads(fd.read())
	author['works'] = sorted(works, key=lambda x: year(x.get('year', '3000')))
if author is None:
	print 'No author data'
	exit(1)
with file(author_path + '.json', 'w') as fd:
	fd.write(json.dumps(author, sort_keys=True,
						indent=4, separators=(',', ': ')))
exit(0)
