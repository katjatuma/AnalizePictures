#!/usr/bin/python
from optparse import OptionParser
import json
import os.path
from PIL import Image

SUPPORTED_FILE_TYPES = ('jpg', 'png', )

parser = OptionParser(usage='usage: %prog [options] [work1 [work2 ... ]]')
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

def hexencode(rgb):
	return '#%02x%02x%02x' % rgb

for work in author['works']:
	fjson = os.path.join(author_work_dir, work['id'] + '.json')

	img_small = work['small'] and os.path.join(author_work_dir, work['small'])
	img_large = work['large'] and os.path.join(author_work_dir, work['large'])

	img_data = {}
	# TODO: process image data
	if img_large:
		im = Image.open(img_large)	
		w, h = im.size
		
		colors = list(im.getcolors(w*h))
		img_data['colors'] = []
		img_data['r'] = []
		img_data['g'] = []
		img_data['b'] = []
		channels = [{}, {}, {}]

		for col in colors:
			#im g_data['colors'].append([
			# 	col[0], col[1], hexencode(col[1])
			# ])
			for i in range(3):
				count = 1
				if col[1][i] in channels[i]:
					count += channels[i][col[1][i]]
				channels[i][col[1][i]] = count
		for j in range(3):
			for i in range(256):
				if i not in channels[j]:
					channels[j][i] = 0
		img_data['r'] = [val for _, val in sorted(channels[0].items())]
		img_data['g'] = [val for _, val in sorted(channels[1].items())]
		img_data['b'] = [val for _, val in sorted(channels[2].items())]
	
	with file(fjson, 'w') as fd:
		fd.write(json.dumps(img_data))
exit(0)

