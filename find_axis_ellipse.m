function [semi_long,semi_short,phi] = find_axis_ellipse(a,b,c,d,e,f)
q = 64*(f*(4*a*c - b^2) - a*e^2 + b*d*e - c*d^2)/(4*a*c - b^2)^2;
s = 1/4*sqrt(abs(q)*sqrt(b^2 + (a - c)^2));
semi_long = 1/8*sqrt(2*abs(q)*sqrt(b^2 + (a - c)^2) - 2*q*(a + c));
semi_short = sqrt(semi_long^2 - s^2);
if q*a - q*c == 0 && q*b == 0
    phi = 0;
elseif q*a - q*c == 0 && q*b > 0
    phi = 1/4*pi;
elseif q*a - q*c == 0 && q*b < 0
    phi = 3/4*pi;
elseif q*a - q*c > 0 && q*b >= 0
    phi = 1/2*atan(b/(a - c));
elseif q*a - q*c > 0 && q*b < 0
    phi = 1/2*atan(b/(a - c)) + pi;
elseif q*a - q*c < 0
    phi = 1/2*atan(b/(a - c)) + 1/2*pi;
end