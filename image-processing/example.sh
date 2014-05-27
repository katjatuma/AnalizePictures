#!/bin/bash
./grep_wiki.py -a brugel -w http://en.wikipedia.org/wiki/List_of_paintings_by_Pieter_Bruegel_the_Elder &&
./prepare_data.py -a brugel
