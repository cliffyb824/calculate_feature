function [c1,c5,c1_length,c1_area] = get_contours(gray)

C = contourc(double(gray),10);
S = contourdata(C);

%% measure the perimeter for all contour
c_length = zeros(1,size(S,2));
for i = 1:size(S,2)
    for j = 1:S(i).numel-1
        c_length(i) = c_length(i) + sqrt((S(i).xdata(j) - S(i).xdata(j+1))^2 + (S(i).ydata(j) - S(i).ydata(j+1))^2);
    end
end

%% measure the area for all contour
c_area = zeros(1,size(S,2));
for i = 1:size(S,2)
    c_area(i) = polyarea(S(i).xdata,S(i).ydata);
end

%% closed contour or not
closed_open = zeros(1,size(S,2));
for i = 1:size(S,2)
    closed_open(i) = S(i).isopen;
end

%% locating every contour
unique_level = unique([S.level]);% Finds unique values and sorts
% a1 = find([S.level] == unique_level(end) & c_length > 250 & c_length < 550 & c_area > 2500 & c_area < 6500 & closed_open == 0);% find out the outside contour
a1 = find([S.level] == unique_level(end) & c_length > 200 & c_area > 2000 & closed_open == 0);% find out the outside contour
a5 = find([S.level] == unique_level(end-5) & c_length > 80 & c_area > 800 & closed_open == 0);% find out the outside contour
a7 = find([S.level] == unique_level(2) & c_length > 20 & c_area > 100 & closed_open == 0);% find out the outside contour

%% plot contours
for i = 1:size(a1,2)
    for  j = 1:size(a5,2)
        if mode(inpolygon(S(a5(j)).xdata,S(a5(j)).ydata,S(a1(i)).xdata,S(a1(i)).ydata)) == 1
            d1{i} = [S(a1(i)).xdata S(a1(i)).ydata]';
            d1_length(i) = c_length(a1(i));
            d1_area(i) = c_area(a1(i));
            d5{i} = [S(a5(j)).xdata S(a5(j)).ydata]';
        end
    end
end
for i = 1:size(d1,2)
    ie(i) = ~isempty(d1{i});
end
ind = find(ie);

figure
imshow(gray)
axis([1 1920 1 1200]);
axis ij
pbaspect([1 1 1])
hold on
for i = 1:size(ind,2)
    c1{i} = d1{ind(i)};
    c1_length(i) = d1_length(ind(i));
    c1_area(i) = d1_area(ind(i));
    plot(c1{i}(1,:),c1{i}(2,:));
    text(c1{i}(1,1),c1{i}(2,1),num2str(i));
    c5{i} = d5{ind(i)};
    plot(c5{i}(1,:),c5{i}(2,:));
    text(c5{i}(1,1),c5{i}(2,1),num2str(i));
end
hold off
