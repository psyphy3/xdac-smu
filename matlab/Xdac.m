%% Class to implement functionalities for nicslab XDAC-40U-R4G8

classdef Xdac
    properties
        Key;
        Ip;
        Req;
        Sub;
        MaxCh=40;
    end

    methods
        %==General methods=====
        function obj=Xdac(ip,key)
            
            obj.Ip=ip;
            obj.Key=key;
            
            ctx = zmq.core.ctx_new();
            % Create Request Socket
            req_socket = zmq.core.socket(ctx, 'ZMQ_REQ');
            req_address = ['tcp://' ip ':5555'];
            zmq.core.connect(req_socket, req_address);
            % Create Subscribe Socket
            sub_socket = zmq.core.socket(ctx, 'ZMQ_SUB');
            sub_address = ['tcp://' XDAC_IP ':5556'];
            zmq.core.connect(sub_socket, sub_address);

            obj.Req=req_socket;
            obj.Sub=sub_socket;
        end

        function out=sendreq(obj,msg)

            msg_send = unicode2native(msg, "UTF-8");
            zmq.core.send(obj.Req, msg_send);
            
            msg_recv=zmq.core.recv(obj.Req);
            out=native2unicode(msg_recv, "UTF-8");
        end

        %==SCPI methods========
        

       function unlock(obj)
            msg="GETINFO:"+obj.Key;
            obj.sendreq(msg);
       end

       function lock(obj)
            msg="LOCK";
            obj.sendreq(msg);
       end

       function config(obj,samples,v_time,c_time)
            msg="CONFIG:"+samples+":"+v_time+":"+c_time;
            obj.sendreq(msg);
       end

       function shutdown(obj)
            msg="EXIT";
            obj.sendreq(msg);
       end

       function setZ(obj) % Set zeros to all channels
           msg="ZERO";

           for ch=1:obj.MaxCh
                obj.sendreq(msg+":"+ch);
           end
       end

       function setV(obj,ch,V)
           msg="SETV";
           obj.temp_set(msg,ch,V);
       end

       function out=getV(obj,ch)
           msg="MEASV";
           out=obj.temp_get(msg,ch);

       end

       function setC(obj,ch,C)
            msg="SETC";
            obj.temp_set(msg,ch,C);

       end

       function out=getC(obj,ch)
            msg="MEASC";
            out=obj.temp_get(msg,ch);
       end

       function setVth(obj,ch,V)
            msg="SETOVT";
            obj.temp_set(msg,ch,V);
       end

       function setCth(obj,ch,C)
            msg="SETOCT";
            obj.temp_set(msg,ch,C);

       end

       function setVr(obj,ch,r)
            msg="SETR";
            obj.temp_set(msg,ch,r);
       end

        %===Dervied methods========

        function CCmode(obj,chs,v_max,c)
            msg=["SETV","SETC"];
            obj.tempc(msg,chs,v_max,c);
        end

        function CVmode(obj,chs,v,c_max)

            msg=["SETC","SETV"];
            obj.tempc(msg,chs,c_max,v);
        end

        %==Template methods========

        function out=temp_get(obj,msg,ch) % template for get functions
           
           if (isa(ch,'double'))
                len=max(size(ch));
               if len==1
                    out=obj.sendreq(msg+":"+ch);

              elseif len>1
                   out=zeros(1,len);
                   for i=1:len
                       out(i)=obj.sendreq(msg+":"+ch(i));
                   end
               else
                   disp("Invalid input");
               end


           else
               if ch=="all"
                   out=zeros(1,obj.MaxCh);
                   for i=1:obj.MaxCh
                        out(i)=obj.sendreq(msg+":"+i);
                   end

               else
                   disp("Invalid input");
               end
           

           end

          
        end

        function out=temp_set(obj,msg,ch,var1) % template for set functions
            
           if (isa(ch,'double'))
                len=max(size(ch));

               if len==1
                    out=obj.sendreq(msg+":"+ch+":"+var1);
              elseif len>1
                   for i=1:len
                       out=obj.sendreq(msg+":"+ch(i)+":"+var1(i));
                   end
               else
                   disp("Invalid input");
               end


           else
               if ch=="all"

                   for i=1:obj.MaxCh
                        out=obj.sendreq(msg+":"+i+":"+var1);
                   end

               else
                   disp("Invalid input");
               end
           

           end
        end

        function tempc(obj,msg,ch,var1,var2) % template for cc and cv modes
            
           if (isa(ch,'double'))
                len=max(size(ch));

               if len==1
                    obj.sendreq(msg(1)+":"+ch+":"+var1);
                    obj.sendreq(msg(2)+":"+ch+":"+var2);
              elseif len>1
                   for i=1:len
                       obj.sendreq(msg(1)+":"+ch(i)+":"+var1(i));
                       obj.sendreq(msg(2)+":"+ch(i)+":"+var2(i));
                   end
               else
                   disp("Invalid input");
               end


           else
               if ch=="all"

                   for i=1:obj.MaxCh
                        obj.sendreq(msg(1)+":"+i+":"+var1);
                        obj.sendreq(msg(2)+":"+i+":"+var2);
                   end

               else
                   disp("Invalid input");
               end
           

           end
        end
    end

    
end