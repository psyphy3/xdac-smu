import zmq
import time
from xdac import Xdac

#==Initialisation==========
ip="YOUR_IP"
port="5555"
key="YOUR_KEY"
x1=Xdac(ip,port)


#===One time procedures===================

""" x1.unlock(key)
x1.setVr_all(1) #Set voltage range to 0-10V
x1.setZ_all() #Set all zeros
x1.setVth_all(7.5)
x1.setCth_all(5)
x1.CCmode(range(1,15),3) """

#x1.config(16,1000,1000)

#===Main body=================
#x1.setC_multi([1,4,7,10,13],[3,3,3,3,3])
#time.sleep(2) 


#V=x1.getV_multi([1,4,7,10,13])
#C=x1.getC_multi([1,4,7,10,13])
#R=float(V)/(1e-3*float(C))
C=x1.getC_multi([1,4,7])
print(C)


#==Shutdown=======
""" x1.setZ_all()
x1.lock()
x1.shutdown() """

#==========================




    

