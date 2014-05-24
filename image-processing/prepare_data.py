#!/bin/env python2
from optparse import OptionParser
import json
import os.path

parser = OptionParser()
parser.add_option('-a', '--author', dest='author', default=None,
                  help='Specify author to prepare data.')
parser.add_option('-d', '--data', dest='data_dir', default='../data/',
				  help='Specify data directory (default: ../data/)')
(options, args) = parser.parse_args()
if not options.author:
	print 'Nothing to do. You have to type author id. Type -h or --help for help.'
	exit(0)

author_fname = os.path.join(options.data_dir, options.author + '.json')
author = None
with file(author_fname, 'r') as fd:
	author = json.loads(fd.read())

if not author:
	print 'Author doesn\'t exist'
	exit(1)

for work in author['work']:
	# do something with the pictures
	pass
