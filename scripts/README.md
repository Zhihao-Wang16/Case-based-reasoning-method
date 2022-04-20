
# Case-based reasoning methods:

   ### (1) Similarity_functions.R              ------- calculating the simialrity between the source area and the target area
   
   It includes:
   
   #### RESOLUTION_SIMILARITY_FUN(source_area, target_area):
   
   formula of spatial resolution 
   
   ![resolution](https://user-images.githubusercontent.com/60289894/164326195-a7eaaef1-67ff-4926-9f0d-a6f24cc85a92.PNG)
   
   #### TOTALRELIEF_SIMILARITY_FUN(source_area, target_area):
   
   formula of total relief (the maximum minus minimum elevation within the study area)
   
   ![totalrelief](https://user-images.githubusercontent.com/60289894/164326190-6375fbb8-eee3-4085-b8d6-289956e0a1ad.PNG)
   
   #### MEANSLOPE_SIMILARITY_FUN(source_area, target_area):
   
   formula of mean slope
   
   ![mean](https://user-images.githubusercontent.com/60289894/164326202-97b7d3ff-61dc-4610-89c4-477e05dc50e1.PNG)
   
   #### STDSLOPE_SIMILARITY_FUN(source_area, target_area):
   
   formula of standard deviation of slope
   
   ![std](https://user-images.githubusercontent.com/60289894/164326205-0bf01cd3-fea0-4f01-95ee-05ef285c9b0f.PNG)
   
   #### GEOLOGICALUNITS_SIMILARITY_FUN(source_area, target_area):
   
   formula of geological characteristics: igneous, sedimentary, metamorphic
   
   ![geounits](https://user-images.githubusercontent.com/60289894/164326199-90a31094-34d5-414c-ad1d-c173dc7150b3.PNG)
   
   ### (2) Landslide_Susceptibility_Modeling.R ------- training the landslide suseceptibility model based on results of (1)
 
# Landmark domain adaptation:

   ### (1) LMDA.py                             ------- selecting subset of the source area with same data distribution as the target area
   
   
   
   ### (2) Landslide_Susceptibility_Modeling.R ------- training the landslide suseceptibility model based on results of (1)

# Single- and Multi- source areas strategies:

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
     
# Examples for those strategies

Please see slidetransfer.md to find more details.


