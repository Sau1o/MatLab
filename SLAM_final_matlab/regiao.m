%recebe como parametros de entrada um vetor de valores em x
%e um vetor com valores em y e retorna quais a linhas e colunas máximas
%definem a região do cone.
function [imin imax jmin jmax] = regiao(X,Y,gridx,gridy);
    imin = 16 - ceil(max(Y) / gridy);
    if imin <= 0 imin = 1 
    end
    imax = 16 - ceil(min(Y) / gridy);
    if imax >= 16 imax = 15
    end
    jmin = ceil(min(X) / gridx) ;
    if jmin <= 0 jmin = 1 
    end
    jmax = ceil(max(X) / gridx);
    if jmax >= 26 jmax = 25 
    end
end