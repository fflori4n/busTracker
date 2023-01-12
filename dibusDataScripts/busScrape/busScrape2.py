#!/usr/bin/python
# -*- coding: utf-8 -*-

import mechanize  #pip install mechanize
import time
import cookielib
import datetime
import re
import smtplib
#import RPi.GPIO as GPIO
from datetime import datetime

#smer = 'A' # smer A ili B
grd = 'rvg'
days = [ 'R','S','N']
vaziod = '2020-09-29'
#linija = '9'
linije = ['12','3A','3B']
#linije = ['2','3','4','5','6','7','8','9','10','11','12','13','14','15','16','17','18B','18A','20']
smers = ['A','B']

links = [
'http://www.gspns.co.rs/red-voznje/ispis-polazaka?rv=rvg&vaziod=2020-09-04&dan=R&linija%5B%5D=1*',
'http://www.gspns.co.rs/red-voznje/ispis-polazaka?rv=rvg&vaziod=2020-09-04&dan=R&linija%5B%5D=2.',
'http://www.gspns.co.rs/red-voznje/ispis-polazaka?rv=rvg&vaziod=2020-09-04&dan=R&linija%5B%5D=3.',
'http://www.gspns.co.rs/red-voznje/ispis-polazaka?rv=rvg&vaziod=2020-09-04&dan=R&linija%5B%5D=3A.',
'http://www.gspns.co.rs/red-voznje/ispis-polazaka?rv=rvg&vaziod=2020-09-04&dan=R&linija%5B%5D=3B.',
'http://www.gspns.co.rs/red-voznje/ispis-polazaka?rv=rvg&vaziod=2020-09-04&dan=R&linija%5B%5D=4*',
]

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


def extractTimes(html,smer,dan):
	#print html
	outstring = ''

	if 'R' in dan:
		outstring+='>#RAD'
	elif 'S' in dan:
		outstring+='>#SUB'
	elif 'N' in dan:
		outstring+='>#NED'
	else:
		print '[  ER  ] invalid day'
		return

	if 'A' == smer:
		html = html[html.find('<!--smer A-->') + len('<!--smer A-->'):html.find('<!--smer B-->')]
	elif 'B' == smer:
		html = html[html.find('<!--smer B-->') + len('<!--smer B-->'):html.find('<!--komentar-->')]
	else:
		print '[  ER  ] invalid smer'
	#print html

	hour = 0
	mins = 0
	isRamp = False

	for line in html.split('\n'):
		if line.strip() == '':
			continue
		if 'rampa' in line:
			isRamp = True
		else:
			isRamp = False

		hourstr = line[:line.find('<-')]
		hourstr = re.sub("[^0-9]", "", hourstr)
		minstr = line[line.find('<-') + 2:line.find('->')]
		minstr = re.sub("[^0-9]", "", minstr)
	
		if len(hourstr)>0:
			outstring += '\n' + hourstr.strip()
		if len(minstr)>0:
			if isRamp:
				outstring += ' ' + minstr.strip() + 'R'
			else:
				outstring += ' ' + minstr.strip()
	return outstring
	


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
			fileString = '># linija ' + str(linija) + str(smer) + '\t' + str(vaziod) +'\n'
			for day in days:
				html = ''
				html2 = ''
				try:
					html = br.open('http://www.gspns.rs/red-voznje/ispis-polazaka?rv='+grd+'&%20vaziod='+vaziod+'%20&dan='+day+'%20&linija[]='+linija +'.',timeout=20).read()
				except:
					pass
				try:
					html2 = br.open('http://www.gspns.rs/red-voznje/ispis-polazaka?rv='+grd+'&%20vaziod='+vaziod+'%20&dan='+day+'%20&linija[]='+linija +'*',timeout=20).read()
				except:
					pass
				html = stripHTML(html)
				outString = extractTimes(html, smer, day)
				outString2 = extractTimes(html2, smer, day)
				if(outString2 > outString):
					outString = outString2
				print outString
				print '\n'
				fileString = fileString + outString + '\n\n'
				time.sleep(2)
			with open("busScrapeOut/" + str(linija) + str(smer) + ".txt",'w') as f:
				f.write(fileString)
  
if __name__== "__main__":
  main()

