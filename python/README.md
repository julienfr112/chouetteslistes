# Techo

Python3, tornado, hosting on heroku

# server.py

contains all the service code:

#### route /search/nuttla

search for product with name match with nuttla -> Ferrero | Nutella
adds it directly to the firebase database for updating list

#### route /recette

return a random recette, push ingredients to firebase

# datagram.py

getting infos from datagram, with cache for speedup. 

# recette.py

from a selection of recepe, use datagram to find ingredients, and try to match
the ingredients with known ingredient.
