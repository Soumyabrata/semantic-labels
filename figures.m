% This generates the figures of the manuscript.


% Figure 2 of the manuscript
CS=[0.952   0.906   0.928];
ThinC=[0.522    0.664   0.586];
ThickC=[0.898   0.869   0.883];

mat=cat(1,CS,ThinC,ThickC);

figure;
bar(mat,'grouped');
xticklabels({'Clear Sky','Thin Clouds','Thick Clouds'})

% ====================================================

% Comparison with other approaches.
% Figure 3 of the manuscript
SS=[0.889	0.879	0.896];
HYTA=[0.896	0.870	0.856];
souza=[0.925	0.701	0.711];
long=[0.631	0.952	0.678];
sylvio=[0.555	0.956	0.610];

mat=cat(1,SS,HYTA,souza,long,sylvio);

figure;
bar(mat,'grouped');
xticklabels({'Our approach','Li et al.','Souza et al.', 'Long et al.', 'Sylvio et al.'})



