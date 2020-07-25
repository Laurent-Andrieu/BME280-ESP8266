import gc
import time
import BME280
import machine
import network
from ubinascii import hexlify
from umqttsimple import MQTTClient
from sys import version, platform, implementation

wlan = network.WLAN(network.STA_IF)
mqtt_broker = ''
client_id = hexlify(machine.unique_id())
client_id = client_id.decode('utf-8')
topic = b'sensor/{}'.format(client_id)
topic_params = topic + b'/params'
py_version = [str(i)  for i in implementation.version]
rssi = wlan.scan()[:][0][3]
py_ver = version
board = platform
firmware = implementation.name
firmware_ver = ".".join(py_version)
(ip, netmask, gateway, dns) = wlan.ifconfig()
mac = hexlify(network.WLAN().config('mac'),':').decode()

# Pin D1 & D2
i2c = machine.I2C(scl=machine.Pin(5), sda=machine.Pin(4), freq=10000)
print('[i]Client id: ', client_id)

def deep_sleep(msecs):
  #configure RTC.ALARM0 to be able to wake the device
  rtc = machine.RTC()
  rtc.irq(trigger=rtc.ALARM0, wake=machine.DEEPSLEEP)
  # set RTC.ALARM0 to fire after Xmilliseconds, waking the device
  rtc.alarm(rtc.ALARM0, msecs)
  #put the device to sleep
  machine.deepsleep()

def connect():
    global client_id, mqtt_broker
    client = MQTTClient(client_id, mqtt_broker)
    client.connect()
    print('[i]Connected to %s MQTT broker' % (mqtt_broker))
    return client

def reconnect():
    print('Failed to connect to MQTT broker. Reconnecting...')
    time.sleep(10)
    machine.reset()

try:
    client = connect()
except OSError as e:
    reconnect()
finally:
    client.check_msg()
    params = b'{},{},{},{},{},{},{},{},{},{},{}'.format(client_id, py_ver, firmware,
                                                        firmware_ver, gc.mem_free(), rssi,
                                                        ip, mac, gateway,
                                                        dns, netmask)
    client.publish(topic_params, params)
while True:
    bme = BME280.BME280(i2c=i2c)
    temp = bme.temperature
    hum = bme.humidity
    pres = bme.pressure
    networks = wlan.scan()[:][0]
    rssi = networks[3]
    try:
        msg = b'{},{},{},{},{}'.format(client_id,rssi,temp,hum,pres)
        client.publish(topic, msg)
        last_message = time.time()
        print('\nRSSI: ', rssi)
        print('Temperature: ', temp)
        print('Humidity: ', hum)
        print('Pressure: ', pres)
        #10min pause
        time.sleep(10)
        deep_sleep(300000)
    except OSError as e:
        reconnect()
