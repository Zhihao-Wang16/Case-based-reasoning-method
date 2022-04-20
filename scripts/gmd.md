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


``` r
## Single source area with CBR
    "
    This strategy is to use the most related source area as traning data.
                              f(S_highest)
    
    " 
    ### here is Paldau 10
    
    fit_paldau_singlecbr <- Landslide_Susceptibility_Modeling(fo, data2)
    
## Single source area with DA
    
    "
    This strategy is to use DA-drived subset of the source area as traning data.
                               
                               <img src="singleda.png" width="100%" style="display: block; margin: auto;" />

    " 
    
    fit_paldau_singleda <- Landslide_Susceptibility_Modeling(fo, bu_paldau_landmarks)
    fit_waidhofen_singleda <- Landslide_Susceptibility_Modeling(fo, bu_waidhofen_landmarks)


## Multiple source areas with CBR
    
    "
    This strategy is to use the related source areas as traning data.
                         ¡Æ w_i*f_i(S_i)

    " 
    fit_paldau <- Landslide_Susceptibility_Modeling(fo, data2)
    fit_waidhofen <- Landslide_Susceptibility_Modeling(fo, data3)
    
    fit_multicbr <- overall_sim_waidhofen*fit_waidhofen + overall_sim_paldau*fit_paldau 

## Multiple source areas with DA
    
    "
    This strategy is to use DA-drived subsets of all source area as traning data.
                        1/N * ¡Æ f_i(D_i)
    " 
    
    fit_multida <- 1/2 * fit_paldau + 1/2 * fit_paldau
    

## Multiple source areas with CBR and DA
    
    
    "
    This strategy is to use DA-drived subsets of the related source areas as traning data.
    
                         ¡Æ w_i * f_i(D_i)

    " 
    
    fit_multicbrda <- overall_sim_waidhofen*fit_waidhofen_singleda + overall_sim_paldau*fit_paldau_singleda
    

## Benchmark

### Single source area benchmark
    
    "
    This strategy is to use each source area as traning data.
    
                           f_i(S_i)
    " 
    fit_singlebenchmark <- Landslide_Susceptibility_Modeling(fo, data3) # and data2
    

### Multiple source areas benchmark
    
    "
    This strategy is to use all source area as traning data.
    
                       1/N * ¡Æf_i(S_i)

    " 
    fit_multibenchmark <- 1/2*fit_waidhofen + 1/2*fit_paldau


### Target benchmark

    
    "
    This strategy is to use the target area itself as traning data.
    
                            f(T)
    " 
    
    fit_targetbenchmark <- Landslide_Susceptibility_Modeling(fo, data1)

```

