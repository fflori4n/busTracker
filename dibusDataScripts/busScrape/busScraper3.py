#!/usr/bin/python
# -*- coding: utf-8 -*-

import mechanize  #pip install mechanize
import time
#import cookielib
import http.cookiejar as cookielib
import datetime
import re
import smtplib
import sys
from collections import namedtuple
#import RPi.GPIO as GPIO
from datetime import datetime

grd = 'rvg'
days = [ 'R','S','N']
vaziod = '2022-01-04'
smers = ['A','B']
BusLine = namedtuple('BusLine','name link only')	# named tuple, like const class, very cool :)

linije = [
BusLine('1','http://www.gspns.co.rs/red-voznje/ispis-polazaka?rv=##grd##&vaziod=##vaziod##&dan=##dan##&linija[]=##linija##*',''),
BusLine('2','http://www.gspns.co.rs/red-voznje/ispis-polazaka?rv=##grd##&vaziod=##vaziod##&dan=##dan##&linija[]=##linija##.',''),
BusLine('2','http://www.gspns.co.rs/red-voznje/ispis-polazaka?rv=##grd##&vaziod=##vaziod##&dan=##dan##&linija[]=##linija##.',''),
BusLine('3','http://www.gspns.co.rs/red-voznje/ispis-polazaka?rv=##grd##&vaziod=##vaziod##&dan=##dan##&linija[]=##linija##.',''),
BusLine('3A','http://www.gspns.co.rs/red-voznje/ispis-polazaka?rv=##grd##&vaziod=##vaziod##&dan=##dan##&linija[]=##linija##.',''),
BusLine('3B','http://www.gspns.co.rs/red-voznje/ispis-polazaka?rv=##grd##&vaziod=##vaziod##&dan=##dan##&linija[]=##linija##.',''),
BusLine('4','http://www.gspns.co.rs/red-voznje/ispis-polazaka?rv=##grd##&vaziod=##vaziod##&dan=##dan##&linija[]=##linija##*',''),
BusLine('5','http://www.gspns.co.rs/red-voznje/ispis-polazaka?rv=##grd##&vaziod=##vaziod##&dan=##dan##&linija%5B%5D=##linija##',''),
BusLine('6','http://www.gspns.co.rs/red-voznje/ispis-polazaka?rv=##grd##&vaziod=##vaziod##&dan=##dan##&linija%5B%5D=##linija##',''),
BusLine('7A','http://www.gspns.co.rs/red-voznje/ispis-polazaka?rv=##grd##&vaziod=##vaziod##&dan=##dan##&linija%5B%5D=##linija##.','A'),
BusLine('7B','http://www.gspns.co.rs/red-voznje/ispis-polazaka?rv=##grd##&vaziod=##vaziod##&dan=##dan##&linija%5B%5D=##linija##.','B'),
BusLine('8','http://www.gspns.co.rs/red-voznje/ispis-polazaka?rv=##grd##&vaziod=##vaziod##&dan=##dan##&linija%5B%5D=##linija##',''),
BusLine('9','http://www.gspns.co.rs/red-voznje/ispis-polazaka?rv=##grd##&vaziod=##vaziod##&dan=##dan##&linija%5B%5D=##linija##.',''),
BusLine('10','http://www.gspns.co.rs/red-voznje/ispis-polazaka?rv=##grd##&vaziod=##vaziod##&dan=##dan##&linija%5B%5D=##linija##',''),
BusLine('11A','http://www.gspns.co.rs/red-voznje/ispis-polazaka?rv=##grd##&vaziod=##vaziod##&dan=##dan##&linija%5B%5D=##linija##.',''),
BusLine('11B','http://www.gspns.co.rs/red-voznje/ispis-polazaka?rv=##grd##&vaziod=##vaziod##&dan=##dan##&linija%5B%5D=##linija##.',''),

BusLine('12','http://www.gspns.co.rs/red-voznje/ispis-polazaka?rv=##grd##&vaziod=##vaziod##&dan=##dan##&linija%5B%5D=##linija##.',''),
BusLine('13','http://www.gspns.co.rs/red-voznje/ispis-polazaka?rv=##grd##&vaziod=##vaziod##&dan=##dan##&linija%5B%5D=##linija##',''),
BusLine('14','http://www.gspns.co.rs/red-voznje/ispis-polazaka?rv=##grd##&vaziod=##vaziod##&dan=##dan##&linija%5B%5D=##linija##',''),
BusLine('15','http://www.gspns.co.rs/red-voznje/ispis-polazaka?rv=##grd##&vaziod=##vaziod##&dan=##dan##&linija%5B%5D=##linija##',''),
BusLine('16','http://www.gspns.co.rs/red-voznje/ispis-polazaka?rv=##grd##&vaziod=##vaziod##&dan=##dan##&linija%5B%5D=##linija##.',''),
BusLine('17','http://www.gspns.co.rs/red-voznje/ispis-polazaka?rv=##grd##&vaziod=##vaziod##&dan=##dan##&linija%5B%5D=##linija##*',''),
BusLine('18A','http://www.gspns.co.rs/red-voznje/ispis-polazaka?rv=##grd##&vaziod=##vaziod##&dan=##dan##&linija%5B%5D=##linija##','A'),
BusLine('18B','http://www.gspns.co.rs/red-voznje/ispis-polazaka?rv=##grd##&vaziod=##vaziod##&dan=##dan##&linija%5B%5D=##linija##','B'),
# ne postoji linija - BusLine('19','http://www.gspns.co.rs/red-voznje/ispis-polazaka?rv=##grd##&vaziod=##vaziod##&dan=##dan##&linija%5B%5D=##linija##.',''),
BusLine('20','http://www.gspns.co.rs/red-voznje/ispis-polazaka?rv=##grd##&vaziod=##vaziod##&dan=##dan##&linija%5B%5D=##linija##',''),
BusLine('74','http://www.gspns.rs/red-voznje/ispis-polazaka?rv=rvp&vaziod=##vaziod##&dan=##dan##&linija[]=##linija##',''),
BusLine('76','http://www.gspns.rs/red-voznje/ispis-polazaka?rv=rvp&vaziod=##vaziod##&dan=##dan##&linija[]=##linija##',''),
BusLine('72','http://www.gspns.rs/red-voznje/ispis-polazaka?rv=rvp&vaziod=##vaziod##&dan=##dan##&linija[]=##linija##',''),
BusLine('64','http://www.gspns.rs/red-voznje/ispis-polazaka?rv=rvp&vaziod=##vaziod##&dan=##dan##&linija%5B%5D=##linija##.',''),
BusLine('60','http://www.gspns.rs/red-voznje/ispis-polazaka?rv=rvp&vaziod=##vaziod##&dan=##dan##&linija%5B%5D=##linija##.',''),
]

