import os.path
from pyquery import PyQuery as pq
import urllib

def download_image(url, name, path):
	ext = url.split('.')[-1]
	fname = name + '.' + ext
	fpath = os.path.join(path, fname)
	try:
		if not os.path.exists(fpath):
			urllib.urlretrieve(url, fpath)
		return fname
	except Exception, e:
		print e
	return None

def parse_picasso(options):
	data_path = os.path.join(options.data_dir, options.author)
	works = []
	
	d = pq(options.wiki_url)
	dTable = d('table.img_grid')
	for elt in d(dTable[0])('a'):
		img_url = elt.get('href')
		meta = elt.get('title').split(', ')
		title = meta[0]
		if len(title.split(' - ')) > 1:
			title = title.split(' - ')[0]
		year = meta[1].split(' - ')[0] if len(meta) > 1 else '3000'
		pid = title.replace(' ', '_').replace(')', '').replace('(','-')
		paintings = {
			'title': title,
			'id': pid,
			'year': year,
			'tech': '',
			'small': False,
			'large': download_image('http://www.pablopicasso.org' + img_url,
									pid + '__large', data_path)
		}
		works.append(paintings)
	return works
	
def parse_brugel(options):
	data_path = os.path.join(options.data_dir, options.author)
	works = []

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
			'title': title.strip(),
			'id': pid,
			'year': cells[2].text.strip(),
			'teh': cells[3].text.strip(),
			'small': False,
			'large': False
		}
		#print paintings
		# image
		img_url_small = tr('td:first img').attr('src')
		if img_url_small:
			paintings['small'] = download_image('http:' + img_url_small,
												pid + '__small', data_path)
		img_wiki_url = 'http://en.wikipedia.org' + tr('td:first a').attr('href')
	
		image_page = pq(img_wiki_url)
		img_url_large = image_page('.fullImageLink img').attr('src')
		if img_url_large:
			paintings['large'] = download_image('http:' + img_url_large,
												pid + '__large', data_path)
		
		works.append(paintings)
	return works

parsers = {
	'brugel': parse_brugel,
	'picasso': parse_picasso,
}
def parse(options):
	return parsers[options.parser](options)
TYPES = parsers.keys()

