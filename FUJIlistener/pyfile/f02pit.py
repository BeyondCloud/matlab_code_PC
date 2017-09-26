#run me second
#this cell input midicsv,f0 data ---> output  PIT 


from math import floor

import csv

#A4 = 69
PBS = 4
def update_pit(pit,f0_data,note,start,end,t_EOT,f0_rows):
    note_f0 = (note-69)/12
    for t in range(start,end-1):
        f0_i = floor(f0_rows*(t/t_EOT))
        if 'NaN' in f0_data[f0_i]:
            if t==0:
                continue
            else:
                pit[t]=pit[t-1]
        else:
            pit_data = 8192+8191/PBS*((float(f0_data[f0_i][0])-note_f0)/(1/12))
            pit[t] = min(floor(pit_data),16383)

f = open('midi_org.csv', 'r')
f_f0 = open('outfile/f0.csv', 'r')
f_on = open('outfile/midi_on.csv', 'r')
wf = open('outfile/midi_pit.csv', 'w')

t_data = list(csv.reader(f))
f0_data = list(csv.reader(f_f0))
on_data = list(csv.reader(f_on))

t_rows = len(t_data)
f0_rows = len(f0_data)
on_rows = len(on_data)

#time end of track
t_EOT = int(t_data[t_rows-2][1]) 

PIT = [8192] * t_EOT

on_i=0
while on_i < on_rows-1:
    start = int(on_data[on_i][0])
    end = int(on_data[on_i+1][0])
    note = int(on_data[on_i][1])
    update_pit(PIT,f0_data,note,start,end,int(t_EOT),f0_rows)
    on_i+=1
    
    
    
for t in PIT:
    wf.write(str(t)+'\n')

f.close()
f_f0.close()
f_on.close()
wf.close()
    