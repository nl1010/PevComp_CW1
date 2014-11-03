from TOSSIM import *
import sys #debugging issue 

t = Tossim ([]);
m = t.getNode (32);
m.bootAtTime(1231);
#create and add Boot channel debug information to the file 
f = open("test1_log.txt","w")
t.addChannel("Boot",f)
t.addChannel("Led",f )
#console stdout print
t.addChannel("Boot",sys.stdout)
t.addChannel("Led",sys.stdout)


t.runNextEvent();

