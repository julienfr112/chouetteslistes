import pyrebase
config = {
  "apiKey": "AIzaSyAnFN7LDu9_i2FkFSumE-JPDU2hOs-ErVw",
  "authDomain": "chouetteslistes.firebaseapp.com",
  "databaseURL": "https://chouetteslistes.firebaseio.com",
  "storageBucket": "chouetteslistes.appspot.com",
  "serviceAccount": "ChouettesListes.json"
}

firebase = pyrebase.initialize_app(config)
#auth=firebase.auth()
db = firebase.database()

db.child("products").remove()
db.set("products")
import json
history=json.load(open('historyfull.json'))
for h in history.values():
    for p in h:
        print(p['id'])
        db.child('products').child(p['id']).set(p)
        #db.child('history').set('history')
        #print(db.child("test").set(p['id']))
