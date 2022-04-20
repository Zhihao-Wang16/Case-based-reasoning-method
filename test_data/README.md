# Test data files

data_1.csv: a data frame with point samples of landslide and non-landslide locations from the study area named Burgenland with 10 m resolution.

data_2.csv: a data frame with point samples of landslide and non-landslide locations from the study area named Paldau with 10 m resolution.

data_3.csv: a data frame with point samples of landslide and non-landslide locations from the study area named Waidhofen with 10 m resolution.

attributes.rds: attributes of all study area for calculating overall similaritis. It includes:

    Geological characteristics: igneous, sedimentary, metamorphic
    Data characteristics: spatial resolution
    topographic characteristics: total relief --- the maximum minus minimum elevation within the study area
                                 mean slope --- average slope of the study area
                                  standard deviation of slope --- standard deviation of slope of the study area
 
 
 # Result files
 
 source_beta_paldau.csv: a data frame obtained by domain adaptation (DA) from the source area Paldau, target area Buegenland
 
 source_beta_waidhofen.csv: a data frame obtained by domain adaptation (DA) from the source area Waidhofen, target area Buegenland                                 
