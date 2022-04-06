#---------------------- Single- and Multi- source areas strategies ----------------------------------------------

# We list 8 strategies for single- and multi- source areas and describe them in step.

# The strategies involved DA need first run LMDA.py to get DA-drived data set.
# The strategies involved CBR need first run Similarity_functions.R to get similarity of each source area.


## Single source area with CBR

    "
    This strategy is to use the most strongly related source area as traning data.
    
    step 1: importing the most strongly related source area
    step 2: constructing the tarin data set based on step 1
    step 3: obtaining the landslide susceptibility model trained by step 2
    step 4: predicting the target area using model obtained by step 3

    "
    
## Single source area with DA
    
    "
    This strategy is to use DA-drived subset of the source area as traning data.
    
    step 1: importing DA-drived subset of the source area
    step 2: constructing the tarin data set based on step 1
    step 3: obtaining the landslide susceptibility model trained by step 2
    step 4: predicting the target area using model obtained by step 3

    " 

## Multiple source areas with CBR
    
    "
    This strategy is to use the related source areas as traning data.
    
    step 1: importing the related source area datasets
    step 2: constructing the tarin data set of each related source area
    step 3: obtaining the landslide susceptibility model of each related source area trained by step 2
    step 4: constructing the final model:
    
              weight = similarity of each related source area/ sum(simlarities of all related source area)
              final model = mean(model based on step 3 * weight)
                
    step 5: predicting the target area using model obtained by step 4

    " 

## Multiple source areas with DA
    
    "
    This strategy is to use DA-drived subsets of all source area as traning data.
    
    step 1: importing DA-drived subset of each source area
    step 2: constructing the tarin data set of each source area
    step 3: obtaining the landslide susceptibility model of each source area trained by step 2
    step 4: constructing the final model:
    
              weight = 1 / the number of source areas
              final model = mean(model based on step 3 * weight)
              
    step 5: predicting the target area using model obtained by step 4

    " 

## Multiple source areas with CBR and DA
    
    
    "
    This strategy is to use DA-drived subsets of the related source areas as traning data.
    
    step 1: importing DA-drived subsets of the related source area datasets
    step 2: constructing the tarin data set of DA-drived subsets of each related source area
    step 3: obtaining the landslide susceptibility model of each related source area trained by step 2
    step 4: constructing the final model:
    
              weight = similarity of each related source / sum(simlarities of all related source area)
              final model = mean(model based on step 3 * weight)
                
    step 5: predicting the target area using model obtained by step 4

    " 


## Benchmark

### Single source area benchmark
    
    "
    This strategy is to use each source area as traning data.
    
    step 1: importing each source area
    step 2: constructing the tarin data set based on step 1
    step 3: obtaining the landslide susceptibility model trained by step 2
    step 4: predicting the target area using model obtained by step 3

    " 


### Multiple source areas benchmark
    
    "
    This strategy is to use all source area as traning data.
    
    step 1: importing all source area datasets
    step 2: constructing the tarin data set of each source area
    step 3: obtaining the landslide susceptibility model of each source area trained by step 2
    step 4: constructing the final model:
    
              weight = 1 / the number of source areas
              final model = mean(model based on step 3 * weight)
                
    step 5: predicting the target area using model obtained by step 4

    " 


### Target benchmark

    
    "
    This strategy is to use the target area itself as traning data.
    
    step 1: importing the target area
    step 2: constructing the tarin data set based on step 1
    step 3: obtaining the landslide susceptibility model trained by step 2
    step 4: predicting the target area using model obtained by step 3

    " 
