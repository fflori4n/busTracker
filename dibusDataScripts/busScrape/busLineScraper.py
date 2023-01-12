#!/usr/bin/python
# -*- coding: utf-8 -*-

import mechanize  #pip install mechanize
import time
#import cookielib
import datetime
import re
import codecs
import smtplib
#import RPi.GPIO as GPIO
from datetime import datetime


links = [
#'http://www.gspns.co.rs/mreza-get-linija-tacke?linija=1',	#1A
#'http://www.gspns.co.rs/mreza-get-linija-tacke?linija=2',	#1B
#'http://www.gspns.co.rs/mreza-get-linija-tacke?linija=232',	#1ZA
#'http://www.gspns.co.rs/mreza-get-linija-tacke?linija=233',	#1ZB
#'http://www.gspns.co.rs/mreza-get-linija-tacke?linija=3',	#2A
#'http://www.gspns.co.rs/mreza-get-linija-tacke?linija=4',	#2B
#'http://www.gspns.co.rs/mreza-get-linija-tacke?linija=5',	#3A
#'http://www.gspns.co.rs/mreza-get-linija-tacke?linija=6',	#3B
#'http://www.gspns.co.rs/mreza-get-linija-tacke?linija=241',	#3AA
#'http://www.gspns.co.rs/mreza-get-linija-tacke?linija=242',	#3AB
#'http://www.gspns.co.rs/mreza-get-linija-tacke?linija=7',	#4A
#'http://www.gspns.co.rs/mreza-get-linija-tacke?linija=8',	#4B
#'http://www.gspns.co.rs/mreza-get-linija-tacke?linija=9',#5A
#'http://www.gspns.co.rs/mreza-get-linija-tacke?linija=10',#5B
#'http://www.gspns.co.rs/mreza-get-linija-tacke?linija=69',#5NA
#'http://www.gspns.co.rs/mreza-get-linija-tacke?linija=70',#5NB
#'http://www.gspns.co.rs/mreza-get-linija-tacke?linija=11',#6A
#'http://www.gspns.co.rs/mreza-get-linija-tacke?linija=12',#6B
#'http://www.gspns.co.rs/mreza-get-linija-tacke?linija=234',#6AA
#'http://www.gspns.co.rs/mreza-get-linija-tacke?linija=235',#6AB
#'http://www.gspns.co.rs/mreza-get-linija-tacke?linija=13',#7A
#'http://www.gspns.co.rs/mreza-get-linija-tacke?linija=14',#7B
#'http://www.gspns.co.rs/mreza-get-linija-tacke?linija=15',#8A
#'http://www.gspns.co.rs/mreza-get-linija-tacke?linija=16',#8B
#'http://www.gspns.co.rs/mreza-get-linija-tacke?linija=17',#9A
#'http://www.gspns.co.rs/mreza-get-linija-tacke?linija=18',#9B
#'http://www.gspns.co.rs/mreza-get-linija-tacke?linija=259',#9AA
#'http://www.gspns.co.rs/mreza-get-linija-tacke?linija=260',#9AB
#'http://www.gspns.co.rs/mreza-get-linija-tacke?linija=19',#10A
#'http://www.gspns.co.rs/mreza-get-linija-tacke?linija=20'#10B
#'http://www.gspns.co.rs/mreza-get-linija-tacke?linija=21', #11A
#'http://www.gspns.co.rs/mreza-get-linija-tacke?linija=22', #11B
#'http://www.gspns.co.rs/mreza-get-linija-tacke?linija=23', #12A
#'http://www.gspns.co.rs/mreza-get-linija-tacke?linija=24', #12B
#'http://www.gspns.co.rs/mreza-get-linija-tacke?linija=239', #13A
#'http://www.gspns.co.rs/mreza-get-linija-tacke?linija=240', #13B
#'http://www.gspns.co.rs/mreza-get-linija-tacke?linija=25', #14A
#'http://www.gspns.co.rs/mreza-get-linija-tacke?linija=26', #14B
#'http://www.gspns.co.rs/mreza-get-linija-tacke?linija=27', #15A
#'http://www.gspns.co.rs/mreza-get-linija-tacke?linija=28' #15B
#'http://www.gspns.rs/mreza-get-linija-tacke?linija=71',	#60A
#'http://www.gspns.rs/mreza-get-linija-tacke?linija=72',	#60B
#'http://www.gspns.rs/mreza-get-linija-tacke?linija=79',	#64A
#'http://www.gspns.rs/mreza-get-linija-tacke?linija=80',#64B
#'http://www.gspns.rs/mreza-get-linija-tacke?linija=87',#72A
#'http://www.gspns.rs/mreza-get-linija-tacke?linija=88',	#72B
#'http://www.gspns.rs/mreza-get-linija-tacke?linija=92',	#74A
#'http://www.gspns.rs/mreza-get-linija-tacke?linija=93',#74B
'http://www.gspns.rs/mreza-get-linija-tacke?linija=239', #13A
'http://www.gspns.rs/mreza-get-linija-tacke?linija=239', #13B
'http://www.gspns.rs/mreza-get-linija-tacke?linija=29',#16A
'http://www.gspns.rs/mreza-get-linija-tacke?linija=30',#16B
'http://www.gspns.rs/mreza-get-linija-tacke?linija=31',#17A
'http://www.gspns.rs/mreza-get-linija-tacke?linija=32',#17B
'http://www.gspns.rs/mreza-get-linija-tacke?linija=243',#18A
'http://www.gspns.rs/mreza-get-linija-tacke?linija=244',#18A
'http://www.gspns.rs/mreza-get-linija-tacke?linija=33',#21A
'http://www.gspns.rs/mreza-get-linija-tacke?linija=34',#21B

]

