#!/bin/env python2
from optparse import OptionParser
import json
import os.path

SUPPORTED_FILE_TYPES = ('jpg', 'png', )

parser = OptionParser()
parser.add_option('-a', '--author', dest='author', default=None,
                  help='Specify author to prepare data.')
parser.add_option('-d', '--data', dest='data_dir', default='../data/',
				  help='Specify data directory (default: ../data/)')
(options, args) = parser.parse_args()
if not options.author:
	print 'Nothing to do. You have to type author id. Type -h or --help for help.'
	exit(0)

author_manifest = os.path.join(options.data_dir, options.author + '.json')
author_work_dir = os.path.join(options.data_dir, options.author)
author = None
with file(author_manifest, 'r') as fd:
	author = json.loads(fd.read())

if not author:
	print 'Author doesn\'t exist'
	exit(1)

for work in author['work']:
	fname = os.path.join(author_work_dir, work['id'])
	for ftype in SUPPORTED_FILE_TYPES:
		if os.path.exists(fname + '.' + ftype):
			fimg = fname + '.' + ftype
			fjson = fname + '.json'
			break
	else:
		print 'Manifest has non-existing work specified'
		exit(1)

	img_data = {}
	# TODO: process image data

	with file(fjson, 'w') as fd:
		fd.write(json.dumps(img_data))
exit(0)
