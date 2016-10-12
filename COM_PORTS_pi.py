import serial
import time

ser = serial.Serial('/dev/ttyUSB0')

ser.flushInput()
ser.flushOutput()


while True:
    print ser

    bytesToRead = ser.inWaiting()
    readBytes   = ser.read(bytesToRead)

    print "READING\n\n"
    print readBytes

    # time.sleep(0.013) # delays for 5 seconds