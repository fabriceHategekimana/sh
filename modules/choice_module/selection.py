import random
import sys

# Récupérer les poids depuis les arguments de ligne de commande
if len(sys.argv) < 2:
    print("Usage : python3 app.py poids1 poids2 poids3 ...")
    sys.exit(1)


def my_convert(argument):
    return list(map(int, argument.split(" ")))


# Convertir les arguments en entiers
try:
    poids = sum(map(my_convert, sys.argv[1:]), [])
except ValueError:
    print("Erreur : Veuillez entrer uniquement des entiers pour les poids.")
    sys.exit(1)

# Indices correspondant aux poids
indices = range(len(poids))

# Sélection aléatoire pondérée (retourne un index)
index_selectionne = random.choices(indices, weights=poids, k=1)[0]

print(index_selectionne)
