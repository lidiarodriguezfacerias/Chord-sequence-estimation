
% Evaluation Chord Sequence detected

%% 1st method : Global Correlation

 % Computation of Global HPCP mean for each standard of the dictionary
for k = 1:length(tema)   
    d = length(tema(k).typesequence);
    for i=1:12    
        for j = 1: d
            aux = circshift(chord(tema(k).typesequence(j)).profile, [0 (tema(k).rootsequence(j)-1)]);
            globtema_aux(j,i,k) = aux(1,i);
        end
    end
end

for k = 1:length(tema)
    for i = 1:12
        global_tema_mean(k,i) = mean(globtema_aux(:,i,k));
    end
end

% Computation of HPCP for each detected sequence

[a b] = size(detected_sequence);

for k = 1: b
[c d] = size(detected_sequence(1,k).detected);
    for i=1:12
         for j=1:d
             globhpcp_aux(j,i,k) = ([detected_sequence(1,k).detected(1,j).hpcp(1,i)]);
         end
     end
end

for k = 1:b
    for i = 1:12
        global_hpcp_mean(k,i) = mean(globhpcp_aux(:,i,k));
    end
end


% Correlation computation
 
for i = 1:b
    for j=1:length(tema)      
        aux_corrcoef = corrcoef(global_hpcp_mean(i,:), global_tema_mean(j,:));
        corr_coef(i,j) = aux_corrcoef(1,2);
            if (corr_coef(i,j) < 0) 
                corr_coef(i,j)= 1+corr_coef(i,j);
            end
    end
end

for i = 1:b
    index_1(i) = find(corr_coef(i,:) == max(corr_coef(i,:)));
end


%% 2nd method: Chord histogram


% CREATE STANDARD HISTOGRAM

aa = length(tema);
Hist0 = zeros(7,13,aa);

for j = 1: aa
    for i = 1:length(tema(j).rootsequence)    
        a = tema(j).typesequence(1,i);
        b = tema(j).rootsequence(1,i);
        Hist0(a,b,j) = Hist0(a,b,j)+1;
    end
    Hist0(:,:,j) = Hist0(:,:,j) ./ max(max(Hist0(:,:,j)));
end

% Hist1
c = length(detected_sequence);

Hist1 = zeros(7,13,c);
for j = 1:length(detected_sequence)
    for i = 1:length(detected_sequence(1,j).detected)
        a = detected_sequence(1,j).detected(1,i).type;
        b = detected_sequence(1,j).detected(1,i).root;
        Hist1(a,b,j) = Hist1(a,b,j)+1;
    end
    Hist1(:,:,j) = Hist1(:,:,j) / max(max(Hist1(:,:,j)));

end


% Hist12

c = length(detected_sequence);

Hist12 = zeros(7,13,c);
for j = 1:length(detected_sequence)
    for i = 1:length(detected_sequence(1,j).detected)

        a = detected_sequence(1,j).detected(1,i).type;
        b = detected_sequence(1,j).detected(1,i).root;
        d = detected_sequence(1,j).detected(1,i).type2;
        e = detected_sequence(1,j).detected(1,i).root2;
        Hist12(a,b,j) = Hist12(a,b,j)+1;
        Hist12(d,e,j) = Hist12(d,e,j)+1;
    end
    Hist12(:,:,j) = Hist12(:,:,j) / max(max(Hist12(:,:,j)));
end

% HistR

c = length(detected_sequence);

HistR = zeros(7,13,c);
for j = 1:length(detected_sequence)
    for i = 1:length(detected_sequence(1,j).detected)

        a = detected_sequence(1,j).detected(1,i).type;
        b = detected_sequence(1,j).detected(1,i).root;
        d = detected_sequence(1,j).detected(1,i).type2;
        e = detected_sequence(1,j).detected(1,i).root2;
        HistR(a,b,j) = HistR(a,b,j)+detected_sequence(1,j).detected(1,i).R(a,b);
        HistR(d,e,j) = HistR(d,e,j)+detected_sequence(1,j).detected(1,i).R(d,e);
    end
    HistR(:,:,j) = HistR(:,:,j) / max(max(HistR(:,:,j)));
