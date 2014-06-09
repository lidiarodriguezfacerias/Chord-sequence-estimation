% reads a csv file, calculates the temporal mean for each 12 bin and plots
% the hpcp chromagram and each bin's mean
%input: filename
%output: bin mean

function [ chroma_mean ] = hpcpread( csv)


nbins = 12;
showfig = 0;


[a,b] = size(csv);


%% Ponderem HPCP de 120 a 12 bins
for k = 1:a
    j = 1;
for i=2:10:b
     
    if  (i == 2)
        HPCP12(k,j) = (csv(k,2) + 0.4*csv(k,3) + 0.3*csv(k,4) + 0.2*csv(k,5) + 0.1*csv(k,6) ...
    + 0.4*csv(k,121) + 0.3*csv(k,120) + 0.2*csv(k,119) + 0.1*csv(k,118))/3;

    else
    HPCP12(k,j) = (0.1*csv(k,i-4) + 0.2*csv(k,i-3) + 0.3*csv(k,i-2) + 0.4*csv(k,i-1) + csv(k,i) ...
        + 0.1*csv(k,i+4) + 0.2*csv(k,i+3) + 0.3*csv(k,i+2) + 0.4*csv(k,i+1))/3;
        
    end
    j = j+1;
end
    
HPCP12(:,13) = 0;

end

 %% CANVIAR   
 
 
 
   % HPCP12 = zeros(a,12);
  % nbinsperoctave = round((b-1)/12);
   %HPCP12 = csv(:,2:nbinsperoctave:b);

    for i = 1:nbins
        chroma_mean(i) = mean(HPCP12(:,i)); %mitjana presencia chroma per cada st
    end

aux_csv = csv(:,2:121);
if showfig
%     subplot 311
% tx = 1:b-1;
% ty = 1:a;
% surf (tx,ty,aux_csv);
% xlabel('bin');
% str = sprintf('HPCP 120 bins for %s %s',chord.rootname, chord.typename);
% title(str);
% ylabel('window');
% view(90,-90);

subplot 211

tx = 1:13;
ty = 1:a;
surf (tx,ty,HPCP12);
xlabel('bin');
str = sprintf('HPCP 12 bins for %s %s',chord.rootname, chord.typename);
title(str);
ylabel('window');
view(90,-90);


% Plot chroma 
subplot 212
plot(chroma_mean,'-o'),
str = sprintf('Chroma mean for %s %s',chord.rootname, chord.typename);
title(str);

aux=(1:nbins);
xlabel('notes');
ylabel('HPCP mean value');
set(gca,'xtick',aux); set(gca,'XTickLabel',{'A';'#';'B';'C';'#';'D';'#';'E';'F';'#';'G';'#'});
grid on
end
    
end