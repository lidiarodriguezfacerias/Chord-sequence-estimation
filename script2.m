% SCRIPT 2

close all;
run('/Users/apple/Documents/UPF/TFG/Codis/Chord sequence standard estimation/diccionari.m')
addpath('/Users/apple/Documents/UPF/TFG/Codis/Chord sequence standard estimation/khpcp')
list = dir('khpcp/*.csv');

detected_sequence = struct; 
original_standard = [];
for i = 1:length(list)
    
    display(list(i).name)
    filename = list(6).name;
    fprintf('\n');   
    
    %Compute chord sequence estimation
    [detected_sequence(i).detected, original_standard(i)]= compute_all(filename, chord, tema,root);
    
    fprintf('\n');
        
end


