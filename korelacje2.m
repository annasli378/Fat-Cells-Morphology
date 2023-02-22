clear all, close all

%%
load("Sex.mat");load("AgeAtDiagnosis.mat");load("AgeAtSurgery.mat")
load("Surgery.mat");load("PreOpBMi.mat");load("EarlyRecOUT.mat");load("EarlyRecWITH.mat")
load("AnyRecOUT.mat");load("AnyRecWITH.mat");load("Outcomes_allpatients.mat")

korrSex={}; korrAgeD={};korrAgeS={};korrSur={};korrPreBMI={};korrEOUT={};korrEWITH={};korrAOUT={};korrAWITH={};
pSex={}; pAgeD={};pAgeS={};pSur={};pPreBMI={};pEOUT={};pEWITH={};pAOUT={};pAWITH={};
for i =3:width(Sex)
    [R, P] = corrcoef(Sex{:,i},Sex{:,1});
    korrSex{i-2} = R(1,2);
    pSex{i-2} = P(1,2);

    [R, P] = corrcoef(AgeAtDiagnosis{:,i},AgeAtDiagnosis{:,1});
    korrAgeD{i-2} = R(1,2);
    pAgeD{i-2} = P(1,2);

    [R, P] = corrcoef(AgeAtSurgery{:,i},AgeAtSurgery{:,1});
    korrAgeS{i-2} = R(1,2);
    pAgeS{i-2} = P(1,2);

    [R, P] =  corrcoef(Surgery{:,i},Surgery{:,1});
    korrSur{i-2} = R(1,2);
    pSur{i-2} = P(1,2);

    [R, P] =corrcoef(PreOpBMI{:,i},PreOpBMI{:,1});
    korrPreBMI{i-2} = R(1,2);
    pPreBMI{i-2} = P(1,2);

    [R, P] = corrcoef(EarlyRecOUT{:,i},EarlyRecOUT{:,1});
    korrEOUT{i-2} = R(1,2);
    pEOUT{i-2} = P(1,2);
    
    [R, P] = corrcoef(EarlyRecWITH{:,i},EarlyRecWITH{:,1});
    korrEWITH{i-2} = R(1,2);
    pEWITH{i-2} = P(1,2);
    
    [R, P] = corrcoef(AnyRecOUT{:,i},AnyRecOUT{:,1});
    korrAOUT{i-2} = R(1,2);
    pAOUT{i-2} = P(1,2);
    
    [R, P] = corrcoef(AnyRecWITH{:,i},AnyRecWITH{:,1});
    korrAWITH{i-2} = R(1,2);
    pAWITH{i-2} = P(1,2);

end

all_korr = [korrSex; korrAgeD; korrAgeS;korrSur; korrPreBMI; korrEOUT; korrEWITH; korrAOUT; korrAWITH];
all_p= [pSex; pAgeD; pAgeS;pSur; pPreBMI; pEOUT; pEWITH; pAOUT; pAWITH]';
all_korr = cell2mat(all_korr);all_p = cell2mat(all_p);all_sig=find(all_p<0.05);
%% Cechy dla których p < 0.05
outcomes = ["Sex", "AgeAtDiagnosis", "AgeAtSurgery", "Surgery", "PreOpBMI", "EarlyRecOut", "EarlyRecWith", "AnyRecOut", "AnyRecWith"];
out_znaczace = (sum(all_p<0.05)>0);
znaczace_wyniki = outcomes(out_znaczace);

