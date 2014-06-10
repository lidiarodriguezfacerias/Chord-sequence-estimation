
function [detected_chord]=chord_estimation(hpcp,chord,root,tema, ind_beat)

%Output: detected chord: struct with fields:
    %root, rootname, type,typename
    %root2, rootname2, type2, typename2
    % R, hpcp
   
showfig=0;
seq_hpcp = hpcp;
hpcpsize = length(hpcp);

mean_hpcp = mean(hpcp);
var_hpcp  = sqrt( sum( (hpcp-mean_hpcp).*(hpcp-mean_hpcp) ) );

Nchords = 7;
for i=1:Nchords
    mean_profile(i) = mean(chord(i).profile);
    var_profile(i) = var(chord(i).profile);
end

R = zeros(7,hpcpsize);

for i=1:(hpcpsize)
    for j=1:Nchords
    vector = [chord(j).profile(hpcpsize-(i-1):hpcpsize) chord(j).profile(1:hpcpsize-i)];
    R(j,i+1) = sum( (hpcp-mean_hpcp) .* (vector-mean_profile(j)) ) / (var_hpcp*var_profile(j));         
    end
end


[fila index] = max(R');
[r mode] = max(fila);
aux_root = index(mode);

if(aux_root == 13) 
    aux_root = 1;
end
d_rootname = root(aux_root).name;
d_typename = chord(mode).name;

X = fprintf('%s %s, ', d_rootname, d_typename);

detected_chord.root = aux_root;
detected_chord.type = mode;
detected_chord.rootname = d_rootname;
detected_chord.typename = d_typename;

% Find 2nd chord max
aux = R(mode, aux_root); R(mode,aux_root) = 0;

[fila2 index2] = max(R');
[r2 mode2] = max(fila2);
aux_root2 = index(mode2);

R(mode,aux_root) = aux;

if(aux_root2 == 13) 
    aux_root2 = 1;
end

d_rootname2 = root(aux_root2).name;
d_typename2 = chord(mode2).name;

X = fprintf('AUX: %s %s, \n', d_rootname2, d_typename2);

detected_chord.root2 = aux_root2;
detected_chord.type2 = mode2;
detected_chord.rootname2 = d_rootname2;
detected_chord.typename2 = d_typename2;
detected_chord.R = R;
detected_chord.hpcp = hpcp;

if showfig
    aux=(1:12);
    f = figure;
    subplot(311)
    plot(hpcp)
    ylabel('HPCP value');    
    set(gca,'xtick',aux);
    set(gca,'XTickLabel',{'A';'#';'B';'C';'#';'D';'#';'E';'F';'#';'G';'#';});
    grid;
    subplot(711);
    plot(R(1,:));
    xlabel('key note');
    ylabel('corr coeff Major');
    set(gca,'xtick',aux);
    set(gca,'XTickLabel',{'A';'#';'B';'C';'#';'D';'#';'E';'F';'#';'G';'#'});
    grid;
    
    subplot(712);
    plot(R(2,:));
    xlabel('key note');
    ylabel('corr coeff Major');
    set(gca,'xtick',aux);
    set(gca,'XTickLabel',{'A';'#';'B';'C';'#';'D';'#';'E';'F';'#';'G';'#'});
    grid;
    
    subplot(713);
    plot(R(3,:));
    xlabel('key note');
    ylabel('corr coeff  minor');
    set(gca,'xtick',aux);
    set(gca,'XTickLabel',{'A';'#';'B';'C';'#';'D';'#';'E';'F';'#';'G';'#';});
    grid;
    
    subplot(714);
    plot(R(4,:));
    xlabel('key note');
    ylabel('corr coeff  minor');
    set(gca,'xtick',aux);
    set(gca,'XTickLabel',{'A';'#';'B';'C';'#';'D';'#';'E';'F';'#';'G';'#';});
    grid;    subplot(715);
    plot(R(5,:));
    xlabel('key note');
    ylabel('corr coeff  minor');
    set(gca,'xtick',aux);
    set(gca,'XTickLabel',{'A';'#';'B';'C';'#';'D';'#';'E';'F';'#';'G';'#';});
    grid;    subplot(716);
    plot(R(6,:));
    xlabel('key note');
    ylabel('corr coeff  minor');
    set(gca,'xtick',aux);
    set(gca,'XTickLabel',{'A';'#';'B';'C';'#';'D';'#';'E';'F';'#';'G';'#';});
    grid;    subplot(717);
    plot(R(7,:));
    xlabel('key note');
    ylabel('corr coeff  minor');
    set(gca,'xtick',aux);
    set(gca,'XTickLabel',{'A';'#';'B';'C';'#';'D';'#';'E';'F';'#';'G';'#';});
   
end



end

