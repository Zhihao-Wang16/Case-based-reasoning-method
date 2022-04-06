
Case-based reasoning methods:

   (1) Similarity_functions.R              ------- calculating the simialrity between the source area and the target area
   
   (2) Landslide_Susceptibility_Modeling.R ------- training the landslide suseceptibility model based on results of (1)
 
Landmark domain adaptation:

   (1) LMDA.py                             ------- selecting subset of the source area with same data distribution as the target area
   
   (2) Landslide_Susceptibility_Modeling.R ------- training the landslide suseceptibility model based on results of (1)

Single- and Multi- source areas strategies:

   This part considers two scenarios --- only one source area as training dataset
                                     --- more than one source areas as training datasets

Hence, 8 strategies are carried out,

    Transfer strategies:
        (1) Single source area with CBR
        (2) Single source area with DA
        (3) Multi source areas with CBR
        (4) Multi source areas with DA
        (5) Multi source areas with CBR and DA
     Transfer benchmarks:
        (1) Single source area benchmark
        (2) Multi source areas benchmark
     Target benchmark:
        (1) Targte benchmark
     
In Strategies.R, you can find the steps for those strategies.
