import requests

headers = {
    'Content-type': 'application/json',
    'Accept': 'text/plain',
    'payload': ""
}

res = requests.post('http://10.0.0.230:5000', headers=headers)

print 'REQUEST SENT'

if res.ok:
    print res
else:
    print 'UHH OH'