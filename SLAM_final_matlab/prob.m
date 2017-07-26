%Trabalho apresentado para a disciplina Robótica
%professor Dr. Marcelo
%Geração das linhas de atuação de um sensor ultrassonico e
%Calculo das probabildades das celulas estarem ocupadas e vazias
%19/07/2016
%Recebe os seguintes parametros
%S = vetor das coordenadas x e y de cada disparo do sensor
%R = vetor da distancia retornada pelo sensor em cada tiro
%t = vetor da inclinação do robo com a horizontal em cada tiro
%Rmin = constante. Distancia do ponto cego do sensor
%w = consntante. Abertura do cone
%erro = erro da leitura do sensor

function [M K] = prob(S,R,t,Rmin,w,erro);

gridx = 0.4; %grid quadrado gridx = gridy
gridy = gridx;
i = 0;
j = 0;

Lin= 15;
Col= 25;
M = zeros(Lin,Col); %matriz para desenhar o cone
K = zeros(Lin,Col); %matriz das probabilidades

for m=1:length(t)
%calculos dos pontos dos segmentos da reta
%linha superior do cone
P1x = S(m,1) + cosd(t(m) + 15)*(R(m)+ erro);
P1y = S(m,2) + sind(t(m) + 15)*(R(m)+ erro);

%linha inferior do cone
P2x = S(m,1) + cosd(t(m) - 15)*(R(m)+ erro);
P2y = S(m,2) + sind(t(m) - 15)*(R(m)+ erro);

figure(1)
hold on
axis([0 10 0 6])
grid on
set(gca, 'XTick',0:0.4:10);
set(gca, 'YTick',0:0.4:6);
title('Linhas de atuação do sensor');

%reta da linha superior do cone
[ap1 bp1 reta_vertical_1] = reta(S(m,1),S(m,2),P1x,P1y);

%reta da linha inferior do cone
[ap2 bp2 reta_vertical_2] = reta(S(m,1),S(m,2),P2x,P2y);

%arco do cone aproximado para uma reta
[ap3 bp3 reta_vertical_3] = reta(P1x,P1y,P2x,P2y);

%monta uma matriz com os dados das retas
retas = [ap1 bp1 reta_vertical_1;
         ap2 bp2 reta_vertical_2;
         ap3 bp3 reta_vertical_3];
     
pontos = [S(m,1) P1x P2x;
          S(m,2) P1y P2y];
      
%hold off

%define região do cone
[imin imax jmin jmax] = regiao([S(m,1) P1x P2x],[S(m,2) P1y P2y],gridx,gridy);
    
for k = 1:3
    %varre as linhas do grid dentro do intervalo da reta
    %calcula a probabilidade para cada uma das celulas cortadas pela
    %linha do sensor
    for i=imin : imax
        for j=jmin : jmax
            [xcellmin xcellmax ycellmin ycellmax]= xycell(i,j);

            if(retas(k,3))  %reta vertical
                if(pontos(1,k) <= xcellmax & pontos(1,k) >= xcellmin)
                    M(i,j) = 1;
                end
            else
                %pe = Pontos de intersecção das retas
                %x,y da reta horizontal min x,y reta vertical min
                pe = [(ycellmin-retas(k,2))/retas(k,1) ycellmin xcellmin xcellmin*retas(k,1) + retas(k,2);
                      (ycellmax-retas(k,2))/retas(k,1) ycellmax xcellmax xcellmax*retas(k,1) + retas(k,2)];
        
                %valida o intervalo dos pontos
                for n= 1 : 2
                    %teste da linha horizontal
                    if pe(n,1) >= xcellmin & pe(n,1) <= (xcellmax) & pe(n,2) > ycellmin & pe(n,2) <= ycellmax
                        M(i,j) = 1;
                    end
                    %teste da linha vertical
                    if pe(n,3) >= xcellmin & pe(n,3) <= xcellmax & pe(n,4) > ycellmin & pe(n,4) <= ycellmax
                        M(i,j) = 1;
                    end    
                end 
            end
            
            r = sqrt((ycellmax - S(m,2))^2+(xcellmax - S(m,1))^2);
            theta = atand((ycellmax - S(m,2)) / (xcellmax - S(m,1)))-t(m);
            
            if r >= Rmin && r < (R(m) - erro) && theta >= -w/2 && theta <= +w/2 
                if M(i,j) == 1
                    K(i,j) = 0;
                else
                    K(i,j)= (1 -(((r-Rmin)/(R(m)-erro-Rmin))^2))* (1- ((2*theta)/w)^2);
                end
            else if r >= (R(m)-erro) && r < (R(m) + erro) && theta >= -w/2 && theta <= +w/2 
                if M(i,j) == 1
                    K(i,j) = 0;
                else
                    K(i,j)= -1*(1 -(((r-R(m))/(erro))^2))* (1- ((2*theta)/w)^2);
                end
                else
                    K(i,j) = 0;
                end
            end       
        end
    end
end

K
    
figure(2)
colormap(gray);
imagesc(~M)
grid on
set(gca, 'XTick',0.5:1:25);
set(gca, 'YTick',0.5:1:15);
title('Celulas marcadas');

figure(3)
surf(K)
end