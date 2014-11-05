from TOSSIM import *
import sys #debugging issue 

t = Tossim ([])
r = t.radio()

mote_num = 50  #number of motes counted from gain topology 

#mapping gain 
f = open("large_random.out", "r")
print "Mapping Gain:"
for line in f:
	s = line.split()
	if s:
		if s[0] =="gain":
			r.add(int(s[1]),int(s[2]),float(s[3]))
			print "",s[1]," >> ",s[2]," : ",s[3],"success"
t.addChannel ("Boot",sys.stdout)

#trace noise 
noise = open("meyer-heavy.txt", "r")
for line in noise:
  str1 = line.strip()
  if str1:
    val = int(str1)
    for i in range(0, mote_num):
      t.getNode(i).addNoiseTraceReading(val)

#create Noise Model
for i in range(0, mote_num):
  t.getNode(i).createNoiseModel()
  print "Creating noise model for mote ",i,"...SUCCESS";

#set boot time 
for i in range(0, mote_num):
	t.getNode(i).bootAtTime(10000)


#run motes 
for i in range (0, mote_num*100):
	t.runNextEvent()	
