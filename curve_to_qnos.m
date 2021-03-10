function [q,len] = curve_to_qnos(p)

[n,N] = size(p);
for i = 1:n
    v(i,:) = gradient(p(i,:),1/(N-1));
end

len = sum(sqrt(sum(v.*v)))/N;
% v = v/len;
for i = 1:N
    L(i) = sqrt(norm(v(:,i)));
    if L(i) > 0.0001
        q(:,i) = v(:,i)/L(i);
    else
        q(:,i) = v(:,i)*0.0001;
    end
end