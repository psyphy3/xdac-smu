import zmq

class Xdac:

    def __init__(self,ip,port):

        self.max_channel=40
        self.maxC=5
        self.maxV=7.5
        self.ip=ip
        self.port=port

        context=zmq.Context()
        self.req=zmq.Socket(context,zmq.REQ)
        #self.sub=zmq.Socket(context,zmq.SUB)

        self.req.setsockopt(zmq.CONNECT_TIMEOUT,500)
        self.req.setsockopt(zmq.LINGER,0)
        self.req.setsockopt(zmq.RCVTIMEO,500)
        self.req.setsockopt(zmq.SNDTIMEO,500)

        self.req.connect("tcp://"+self.ip+":"+self.port)

        #self.sub.setsockopt(zmq.LINGER,0)
        #self.sub.setsockopt(zmq.SUBSCRIBE,b"")
        #self.sub.setsockopt(zmq.CONFLATE,True)
        #self.sub.setsockopt(zmq.RCVHWM,100)

        #self.sub.connect("tcp://"+self.ip+":5556")

    
    # ====Basic methods============

    def unlock(self,key):
        msg="GETINFO:"+key
        out=self.sendreq(msg)
        print(out)

    def lock(self):
        msg="LOCK"
        out=self.sendreq(msg)

    def shutdown(self):
        msg="EXIT"
        out=self.sendreq(msg)

    def config(self,avg_samples,v_conv_time,c_conv_time):  # Measurement configuration
        #conversion time in micro seconds.
        msg="CONFIG:"+str(avg_samples)+":"+str(v_conv_time)+":"+str(c_conv_time)
        out=self.sendreq(msg)

    def setZ(self,channel):
        msg="ZERO:"+str(channel)
        out=self.sendreq(msg)

    def setV(self,channel,V): #Set voltage in V
        msg="SETV:"+str(channel)+":"+str(V)
        out=self.sendreq(msg)

    def getV(self,channel):
        msg="MEASV:"+str(channel)
        V=self.sendreq(msg)
        return V

    
    def setC(self,channel,C): # Set current in mA
        msg="SETC:"+str(channel)+":"+str(C)
        out=self.sendreq(msg)

    def getC(self,channel):
        msg="MEASC:"+str(channel)
        C=self.sendreq(msg)
        return C
    
    def setVth(self,channel,V): #Set Voltage threshold in V
        msg="SETOVT:"+str(channel)+":"+str(V)
        out=self.sendreq(msg)

    def setCth(self,channel,C): #Set Current threshold in mA
        msg="SETOCT:"+str(channel)+":"+str(C)
        out=self.sendreq(msg)

    def setVr(self,channel,r): #Set Voltage range
        #0:0-5V  1:0-10V  2:0-20V  3:0-34V
        msg="SETR:"+str(channel)+":"+str(r)
        out=self.sendreq(msg)


    #====Derived methods=====================

    def setZ_all(self):
        
        for channel in range(1,self.max_channel+1):
            self.setZ(channel)

    def setC_all(self,C):
        
        for channel in range(1,self.max_channel+1):
            self.setC(channel,C)

    def setV_all(self,V):
        
        for channel in range(1,self.max_channel+1):
            self.setV(channel,V)

    def setVr_all(self,r):
        
        for channel in range(1,self.max_channel+1):
            self.setVr(channel,r)

    def setVth_all(self,th):
        
        for channel in range(1,self.max_channel+1):
            self.setVth(channel,th)

    def setCth_all(self,th):
        
        for channel in range(1,self.max_channel+1):
            self.setCth(channel,th)

    def setV_multi(self,channels,voltages):
        
        N=len(channels)

        for i in range(N):
            self.setV(channels[i],voltages[i])

    def setC_multi(self,channels,currents):
        
        N=len(channels)

        for i in range(N):
            self.setC(channels[i],currents[i])  

    def getV_multi(self,channels):
        
        N=len(channels)
        voltages=[0]*N
        for i in range(N):
            voltages[i]=self.getV(channels[i])

        return voltages
    
    def getC_multi(self,channels):
        
        N=len(channels)
        currents=[0]*N
        for i in range(N):
            currents[i]=self.getC(channels[i])

        return currents
    
    def CVmode(self,channels,V):
        N=len(channels)
        for i in range(N):
            self.setC(channels[i],self.maxC)
            self.setV(channels[i],V)

    def CCmode(self,channels,C):
        N=len(channels)
        for i in range(N):
            self.setV(channels[i],self.maxV)
            self.setC(channels[i],C)
    

    #===Util functions==============

    def sendreq(self,msg):
        self.req.send(msg.encode('utf-8'))
        out=self.req.recv()
        return out




