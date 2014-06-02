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
MAIN_COLORS = 4
COLOR_SIMILARITY = 10

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

def color_distance(c1, c2):
	return np.sqrt(sum((c1-c2)**2))
	
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
		mains = {
			col: 0
			for _, col in sorted(colors, reverse=True)[:(4*MAIN_COLORS)]
		}

		img_data['huehist'] = {}
		img_data['grayhist'] = {}
		for cnt, col in colors:
			col_ary = np.array(col)
			hsv = colorsys.rgb_to_hsv(*(np.array(col)/255.))
			dummy_gray = col_ary.mean()
			is_gray1 = np.sqrt(np.sum((col_ary - dummy_gray)**2)) < GRAY_MSE_THRESHOLD
			is_gray2 = hsv[1] < 0.5

			most_similar = list(sorted(
				(color_distance(np.array(mc), col_ary), mc)
				for mc in mains.keys()))[0]
			if most_similar[0] < COLOR_SIMILARITY:
				mains[most_similar[1]] += cnt
			
			if is_gray2:
				# is gray
				key = int(round((dummy_gray/255.)*(GRAY_RANGE - 1)))
				if key not in img_data['grayhist']:
					img_data['grayhist'][key] = 0
				img_data['grayhist'][key] += 1
			else:
				key = int(round(hsv[0]*(HUE_RANGE-1)))
				if key > HUE_RANGE:
					key = 0
				if key not in img_data['huehist']:
					img_data['huehist'][key] = 0
				img_data['huehist'][key] += cnt
		img_data['maxHG'] = max(
			max(img_data['huehist'].values()),
			max(img_data['grayhist'].values())
		)
		mains = sorted([(cnt, col) for col, cnt in mains.iteritems()],
					   reverse=True)[:MAIN_COLORS]
		max_main = float(sum(m[0] for m in mains))
		img_data['colors'] = [
			[col, cnt, cnt/max_main] for cnt, col in mains
		]
			
	if not options.simulation:
		with file(fjson, 'w') as fd:
			fd.write(json.dumps(img_data))
	else:
		print work['title']
		pprint(img_data['huehist'])
		pprint(img_data['grayhist'])


	if (work_i+1) % step == 0 and not options.simulation:
		print "#"
if not options.simulation:
	print "# DONE"
exit(0)

