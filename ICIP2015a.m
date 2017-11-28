% ICIP 2015a
% Plotting of figures in the paper.
% Semantic segmentation + cluster determination paper

fs=[0.971;0.655;0.974];



bar(1:3,fs,0.4); hold on;

set(gca,'Xtick',1:3,'XTickLabel',{'Clear sky','Thin clouds','Thick clouds'},'FontSize',12); hold on;
%title('Evaluation results for semantic labelling of images in HYTA database.','FontSize',14); hold on;
ylabel('F-score','FontSize',12); hold on;
%xlabel('Months of year','FontSize',12); hold on;

%%
% Comparison with other approaches.
figure(5);
SS=[0.889	0.879	0.896];
HYTA=[0.896	0.870	0.856];
souza=[0.925	0.701	0.711];
long=[0.631	0.952	0.678];
sylvio=[0.555	0.956	0.610];



mat=cat(1,SS,HYTA,souza,long,sylvio);

bar(mat,'grouped');
xlab=['aa';'bb';'cc';'dd';'ee'];
set(gca,'XTickLabel',xlab);



%%

% Precision, recall, f-score for 3-level
figure(5);

CS=[0.944   1.000   0.971];
ThinC=[0.487    1.000   0.655];
ThickC=[0.949   1.000   0.974];

mat=cat(1,CS,ThinC,ThickC);

bar(mat,'grouped');
xlab=['aa';'bb';'CC'];
set(gca,'XTickLabel',xlab);


%%

% Precision, recall, f-score for 3-level
figure(5);

CS=[0.952   0.906   0.928];
ThinC=[0.522    0.664   0.586];
ThickC=[0.898   0.869   0.883];

mat=cat(1,CS,ThinC,ThickC);

bar(mat,'grouped');
xlab=['aa';'bb';'CC'];
set(gca,'XTickLabel',xlab);


%%
