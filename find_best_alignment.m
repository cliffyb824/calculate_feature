function c2n = find_best_alignment(c1,c2)
c1 = c1 - mean(c1')';
c2 = c2 - mean(c2')';

[p1,~] = Find_Rotation_and_Seed_unique(curve_to_q(c1),curve_to_q(c2),0);
[p2,~] = Find_Rotation_and_Seed_unique(curve_to_q(c1),curve_to_q(flip(c2')'),0);
Ec1 = acos(InnerProd_Q(curve_to_q(c1),p1));
Ec2 = acos(InnerProd_Q(curve_to_q(c1),p2));
if Ec1 > Ec2
    c2 = flip(c2')';
end
[q,~] = Find_Rotation_and_Seed_unique(curve_to_q(c1),curve_to_q(c2),1);
c2n = q_to_curve(q);
c2n = c2n*(InnerProd_Q(curve_to_qnos(c2),curve_to_qnos(c2)));
c2n = c2n - mean(c2n')';
