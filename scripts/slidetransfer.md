Transfer learning for landslide susceptibility modelling using domain adaptation(DA) and case-based reasoning(CBR)
================
Zhihao Wang
First published 28 March 2022, last edited 19 April 2022

## Preface

This vignette walks you through most of the analyses performed for the
paper that introduces strategies used in paper. Please refer to that paper for
conceptual and formal details, and cite it when using or
referring to the methods and results presented herein.

> Wang, Z. H., Goetz, J. N., Brenning, A. (submitted) Transfer learning for landslide 
> susceptibility modelling using domain adaptation and case-based reasoning. Submitted to
> Geoscientific Model Development, April 2022.

We list 8 strategies for single and multiple source areas and describe them in step.

The strategies involved DA need first run LMDA.py to get DA-drived data set.
The strategies involved CBR need first run Similarity_functions.R to get similarity of each source area.

## Getting started

### Work environment

Make sure that all required packages and their dependencies are
installed and up-to-date.
In addition, you will need the packages `numpy`, `sklearn.metrics`,
`cvxopt`, `pandas`, `torch` for running DA based on python and the packages `mgcv`, 
`ROCR` for running CBR based on r.

### Case study and data preparation

We use Burgenland with a 10 m * 10 m resolution as the target area and Paldau with
a 10 m * 10 m resolution and Waidhofen with a 10 m * 10 m resolution as source areas.

data_1.csv are from the study area named Burgenland. 

data_2.csv are from the study area named Paldau.

data_3.csv are from the study area named Waidhofen.

Note: these data are subset of whole data sets for quick going through methods used.
Please find all data sets in Data availability in paper.

Let's get started by preparing the data set:

``` r

data1 <- read.csv("~/test_data/data_1.csv") # Burgenland
data2 <- read.csv("~/test_data/data_2.csv") # Paldau
data3 <- read.csv("~/test_data/data_3.csv") # Waidhofen

# Set up lists of features and model formulas:
vars <- c("slope", "cslope", "log.carea", "plancurv", "profcurv")


# Formula for fitting the model with all features:
fo <- as.formula(slides ~ s(slope, k = 4)+s(plancurv, k =4) +
                  s(profcurv, k = 4) + s(log.carea, k = 4) + s(cslope, k = 4))

```

### Strategies

We introduce case-based reasoning method and domain adaptation used in paper, respectively.

Case-based reasoning method:

(1) Similarity_functions.R ------- calculating the similarity between the source area and the target area

(2) Landslide_Susceptibility_Modeling.R ------- training the landslide susceptibility model based on results of (1)

``` r

# calculating overall similarities

source("~/scripts/Similarity_functions.R") # similarity functions of all attributes

attributes <- readRDS("~/test_data/attributes.rds") # load attributes of all study areas

# > attributes$Burgenland_10m
# mean slope          std slope            igneous        sedimentary        metamorphic       total relief 
# 8.3                6.7                1.0                1.0                1.0              529.9 
# spatial resolution 
# 10.0 

## test target area: Burgenland 10m

### test source area: Paldau 10m

sim_meanslope_paldau <- MEANSLOPE_SIMILARITY_FUN(attributes$Paldau_10m, attributes$Burgenland_10m, 40) 
# result: 0.95
sim_resolution_paldau <- RESOLUTION_SIMILARITY_FUN(attributes$Paldau_10m, attributes$Burgenland_10m)
# result: 1
sim_totalrelief_paldau <- TOTALRELIEF_SIMILARITY_FUN(attributes$Paldau_10m, attributes$Burgenland_10m)
# result: 0.96
sim_stdslope_paldau <- STDSLOPE_SIMILARITY_FUN(attributes$Paldau_10m, attributes$Burgenland_10m)
# result: 0.92
sim_geounits_paldau <- GEOLOGICALUNITS_SIMILARITY_FUN(attributes$Paldau_10m, attributes$Burgenland_10m)
# result: 1

overall_sim_paldau <- min(sim_meanslope_paldau,sim_resolution_paldau,sim_totalrelief_paldau,sim_stdslope_paldau,sim_geounits_paldau)
# result: 0.92

### test source area: Waidhofen 10m

sim_meanslope_waidhofen <- MEANSLOPE_SIMILARITY_FUN(attributes$Waidhofen_10m, attributes$Burgenland_10m, 40) 
# result: 0.66
sim_resolution_waidhofen <- RESOLUTION_SIMILARITY_FUN(attributes$Waidhofen_10m, attributes$Burgenland_10m)
# result: 1
sim_totalrelief_waidhofen <- TOTALRELIEF_SIMILARITY_FUN(attributes$Waidhofen_10m, attributes$Burgenland_10m)
# result: 0.97
sim_stdslope_waidhofen <- STDSLOPE_SIMILARITY_FUN(attributes$Waidhofen_10m, attributes$Burgenland_10m)
# result: 0.695
sim_geounits_waidhofen <- GEOLOGICALUNITS_SIMILARITY_FUN(attributes$Waidhofen_10m, attributes$Burgenland_10m)
# result: 1

overall_sim_waidhofen <- min(sim_meanslope_waidhofen,sim_resolution_waidhofen,sim_totalrelief_waidhofen,sim_stdslope_waidhofen,sim_geounits_waidhofen)
# result: 0.66

# Landslide Susceptibility Modeling

source("Landslide_Susceptibility_Modeling.R")

```

