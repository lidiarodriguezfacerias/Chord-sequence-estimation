function [ original_standard, tempo] = set_original_features2(filename, tema )

%run('/Users/apple/Documents/UPF/TFG/Codis/diccionari.m')
addpath('/Users/apple/Documents/UPF/TFG/Codis/Chord sequence standard estimation/ktempo')
list = dir('ktempo/*.csv');



divided_filename = regexp(filename, '[_.]', 'split');
author = divided_filename{1};
song =divided_filename{2};
version = divided_filename{3};

audio_name = strcat(author,'_',song,'_',version);
tempos = strcat(audio_name,'_vamp_qm-vamp-plugins_qm-tempotracker_beats.csv');

fid = fopen(tempos);
data = fread(fid, '*char')'; 
fclose(fid);
entries = regexp(data, '"', 'split');
entriesaux= regexp(entries, ',', 'split');

%audio_length = read_audio(audio_name);
 j=1;
for i = 1:2:length(entries)
    
    aux_entries{j} = sscanf(entries{i},'%f',[1 Inf]);
    j=j+1;
    
    
end

ent = cell2mat(aux_entries);
tempo = ent;
shift = 0;

switch (song)
    case 'attya', 
    num = 1;
    case 'al', 
    num = 2;
     case 'blues', 
    num = 3;
     case 'rc', 
    num = 4;
     case 'rm', 
    num = 5;
     case 'solar', 
    num = 6;
     case 'someday', 
    num = 7;
     case 'stella', 
    num = 8;
     otherwise
    num = 9;
end

original_standard = num;


end

