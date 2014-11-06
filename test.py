from TOSSIM import *
import sys #debugging issue 

#Commen
t = Tossim ([])
r = t.radio()


#Channels 
#t.addChannel ("System",sys.stdout) #system/modules debug
t.addChannel ("Channel",sys.stdout) #SND/RCV
#t.addChannel ("Flag",sys.stdout) #flags holding on



#Set Total Mote Number 
mote_num = 50  

# Gain Mapping 
f = open("large_uniform.out", "r") #mote_num should change at the same time when switching file
print "Mapping Gain:"
for line in f:
	s = line.split()
	if s:
		if s[0] =="gain":
			r.add(int(s[1]),int(s[2]),float(s[3]))
			print "Mapping Gain:",s[1],"=>",s[2],":",s[3],"...SUCCESS"


#Noise Tracing 
noise = open("meyer-heavy.txt", "r")
for line in noise:
  str1 = line.strip()
  if str1:
    val = int(str1)
    for i in range(0, mote_num):
      t.getNode(i).addNoiseTraceReading(val)

#Create Noise Model
for i in range(0, mote_num):
  t.getNode(i).createNoiseModel()
  print "Creating noise model for mote ",i,"...SUCCESS";

#Set Boot Time  
for i in range(0, mote_num):
	boot_time = 500
	t.getNode(i).bootAtTime(boot_time)


# /run motes 
while True:
	t.runNextEvent()

#Need Ctrl+C if no event running next.	
