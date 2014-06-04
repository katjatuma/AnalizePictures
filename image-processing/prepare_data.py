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
GRAY_BORDER = 0.1
MAIN_COLORS = 4
COLOR_SIMILARITY = 15.
COLOR_SIMILARITY_CNT_MIN = 30

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
	
for work_i, work in enumerate(author['works']):
	fjson = os.path.join(author_work_dir, work['id'] + '.json')

	img_small = work['small'] and os.path.join(author_work_dir, work['small'])
	img_large = work['large'] and os.path.join(author_work_dir, work['large'])

	img_data = {}
	print work_i, work['title'], 'counts:', 
	if img_large:
		im = Image.open(img_large)	
		w, h = im.size
		
		colors = list(im.getcolors(w*h))
		mains = {}

		for cnt, col in sorted(colors, reverse=True):
			if cnt > COLOR_SIMILARITY_CNT_MIN:
				for mcol in mains:
					if color_distance(np.array(col), np.array(mcol)) < COLOR_SIMILARITY:
						break
				else:
					mains[col] = 0
			if len(mains) > 20*MAIN_COLORS:
				break
		print len(colors), len(mains)
		
		img_data['huehist'] = {}
		img_data['grayhist'] = {}
		img_data['valhist'] = {}
		for cnt, col in colors:
			rgb_ary = np.array(col)
			hsv = colorsys.rgb_to_hsv(*(np.array(col)/255.))
			hsv_ary = np.array(hsv)

			vkey = int(round(hsv[2]*255))
			if vkey not in img_data['valhist']:
				img_data['valhist'][vkey] = 0
			img_data['valhist'][vkey] += cnt
			
			is_gray = hsv[1] < 0.1

			# if gray, hsv[1] is 0 and hsv[2] shows how much
			
			most_similar = list(sorted(
				(color_distance(np.array(mc), rgb_ary), mc)
				for mc in mains.keys()))[0]

			if most_similar[0] < COLOR_SIMILARITY:
				mains[most_similar[1]] += cnt
			
			if is_gray:
				key = int(round(hsv[2])*(GRAY_RANGE - 1))
				if key not in img_data['grayhist']:
					img_data['grayhist'][key] = 0
				img_data['grayhist'][key] += cnt
			else:
				key = int(round(hsv[0]*(HUE_RANGE-1)))
				if key > HUE_RANGE:
					key = 0
				if key not in img_data['huehist']:
					img_data['huehist'][key] = 0
				img_data['huehist'][key] += cnt
		img_data['maxV'] = max(img_data['valhist'].values())
		img_data['maxHG'] = max(
			max(img_data['huehist'].values()),
			max(img_data['grayhist'].values())
		)
		mains = sorted([(cnt, col) for col, cnt in mains.iteritems()],
					   reverse=True)[:MAIN_COLORS]
		max_main = float(sum(m[0] for m in mains))
		img_data['maxMain'] = max_main
		img_data['colors'] = [
			[col, cnt, cnt/max_main] for cnt, col in mains
		]
			
	if not options.simulation:
		with file(fjson, 'w') as fd:
			fd.write(json.dumps(img_data))
	else:
		pprint(img_data['huehist'])
		pprint(img_data['grayhist'])


exit(0)

