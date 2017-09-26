#run me third
#input midi pit data ,origin csv  output final data


import csv
f_org = open('midi_org.csv', 'r')
f_pit = open('outfile/midi_pit.csv', 'r')
wf = open('outfile/midi_final.csv', 'w')

def cpstr(org_data):
    wf.write(','.join(org_data))
    wf.write('\n')    

org_data = list(csv.reader(f_org))
pit_data = list(csv.reader(f_pit))

t_rows = len(org_data)


t=0
start_output_f0 = False
from_t = 0;
while t in range(0,t_rows):
    if start_output_f0:
        if org_data[t][1] != from_str:
            from_t = int(from_str)
            to_t = int(org_data[t][1])
            if to_t<from_t:
                cpstr(org_data[t])
                break
            for i in range(from_t,to_t-1):
                wf.write('2, '+str(i)+', Pitch_bend_c, 0, '+str(pit_data[i][0])+'\n')
            cpstr(org_data[t])
            from_str = org_data[t][1]
        else:
            cpstr(org_data[t])
    elif 'Note_on' in org_data[t][2]:
        from_str = org_data[t][1]
        start_output_f0 = True
        cpstr(org_data[t])
#         wf.write(str(org_data[t])+'\n')
    else:
        cpstr(org_data[t])
    t+=1
    
#         print(my_csv_data[t][2]) 
#         wf.write(my_csv_data[t][1]+','+my_csv_data[t][4]+'\n')   

f_org.close()
f_pit.close()
wf.close()
