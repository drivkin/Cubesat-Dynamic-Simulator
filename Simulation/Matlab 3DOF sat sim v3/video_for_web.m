fabric=permute(full_canvas,[2 1 3]);;%permute(full_canvas,[2 1 3]);

xlen = size(fabric,1)
ylen = size(fabric,2)

%corners:

% one half length of one side of camera in pixels ( camera is square)
cPixX = 380;
cPixY = 250;
%M=zeros(2*cPix,2*cPix,3);

writerObj = VideoWriter('firstrun.mp4');
writerObj.FrameRate = 1000/30;
open(writerObj);
for i=10:30:20000%size(Tb_i_m,3)
    i
    [yaw pitch roll]=dcm2angle(Tb_i_m(:,:,i));
    
    %middle pixel
    mpx = round(((yaw+pi)*xlen)/(2*pi));
    mpy = round(((pitch+pi/2)*ylen)/(pi));
    
    pxmin = mpx - cPixX;
    pxmax = mpx + cPixX-1;
    
    pymin = mpy - cPixY;
    pymax = mpy + cPixY - 1;
    
    
    
    
    %wrap around
    if (pymin < 1 || pxmin<1 || pxmax > xlen || pymax > ylen)
        %find corners
        bl = [pxmin pymin];
        tl = [pxmin pymax];
        br = [pxmax pymin];
        tr = [pxmax pymax];
        
        if(pxmin<1)
            bl(1) = pxmin+xlen;
            tl(1) = pxmin+xlen;
        end
        
        if(pxmax>xlen)
            br(1) = pxmax - xlen;
            tr(1) = pxmax - xlen;
        end
        
        if(pymin<1)
            bl(2) = pymin+ylen;
            br(2) = pymin+ylen;
        end
        
        if(pymax>ylen)
            tl(2) = pymax - ylen;
            tr(2) = pymax - ylen;
        end
        
        frame = fabric(1:2*cPixX,1:2*cPixY,:);
        
        %bottom left up and out
        frame(1:first_above(bl(1),br(1),xlen) - bl(1)+1,1:first_above(bl(2),tl(2),ylen)-bl(2)+1,:)...
            = fabric(bl(1):first_above(bl(1),br(1),xlen),bl(2):first_above(bl(2),tl(2),ylen),:);
        
        %top left down and out
        frame(1:first_above(tl(1),tr(1),xlen)-tl(1)+1,size(frame,2)-(tl(2)-first_below(tl(2),1,bl(2))):size(frame,2),:)...
            = fabric(tl(1):first_above(tl(1),tr(1),xlen),first_below(tl(2),1,bl(2)):tl(2),:);
        
        %bottom right back and up
        frame(size(frame,1)-(br(1)-first_below(br(1),bl(1),1)):size(frame,1),1:first_above(br(2),tr(2),ylen)-br(2)+1,:)...
            =fabric(first_below(br(1),bl(1),1):br(1),br(2):first_above(br(2),tr(2),ylen),:);
        
        %top right back and down
        frame(size(frame,1)-(tr(1)-first_below(tr(1),tl(1),1)):size(frame,1),size(frame,2)-(tr(2)-first_below(tr(2),br(2),1)):size(frame,2),:) ...
            =fabric(first_below(tr(1),tl(1),1):tr(1),first_below(tr(2),br(2),1):tr(2),:);
        
    else
        
        frame=fabric(pxmin:pxmax,pymin:pymax,:);
    end
    writeVideo(writerObj,permute(frame,[2 1 3]));
end
    
close(writerObj);
        
            
        
        

        
       
            
            
        
        
    