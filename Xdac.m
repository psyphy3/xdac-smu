%%Class to implement functionalities for nicslab XDAC-40U-R4G8

classdef Xdac
    properties
        Key;
        Interface;
        MaxV=2;
        MaxC=2;
        MaxCh=40;
    end

    methods
        %==General methods=====
        function obj=Xdac(k,i)
            obj.Key=k;
            obj.Interface=i;
        end

        function out=sendreq(obj,msg)
            [status,cmdout]=system("python "+obj.Interface+" "+msg);
            if(status==1)
                disp("Error during command execution");
            end
            out=str2double(cmdout(3:length(cmdout)-2));

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

       function setZ(obj)
           msg="ZERO";

           for ch=1:obj.MaxCh
                obj.sendreq(msg+":"+ch);
           end
       end

       function setV(obj,ch,V)
           msg="SETV";
           obj.temp2(msg,ch,V);
       end

       function out=getV(obj,ch)
           msg="MEASV";
           out=obj.temp1(msg,ch);

       end

       function setC(obj,ch,C)
            msg="SETC";
            obj.temp2(msg,ch,C);

       end

       function out=getC(obj,ch)
            msg="MEASC";
            out=obj.temp1(msg,ch);
       end

       function setVth(obj,ch,V)
            msg="SETOVT";
            obj.temp2(msg,ch,V);
       end

       function setCth(obj,ch,C)
            msg="SETOCT";
            obj.temp2(msg,ch,C);

       end

       function setVr(obj,ch,r)
            msg="SETR";
            obj.temp2(msg,ch,r);
       end

        %===Dervied methods========

        function CCmode(obj,chs,c)

            for i=1:max(size(chs))
                obj.setV(chs(i),obj.MaxV);
                obj.setC(chs(i),c)
            end
        end

        function CVmode(obj,chs,v)

            for i=1:max(size(chs))
                obj.setC(chs(i),obj.MaxC);
                obj.setV(chs(i),v)
            end
        end

        %==Template methods========

        function out=temp1(obj,msg,var1) % 1 variable template
           
           if (isa(var1,'double'))
                len=max(size(var1));
               if len==1
                    out=obj.sendreq(msg+":"+var1);

              elseif len>1
                   out=zeros(1,len);
                   for i=1:len
                       out(i)=obj.sendreq(msg+":"+var1(i));
                   end
               else
                   disp("Invalid input");
               end


           else
               if var1=="all"
                   out=zeros(1,obj.MaxCh);
                   for i=1:obj.MaxCh
                        out(i)=obj.sendreq(msg+":"+i);
                   end

               else
                   disp("Invalid input");
               end
           

           end

          
        end

        function out=temp2(obj,msg,var1,var2) % 2 variable template
            
           if (isa(var1,'double'))
                len=max(size(var1));

               if len==1
                    out=obj.sendreq(msg+":"+var1+":"+var2);
              elseif len>1
                   for i=1:len
                       out=obj.sendreq(msg+":"+var1(i)+":"+var2(i));
                   end
               else
                   disp("Invalid input");
               end


           else
               if var1=="all"

                   for i=1:obj.MaxCh
                        out=obj.sendreq(msg+":"+i+":"+var2);
                   end

               else
                   disp("Invalid input");
               end
           

           end
        end
    end
end
