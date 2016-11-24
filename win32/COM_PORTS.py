import serial
import time
import requests

ser = serial.Serial('/dev/cu.usbserial-AD02GOSD')
ser.baudrate = 9600
ser.timeout = 1
ser.setDTR(1)

while True:
    print(ser.isOpen())
    print ser.inWaiting()

    s = ser.read(1)
    print s.__len__()

    bytesToRead = ser.inWaiting()
    readBytes   = ser.readline()

    print "---------------------"
    print bytesToRead
    print readBytes
    tenBytes = ser.read(10)

    print "--"
    print tenBytes
    print "--"
    print "---------------------"

    time.sleep(0.013) # delays for BAUD RATE seconds

    atenna_mode = ""

    if readBytes == "BKH234":
        atenna_mode = "dipole"
    else:
        atenna_mode = "single"

    headers = {
        'Content-type': 'application/json',
        'Accept': 'text/plain',
        'payload': atenna_mode
    }

    res = requests.post('http://10.0.0.230:5000', headers=headers)

    print 'REQUEST SENT'

    if res.ok:
        print res
    else:
        print 'UHH OH'

    time.sleep(2)