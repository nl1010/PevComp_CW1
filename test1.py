from TOSSIM import *
import sys #debugging issue 

t = Tossim ([]);

m = t.getNode (32);
n = t.getNode (11);
n.bootAtTime(1231);
m.bootAtTime(1231);
#create and add Boot channel debug information to the file 
f = open("test1_log.txt","w")
t.addChannel("Boot",f)
t.addChannel("Control",f )


#console stdout print
t.addChannel("Boot",sys.stdout)
t.addChannel("Control",sys.stdout)


while True:
	t.runNextEvent();
