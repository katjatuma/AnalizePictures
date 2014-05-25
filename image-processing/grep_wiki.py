#!/usr/bin/python
from optparse import OptionParser
from pyquery import PyQuery as pq
import urllib
import os.path
import os
import json

parser = OptionParser(usage='usage: %prog [options]')
parser.add_option('-a', '--author', dest='author', default=None,
                  help='Specify author to prepare data.')
parser.add_option('-d', '--data', dest='data_dir', default='../data/',
				  help='Specify data directory (default: ../data/)')
parser.add_option('-w', '--wiki', dest='wiki_url',
				  help='Specify wiki URL')

(options, args) = parser.parse_args()

if not options.author or not options.wiki_url:
	print 'Specify author and/or wiki url. Type -h for help.'
	exit(1)

works = []
author_path = os.path.join(options.data_dir, options.author)

if not os.path.exists(author_path):
	os.mkdir(author_path)

def download_image(url, name):
	ext = url.split('.')[-1]
	fname = name + '.' + ext
	fpath = os.path.join(author_path, fname)
	try:
		if not os.path.exists(fpath):
			urllib.urlretrieve(url, fpath)
		return fname
	except Exception, e:
		print e
	return None

d = pq(options.wiki_url)
for rows in d('.wikitable tr'):
	tr = pq(rows)
	cells = tr('td')
	if not cells:
		continue
	title = cells[1].text
	if not title:
		title = pq(cells[1])('a').text()
	pid = title.replace(' ', '_').replace(')', '').replace('(','-')
	paintings = {
		'title': title,
		'id': pid,
		'year': cells[2].text,
		'teh': cells[3].text,
		'small': False,
		'large': False
	}
	#print paintings
	# image
	img_url_small = tr('td:first img').attr('src')
	if img_url_small:
		paintings['small'] = download_image('http:' + img_url_small,
											pid + '__small')
	img_wiki_url = 'http://en.wikipedia.org' + tr('td:first a').attr('href')

	image_page = pq(img_wiki_url)
	img_url_large = image_page('.fullImageLink img').attr('src')
	if img_url_large:
		paintings['large'] = download_image('http:' + img_url_large,
											pid + '__large')
	
	works.append(paintings)

author = None
print 'Works processed:', len(works)
with file(author_path + '.json', 'r') as fd:
	author = json.loads(fd.read())
	author['works'] = sorted(works, key=lambda x: x.get('year', '3000'))
if author is None:
	print 'No author data'
	exit(1)
with file(author_path + '.json', 'w') as fd:
	fd.write(json.dumps(author, sort_keys=True,
						indent=4, separators=(',', ': ')))
exit(0)
