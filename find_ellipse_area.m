function Area=find_ellipse_area(coeffs)
% coeffs(1) x^2 + coeffs(2) x*y + coeffs(3) y^2
%+ coeffs(4) x + coeffs(5) y + coeffs(6) = 0
A=[coeffs(1) coeffs(2)/2; coeffs(2)/2 coeffs(3)];
% find principle axis
[U,D]=eig(A);
% A = U*D*U'
% [x y] U D U' [x y]' + [d e] U U' [x y]' +  f =0
% an = D(1), bn = D(2), cn = 0
% [dn en] = [d e] U
an=D(1); bn=D(4);
[de]=[coeffs(4) coeffs(5)]*U; dn=de(1); en=de(2);
fn=coeffs(6);
den=dn^2/(4*an) + en^2/(4*bn) - fn;
atilde=an/den;
btilde=bn/den;
Area=pi/sqrt(atilde)/sqrt(btilde);
if atilde <0 || btilde < 0
    Area=nan;
end
