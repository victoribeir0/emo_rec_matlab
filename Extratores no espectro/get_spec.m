% Calcula o espectrograma de um sinal x.
% x = Sinal.
% Fs = Freq. de amostragem.
% Tjan = Duração de cada janela (em ms).
% Tav = Tempo de avanço (em ms).

function [S, L] = get_spec(x, Fs, Tjan, Tav, plot_img, rnn)

% L = Comprimento de cada janela (am amostras).
L = round((Tjan/1000)*Fs);

% Num. de amostras para o avanço.
Avanco = round((Tav/1000)*Fs);

% Njan = Núm. de janelas totais (incluindo as sobrepostas).
Njan = round((length(x)-L)/Avanco);

% S = Matriz do espectrograma.
% S = zeros(round(L/2),Njan);

janelaHamming = 0.54 - 0.46*cos(2*pi*(0:L-1)/L); %Melhora a análise espectral de curto termo
x = x(1:end-1)-0.97*x(2:end);

cc = 1;
idx = [];

for c = 1:Njan
    apontador = ((c-1)*Avanco) + 1;
    y = x(apontador:apontador + L - 1);
    y=y'.*janelaHamming; %Melhora a análise espectral de curto termo.
    
    % [coefs,yy,erro] = lpc_coefs(y,3);
    % [coefs2,~] = lpc(y,12);
    
    if rnn
        feats = vad_coefs_cada(y);
        prev = feed_vad(feats);
        
        if prev >= 0.6
            y = fft2(y,Fs);
            S(:,cc) = y(:);
            cc = cc + 1;
            % idx = [idx c];
        end
        
    else
        y = fft2(y,Fs);
        S(:,c) = y(:);
    end    
    
end

if plot_img
    imshow(S);
end
end
