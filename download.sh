#!/bin/bash
cd image-processing
echo 'Downlaod Brugel'
./grep_wiki.py -a brugel -w http://en.wikipedia.org/wiki/List_of_paintings_by_Pieter_Bruegel_the_Elder

echo 'Downlaod Picasso'
./grep_wiki.py -a picasso -p picasso -w http://www.pablopicasso.org/picasso-paintings.jsp

echo 'Downlaod Raphael'
./grep_wiki.py -a raphael -w http://en.wikipedia.org/wiki/List_of_paintings_by_Raphael

echo 'Downlaod Rembrandt'
./grep_wiki.py -a rembrandt -w http://en.wikipedia.org/wiki/List_of_paintings_by_Rembrandt

cd ..
