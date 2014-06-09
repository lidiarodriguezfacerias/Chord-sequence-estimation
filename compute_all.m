%Compute chord sequence estimation

function [detected_sequence, original_standard] = compute_all(filename,chord,tema,root)
%Input: filename and structs chord, tema, root
%Output: detected_chord

detected_sequence=struct;
original_chord=struct;

csv = csvread(filename);
[original_standard,tempo] = set_original_features2(filename,tema);

fs = 44100;

% Compute length and starting window
s_starting_beat= tempo.*fs;

for i = 1:length(tempo)-1
    s_length_beat(i) = (s_starting_beat(i+1) - s_starting_beat(i));
end

s_starting_beat = s_starting_beat(1:length(s_starting_beat)-1);
w_starting_beat = round(s_starting_beat ./ 256);

for i = 1:length(w_starting_beat)      
    w_length_beat(i) = round(s_length_beat(i) / 256);
end

for i = 1: (length(w_starting_beat))

    if (i==length(w_starting_beat))
        wl = length(csv) - w_starting_beat(i);
    else
        wl = w_length_beat(i);
    end
    
    hpcp_aux = 0;
    ws = w_starting_beat(i);
    aux_csv = csv((ws:ws+wl), :);
    hpcp_aux = hpcpread(aux_csv);
    
    %Compute chord detection
    [detected_chord_aux]=chord_estimation2(hpcp_aux,chord,root,tema,i);
    
    % Set the detected features
    detected_sequence(i).root =     detected_chord_aux.root;
    detected_sequence(i).type = detected_chord_aux.type;
    detected_sequence(i).rootname = detected_chord_aux.rootname;
    detected_sequence(i).typename = detected_chord_aux.typename;
    detected_sequence(i).root2 = detected_chord_aux.root2;
    detected_sequence(i).type2 = detected_chord_aux.type2;
    detected_sequence(i).rootname2 = detected_chord_aux.rootname2;
    detected_sequence(i).typename2 = detected_chord_aux.typename2;
    detected_sequence(i).hpcp = detected_chord_aux.hpcp;
    detected_sequence(i).R = detected_chord_aux.R;
   
end

end