headlines = [
#'<>1A,50,255,150,KLISA - CENTAR - LIMAN I<.>',
#'<>1B,50,255,150,LIMAN I - CENTAR - KLISA<.>',
#'<>1ZA,50,255,150,KLISA - CENTAR - LIMAN<.>',
#'<>1ZB,50,255,150,LIMAN I - CENTAR - KLISA<.>',
#'<>2A,50,255,150,CENTAR - NOVO NASELJE<.>',
#'<>2B,50,255,150,NOVO NASELJE - CENTAR<.>',
#'<>3A,50,255,150,PETROVARADIN - CENTAR - DETELINARA<.>',
#'<>3B,50,255,150,DETELINARA - CENTAR - PETROVARADIN<.>',
#'<>3AA,50,255,150,ZEL.STANICA - POBEDA<.>',
#'<>3AB,50,255,150,POBEDA - ZEL.STANICA<.>',
#'<>4A,50,255,150,LIMAN IV - CENTAR - Z.STANICA<.>',
#'<>4B,50,255,150,Z.STANICA - CENTAR - LIMAN IV<.>',
#'<>5A,50,255,150,TEMERINSKI PUT - CENTAR - AVIJATICAR.NASELJE<.>',
#'<>5B,50,255,150,AVIJATICAR.NASELJE - CENTAR - TEMERINSKI PUT<.>',
#'<>5NA,50,255,150,TEMERINSKI PUT - CENTAR - AVIJATICAR.NASELJE<.>',
#'<>5NB,50,255,150,AVIJATICAR.NASELJE - CENTAR - TEMERINSKI PUT<.>',
#'<>6A,50,255,150,PODBARA - CENTAR - ADICE<.>',
#'<>6B,50,255,150,ADICE - CENTAR - PODBARA<.>',
#'<>6AA,50,255,150,PODBARA - CENTAR - ADICE<.>',
#'<>6AB,50,255,150,ADICE - CENTAR - PODBARA<.>',
#'<>7A,50,255,150,N.NASELJE - Z.STAN - F.PIJA - LIMAN4 - N.NASELJE<.>',
#'<>7B,50,255,150,N.NASELJE - LIMAN4 - F.PIJA - Z.STAN - N.NASELJE<.>',
#'<>8A,50,255,150,NOVO NASELJE - CENTAR - LIMAN I<.>',
#'<>8B,50,255,150,LIMAN I - CENTAR - NOVO NASELJE<.>',
#'<>9A,50,255,150,NOVO NASELJE - LIMAN - PETROVARADIN<.>',
#'<>9B,50,255,150,PETROVARADIN - LIMAN - NOVO NASELJE<.>',
#'<>9AA,50,255,150,NOVO NASELJE - LIMAN - PETROVARADIN<.>',
#'<>9AB,50,255,150,PETROVARADIN - LIMAN - NOVO NASELJE<.>',
#'<>10A,50,255,150,CENTAR - INDUST.ZONA JUG<.>',
#'<>10B,50,255,150,INDUST.ZONA JUG - CENTAR<.>'
#'<>11A,50,255,150,ZELEZNICKA STANICA - BOLNICA - LIMAN - ZELEZNICKA STANICA<.>',
#'<>11B,50,255,150,ZELEZNICKA STANICA - LIMAN - BOLNICA - ZELEZNICKA STANICA<.>',
#'<>12A,50,255,150,CENTAR - TELEP<.>',
#'<>12B,50,255,150,TELEP - CENTAR<.>',
#'<>13A,50,255,150,DETELINARA - GRBAVICA - UNIVERZITET<.>',
#'<>13B,50,255,150,UNIVERZITET - GRBAVICA - DETELINARA<.>',
#'<>14A,50,255,150,CENTAR - SAJLOVO <.>',
#'<>14B,50,255,150,SAJLOVO - CENTAR<.>',
#'<>15A,50,255,150,CENTAR - INDUSTRIJSKA ZONA SEVER<.>',
#'<>15B,50,255,150,INDUSTRIJSKA ZONA SEVER - CENTAR<.>'
#'<>60A,50,255,150,S.KARLOVCI-BELILO II<.>',
#'<>60B,50,255,150,S.BELILO II- KARLOVCI<.>',
#'<>64A,50,255,150,Polasci za BUKOVAC<.>',
#'<>64B,50,255,150,Polasci iz BUKOVAC<.>',
#'<>72A,50,255,150,Polasci za PARAGOVO<.>',
#'<>72B,50,255,150,Polasci iz PARAGOVO<.>',
#'<>74A,50,255,150,Polasci za POPOVICA<.>',
#'<>74B,50,255,150,Polasci iz POPOVICA<.>',
'<>13A,50,255,150,DETELINARA - LIMAN - UNIVERZITET<.>',
'<>13B,50,255,150,UNIVERZITET - LIMAN - DETELINARA<.>',
'<>16A,50,255,150,ŽELEZNIČKA STANICA - PRISTANIŠNA ZONA<.>',
'<>16B,50,255,150,PRISTANIŠNA ZONA - ŽELEZNIČKA STANICA<.>',
'<>17A,50,255,150,BIG TC - CENTAR<.>',
'<>17B,50,255,150,CENTAR - BIG TC<.>',
'<>18A,50,255,150,N.NASELJE - DETELINARA - CENTAR - LIMAN - N.NASELJE<.>',
'<>18A,50,255,150,B:N.NASELJE - LIMAN - CENTAR - DETELINARA - N.NASELJE<.>',
'<>21A,50,255,150,Polasci za ŠANGAJ<.>',
'<>21B,50,255,150,Polasci iz ŠANGAJ<.>',
]

def stripHTML(html):
	html.replace('[','')
	html.replace(']','')
	html.replace('"','')
	html.replace('\\r','')
	html.replace('\\n','\n')

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

	i = 0
	for link in links:
		html = ''
		html = br.open(link).read().strip().decode()
		#print(html)
		html = stripHTML(html)
		#print headlines[i]
		#print html
		#print '\n'
		html = html[:len(html) -2]
		outstr = headlines[i] + '\n' + html + '\n\n\n'
		print(outstr) 
		i = i+1

		with codecs.open("nsBusLines2022jan.txt", "a", encoding="utf-8") as myfile:
			myfile.write(outstr)

  
if __name__== "__main__":
  main()

