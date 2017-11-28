% Multi - level semantic segmentation.

%%

addpath('./scripts/')
clc;
[BETA]=calculateBeta;


%%
% =======================================================
% Vectorizing all the images and its corresponding labels
% For training the multi-variate normal distribution.
% =======================================================
Files=dir('./dataset/Training/*.jpg');
location_dir='./dataset/Training/';

st_feature_vec=[];
rows=0; cols=0;
st_labels=[];


for kot=1:length(Files)
    
    disp (['Processing image number ', num2str(kot)])
        
    FileNames=Files(kot).name;
    I1=imread(strcat(location_dir,FileNames));
    [rows1,cols1,~]=size(I1);

    GroundTruthName=FileNames;
    ind=length(GroundTruthName)-3:1:length(GroundTruthName);
    GroundTruthName(ind)=[];
    GroundTruthName=strcat(GroundTruthName,'_3GT.png');
    GroundTruth=double(imread(['./dataset/Training/',GroundTruthName]));
    GT_image1=double(GroundTruth);

    [st_feature_vec1, st_labels1]=features_3labels(I1,GT_image1,BETA);

    st_feature_vec=cat(1,st_feature_vec,st_feature_vec1);
    rows=rows+rows1;
    cols=cols+cols1;
    st_labels=cat(1,st_labels,st_labels1);


end

[phi_class1,mu0_class1,mu1_class1,sigma_class1]=likelihood_estimate(st_feature_vec,st_labels,1,2,3);
[phi_class2,mu0_class2,mu1_class2,sigma_class2]=likelihood_estimate(st_feature_vec,st_labels,2,1,3);
[phi_class3,mu0_class3,mu1_class3,sigma_class3]=likelihood_estimate(st_feature_vec,st_labels,3,1,2);

disp ('Parameters for multi-variate normal distribution learnt.');

%%

% =============================================

% Log file where individual image's performance are recorded

fileID = fopen('./logs/logfile.txt','a');
fprintf(fileID,'c1=sky \t c2=thin cloud \t c3=thick cloud \n');
fprintf(fileID,'FileNames \t Precision_c1 \t Precision_c2 \t Precision_c3 \t Recall_c1 \t Recall_c2 \t Recall_c3 \t Accuracy_c1 \t Accuracy_c2 \t Accuracy_c3 \t FScore_c1 \t FScore_c2 \t FScore_c3 \n');

% Testing stage
Files=dir('./dataset/Testing/*.jpg');
location_dir='./dataset/Testing/';
    
TP=zeros(1,3);
FP=zeros(1,3);
TN=zeros(1,3);
FN=zeros(1,3);
    
for kot=1:length(Files)
    
    FileNames=Files(kot).name;        
    I_test=imread(strcat(location_dir,FileNames));        
    disp (['Processing image ',FileNames]);
    [rows_test,cols_test,~]=size(I_test);
    [color_ch_test]=color16_struct(I_test);

    channel0_test=color_ch_test.c1;
    channel1_test=color_ch_test.c5;
    channel2_test=color_ch_test.c13;
    channel0_test=showasImage(channel0_test); channel0_test(channel0_test==0)=1;
    channel1_test=showasImage(channel1_test); channel1_test(channel1_test==0)=1;
    channel2_test=showasImage(channel2_test); channel2_test(channel2_test==0)=1;
    St_zero_test=reshape(channel0_test,rows_test*cols_test,1);
    St_one_test=reshape(channel1_test,rows_test*cols_test,1);
    St_two_test=reshape(channel2_test,rows_test*cols_test,1);
    St_zero_test=St_zero_test./255;
    St_one_test=St_one_test./255;
    St_two_test=St_two_test./255;
    
    color_test=cat(2,St_one_test,St_two_test,St_zero_test);
    data_vector_test = [ones(rows_test*cols_test,1) color_test]*BETA;
    res_test=reshape(data_vector_test,rows_test,cols_test);
    prob_res_test=(showasImage(res_test))./255 ;
    st_prob_test=reshape(prob_res_test,rows_test*cols_test,1);    

    % This is the feature vector.
    feature_test=st_prob_test;
    label_test=zeros(rows_test*cols_test,1);

    for p=1:rows_test*cols_test
        
        % This is the log-likelihood estimate for each of the elements of the testing image.   
        likelihood_class1_positivesample= (feature_test(p,:)'-mu1_class1')'*(inv(sigma_class1))*((feature_test(p,:)'-mu1_class1'));
        likelihood_class2_positivesample= (feature_test(p,:)'-mu1_class2')'*(inv(sigma_class2))*((feature_test(p,:)'-mu1_class2'));
        likelihood_class3_positivesample= (feature_test(p,:)'-mu1_class3')'*(inv(sigma_class3))*((feature_test(p,:)'-mu1_class3'));
        like=[likelihood_class1_positivesample,likelihood_class2_positivesample,likelihood_class3_positivesample];
        [~,ind]=min(like);

        label_test(p,1)=ind;
    
    end

    % Display output
    label_test(label_test==1)=0;
    label_test(label_test==2)=126;
    label_test(label_test==3)=255;

    % Filtering with a 7X7 filter for better results
    A=reshape(label_test,rows_test,cols_test); B = medfilt2(A, [7 7]);

    GroundTruthName=FileNames;
    ind=length(GroundTruthName)-3:1:length(GroundTruthName);
    GroundTruthName(ind)=[];
    GroundTruthName=strcat(GroundTruthName,'_3GT.png');
    GroundTruth=double(imread(['./dataset/Testing/',GroundTruthName]));
    GroundTruth=double(GroundTruth);

    % Individual scoring
    [Precision_c1,Precision_c2,Precision_c3,Recall_c1,Recall_c2,Recall_c3,Accuracy_c1,Accuracy_c2,Accuracy_c3,FScore_c1,FScore_c2,FScore_c3] = individual_score(B,GroundTruth);

    % Cumulative scoring
    [true_positive,false_positive,true_negative,false_negative]= cumulative_score(B,GroundTruth,TP,FP,TN,FN);
    TP=true_positive;
    FP=false_positive;
    TN=true_negative;
    FN=false_negative;
    fprintf(fileID,'%s \t %f \t %f \t %f \t %f \t %f \t %f \t %f \t %f \t %f \t %f \t %f \t %f \n',FileNames,Precision_c1,Precision_c2,Precision_c3,Recall_c1,Recall_c2,Recall_c3,Accuracy_c1,Accuracy_c2,Accuracy_c3,FScore_c1,FScore_c2,FScore_c3);

end    
    
fclose(fileID);

% Reporting the final precision-, recall- and f-score value by cumulating
% all the observations.
pr=true_positive./(true_positive+false_positive);
re=true_positive./(true_positive+false_negative);
fs=(2.*pr.*re)./(pr+re);

disp (['Precision for clear sky, thin clouds and thick clouds are: ',num2str(pr), ' respectively']);
disp (['Recall for clear sky, thin clouds and thick clouds are: ',num2str(re), ' respectively']);
disp (['F-score for clear sky, thin clouds and thick clouds are: ',num2str(fs), ' respectively']);

%%
