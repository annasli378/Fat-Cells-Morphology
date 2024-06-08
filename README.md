# Adiopocyte analysis

Adipocytes are adipose tissue cells and are the body's main energy store. Their main role is to store energy in the form of triglycerides. In a situation of higher energy demand, the body can derive the substrates it needs from the stored reserves through the process of lipolysis, i.e. breakdown. On the other hand, when the food supply is too high and the amount of energy expended by the body is lower, lipogenesis will occur and the excess will be deposited in the fat cells.  

## Data 
Input: H&E 40x digital images in .tif format.

## Aim 

1. Analysis of fat cells morphology (area, shape and distance from other cells) in the bedding of the small intestine. 
2. To see if correlations can be found between these characteristics and variables such as gender or the need for reccurent surgery.

## Steps

### Notebook fatcells_features.ipynb
Fat cell segmentation and feature extraction file program - authors of the original paper see: https://github.com/abebe9849/Crohn_wsi

### Notebook features_analysis.ipynb
Analysis of the data and matching it with patient information:
- search for correlations (Pearson)
- analysis of differences between groups (Ranksum)
- clustering (Clustergram)

## Results
### Correlation analysis
The first step was to look for correlations between fat cell features and patient characteristics. It was particularly important to check the correlation between the features and whether the patient required re-operation. The alpha used was equal 0.05

| Patient feature | Fat Cell feature    | Pearson corr | P value |
|-----------------|---------------------|--------------|---------|
| AgeAtSurgery    | mean area           | 0.4492       | 0.0017  |
| AgeAtSurgery    | median area         | 0.3455       | 0.0187  |
| AgeAtSurgery    | area variance       | 0.4279       | 0.0030  |
| AgeAtSurgery    | area std            | 0.4814       | 0.0007  |
| AgeAtSurgery    | area 3rd quartile   | 0.4632       | 0.0012  |
| AgeAtSurgery    | area quartile range | 0.5038       | 0.0003  |


|               Patient_ft | Cell_ft | pearson_corr_coef | p_value |
|--------------------------|---------|-------------------|---------|
|           AgeAtDiagnosis |    mean |           -0.3254 |  0.0311 | 
|           AgeAtDiagnosis |    skew |           -0.3732 |  0.0386 | 
|           AgeAtDiagnosis |      Q3 |           -0.3398 |  0.0240 | 
|             AgeAtSurgery |    mean |           -0.4091 |  0.0048 |
|             AgeAtSurgery |  median |           -0.3630 |  0.0132 |
|             AgeAtSurgery |     std |           -0.3602 |  0.0139 |
|             AgeAtSurgery |    skew |           -0.3832 |  0.0304 |
|             AgeAtSurgery |  maxmin |           -0.3902 |  0.0073 |   
|             AgeAtSurgery |      Q1 |           -0.3165 |  0.0321 |   
|             AgeAtSurgery |      Q3 |           -0.4488 |  0.0018 |   
|             AgeAtSurgery |       Q |           -0.3560 |  0.0152 |   
| Any_rec_withOUT_i2ab_6mo |    kurt |           -0.4681 |  0.0120 |   
|    Any_rec_WITH_i2ab_6mo |    kurt |           -0.4681 |  0.0120 |   






## Bibliography

