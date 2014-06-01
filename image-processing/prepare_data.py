#!/usr/bin/env python2
from optparse import OptionParser
from pprint import pprint
import json

import os.path
import colorsys
import numpy as np
from PIL import Image

HUE_RANGE = 12
GRAY_RANGE = 6
GRAY_MSE_THRESHOLD = 20

parser = OptionParser(usage='usage: %prog [options] [work1 [work2 ... ]]')
parser.add_option('-a', '--author', dest='author', default=None,
				  help='Specify author to prepare data.')
parser.add_option('-d', '--data', dest='data_dir', default='../data/',
				  help='Specify data directory (default: ../data/)')
parser.add_option('-s', '--simulation', dest='simulation', default=False,
				  action='store_true',
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
step = len(author['works']) / 10

for work_i, work in enumerate(author['works']):
	fjson = os.path.join(author_work_dir, work['id'] + '.json')

	img_small = work['small'] and os.path.join(author_work_dir, work['small'])
	img_large = work['large'] and os.path.join(author_work_dir, work['large'])

	img_data = {}
	
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

		
		img_data['maxRGB'] = max(max(img_data[ch]) for ch in ('r', 'g', 'b'))
		
		img_data['huehist'] = {}
		img_data['grayhist'] = {}
		for _, col in colors:
			col_ary = np.array(col)
			dummy_gray = col_ary.mean()
			if np.sqrt(np.sum((col_ary - dummy_gray)**2)) < GRAY_MSE_THRESHOLD:
				# is gray
				key = int(round((dummy_gray/255.)*(GRAY_RANGE - 1)))
				if key not in img_data['grayhist']:
					img_data['grayhist'][key] = 0
				img_data['grayhist'][key] += 1
			else:
				hsv = colorsys.rgb_to_hsv(*(np.array(col)/255.))
				key = int(round(hsv[0]*(HUE_RANGE-1)))
				if key > HUE_RANGE:
					key = 0
				if key not in img_data['huehist']:
					img_data['huehist'][key] = 0
				img_data['huehist'][key] += 1
		img_data['maxHG'] = max(
			max(img_data['huehist'].values()),
			max(img_data['grayhist'].values())
		)
			
	if not options.simulation:
		with file(fjson, 'w') as fd:
			fd.write(json.dumps(img_data))
	else:
		print work['title']
		pprint(img_data['huehist'])
		pprint(img_data['grayhist'])


	if (work_i+1) % step == 0 and not options.simulation:
		print "#",
if not options.simulation:
	print "# DONE"
exit(0)

