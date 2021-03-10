function attr = Get_feature(I,A)
gray = rgb2gray(I);
gray = 255 - mode(gray(:)) + gray + 12;
%% get contours; standardize them
[c1,c5,~,~] = get_contours(gray);
[vacuole_area,vacuole_number] = vacuoles_detection(gray,c1);

%% standardize them
for i = 1:size(c1,2)
    oc(:,:,i) = ReSampleCurvec([unique(c1{i}','row','stable')'],200)*(InnerProd_Q(curve_to_qnos(c1{i}),curve_to_qnos(c1{i})));
    oc(:,:,i) = oc(:,:,i) - mean(oc(:,:,i)')';
    ic(:,:,i) = ReSampleCurvec([unique(c5{i}','row','stable')'],200)*(InnerProd_Q(curve_to_qnos(c5{i}),curve_to_qnos(c5{i})));
    ic(:,:,i) = ic(:,:,i) - mean(ic(:,:,i)')';
end

%%
A = A - mean(A')'; % contrast
ind1 = 19; ind2 = 113;

h1 = [A(:,ind2:end) A(:,1:ind1)]; % head curve
h1 = ReSampleCurve([unique(h1','row','stable')'],200);

%% smooth
windowWidth = 15;
polynomialOrder = 6;

%% registration(before smoothing)

for i = 1:size(c1,2)
    oc(1,:,i) = sgolayfilt(oc(1,:,i), polynomialOrder, windowWidth);
    oc(2,:,i) = sgolayfilt(oc(2,:,i), polynomialOrder, windowWidth);
    oc(:,:,i) = ReSampleCurvec(oc(:,:,i),200)*InnerProd_Q(curve_to_qnos(oc(:,:,i)),curve_to_qnos(oc(:,:,i)));
    oc(:,:,i) = oc(:,:,i) - mean(oc(:,:,i)')';
    oc(:,:,i) = find_best_alignment(A,oc(:,:,i));
end

%% head ellipse fit
for i = 1:size(c1,2)
    % head
    hc(:,:,i) = [oc(:,ind2:end,i) oc(:,1:ind1,i)];
    hch(:,:,i) = ReSampleCurve([unique(hc(:,:,i)','row','stable')'],200);
    coef = EllipseDirectFit([hch(:,:,i)]');
    f = @(x,y) coef(1)*x.^2 + coef(2)*x.*y + coef(3)*y.^2 + coef(4)*x + coef(5)*y + coef(6);
    [long,short,phi] = find_axis_ellipse(coef(1),coef(2),coef(3),coef(4),coef(5),coef(6));
    long_axis(i) = 2*long/(194-17)*10;
    short_axis(i) = 2*short/(194-17)*10;
    long_vs_short(i) = long_axis(i)/short_axis(i);
    tilted_degree1(i) = phi;

    e_area(i) = find_ellipse_area(coef);
    acro_ratio(i) = polyarea(c5{i}(1,:),c5{i}(2,:))/e_area(i);
    vacu_ratio(i) = vacuole_area(i)/e_area(i);

    headdiff1(i) = acos(InnerProd_Q(curve_to_q(h1),curve_to_q(hch(:,:,i))));
    headdiff2(i) = dist_curve(h1 - mean(h1')',hch(:,:,i) - mean(hch(:,:,i)')');
    clear coef long short phi x y
    
    % neck
    nc(:,:,i) = [oc(:,ind1+3:ind1+18,i) oc(:,ind2-18:ind2-3,i)];
    ncn(:,:,i) = ReSampleCurve([unique(nc(:,:,i)','row','stable')'],200);
    coef = EllipseDirectFit([ncn(:,:,i)]');
    f = @(x,y) coef(1)*x.^2 + coef(2)*x.*y + coef(3)*y.^2 + coef(4)*x + coef(5)*y + coef(6);
    [~,short,phi] = find_axis_ellipse(coef(1),coef(2),coef(3),coef(4),coef(5),coef(6));
    neck_width(i) = 2*short/(194-17)*10;
    tilted_degree2(i) = phi;
    tilted_degree(i) = abs(tilted_degree1(i) - tilted_degree2(i));
    clear coef long short phi x y
end
attr = [long_axis' short_axis' long_vs_short' tilted_degree' headdiff1' headdiff2' neck_width' acro_ratio' vacu_ratio'*1.1 vacuole_number'];
