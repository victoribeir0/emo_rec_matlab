% Obt�m o modelo GMM para cada emo��o.
% K = N�mero de centros (gaussianas) para o GMM.
% ext = Tipo de extrator a ser usado ('mfcc', 'f0', etc.).
% rnn = VAD com rede neural (0 ou 1).
% [p0,c,S,L] = Par�metros do GMM (para cada emo��o).

function [p0,C,cov,L] = get_emo_gmm(K,ext,rnn)

folder = 'C:\Users\victo\Documents\Dataset _ EmoDB2';
cd(folder);

if strcmp(ext, 'f0')
    load('emo_full_treino.mat');
    
elseif strcmp(ext, 'mfcc')
    load('emo_mfcc_treino.mat');
end

% Inicaliza��o dos par�metros do GMM (para cada emo��o).

C = [];
cov = [];
p0 = [];
L = [];

% Emo��es a serem procuradas.
emos = ['T';'W';'F';'N'];
% emos = 'T';

% La�o for para cada emo��o.
for k = 1:length(emos)
    
    % Extrai as caracter�sticas para cada emo��o.
    % emo��o, vad-rnn (1 ou 0), extrator ('mfcc', 'f0', ...).
    % y = get_emo_feats(emos(k),rnn,ext,'treino');
    if strcmp(ext, 'f0')
        y = emo_full_treino{k};
    elseif strcmp(ext, 'mfcc')
        y = emo_mfcc_treino{k};
    end
    
    
    y = y(9:12,:);
    
    % Determina os par�metros do GMM para uma emo��o.
    [p0n,cn,Sn,Ln] = gmm_em_2(y', K, 10, 0);
    
    % Agrupa os par�metros do GMM, cada emo��o em uma dimens�o diferente.
    p0 = cat(1,p0,p0n');
    L = cat(1,L,Ln);
    C = cat(3,C,cn);
    cov = cat(3,cov,Sn);
    
    % emo_full_treino{k} = y;
end