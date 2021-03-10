function [vacuole_area,number] = vacuoles_detection(gray,c1)
%% number of vacuoles; area of vacuoles
sperm = find_sperm(imfilter(gray,fspecial('log',20,0.23)),c1);
[C,c_len,~] = get_contour(sperm);
a = find(c_len > 8 & c_len < 100);
number = zeros(1,size(c1,2));
for i = 1:size(c1,2)
    for j = 1:size(a,2)
        in{i,j} = inpolygon(C{a(j)}(1,:),C{a(j)}(2,:),c1{i}(1,:),c1{i}(2,:));
        va_area = zeros(size(a,2),size(c1,2));
        if sum(in{i,j}) ~= 0
            va_area(j,i) = polyarea(C{a(j)}(1,:),C{a(j)}(2,:));
            number(i) = number(i) + 1;
        end
%         vacuole_area(i) = sum(va_area(:,i));
    end
end
vacuole_area = sum(va_area);