Landmark domain adaptation:

(1) LMDA.py ------- selecting subset of the source area with same data distribution as the target area

(2) Landslide_Susceptibility_Modeling.R ------- training the landslide susceptibility model based on results of (1)

``` python

# selecting subset

import LMDA # make sure you are in the right path

if __name__ == '__main__':
## import source area Paldau 10
   
     source_area = pd.DataFrame(pd.read_csv("data_2.csv"),
                         columns=["x","y","dem","slope","carea", "cslope", "plancurv", "profcurv",
                                  "log.carea", "slides"])
     source_label = source_area["slides"].values.astype(int)
     source_predictors = pd.DataFrame(source_area,
                         columns=["carea", "slope", "cslope", "plancurv", "profcurv",
                                  "log.carea"]).values
     source_predictors = torch.tensor(source_predictors)
     
   ## import target area Burgenland 10
 
     target = pd.DataFrame(pd.read_csv("data_1.csv"),
                          columns=["carea", "slope", "cslope", "plancurv", "profcurv",
                                  "log.carea"]).values
     target = torch.tensor(target)

   ## Obtaining beta
   
     a = selects(source_predictors, target, source_label)
     beta = np.array(a['x'])
     
   ## Save source area with beta as .csv file
   
     source_beta = np.append(source_area, beta, axis = 1)
     np.savetxt("source_beta_paldau.csv", source_beta, delimiter=',')
     
## the process of Waidhofen 10 is same as taht of Paldau 10, the result is source_beta_waidhofen.csv.
```

``` r
# setting the threshold

data1 <- read.csv("~/test_data/data_1.csv")
data2 <- read.csv("~/test_data/data_2.csv")
data3 <- read.csv("~/test_data/data_3.csv")

threshold_paldau <- 1/ nrow(data2)
threshold_waidhofen <- 1/ nrow(data3)

# selecting the landmarks

bu_paldau <- read.csv("~/test_data/source_beta_paldau.csv")
bu_waidhofen <- read.csv("~/test_data/source_beta_waidhofen.csv")

bu_paldau_landmarks <- bu_paldau[which(bu_paldau$beta>threshold_paldau),]
bu_waidhofen_landmarks <- bu_waidhofen[which(bu_waidhofen$beta>threshold_waidhofen),]

summary(bu_waidhofen_landmarks)
summary(bu_paldau_landmarks)

# Landslide Susceptibility Modeling

source("Landslide_Susceptibility_Modeling.R")

```

There are two scenarios we consider:

Single source area learning --- only one source area as training data set 

Multiple source areas learning --- more than one source areas as training data sets.


###### Single source area with CBR

This strategy is to use the most related source area as traning data.

