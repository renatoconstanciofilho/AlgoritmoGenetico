close all; clc; clear;

%https://www.mathworks.com/help/gads/genetic-algorithm-options.html
%https://www.mathworks.com/help/gads/vary-mutation-and-crossover.html

global iag x y
%% Configuracao Inicial
npar=20; % numero das variaveis para serem otimizadas (genes)
Nt=npar; % numero de colunas da matriz de populacao

x=rand(1,npar);
y=rand(1,npar); % cidades em (cidadeX, cidadeY)

% Adiciona o numero maximo de interacoes (Criterio de Parada)
maxit=10000;%numero de interações
% Parametros do AG
tamPop=20;% tamanho da populacao
mutacao=0.05;% taxa de mutacao (probabilidade de 0.05)
selecao=0.5; % fracao da populacao a ser mantida
manter=floor(selecao*tamPop); % numero de membros da populacao que sobrevivem
M=ceil((tamPop-manter)/2); % numero de cruzamentos

% calculo da probabilidade para a selecao dos pais
probab=1; %probabilidade
for ii=2:manter
    probab=[probab ii*ones(1,ii)];
end
Nprobab=length(probab);
probab=manter-probab+1; 


% Gerar a populacao inicial
iag=0; % contador para iniciar a geracao
for ij=1:tamPop
  pop(ij,:)=randperm(npar); %distribuir numeros de 1 a 20 em uma matriz
end

% gerar a populacao aleatoria (Veja funcao randperm)
% deve ser uma matriz 20x20 (cromossomo + n. da populacao)

custoPop = cvfun(pop);%calcular o custo da populacao utilizando a funcao de aptidao
[custoPop, ind] = sort(custoPop);% colocar o custo minimo no elemento 1 (Veja funcao sort)
pop = pop(ind,:);% organizar a populacao com o custo mais baixo primeiro
minc(1) = min(custoPop);% calcula o custo minimo da populacao (veja funcao min)
meanc(1) = mean(custoPop);% calcula a media aritmetica da populacao (veja funcao mean)

%% Interacao pelas geracoes (LOOP PRINCIPAL)
hold on;
while iag<maxit
    iag=iag+1; % incrementa o contador de geracoes
    
    % Escolha do Pai1 e Pa2 que são escolhidos aleatoriamente do vetor
    % probab
    escolha1=ceil(Nprobab*rand(1,M)); % escolher aleatoriamente na roleta os indivíduos
    escolha2=ceil(Nprobab*rand(1,M)); % escolher aleatoriamente na roleta os indivíduos
    indPai1=probab(escolha1); % selecionar os indices escolhidos na roleta para o pai 1
    indPai2=probab(escolha2); % selecionar os indices escolhidos na roleta para o pai 2
    
    % Execucao da Recombinacao (crossover)
    %% CyclicXover
    % https://github.com/estsauver/GAOT/blob/master/cyclicXover.m
    filhos = [];
    for ic=1:M
        p1=pop(indPai1(ic),:);%seleciona o Pai 1
        p2=pop(indPai2(ic),:);%seleciona o Pai 2 
        sz = size(p1,2);
        c1=zeros(1,sz); % cria o vetor c1 e c2 do tamanho de p1 preenchido por zero
        c2=zeros(1,sz);
        pt=find(p1==1); % salva em pt a posicao do 1 no vetor p1
        while (c1(pt)==0) % enquanto c1 posicao pt for 0
          c1(pt)=p1(pt); % copia a o valor de p1 na posicao pt para c1 na posicao pt
          pt=find(p1==p2(pt)); % verifica em qual posicao de p1 encontra o numero na posicao pt de p2
        end
        left=find(c1==0); % salva no vetor left as posicoes de c1 que contem zero
        c1(left)=p2(left); % copia para as posicoes que contem zero os valores das mesmas posicoes de p2
        % repete a operação em c2
        pt=find(p2==1); 
        while (c2(pt)==0)
          c2(pt)=p2(pt);
          pt=find(p2==p1(pt));
        end
        left=find(c2==0);
        c2(left)=p1(left);
        filhos = [filhos;c1];
        filhos = [filhos;c2];
    end
    
    %mantem os 10 pais matriz manter / pegar os 10 filhos
    pop(11:20,:) = filhos; % sobrepõe a matriz pop da linha 11 a 20 com os filhos gerados
    
    %% Swap mutation
    % https://github.com/estsauver/GAOT/blob/master/swapMutation.m
    % https://www.tutorialspoint.com/genetic_algorithms/genetic_algorithms_mutation.htm
    % http://www.rubicite.com/Tutorials/GeneticAlgorithms/CrossoverOperators/CycleCrossoverOperator.aspx
    % Faz a Mutacao da populacao
    for im=1:tamPop
        par = pop(im,:);
        sz = size(par,2)-1;
        pos1 = round(rand*sz + 0.5);
        pos2 = round(rand*sz + 0.5);
        if pos1 ~= pos2
           if pos1 > pos2
              t = pos1; pos1 = pos2; pos2 = t;
           end
           child = [par(1:pos1-1) par(pos2) par(pos1+1:pos2-1) par(pos1) par(pos2+1:(sz+1))];
        else
           child = par;
        end
        pop(im,:) = child;
    end
    %% Recalcula custo e reorganiza população
    custoPop = cvfun(pop);%calcular o custo da populacao utilizando a funcao de aptidao
    [custoPop, ind] = sort(custoPop);% colocar o custo minimo no elemento 1 (Veja funcao sort)
    pop = pop(ind,:);% organizar a populacao com o custo mais baixo primeiro
    minc(1) = min(custoPop);% calcula o custo minimo da populacao (veja funcao min)
    meanc(1) = mean(custoPop);% calcula a media aritmetica da populacao (veja funcao mean)
    %plot(iag,minc(1),'.');
    plot(iag,meanc(1),'.');
end %iga
%% Mostrar os resultados
melhorCaminho = [pop(1,:) pop(1,1)];
disp(['Melhor caminho: ', num2str(melhorCaminho)]);
%num2str(pop(1,:))]);
disp(['Menor custo: ', num2str(custoPop(1,:))]);
linhaX = [];
linhaY = [];
for ip = 1:length(melhorCaminho)
    linhaX(ip) = x(melhorCaminho(ip));
    linhaY(ip) = y(melhorCaminho(ip));
end
% https://www.mathworks.com/matlabcentral/fileexchange/25542-nearest-neighbor-algorithm-for-the-travelling-salesman-problem    
figure;
mapshow(x,y,'DisplayType','point');
line(linhaX,linhaY);
shg;
%figure;
%plot(x,y);