cechy_audiopocytow = ["var areas", "std areas"	"mean areas", "median areas", "min areas"	"max areas"	"quartile areas1"	"quartile areas3",  "var dist"	"std dist"	"mean dist"	"median dist"	"min dist"	"max dist"	"quartile dist1", "quartile dist3"	, "var flat"	"std flat"	"mean flat"	"median flat"	"min flat"	"max flat"	"quartile flat1"	"quartile flat3"]
out_znacz = (sum(all_p'<0.05)>0);
znaczace_cechy_aud = cechy_audiopocytow(out_znacz);
%% Wykresy korelacji i p FIG 1-4
figure,
imagesc(all_korr, [-1, 1]);title("correlation coeffs");ylabel("Features of adipocytes");xlabel("Outcomes")
colorbar
xt = get(gca, "XTick");yt = [1:1:24];set(gca, "XTick",xt, "XTickLabel",outcomes, "YTick",yt, "YTickLabel",cechy_audiopocytow);                       
figure,
imagesc(all_p, [0, max(max(all_p))]);title("p-values");ylabel("Features of adipocytes");xlabel("Outcomes")
colorbar
xt = get(gca, "XTick");yt = [1:1:24];set(gca, "XTick",xt, "XTickLabel",outcomes, "YTick",yt, "YTickLabel",cechy_audiopocytow); 
figure,
hk = heatmap(all_korr);title("correlation coeffs");ylabel("Features of adipocytes");xlabel("Outcomes")
hk.XDisplayLabels = outcomes;hk.YDisplayLabels = cechy_audiopocytow;
figure,
hp = heatmap(all_p);title("p-values");ylabel("Features of adipocytes");xlabel("Outcomes")
hp.XDisplayLabels = outcomes;hp.YDisplayLabels = cechy_audiopocytow;

%% Jakie cechy audipozydów:
cechy_dla_AgeAtSurgery = cechy_audiopocytow(all_p(:,3)<0.05)    % dla AgeAtSurgery:
cechy_dla_PreOPBMI = cechy_audiopocytow(all_p(:,5)<0.05)        % dla PreOPBMI
cechy_dla_EarlyRecOut = cechy_audiopocytow(all_p(:,6)<0.05)     % dla EarlyRecOut
cechy_dla_EarlyRecWith = cechy_audiopocytow(all_p(:,7)<0.05)    % dla EarlyRecWith
cechy_dla_AnyRecOut = cechy_audiopocytow(all_p(:,8)<0.05)       % dla AnyRecOut
cechy_dla_AnyRecWith = cechy_audiopocytow(all_p(:,9)<0.05)      % dla AnyRecWith
%% FIG 5
figure,
subplot(5, 1, 1)
scatter(AgeAtSurgery.AgeAtSurgery,AgeAtSurgery.wariancja_areas,  "filled")
hold on;plot(AgeAtSurgery.AgeAtSurgery,(AgeAtSurgery.AgeAtSurgery\AgeAtSurgery.wariancja_areas)*AgeAtSurgery.AgeAtSurgery)
hold off
ylabel(cechy_dla_AgeAtSurgery(1));xlabel("AgeAtSurgery");title(strcat("Correlation coeff: ", sprintf("%.3f",all_korr(1,3)), " P-value: " , sprintf("%.3f",all_p(1,3))))
subplot(5, 1, 2)
scatter(AgeAtSurgery.AgeAtSurgery,AgeAtSurgery.std_areas,  "filled")
hold on;plot(AgeAtSurgery.AgeAtSurgery,(AgeAtSurgery.AgeAtSurgery\AgeAtSurgery.std_areas)*AgeAtSurgery.AgeAtSurgery)
hold off
ylabel(cechy_dla_AgeAtSurgery(2));xlabel("AgeAtSurgery");title(strcat(" Correlation coeff: ", sprintf("%.3f",all_korr(2,3)), " P-value: " , sprintf("%.3f",all_p(2,3))))
subplot(5, 1, 3)
scatter(AgeAtSurgery.AgeAtSurgery,AgeAtSurgery.rednia_areas,  "filled")
ylabel(cechy_dla_AgeAtSurgery(3));xlabel("AgeAtSurgery");title(strcat(" Correlation coeff: ", sprintf("%.3f",all_korr(3,3)), " P-value: " , sprintf("%.3f",all_p(3,3))))
hold on;plot(AgeAtSurgery.AgeAtSurgery,(AgeAtSurgery.AgeAtSurgery\AgeAtSurgery.rednia_areas)*AgeAtSurgery.AgeAtSurgery)
hold off
subplot(5, 1, 4)
scatter(AgeAtSurgery.AgeAtSurgery,AgeAtSurgery.mediana_areas,  "filled")
ylabel(cechy_dla_AgeAtSurgery(4));xlabel("AgeAtSurgery");title(strcat(" Correlation coeff: ", sprintf("%.3f",all_korr(4,3)), " P-value: " , sprintf("%.3f",all_p(4,3))))
hold on;plot(AgeAtSurgery.AgeAtSurgery,(AgeAtSurgery.AgeAtSurgery\AgeAtSurgery.mediana_areas)*AgeAtSurgery.AgeAtSurgery)
hold off
subplot(5, 1, 5)
scatter(AgeAtSurgery.AgeAtSurgery,AgeAtSurgery.kwartyl_3, "filled")
ylabel(cechy_dla_AgeAtSurgery(5));xlabel("AgeAtSurgery");title(strcat(" Correlation coeff: ", sprintf("%.3f",all_korr(8,3)), " P-value: " , sprintf("%.3f",all_p(8,3))))
hold on;plot(AgeAtSurgery.AgeAtSurgery,(AgeAtSurgery.AgeAtSurgery\AgeAtSurgery.kwartyl_3)*AgeAtSurgery.AgeAtSurgery)
hold off

%% FIG 6 
figure,
subplot(6, 2, 1)
plot( PreOpBMI.Pre_op_BMI, PreOpBMI.wariancja_areas,"r.")
ylabel(cechy_dla_PreOPBMI(1));xlabel(znaczace_wyniki(2));title(strcat(" Correlation coeff: ", sprintf("%.3f",all_korr(1,5)), " P-value: " , sprintf("%.3f",all_p(1,5))))
hold on;plot(PreOpBMI.Pre_op_BMI,(PreOpBMI.Pre_op_BMI\PreOpBMI.wariancja_areas)*PreOpBMI.Pre_op_BMI);hold off
subplot(6, 2, 2)
plot( PreOpBMI.Pre_op_BMI, PreOpBMI.std_areas,"r.")
ylabel(cechy_dla_PreOPBMI(2));xlabel(znaczace_wyniki(2));title(strcat(" Correlation coeff: ", sprintf("%.3f",all_korr(2,5)), " P-value: " , sprintf("%.3f",all_p(2,5))))
hold on;plot(PreOpBMI.Pre_op_BMI,(PreOpBMI.Pre_op_BMI\PreOpBMI.std_areas)*PreOpBMI.Pre_op_BMI);hold off
subplot(6, 2, 3)
plot( PreOpBMI.Pre_op_BMI,PreOpBMI.rednia_areas, "r.")
ylabel(cechy_dla_PreOPBMI(3));xlabel(znaczace_wyniki(2));title(strcat(" Correlation coeff: ", sprintf("%.3f",all_korr(3,5)), " P-value: " , sprintf("%.3f",all_p(3,5))))
hold on;plot(PreOpBMI.Pre_op_BMI,(PreOpBMI.Pre_op_BMI\PreOpBMI.rednia_areas)*PreOpBMI.Pre_op_BMI);hold off
subplot(6, 2, 4)
plot( PreOpBMI.Pre_op_BMI, PreOpBMI.mediana_areas,"r.")
ylabel(cechy_dla_PreOPBMI(4));xlabel(znaczace_wyniki(2));title(strcat(" Correlation coeff: ", sprintf("%.3f",all_korr(4,5)), " P-value: " , sprintf("%.3f",all_p(4,5))))
hold on;plot(PreOpBMI.Pre_op_BMI,(PreOpBMI.Pre_op_BMI\PreOpBMI.mediana_areas)*PreOpBMI.Pre_op_BMI);hold off
subplot(6, 2, 5)
plot( PreOpBMI.Pre_op_BMI, PreOpBMI.kwartyl_3,"r.")
ylabel(cechy_dla_PreOPBMI(5));xlabel(znaczace_wyniki(2));title(strcat(" Correlation coeff: ", sprintf("%.3f",all_korr(8,5)), " P-value: " , sprintf("%.3f",all_p(8,5))))
hold on;plot(PreOpBMI.Pre_op_BMI,(PreOpBMI.Pre_op_BMI\PreOpBMI.kwartyl_3)*PreOpBMI.Pre_op_BMI);hold off
subplot(6, 2, 6)
plot( PreOpBMI.Pre_op_BMI, PreOpBMI.wariancja_dist,"g.")
ylabel(cechy_dla_PreOPBMI(6));xlabel(znaczace_wyniki(2));title(strcat(" Correlation coeff: ", sprintf("%.3f",all_korr(9,5)), " P-value: " , sprintf("%.3f",all_p(9,5))))
hold on;plot(PreOpBMI.Pre_op_BMI,(PreOpBMI.Pre_op_BMI\PreOpBMI.wariancja_dist)*PreOpBMI.Pre_op_BMI, "g");hold off
subplot(6, 2, 7)
plot( PreOpBMI.Pre_op_BMI, PreOpBMI.std_dist,"g.")
ylabel(cechy_dla_PreOPBMI(7));xlabel(znaczace_wyniki(2));title(strcat(" Correlation coeff: ", sprintf("%.3f",all_korr(10,5)), " P-value: " , sprintf("%.3f",all_p(10,5))))
hold on;plot(PreOpBMI.Pre_op_BMI,(PreOpBMI.Pre_op_BMI\PreOpBMI.std_dist)*PreOpBMI.Pre_op_BMI, "g");hold off
subplot(6, 2, 8)
plot( PreOpBMI.Pre_op_BMI, PreOpBMI.max_dist, "g.")
ylabel(cechy_dla_PreOPBMI(8));xlabel(znaczace_wyniki(2));title(strcat(" Correlation coeff: ", sprintf("%.3f",all_korr(14,5)), " P-value: " , sprintf("%.3f",all_p(14,5))))
hold on;plot(PreOpBMI.Pre_op_BMI,(PreOpBMI.Pre_op_BMI\PreOpBMI.max_dist)*PreOpBMI.Pre_op_BMI, "g");hold off
subplot(6, 2, 9)
plot( PreOpBMI.Pre_op_BMI, PreOpBMI.wariancja_flat,"b.")
ylabel(cechy_dla_PreOPBMI(9));xlabel(znaczace_wyniki(2));title(strcat(" Correlation coeff: ", sprintf("%.3f",all_korr(17,5)), " P-value: " , sprintf("%.3f",all_p(17,5))))
hold on;plot(PreOpBMI.Pre_op_BMI,(PreOpBMI.Pre_op_BMI\PreOpBMI.wariancja_flat)*PreOpBMI.Pre_op_BMI, "b");hold off
subplot(6, 2, 10)
plot( PreOpBMI.Pre_op_BMI, PreOpBMI.std_flat,"b.")
ylabel(cechy_dla_PreOPBMI(10));xlabel(znaczace_wyniki(2));title(strcat(" Correlation coeff: ", sprintf("%.3f",all_korr(18,5)), " P-value: " , sprintf("%.3f",all_p(18,5))))
hold on;plot(PreOpBMI.Pre_op_BMI,(PreOpBMI.Pre_op_BMI\PreOpBMI.std_flat)*PreOpBMI.Pre_op_BMI, "b");hold off
subplot(6, 2, 11)
plot( PreOpBMI.Pre_op_BMI, PreOpBMI.kwartyl_5,"b.")
ylabel(cechy_dla_PreOPBMI(10));xlabel(znaczace_wyniki(2));title(strcat(" Correlation coeff: ", sprintf("%.3f",all_korr(23,5)), " P-value: " , sprintf("%.3f",all_p(23,5))))
hold on;plot(PreOpBMI.Pre_op_BMI,(PreOpBMI.Pre_op_BMI\PreOpBMI.kwartyl_5)*PreOpBMI.Pre_op_BMI, "b");hold off
%%
% figure,
% subplot(2,2,1)
% plot(EarlyRecOUT.Early_rec_withOUTi2ab_15mo, EarlyRecOUT.min_flat, "ro")
% ylabel(cechy_dla_EarlyRecOut(1))
% xlabel(znaczace_wyniki(3));
% subplot(2,2,2)
% plot( EarlyRecWITH.Early_rec_WITHi2ab_15mo, EarlyRecWITH.min_flat,"bo")
% ylabel(cechy_dla_EarlyRecWith(1))
% xlabel(znaczace_wyniki(4));
% subplot(2,2,3)
% plot( AnyRecOUT.Any_rec_withOUT_i2ab_6mo, AnyRecOUT.mediana_flat,"ro")
% ylabel(cechy_dla_AnyRecOut(1))
% xlabel(znaczace_wyniki(5));
% subplot(2,2,4)
% plot( AnyRecWITH.Any_rec_WITH_i2ab_6mo, AnyRecWITH.mediana_flat,"bo")
% ylabel(cechy_dla_AnyRecWith(1))
% xlabel(znaczace_wyniki(6));

% figure,
% subplot(2,2,1)
% boxchart( EarlyRecOUT.min_flat,"BoxFaceColor","red")
% ylabel(cechy_dla_EarlyRecOut(1))
% xlabel(znaczace_wyniki(3));
% title(strcat(" P-value: " , sprintf("%.3f",all_p(21,6))))
% subplot(2,2,2)
% boxchart(  EarlyRecWITH.min_flat,"BoxFaceColor","red")
% ylabel(cechy_dla_EarlyRecWith(1))
% xlabel(znaczace_wyniki(4));
% title(strcat(" P-value: " , sprintf("%.3f",all_p(21,7))))
% subplot(2,2,3)
% boxchart(  AnyRecOUT.mediana_flat,"BoxFaceColor","cyan")
% ylabel(cechy_dla_AnyRecOut(1))
% xlabel(znaczace_wyniki(5));
% title(strcat(" P-value: " , sprintf("%.3f",all_p(20,8))))
% subplot(2,2,4)
% boxchart(  AnyRecWITH.mediana_flat,"BoxFaceColor","cyan")
% ylabel(cechy_dla_AnyRecWith(1))
% xlabel(znaczace_wyniki(6));
% title(strcat(" P-value: " , sprintf("%.3f",all_p(20,9))))



%% p-value z ranksum
Sex1 = Sex(Sex.Sex == 1,:)
Sex2 = Sex(Sex.Sex == 2,:)

Surgery_No1 = Surgery(Surgery.Surgery == 1,:)
Surgery_No2= Surgery(Surgery.Surgery > 1,:)

Early_recOUT1 = EarlyRecOUT(EarlyRecOUT.Early_rec_withOUTi2ab_15mo == 1, :)
Early_recOUT2 = EarlyRecOUT(EarlyRecOUT.Early_rec_withOUTi2ab_15mo == 0, :) 

Early_recWITH1 = EarlyRecWITH(EarlyRecWITH.Early_rec_WITHi2ab_15mo == 1, :)
Early_recWITH2 = EarlyRecWITH(EarlyRecWITH.Early_rec_WITHi2ab_15mo == 0, :) 

Any_recOUT1 = AnyRecOUT(AnyRecOUT.Any_rec_withOUT_i2ab_6mo == 1, :)
Any_recOUT2 = AnyRecOUT(AnyRecOUT.Any_rec_withOUT_i2ab_6mo == 0, :) 

Any_recWITH1 = AnyRecWITH(AnyRecWITH.Any_rec_WITH_i2ab_6mo == 1, :)
Any_recWITH2 = AnyRecWITH(AnyRecWITH.Any_rec_WITH_i2ab_6mo == 0, :) 

%% 
padding = NaN(18,1);
figure,
subplot(1,2,1)
padding(1:14) = Early_recOUT1.min_flat;
boxplot([Early_recOUT2.min_flat, padding], "Labels",{" 0"," 1"})
title("EarlyRec min flat:")
subtitle(strcat(" P-value: " , sprintf("%.3f",all_p(21,6))))
subplot(1,2,2)
padding(1:14) = Early_recOUT1.mediana_flat;
boxplot([Early_recOUT2.mediana_flat, padding], "Labels",{" 0"," 1"})
title("EarlyRec median flat:")
subtitle(strcat(" P-value: " , sprintf("%.3f",all_p(21,6))))

padding = NaN(28,1);
figure,
subplot(1,2,1)
padding(1:12) = Any_recOUT2.min_flat;
boxplot([ padding,Any_recOUT1.min_flat], "Labels",{" 0"," 1"})
title("AnyRec min flat:")
subtitle(strcat(" P-value: " , sprintf("%.3f",all_p(20,7))))
subplot(1,2,2)
padding(1:12) = Any_recOUT2.mediana_flat;
boxplot([padding,Any_recOUT1.mediana_flat], "Labels",{" 0"," 1"})
title("AnyRec median flat:")
subtitle(strcat(" P-value: " , sprintf("%.3f",all_p(20,7))))
%%
pSex1={}; pSur1={};pEOUT1={};pEWITH1={};pAOUT1={};pAWITH1={};
pSex2={}; pSur2={};pEOUT1={};pEWITH2={};pAOUT2={};pAWITH2={};

for i =3:width(Sex)
    pSex1{i-2} = ranksum(Sex1{:,i},Sex1{:,1});
    pSex2{i-2} = ranksum(Sex2{:,i},Sex2{:,1});
    pSur1{i-2} = ranksum(Surgery_No1{:,i},Surgery_No1{:,1});
    pSur2{i-2} = ranksum(Surgery_No2{:,i},Surgery_No2{:,1}); 
    pEOUT1{i-2} = ranksum(Early_recOUT1{:,i},Early_recOUT1{:,1});
    pEOUT2{i-2} = ranksum(Early_recOUT2{:,i},Early_recOUT2{:,1});
    pEWITH1{i-2} = ranksum(Early_recWITH1{:,i},Early_recWITH1{:,1});
    pEWITH2{i-2} = ranksum(Early_recWITH2{:,i},Early_recWITH2{:,1});
    pAOUT1{i-2} = ranksum(Any_recOUT1{:,i},Any_recOUT1{:,1});
    pAOUT2{i-2} = ranksum(Any_recOUT2{:,i},Any_recOUT2{:,1});
    pAWITH1{i-2} = ranksum(Any_recWITH1{:,i},Any_recWITH1{:,1});
    pAWITH2{i-2} = ranksum(Any_recWITH2{:,i},Any_recWITH2{:,1});
end


%%
pSex1_2 = cell2mat([pSex1;pSex2])
pSur1_2 = cell2mat([pSur1;pSur2])
pEOUT1_2 = cell2mat([pEOUT1;pEOUT2])
pEWITH1_2 = cell2mat([pEWITH1;pEWITH2])
pAOUT1_2 = cell2mat([pAOUT1;pAOUT2])
pAWITH1_2 = cell2mat([pAWITH1;pAWITH2])
%% Cechy dla których 
disp("Znaczące cechy dla płci:")
znaczace_Sex1 = cechy_audiopocytow((pSex1_2(1,:)<0.05))
znaczace_Sex2 = cechy_audiopocytow((pSex1_2(2,:)<0.05))
disp("Znaczące cechy Surgery No. 1 lub więcej:")
znaczace_Sur1 = cechy_audiopocytow((pSur1_2(1,:)<0.05))
znaczace_Sur2 = cechy_audiopocytow((pSur1_2(2,:)<0.05))
disp("Znaczące cechy dla EarlyRecOUT:")
znaczace_EOUT1 = cechy_audiopocytow((pEOUT1_2(1,:)<0.05))
znaczace_EOUT2 = cechy_audiopocytow((pEOUT1_2(2,:)<0.05))
disp("Znaczące cechy dla EarlyRecWITH:")
znaczace_EWITH1 = cechy_audiopocytow((pEWITH1_2(1,:)<0.05))
znaczace_EWITH2 = cechy_audiopocytow((pEWITH1_2(2,:)<0.05))
disp("Znaczące cechy dla AnyRecOUT:")
znaczace_AOUT1 = cechy_audiopocytow((pAOUT1_2(1,:)<0.05))
znaczace_AOUT2 = cechy_audiopocytow((pAOUT1_2(2,:)<0.05))
disp("Znaczące cechy dla AnyRecOUT:")
znaczace_AWITH1 = cechy_audiopocytow((pAWITH1_2(1,:)<0.05))
znaczace_AWITH2 = cechy_audiopocytow((pAWITH1_2(2,:)<0.05))



%%
recurrent_surgery = sameoutcomes.RecurrentSurgery';
early_rec = sameoutcomes.Early_rec_withOUTi2ab_15mo';
any_rec = sameoutcomes.Any_rec_withOUT_i2ab_6mo';
patient_names = (Sex.PatientNames)';
razem = [any_rec;early_rec; patient_names]
%%
cechy_macierz = (table2array(Sex(:,3:end)))';

c = clustergram(cechy_macierz,"Standardize", "row", "ColumnLabels", patient_names, "RowLabels", cechy_audiopocytow);
cm = struct("GroupNumber", {45,40},"Annotation",{"1","0"},"Color",{"cyan","r"});
set(c,"ColumnGroupMarker",cm)
%% Early Rec OUT
c = clustergram(cechy_macierz,"Standardize", "row", "ColumnLabels", patient_names, "RowLabels", cechy_audiopocytow);
%%
fH = figure;
hA = plot(c,fH);
dim = [.2435 .727 .5753 .02];
annotation('rectangle',dim,'Color','cyan', 'FaceColor',[0 1 1])
annotation('rectangle',[.307 .727 .022 .02],'Color','red', 'FaceColor',[1 0 0])
annotation('rectangle',[.2435 .727 .034 .02],'Color','red', 'FaceColor',[1 0 0])
annotation('rectangle',[.38 .727 .012 .02],'Color','red', 'FaceColor',[1 0 0])
annotation('rectangle',[.405 .727 .012 .02],'Color','red', 'FaceColor',[1 0 0])
annotation('rectangle',[.519 .727 .012 .02],'Color','red', 'FaceColor',[1 0 0])
annotation('rectangle',[.554 .727 .012 .02],'Color','red', 'FaceColor',[1 0 0])
annotation('rectangle',[.654 .727 .012 .02],'Color','red', 'FaceColor',[1 0 0])
annotation('rectangle',[.733 .727 .023 .02],'Color','red', 'FaceColor',[1 0 0])
annotation('rectangle',[.791 .727 .0265 .02],'Color','red', 'FaceColor',[1 0 0])
title("Early Rec WithOUT i2ab 15 mo")
%% WITH
fH2 = figure;
hA2 = plot(c,fH2);
title("Early Rec WITH i2ab 15 mo")
dim = [.2435 .727 .5753 .02];
annotation('rectangle',dim,'Color','cyan', 'FaceColor',[0 1 1])
annotation('rectangle',[.307 .727 .022 .02],'Color','red', 'FaceColor',[1 0 0])
annotation('rectangle',[.2435 .727 .034 .02],'Color','red', 'FaceColor',[1 0 0])
annotation('rectangle',[.38 .727 .012 .02],'Color','red', 'FaceColor',[1 0 0])
annotation('rectangle',[.405 .727 .012 .02],'Color','red', 'FaceColor',[1 0 0])
annotation('rectangle',[.519 .727 .012 .02],'Color','red', 'FaceColor',[1 0 0])
annotation('rectangle',[.554 .727 .012 .02],'Color','red', 'FaceColor',[1 0 0])
annotation('rectangle',[.654 .727 .012 .02],'Color','red', 'FaceColor',[1 0 0])
annotation('rectangle',[.733 .727 .023 .02],'Color','red', 'FaceColor',[1 0 0])
annotation('rectangle',[.791 .727 .0265 .02],'Color','red', 'FaceColor',[1 0 0])

%% RecSur
fH3 = figure;
hA3 = plot(c,fH3);
dim = [.2435 .727 .5753 .02];
annotation('rectangle',dim,'Color','cyan', 'FaceColor',[0 1 1])
annotation('rectangle',[.341 .727 .012 .02],'Color','red', 'FaceColor',[1 0 0])
annotation('rectangle',[.405 .727 .012 .02],'Color','red', 'FaceColor',[1 0 0])
annotation('rectangle',[.518 .727 .012 .02],'Color','red', 'FaceColor',[1 0 0])
annotation('rectangle',[.57 .727 .012 .02],'Color','red', 'FaceColor',[1 0 0])
annotation('rectangle',[.73 .727 .012 .02],'Color','red', 'FaceColor',[1 0 0])
title('Rec Surgery')