import tornado.ioloop
import tornado.web
import json
from random import choice
recettes=json.load(open('recettesfullfull.json','r'))
recettes2=recettes.copy()

def random_recette():
    global recettes,recettes2
    if recettes2:
        i=choice(range(len(recettes2)))
        r=recettes2[i]
        del recettes2[i]
        return r
    else:
        recettes2=recettes.copy()
        return random_recette()

history=json.load(open('historyfull.json'))
history= { h['name']:h for cat in history for h in history[cat] }
historye=json.load(open('historyfulle.json'))
historye= { h['Name']:h for cat in historye for h in historye[cat]}
e2f={e['Id']:f for e in historye.values() for f in history.values() if e['Id']==f['id']}
historye= { k:e2f[v['Id']] for k,v in historye.items()}
history.update(historye)
from fuzzyset import FuzzySet
f=FuzzySet(history)

config = {
  "apiKey": "AIzaSyAnFN7LDu9_i2FkFSumE-JPDU2hOs-ErVw",
  "authDomain": "chouetteslistes.firebaseapp.com",
  "databaseURL": "https://chouetteslistes.firebaseio.com",
  "storageBucket": "chouetteslistes.appspot.com",
  "serviceAccount": "ChouettesListes.json"
}

import pyrebase
firebase = pyrebase.initialize_app(config)
db = firebase.database()

class RecetteHandler(tornado.web.RequestHandler):
    def get(self):
        self.write(random_recette())
        #check_output(['mupdf-gl',files[int(i)]])

class ProductHandler(tornado.web.RequestHandler):
    def get(self,q):
        if q=="everything":
            self.write(history)
        else:
            name=f.get(q)[0][1]
            self.write(history[name])
            db.child('messages').push({"text":name})

import os
tornado.web.Application([
    (r"/recette", RecetteHandler),
    (r"/search/(.*)", ProductHandler),
],debug=True).listen(os.environ.get('PORT',8888))
tornado.ioloop.IOLoop.current().start()
