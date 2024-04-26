tic
%% ==Initialisations=======
key="BEL-ULB40c001";
inter="interface.py";
x1=Xdac(key,inter);

%% ==First time procedures===
% x1.unlock();
% x1.setZ();
% x1.setVth('all',4);
% x1.setCth('all',3);
% x1.CCmode(linspace(1,20,20),1);

% ===Main body=========

%channel 36 is bad

% V_array=zeros(1,40);
% C_array=zeros(1,40);
% R_array=zeros(1,40);
% for i=1:40
%     ch=i;
%     x1.setV(ch,3);+
%     x1.setC(ch,1);
% 
%     pause(0.1);
% 
%     V=x1.getV(ch);
%     C=x1.getC(ch);
%     R=V/C;
% 
%     V_array(i)=V;
%     C_array(i)=C;
%     R_array(i)=R;
% end



% histogram(R_array,8);
% plot(R_array);


%% ==Shutdown procedures====
x1.lock();
x1.shutdown();

%% =================
toc