end


[a0 b0 c0] = size(Hist0);
[a1 b1 c1] = size(Hist1);
[a12 b12 c12] = size(Hist12);
[aR bR cR] = size(HistR);

% Histogram corr matrix 1 max corr chord

for a = 1:c1 
    for b = 1 : c0  
                       
        aa = Hist1(:,:,a);
        bb = Hist0(:,:,b);
        cc = corrcoef(aa,bb);
        hc_matrix1(a,b) = cc(1,2);
    end
end

[max_2 index_2] =max(hc_matrix1, [], 2); % Max for each detected sequence

aux = hc_matrix1 (:,index_2); hc_matrix1(:,index_2) = 0;

[max_22 index_22] =max(hc_matrix1, [], 2); % 2nd Max for each detected sequence
hc_matrix1(:,index_2) = aux;

[CM_2, index_CM2] = confusionmat(original_standard, index_2); 


% Histogram corr matrix with 2 max corr chord

for a = 1:c12 
    for b = 1 : c0 % N de temes
   
        aa = Hist12(:,:,a);
        bb = Hist0(:,:,b);
        
        cc = corrcoef(aa,bb);
        hc_matrix12(a,b) = cc(1,2);
    end
end

[max_3 index_3] =max(hc_matrix12, [], 2);
[CM_3, index_CM3] = confusionmat(original_standard, index_3); 

aux = hc_matrix12(:,index_3); hc_matrix12(:,index_3) = 0;
[max_32 index_32] =max(hc_matrix12, [], 2); % Max for each detected sequence
hc_matrix12(:,index_3) = aux;

% Hist with R values

for a = 1:cR
    for b = 1 : c0 % N de temes

        aa = HistR(:,:,a);
        bb = Hist0(:,:,b);
        cc = corrcoef(aa,bb);
        hc_matrixR(a,b) = cc(1,2);
    end
end

[max_R index_4] =max(hc_matrixR, [], 2); %Max for each detected sequence
[CM_4, index_CM4] = confusionmat(original_standard, index_4); 

aux = hc_matrixR(:,index_4); hc_matrixR(:,index_4) = 0;
[max_42 index_42] =max(hc_matrixR, [], 2); % 2ndMax for each detected sequence
hc_matrixR(:,index_4) = aux;


%% 3rd method: HPCP correlation


% Create HPCP matrix
for i = 1:length(detected_sequence)
    for j = 1:length(detected_sequence(i).detected)
        hpcp_detected(j,1:12,i) = detected_sequence(i).detected(j).hpcp(1,:)';
    end
end

for i=  1:length(detected_sequence)
    for j = 1:length(tema)
        
      [a ~] =  size(tema(1,j).hpcp);
      
      x = hpcp_detected(:,:,i);
      
      hpcp_det = x(find(sum(x')>0),:);
      hpcp_def = zeros(size(hpcp_det));
      
      [b c]  = size(hpcp_det);

      if (a<b)
          for k = a:b
              d = round(b/a);
              hpcp_det(d,:) = hpcp_det(d,:) + hpcp_det(k,:); 
          end
      end

      if (a>b) 
          corr_HPCP = corrcoef(tema(1,j).hpcp(1:b,:), hpcp_det);
      end
      
      if (a == b)
        corr_HPCP = corrcoef(tema(1,j).hpcp(:,:), hpcp_det);
      end
      
      if (a<b)
          corr_HPCP = corrcoef(tema(1,j).hpcp, hpcp_det(1:a,:));  
      end
      
      hpcpcorr(i,j) = corr_HPCP(1,2);      
    end
end

[max_5 index_5] =max(hpcpcorr, [], 2);

correct_1 = sum(original_standard == index_1)
correct_2 = sum(original_standard == index_2')
correct_3 = sum(original_standard == index_3')
correct_4 = sum(original_standard == index_4')
correct_5 = sum(original_standard == index_5')
