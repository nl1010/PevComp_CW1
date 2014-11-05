from TOSSIM import *
import sys #debugging issue 

t = Tossim ([])
r = t.radio()

mote_double_num = 0

#mapping gain 
f = open("small.out", "r")
print "Mapping Gain:"
for line in f:
	s = line.split()
	if s:
		if s[0] =="gain":
			r.add(int(s[1]),int(s[2]),float(s[3]))
			print "",s[1]," >> ",s[2]," : ",s[3],"success"
			mote_double_num += 1
t.addChannel ("Boot",sys.stdout)

mote_num = mote_double_num/2 #number of motes counted from gain topology 

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
for i in range (mote_num):
	t.runNextEvent()	
