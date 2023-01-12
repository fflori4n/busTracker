#!/usr/bin/python
# -*- coding: utf-8 -*-

import hashlib


nsStops = ""
suStops = ""

def add_stop2system_ns(key,name = None,lat = None, lon = None,zone = None,served_lines = []):
	global nsStops
	nsStops += """
    {
      \"name\" : \"""" + str(name) + """\",
      \"lat\" : """ + str(lat) + """,
      \"lon\" : """ + str(lon) + """,
      \"zone\" : \"""" + str(zone) + """\",
      \"served_lines\" : """ + str(served_lines).replace('\'','"') + """,
      \"uid\" : \"""" + str(key) + """\"
    }"""
def add_stop2system_su(key,name = None,lat = None, lon = None,zone = None,served_lines = []):
	global suStops
	suStops += """
    {
      \"name\" : \"""" + str(name) + """\",
      \"lat\" : """ + str(lat) + """,
      \"lon\" : """ + str(lon) + """,
      \"zone\" : \"""" + str(zone) + """\",
      \"served_lines\" : """ + str(served_lines).replace('\'','"') + """,
      \"uid\" : \"""" + str(key) + """\"
    }"""

def load_busstops_from_file(filename,city_str):
	with open(filename) as f:
	    lines = f.readlines()
	    for line in lines:
		datatags = line.split('|')
		name = str(datatags[0]).strip()
		lat, lon = datatags[1].split(',')
		zone = datatags[2].strip()
		served_lines = datatags[3].strip().split(',')
		served_lines2 = []
		for busline in served_lines:
			busline = busline.strip()
			served_lines2.append(busline)
		served_lines = served_lines2
		#key = name.replace('-', '').replace(' ','')[:8] + hashlib.md5(name + str(lat) + str(lon)).hexdigest()[1:9]
		#key = hashlib.md5(name + str(lat) + str(lon)).hexdigest()[1:9]
		key = hashlib.md5(name + str(lat) + str(lon)).hexdigest()
		#print(name + ' ' + str(lat) + ' ' + str(lon) + ' ' + zone + ' ' + str(served_lines))
		if 'ns' in city_str:
			add_stop2system_ns(key, name,float(lat), float(lon),zone,served_lines)
		elif 'su' in city_str:
			add_stop2system_su(key, name,float(lat), float(lon),zone,served_lines)

load_busstops_from_file('nsStations.txt','ns')
load_busstops_from_file('suStations.txt','su')

'''print nsStops.replace("""    }
    {""","""    },
    {""" )'''

outStr = """{
  "nsBusStops": [""" + nsStops.replace("""    }
    {""","""    },
    {""" ) + """
  ],
  "suBusStops": [""" + suStops.replace("""    }
    {""","""    },
    {""" ) + """
  ]
}"""
print outStr

f = open("stations.json", "w")
f.write(outStr)
f.close()
    
