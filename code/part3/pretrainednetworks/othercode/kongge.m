a=importdata('labels_val.txt');
for i=1:size(a,1)
    index=strfind(a{i},',');
    b=a{i}(1:index);
    c=a{i}(index+1:end);
    d=strcat(b,32,c);
    label_t{i,1}=d;
end
[nrows,ncols]= size(label_t);
filename ='./labels_val.txt';
fid = fopen(filename, 'w');
for row=1:nrows
fprintf(fid, '%s\n', label_t{row,:});
end
fclose(fid);
 