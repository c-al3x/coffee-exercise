In order to regenerate a more recent CSV archive for appending, run the following commands (this archive will only be up to 04/08/2022):

cd dev
cp ../archive/us-dairy-slaughter-2000-2021.csv us-dairy-slaughter-2000-2021-copy.csv
./recreate-archive us-dairy-slaughter-2000-2021-copy.csv
./append-to-archive us-dairy-slaughter-2000-04082022.csv
sed -i '1s/^/DATE,OPEN,HIGH,LOW,CLOSE,VOL,OI\n/' us-dairy-slaughter-2000-04082022.csv
rm us-dairy-slaughter-2000-2021-copy.csv

This will leave a more recent CSV archive in the dev directory. In order to generate an even more recent archive, you will need to manually add links to more recent reports that are missing from the array in the append-to-archive script and make sure to update the date given in the first sentence of this text file as well as the timestamps in the file names in the commands above.
