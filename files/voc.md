## Commande pour le voc

Trouver les lignes de séparation du fichier kinyarwanda.txt
```bash
cat -n kinyarwanda.txt | grep -e "[0-9]\+\s-$" | sed "s/\s-//g" > lines
```

Vérification si les fichiers xaa et xab ont la même taille
```bash
for folder in $(ls); do wc -l $folder/xaa && wc -l $folder/xab && echo ------;done | less
```

Création du fichier final.txt
```bash
paste xaa xab | awk -F "\t" '{print $1 " == " $2}' >> final.txt
```
