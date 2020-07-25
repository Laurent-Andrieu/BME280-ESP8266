import gc
import sys
import network
import webrepl
import machine
import ubinascii
from umqttsimple import MQTTClient


SSID = ''
PASS = ''
mqtt_broker = ''

version = [str(i)  for i in sys.implementation.version]
wlan = network.WLAN(network.STA_IF)
ap = network.WLAN(network.AP_IF)
ap.active(False)
networks = wlan.scan()[:][0]

rssi = networks[3]
py_ver = sys.version
board = sys.platform
firmware = sys.implementation.name
firmware_ver = ".".join(version)
ap_state = ap.isconnected()

print('\n[Boot]')
print('\n[i]Python version: %s'% py_ver,
      '\n[i]board name: %s'% board,
      '\n[i]firmware: %s'% firmware,
      '\n[i]version: %s'% firmware_ver)
print('[i]AP state: %s'% ap_state)

if b'%s'%SSID in networks:
    print('[i]RSSI: {}db'.format(networks[3]))
    
if not wlan.isconnected():
    print('[+]Connecting to Wifi...\n')
    wlan.active(True)
    wlan.connect(SSID, PASS)
    while not wlan.isconnected():
        pass
webrepl.start()
gc.collect()
print('\n[i]Memory free:', gc.mem_free())

(ip, netmask, gateway, dns) = wlan.ifconfig()
mac = ubinascii.hexlify(network.WLAN().config('mac'),':').decode()

wlan_data = {'IP': ip, 'Netmask': netmask, 'Gateway': gateway, 'DNS': dns, 'MAC': mac}
if not wlan.isconnected():
    print('[i]Not Connected to Wifi Network, please check SSID & password or Wifi params')
else:
    for k, v in wlan_data.items():
        print('[i]{}: '.format(k), v)

import main
