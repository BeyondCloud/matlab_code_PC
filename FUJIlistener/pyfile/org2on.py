#run me first
#this cell input csv , output delta_f0 to csv file
from math import floor
import csv
f = open('midi_org.csv', 'r')
wf = open('outfile/midi_on.csv', 'w')

my_csv_data = list(csv.reader(f))

t_rows = len(my_csv_data)

#extract note on, note off time data
t=0
while t in range(0,t_rows-1):
    if 'Note_on' in my_csv_data[t][2]:
        wf.write(my_csv_data[t][1]+','+my_csv_data[t][4]+'\n')   
    t+=1
#time end of track
end_str = str(my_csv_data[t_rows-3][1])
wf.write(end_str)
        
f.close()
wf.close()

