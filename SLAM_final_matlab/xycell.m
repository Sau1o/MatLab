%Essa fun��o recebe como parametro a linha e coluna de uma celula
%e retorna os limites m�ximos e minimos em x e y da celula
function [xcellmin xcellmax ycellmin ycellmax] = xycell(i,j);
    xcellmax = j*0.4;
    xcellmin = j*0.4 - 0.4;
        
    ycellmin = 6 - i*0.4;
    ycellmax = ycellmin + 0.4;
end
