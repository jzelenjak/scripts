#!/usr/bin/env python
# Fetches information about an IP address (e.g. country, continent, ISP, etc.)

import json
import requests
import sys

# Using ip-api.com 
# NB! For the free version, at most 45 requests per minute!
API_ENDPOINT = "http://ip-api.com/json/"

def find_ip(ip_address):
    params = ['continent', 'continentCode', 'country', 'countryCode', 'region', 'regionName',
              'city', 'district', 'zip', 'lat', 'lon', 'timezone', 'offset', 'currency',
              'isp', 'org', 'as', 'asname', 'reverse']
    request = API_ENDPOINT + ip_address
    response = requests.get(request, params={'fields': ','.join(params)}).json()
    return json.dumps(response, indent=4)


if len(sys.argv) != 2:
    print("Usage:", sys.argv[0], "<ip_address>")
    exit()

print(find_ip(sys.argv[1]))
