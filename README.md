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

### Notebook cell_features_analysis.ipynb
Analysis of the data and matching it with patient information:
- search for correlations (Pearson)
- analysis of differences between groups (Ranksum)
- clustering (Clustergram)

## Results
### Correlation analysis
The first step was to look for correlations between fat cell features and patient characteristics. It was particularly important to check the correlation between the features and whether the patient required re-operation. The alpha used was equal 0.05. The obtained correlation values, which are statistically significant, have a value between |0.3| and |0.5|, so are rather at a weak/medium.

Table 1. Patient features vs Fat Cell Areas features 
| Patient feature | Fat Cell feature    | Pearson corr | P value |
|-----------------|---------------------|--------------|---------|
| AgeAtSurgery    | mean area           | 0.4492       | 0.0017  |
| AgeAtSurgery    | median area         | 0.3455       | 0.0187  |
| AgeAtSurgery    | area variance       | 0.4279       | 0.0030  |
| AgeAtSurgery    | area std            | 0.4814       | 0.0007  |
| AgeAtSurgery    | area 3rd quartile   | 0.4632       | 0.0012  |
| AgeAtSurgery    | area quartile range | 0.5038       | 0.0003  |

![img3](https://github.com/annasli378/Fat-Cells-Morphology/blob/main/img3.png)



Table 2. Patient features vs Fat Cell Background features 
|          Patient feature | Fat Cell feature           | Pearson corr | P value |
|--------------------------|----------------------------|--------------|---------|
|           AgeAtDiagnosis |  background mean           |     -0.3254  |  0.0311 | 
|           AgeAtDiagnosis |  background skewness       |      -0.3732 |  0.0386 | 
|           AgeAtDiagnosis |  background 3rd quartile   |      -0.3398 |  0.0240 | 
|             AgeAtSurgery |  background mean           |      -0.4091 |  0.0048 |
|             AgeAtSurgery |  background median         |      -0.3630 |  0.0132 |
|             AgeAtSurgery |  background std            |      -0.3602 |  0.0139 |
|             AgeAtSurgery |  background skewness       |      -0.3832 |  0.0304 |
|             AgeAtSurgery |  background range          |      -0.3902 |  0.0073 |   
|             AgeAtSurgery |  background 1st quartile   |      -0.3165 |  0.0321 |   
|             AgeAtSurgery |  background 3rd quartile   |      -0.4488 |  0.0018 |   
|             AgeAtSurgery |  background quartile range |      -0.3560 |  0.0152 |   
| Any_rec_withOUT_i2ab_6mo |  background kurtosis       |      -0.4681 |  0.0120 |   
|    Any_rec_WITH_i2ab_6mo |  background kurtosis       |      -0.4681 |  0.0120 |   

![img2](https://github.com/annasli378/Fat-Cells-Morphology/blob/main/img2.png)

![img1](https://github.com/annasli378/Fat-Cells-Morphology/blob/main/img1.png)


Table 3. Patient features vs Fat Cell Distances features 
| Patient feature            | Fat Cell feature         | Pearson corr | P value |
|----------------------------|--------------------------|--------------|---------|
|             AgeAtDiagnosis |        distanes skewness |      -0.3759 |  0.0119 |
|               AgeAtSurgery |        distanes skewness |      -0.3544 |  0.0157 |
| Early_rec_withOUTi2ab_15mo |       distances variance |      -0.3683 |  0.0381 |
| Early_rec_withOUTi2ab_15mo |            distances std |      -0.3737 |  0.0351 |
| Early_rec_withOUTi2ab_15mo | distances quartile range |      -0.4157 |  0.0180 |
|    Early_rec_WITHi2ab_15mo |      distanece variation |      -0.3683 |  0.0381 |
|    Early_rec_WITHi2ab_15mo |             distance std |      -0.3737 |  0.0351 |
|    Early_rec_WITHi2ab_15mo | distances quartile range |      -0.4157 |  0.0180 |

Table 4. Patient features vs Fat Cell Flatness features 
| Patient feature            | Fat Cell feature | Pearson corr | P value |
|----------------------------|------------------|--------------|---------|
| Early_rec_withOUTi2ab_15mo |   flatness range |      -0.4192 |  0.0169 |
|    Early_rec_WITHi2ab_15mo |   flatness range |      -0.4192 |  0.0169 |
|   Any_rec_withOUT_i2ab_6mo |  flatness median |       0.3260 |  0.0401 |
|      Any_rec_WITH_i2ab_6mo |  flatness median |       0.3260 |  0.0401 |

### Wilcoxon rank-sum test
The Wilcoxon rank-sum tests the null hypothesis that two sets of measurements are drawn from the same distribution. In this case, characteristics that divided patients into distinct groups (0/1) were analysed.

No differences were noted for the groups: Sex and Reccurent Surgery. The differences for the other groups are shown below.

Table 5. Differences in Early rec withOUT
| Fat Cell feature        | Statistic | P value |
|-------------------------|-----------|---------|
| Background 1st quartile |    2.1273 |  0.0334 |
| Background 3rd quartile |    2.0513 |  0.0402 |
| Distance quartile range |    2.2032 |  0.0276 |
|          Flatness range |    2.0893 |  0.0367 |

Table 6. Differences in Early rec WITH
| Fat Cell feature        | Statistic | P value |
|-------------------------|-----------|---------|
| Background 1st quartile |    2.1273 |  0.0334 |
| Background 3rd quartile |    2.0513 |  0.0403 |
| Distance quartile range |    2.2033 |  0.0276 |
|          Flatness range |    2.0893 |  0.0367 |

Table 7. Differences in Any rec withOUT
| Fat Cell feature        | Statistic | P value |
|-------------------------|-----------|---------|
|         Background mean |    2.1840 |  0.0290 |
|       Background median |    2.0660 |  0.0388 |
| Background 1st quartile |    2.0365 |  0.0417 |
| Background 3rd quartile |    2.2136 |  0.0269 |

Table 8. Differences in Any rec WITH
| Fat Cell feature        | Statistic | P value |
|-------------------------|-----------|---------|
|         Background mean |    2.1840 |  0.0289 |
|       Background median |    2.0660 |  0.0388 |
| Background 1st quartile |    2.0365 |  0.0417 |
| Background 3rd quartile |    2.2136 |  0.0269 |

### Clusterization results

![img4](https://github.com/annasli378/Fat-Cells-Morphology/blob/main/kmeans1.png)

![img5](https://github.com/annasli378/Fat-Cells-Morphology/blob/main/clusters1.png)

![img6](https://github.com/annasli378/Fat-Cells-Morphology/blob/main/kmeans2.png)

![img7](https://github.com/annasli378/Fat-Cells-Morphology/blob/main/clusters2.png)



## Bibliography
 - https://github.com/abebe9849/Crohn_wsi
 - https://docs.scipy.org/doc/scipy/reference/generated/scipy.stats.ranksums.html
