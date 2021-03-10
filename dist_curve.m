%dissimilarity of two curve in norm, c1,c2 is 2*n
function dist = dist_curve(c1,c2)
n = size(c1,2);
dist = 0;
for i = 1:n
    dist = dist + norm(c1(:,i)-c2(:,i));
end
dist = dist/n;