![singlecbr](https://user-images.githubusercontent.com/60289894/164320002-997b9371-ccd2-4343-981f-4df99ee67231.PNG)
    


``` r
    ### here is Paldau 10
    fit_paldau_singlecbr <- Landslide_Susceptibility_Modeling(fo, data2)
    par(mfrow=c(2,3),mex=0.7,mar=c(5,5,2,2))
    plot(fit_paldau_singlecbr, residuals = FALSE, se = TRUE, ylim = c(-3,3))
    
```   
![rsinglecbr](https://user-images.githubusercontent.com/60289894/164337269-1fd79b08-530d-478d-b3fc-e445b84beb2d.png)

###### Single source area with DA

This strategy is to use DA-drived subset of the source area as traning data.
  
![singleDA](https://user-images.githubusercontent.com/60289894/164317509-96f48cb0-9f1c-4ba3-aac4-d526b3955ed2.png)
  
 ``` r
 
    fit_paldau_singleda <- Landslide_Susceptibility_Modeling(fo, bu_paldau_landmarks)
    fit_waidhofen_singleda <- Landslide_Susceptibility_Modeling(fo, bu_waidhofen_landmarks)
    par(mfrow=c(2,3),mex=0.7,mar=c(5,5,2,2))
    plot(fit_paldau_singleda, residuals = FALSE, se = TRUE, ylim = c(-3,3))
    par(mfrow=c(2,3),mex=0.7,mar=c(5,5,2,2))
    plot(fit_waidhofen_singleda, residuals = FALSE, se = TRUE, ylim = c(-3,3))
    
 ```
 
![rsingledawa](https://user-images.githubusercontent.com/60289894/164338937-a42f2a06-14b0-449c-aaa8-51a00963fb6f.png)
![rsingledapal](https://user-images.githubusercontent.com/60289894/164338942-0408358e-b050-4be6-8f4c-4f773845eae5.png)


###### Multiple source areas with CBR
    

This strategy is to use the related source areas as traning data.

![multicbr](https://user-images.githubusercontent.com/60289894/164320280-272c64eb-2dd2-4c19-badb-3fcdf9b3ab60.PNG)

``` r   
    fit_paldau <- Landslide_Susceptibility_Modeling(fo, data2)
    fit_waidhofen <- Landslide_Susceptibility_Modeling(fo, data3)
    
    predbupaldau <- predict(fit_paldau, newdata = data1, type = "response")
    predbuwaidhofen <- predict(fit_waidhofen, newdata = data1, type = "response")
    
    final_predmulticbr <- overall_sim_waidhofen*predbuwaidhofen + overall_sim_paldau*predbupaldau 
```
###### Multiple source areas with DA

This strategy is to use DA-drived subsets of all source area as traning data.

![multida](https://user-images.githubusercontent.com/60289894/164320012-9c4339cc-98f9-4ee9-8e16-847924110578.PNG)

``` r  
    predbupaldauda <- predict(fit_paldau_singleda, newdata = data1, type = "response")
    predbuwaidhofenda <- predict(fit_waidhofen_singleda, newdata = data1, type = "response")
    
    final_predmultida <- 1/2 * predbuwaidhofenda + 1/2 * predbupaldauda
```   

###### Multiple source areas with CBR and DA
    
This strategy is to use DA-drived subsets of the related source areas as traning data.

![multicbrda](https://user-images.githubusercontent.com/60289894/164320020-c3a73f2c-37d9-4917-9f61-1eb4f13184c0.PNG)

``` r    
    final_predmulticbrda <- overall_sim_waidhofen*predbuwaidhofenda + overall_sim_paldau*predbupaldauda
```    

##### Benchmark

###### Single source area benchmark

This strategy is to use each source area as traning data.

![singlebench](https://user-images.githubusercontent.com/60289894/164320033-003f4b61-7d3b-4520-af2e-d6a34120ddcb.PNG)    
                  
 ``` r
 
    fit_singlebenchmark <- Landslide_Susceptibility_Modeling(fo, data3) # and data2
    par(mfrow=c(2,3),mex=0.7,mar=c(5,5,2,2))
    plot(fit_singlebenchmark, residuals = FALSE, se = TRUE, ylim = c(-3,3))
    
 ```   

![rsinglebenchamrk](https://user-images.githubusercontent.com/60289894/164338944-1c6ab0b9-50a0-456d-a24b-4c1eb92bd882.png)

###### Multiple source areas benchmark

This strategy is to use all source area as traning data.
    
![multibench](https://user-images.githubusercontent.com/60289894/164320024-7a444783-0cea-4d75-aff8-dac9d8e0d343.PNG)

 ``` r
    final_predmultibenchmark <- 1/2*predbuwaidhofen + 1/2*predbupaldau

 ```

###### Target benchmark

This strategy is to use the target area itself as traning data.

![targetbench](https://user-images.githubusercontent.com/60289894/164320041-6f88323b-6dba-4efd-aaf6-c26ea1bdb2eb.PNG)
    
  ``` r
    fit_targetbenchmark <- Landslide_Susceptibility_Modeling(fo, data1)
    par(mfrow=c(2,3),mex=0.7,mar=c(5,5,2,2))
    plot(fit_targetbenchmark, residuals = FALSE, se = TRUE, ylim = c(-3,3))
  ```
![rtarget](https://user-images.githubusercontent.com/60289894/164338943-d6253ba5-f765-43f6-8477-2f2b93f23960.png)
