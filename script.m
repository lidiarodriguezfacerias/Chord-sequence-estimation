% SCRIPT

close all;
run('/Users/apple/Chord-sequence-estimation/diccionari.m')
addpath('/Users/apple/Chord-sequence-estimation/hpcp2')
list = dir('hpcp2/*.csv');

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

run('/Users/apple/Chord-sequence-estimation/evaluation.m')


