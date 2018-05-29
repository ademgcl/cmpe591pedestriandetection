function bboxes = importbboxes(filename)

bboxes=[];
fid = fopen(filename,'r');

tline = fgetl(fid);
tline = fgetl(fid);

while ischar(tline)
    linesplitted = split(tline,' ');
    bboxes=[bboxes;str2double(linesplitted{2}) str2double(linesplitted{3}) str2double(linesplitted{4}) str2double(linesplitted{5})];
    tline = fgetl(fid);
end
fclose(fid);
