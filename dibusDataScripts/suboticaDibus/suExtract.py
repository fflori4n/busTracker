#!/usr/bin/python
# -*- coding: utf-8 -*-

import re



def strip_tags(string):
	string = re.sub("<styleUrl>(.*?)</styleUrl>", "", string)
	string = string.replace("<name>", "*name: ")
	string = re.sub("<Data([\s\S]*?)</Data>", "", string)


	string = re.sub("<coordinates>", "*coords:", string)
	string = re.sub("</tessellate>", "*linija:", string)
	string = re.sub("<.*?>", "", string)

	string = re.sub(r'\s{2}', '', string)
	string = string.replace("*name:", "\n*name: ")
	string = string.replace("*coords:", "\n*coords: ")
	string = string.replace("*linija:", "\n*linija: ")

	'''string = string.replace('[','')
	string = string.replace(']','')
	string = string.replace('"','')
	string = string.replace('\\r','')
	string = string.replace('\\n','\n')'''
	#string = re.sub(r'^https?:\/\/.*[\r\n]*', '', string, flags=re.MULTILINE)


	return string

class bus_stop:
	name = ''
	lat=''
	lon=''

	#bus_stop(self,name,lat,lon):
		

bus_stops = []

def main():
	with open("suboticaRaw.txt",'r') as f:
		raw_data = f.read()
	raw_data = strip_tags(raw_data)
	split_data = raw_data.splitlines()
	statoutstr = ''
	
	for i in range(0,len(split_data)):
		line = split_data[i]
		if '*name' in line and '*name' in split_data[i+1]:
			continue
		if '*name' in line and '*coords' in split_data[i+1]:	#bus stops 
			#bus_stops.append(bus_stop())
			name = line.replace("*name:", "").strip()
			coords = split_data[i+1].replace("*coords:", "").strip()
			lat, lon, z = coords.split(',')
			statoutstr += (name + '|' + lat + ',' + lon + '|1||\n')
			bus_stops.append(name + ' ' + coords)
		elif '*coords:' in line and '*linija:' in split_data[i-1] and '*name:' in split_data[i-2]:
			print split_data[i-2]
			line=line.replace('*coords:','')
			coordinates = line.split(",0")
			for coord in coordinates:
				print("\""+ coord.replace(" ","") + "\",")
			
	print(len(bus_stops))
	with open("suStanice.txt",'w') as f:
		f.write(statoutstr)

  
if __name__== "__main__":
  main()

