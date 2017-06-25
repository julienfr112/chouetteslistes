
import json
with open('recettesfull.json') as f:
    recettes=json.load(f)

import pickle
with open('products.pkl','rb') as f:
    products=pickle.load(f)
print(recettes)

import datagram
from fuzzyset import FuzzySet
names=FuzzySet(p['name'] for p in products.values())
print(len(products))
for r in recettes:
    print(r['url'])
    recepe=datagram.get_ingredients(r['url'])
    if 'ingredients' in recepe:
        r['ingedients']=[i for i in recepe['ingredients']
            if 'name' in i and ('probablyathome' not in i or not i['probablyathome'])]


with open('recettesfullfull.json','w') as f:
    json.dump(recettes,f, sort_keys=True,
                 indent=4, separators=(',', ': '),ensure_ascii=False)
