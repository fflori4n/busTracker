#!/usr/bin/python
# -*- coding: utf-8 -*-

import json
import hashlib

from random import randint

class Json_manage:
    @classmethod
    def load_Json_file(self,filename):
        with open(filename) as json_in:
            return json.load(json_in)
    
    @classmethod
    def write_Json_file(self, filename, data):
        with open(filename, 'w') as Json_out:
            json.dump(data, Json_out, indent=2, ensure_ascii=False)
  
#print Json_manage.load_Json_file('proba.json')

bus_system= {}
bus_system['SU_bus_stop'] = []
bus_system['NS_bus_stop'] = []

def add_stop2system(city,key,name = None,lat = None, lon = None,zone = None,served_lines = []):
    bus_system[city] = {
        'name' : name,
        'location' : [ lat, lon ],
        'zone' : zone,
        'served_lines' : served_lines,
	'uid' : key
	#'description' : None,
        #'weather_proof' : False,
        #'display' : False
    }

#for i in range(0,10):
#    add_stop2system('SU_bus_stop', str(i))
#    add_stop2system('NS_bus_stop', str(i))

def load_busstops_from_file(filename, bussysname):
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
		print(name + ' ' + str(lat) + ' ' + str(lon) + ' ' + zone + ' ' + str(served_lines))
		add_stop2system(bussysname, key, name,float(lat), float(lon),zone,served_lines)

load_busstops_from_file('stations.txt', 'NS_bus_stop')
load_busstops_from_file('suStanice.txt', 'SU_bus_stop')

Json_manage.write_Json_file('proba.json', bus_system)
#print Json_manage.load_Json_file('proba.json')

    
