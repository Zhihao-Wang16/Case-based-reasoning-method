# Single source area with Case-based reasoning method

# It includes Similarity Functions and Landslide Susceptibility Modeling.

# Author: Zhihao Wang - zhihao.wang@uni-jena.de

#----------------------Similarity Functions---------------------------------------------------------------------

# Similarity functions for Geological characteristics, Data characteristics and Characteristics of study area

# @Description of parameters
# # source_area ---- a `data.frame`, rows represent values of attributes for study area for train data
#
# # target_area ---- a `data.frame`, rows represent values of attributes for study area for test data

# @Example
# Spatial resolution between Ecuador with 10m resolution and Bologna with 25m resolution
# # source_area = 10
# # target_area = 25
# # RESOLUTION_SIMILARITY_FUN(source_area, target_area)


### Spatial Resolution

RESOLUTION_SIMILARITY_FUN <- function(source_area, target_area){

  if (source_area <= target_area) {

    sim_resolution <- 2 ^ -(2 * abs(log10(source_area)-log10(target_area))) ^ 0.5

  }else{

    sim_resolution <- 1

  }

  return(sim_resolution)

}

### Total relief

TOTALRELIEF_SIMILARITY_FUN <- function(source_area, target_area){

  sim_totalrelief <- 1-(abs(source_area - target_area) / max(8848-source_area, source_area))

  return(sim_totalrelief)

}

### Mean Slope

MEANSLOPE_SIMILARITY_FUN <- function(source_area, target_area, limit_Slope){

  # Args:
  #   limit_slope: should cover mean slope of each study area, in our paper is 40.

  sim_meanslope <- 1 - (abs(source_area - target_area) / max(limit_slope-source_area, source_area))

  return(sim_meanslope)

}

### STANDARD DEVIATION OF SLOPE

STDSLOPE_SIMILARITY_FUN <- function(source_area, target_area){

  sim_stdslope <-  2 ^ -(2*abs(log10(source_area)-log10(target_area))) ^ 0.5

  return(sim_stdslope)

}

### GEOLOGICAL UNITS

GEOLOGICALUNITS_SIMILARITY_FUN <- function(source_area, target_area){

  Igneous_sim = !is.null(intersect(source_area$Igneous, target_area$Igneous))

  Sedimentary_sim = !is.null(intersect(source_area$Sedimentary, target_area$Sedimentary))

  Metamorphic_sim = !is.null(intersect(source_area$Metamorphic, target_area$Metamorphic))

  sim_geounits = mean(c(Igneous_sim, Sedimentary_sim, Metamorphic_sim))

  return(sim_geounits)

}








