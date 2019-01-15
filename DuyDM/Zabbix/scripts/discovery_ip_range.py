#!/usr/bin/python3.5
from ipaddress import ip_address
import sys
import json

def ips(start, end):
    '''Return IPs in IPv4 range, inclusive.'''
    start_int = int(ip_address(start).packed.hex(), 16)
    end_int = int(ip_address(end).packed.hex(), 16)
    data = [{"{#IP}": ip_address(ip).exploded} for ip in range(start_int, end_int)]
    print(json.dumps({"data": data}, indent=4))

ips(str(sys.argv[1]), str(sys.argv[2]))
