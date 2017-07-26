function [a b reta] = reta(Sx,Sy,Px,Py);
    reta = 0;
    if (Sx == Px)
        a = 0;
        b = 0;
        reta = 1;
        line([Px Px],[min(Py,Sy) max(Py,Sy)])
    else
        a = (Py - Sy) / (Px - Sx);
        b = -a*Sx+Sy; 
        x = linspace(min(Sx,Px),max(Sx,Px));
        y = a*x + b;
        plot(x,y)
    end
end