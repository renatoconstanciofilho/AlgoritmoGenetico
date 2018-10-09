function [c1,c2] = cyclicXover(p1,p2)
c1
%function [c1,c2] = cyclicXover(p1,p2,bounds,Ops) %-> Função original
% https://github.com/estsauver/GAOT/blob/master/cyclicXover.m
% Cyclic crossover takes two parents P1,P2 and performs cyclic
% crossover by Davis on permutation strings.  
%
% function [c1,c2] = cyclicXover(p1,p2,bounds,Ops)
% p1      - the first parent ( [solution string function value] )
% p2      - the second parent ( [solution string function value] )
% bounds  - the bounds matrix for the solution space
% Ops     - Options matrix for simple crossover [gen #SimpXovers].

% Binary and Real-Valued Simulation Evolution for Matlab 
% Copyright (C) 1996 C.R. Houck, J.A. Joines, M.G. Kay 
%
% C.R. Houck, J.Joines, and M.Kay. A genetic algorithm for function
% optimization: A Matlab implementation. ACM Transactions on Mathmatical
% Software, Submitted 1996.
%
% This program is free software; you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation; either version 1, or (at your option)
% any later version.
%
% This program is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details. A copy of the GNU 
% General Public License can be obtained from the 
% Free Software Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.

sz = size(p1,2); % salva o tamanho de p1 em sz
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