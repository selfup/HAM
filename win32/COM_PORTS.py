import serial
import time
import requests

ser = serial.Serial('/dev/ttyUSB0')

ser.flushInput()
ser.flushOutput()


while True:
    print ser

    bytesToRead = ser.inWaiting()
    readBytes   = ser.read(bytesToRead)

    print "READING\n\n"
    print readBytes

    # time.sleep(0.013) # delays for BAUD RATE seconds

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