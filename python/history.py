import pickle

products=pickle.load(open('products.pkl','rb'))

print(len(products))

from collections import Counter,defaultdict
from pprint import pprint

nbcat=Counter(p['category_crumb'][0].split('|')[1].strip() for p in products.values())

cats=[
'Charcuterie',
'Goûters',
'Yaourts et desserts',
'Soins du corps',
'Fromages',
'Condiments et sauces',
'Cafés et boissons chaudes',
'Vins et champagnes',
'Entretien de la maison',
'Petit déjeuner',
'Plats cuisinés, tartes et pizzas',
'Alcools et bières',
'Chats',
'Légumes',
'Soins du visage',
'Boucherie, volaille',
'Laits et boissons',
'Viandes et poissons',
'Sodas',
'Apéritif',
'Jus de fruits et sirops',
'Riz, pâtes et légumes secs',
'Conserves',
'Desserts',
'Eaux et laits',
'Plats cuisinés et soupes',
'Papiers, cotons et parapharmacie',
'Beurres, œufs et crèmes',
'Soins des cheveux',
'Hygiène',
'Soins du linge',
'Fruits',
'Glaces et desserts',
'Gourmet et Fromage',
'Fruits et Légumes',
'Poissonnerie',
'Puériculture',
'Chiens',
]

from nltk.stem.snowball import FrenchStemmer
stemmer = FrenchStemmer()
words=set()
res=defaultdict(list)
for c in cats:
    print(c,nbcat[c])
    for p in products.values():
        if p['category_crumb'][0].split('|')[1].strip()==c:
            w={stemmer.stem(w) for w in p['name'].lower().split() if len(w)>2}
            if not words & w:
                words|=w
                res[c].append({'id':p['id'],'name':p['name']+
                    (' '+p["mc_brand_crumb"] if "mc_brand_crumb" in p and p['mc_brand_crumb'] else ''),'category':c})
        if len(res[c])>5 or len(res[c])>nbcat[c]/15:
            break
print()
from pprint import pprint
for c in res:
    print(c,len(res[c]))
print(sum(len(res[c]) for c in res))
import json
with open('history.json','w') as f:
    json.dump(res,open('history.json','w'), sort_keys=True,
                 indent=4, separators=(',', ': '),ensure_ascii=False)
