#!/usr/bin/python
# -*- coding: utf-8 -*-

import mechanize  #pip install mechanize
import time
import cookielib
import datetime
import re
import smtplib
import codecs
#import RPi.GPIO as GPIO
from datetime import datetime


lines = ['1','2','3','4','5','6','7','8','9','10','11','12','13','14','15','16','17','18','19','20',]

def stripHTML(html):
	html = html.replace('[','')
	html = html.replace(']','')
	html = html.replace('\/','')
	html = html.replace('\\r','')
	html = html.replace('\\n','')

	html = html.replace('",','\n')
	html = html.replace('"','')

	return html
def parseStationDat(rawHtml):
	lines = rawHtml.split('\n')
	for line in lines:
		try:
			line = line.encode('utf-8').decode('unicode-escape')
		except:
			print '[  Er  ] faulty encoding!: ' + line
			continue
		splitstr = line.split('|')
		if len(splitstr) != 6:
			print '[  ER  ]' + splitstr
			continue
		#print len(splitstr)
		servedLines = splitstr[0]
		lat = splitstr[1]
		lon = splitstr[2]
		name = splitstr[3]
		clas = splitstr[5]
		hsh = hash(lat + lon + servedLines)
		
		try:
			with open('stations.txt') as f:
				if str(hsh) in f.read():
					print 'alredy loged: ' + name
					continue
		except:
			pass

		newStation = name.strip() + '|' + lat.strip() + ',' + lon.strip() + '|' + clas.strip() + '|' + servedLines.strip() + '|' + str(hsh) +'\n'
		#print newStation
		with codecs.open("stations.txt", "a", "utf-8") as myfile:
			myfile.write(newStation)


		
def main():
	br = mechanize.Browser()

	# Browser options
	br.set_handle_equiv(True)
	br.set_handle_gzip(True)
	br.set_handle_redirect(True)
	br.set_handle_referer(True)
	br.set_handle_robots(False)

	# Follows refresh 0 but not hangs on refresh > 0
	br.set_handle_refresh(mechanize._http.HTTPRefreshProcessor(), max_time=1)

	br = mechanize.Browser()
	br.set_handle_robots(False)
	br.addheaders = [("User-agent","Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.13) Gecko/20101206 Ubuntu/10.10 (maverick) Firefox/3.6.13")]

	for line in range(1,112):
		print 'parsing ' + str(line) + '...'
		html = ''
		try:
			html = br.open('http://www.gspns.rs/mreza-get-stajalista-tacke?linija=' + str(line)).read().strip()
		except:
			print 'host unreachable for line no: ' + str(line)
			continue
		html = stripHTML(html)
		parseStationDat(html)
		#print html
		#print html

  
if __name__== "__main__":
  main()

