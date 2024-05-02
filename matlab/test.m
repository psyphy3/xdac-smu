%% Code to test Nicslab XDAC-40U-R4G8

tic
%% ==Initialisations=======
addpath (".\lib");
key="INSERT_KEY";
ip="INSERT_IP_ADDRESS";
x1=Xdac(ip,key);

%% ==First time procedures===
x1.unlock();
x1.setZ();
x1.setVth('all',4);
x1.setCth('all',3);
x1.CCmode('all',6,2);

%% ===Main body=========

x1.setV(2,3);
V=x1.getV(2);



%% ==Shutdown procedures====
x1.lock();
x1.shutdown();

%% =================
toc