def extractTimes2(html,smer,dan):
	#print html
	outstring = ''

	if 'R' in dan:
		outstring+='>#RAD'
	elif 'S' in dan:
		outstring+='>#SUB'
	elif 'N' in dan:
		outstring+='>#NED'
	else:
		print('[  ER  ] invalid day') 
		return

	if 'A' == smer:
		html = html[html.find('<!--smer A-->') + len('<!--smer A-->'):html.find('<!--smer B-->')]
	elif 'B' == smer:
		html = html[html.find('<!--smer B-->') + len('<!--smer B-->'):html.find('<!--komentar-->')]
	else:
		print ('[  ER  ] invalid smer')
	#print html

	hour = 0
	mins = 0
	isRamp = False

	for line in html.split('\n'):
		if line.strip() == '':
			continue
		if 'rampa' in line or 'niskopodni' in line:
			isRamp = True
		else:
			isRamp = False

		line = re.sub('<niskopodni-rampa>','',line)
		hourstr = line[:line.find('<-')]
		hourstr = re.sub("[^0-9]", "", hourstr)
		minstr = line[line.find('<-') + 2:line.find('->')]
		minstr = re.sub("[^0-9]", "", minstr)

		#print hourstr,' ', minstr
	
		if len(hourstr)>0:
			outstring += '\n' + hourstr.strip()
		if len(minstr)>0:
			if isRamp:
				outstring += ' ' + minstr.strip() + 'R'
			else:
				outstring += ' ' + minstr.strip()
	return outstring

def stripHTML(html):
	html = re.sub("\t", "", html)
	#html = re.sub("\n", "", html)
	#html = re.sub(" ", "", html)

	html = re.sub("(?s)</div>", "", html)
	html = re.sub("(?s)<div(?: [^>]*)?>", "", html)

	html = re.sub("(?s)</td>", "", html)
	html = re.sub("(?s)<td(?: [^>]*)?>", "", html)

	html = re.sub("(?s)</tr>", "", html)
	html = re.sub("(?s)<tr(?: [^>]*)?>", "", html)

	#print html

	html = re.sub("(?s)</sup>", "\n", html)
	html = re.sub("(?s)<sup(?: [^>]*)?>", "", html)

	html = re.sub("(?s)</br>", "", html)
	html = re.sub("(?s)<br(?: [^>]*)?>", "", html)

	html = re.sub("(?s)</font>", "", html)
	html = re.sub("(?s)<font(?: [^>]*)?>", "", html)

	html = re.sub("(?s)</th>", "", html)
	html = re.sub("(?s)<th(?: [^>]*)?>", "", html)

	html = re.sub("(?s)</table>", "", html)
	html = re.sub("(?s)<table(?: [^>]*)?>", "", html)

	html = re.sub("(?s)</span>", "->", html)
	html = re.sub("(?s)<span class=", "<-<", html)

	html = re.sub("<br/>", "", html)
	html = re.sub("<b>", "", html)
	html = re.sub("</b>", "", html)

	return html
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
	for linija in linije:
		for smer in smers:
			fileString = '# linija ' + linija.name + str(smer) + '\t' + str(vaziod) +'\n'
			for day in days:
				html = ''
				linkstr = linija.link
				linkstr = re.sub("##grd##", "rvg", linkstr)
				linkstr = re.sub("##vaziod##", vaziod, linkstr)
				linkstr = re.sub("##dan##", day, linkstr)
				linkstr = re.sub("##linija##", linija.name, linkstr)
				print(linkstr)
				#try:
				html = br.open(linkstr,timeout=20).read().decode('utf-8')
				#except:
				#	print 'ERROR '
				#	pass
				html = stripHTML(html)
				html = linkstr = re.sub("##dan##", day, html)
				#print html
				#print linkstr

				outString = extractTimes2(html, smer, day)
				#print outString
				print(outString)
				print('\n')
				fileString = fileString + outString + '\n\n'
				time.sleep(2)
			with open( "busScrapeOut/" + linija.name + str(smer) + ".txt",'a+') as f:#
				f.write(fileString)
			print('file write completed. ') 
				
  
if __name__== "__main__":
  main()




#http://www.gspns.co.rs/red-voznje/ispis-polazaka?rv=rvg&vaziod=2020-11-09&dan=R&linija%5B%5D=111A*
#http://www.gspns.rs/red-voznje/ispis-polazaka?rv=rvg&vaziod=2020-11-09&dan=R&linija[]=111A.
#http://www.gspns.rs/red-voznje/ispis-polazaka?rv=rvg&vaziod=2020-11-09&dan=R&linija%5B%5D=11A.

