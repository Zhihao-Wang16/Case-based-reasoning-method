
# Author: Zhihao Wang - zhihao.wang@uni-jena.de

#----------------------Landslide Susceptibility Modeling----------------------------------------------

# Landslide susceptibility modeling is based on Generalized additive model (GAM).
# The dimension of the basis used to represent the smooth term k as 4.

# @Description of parameters
# # train_data ---- a `data.frame`, data from the source area with the highest similarity to the target area
#
# # formula ---- a `formula`, consist of landslide susceptibility predictors

# @Example
# # library(sperrorest)
# # data(ecuador) # Muenchow et al. (2012), see ?ecuador
# # fo <- as.formula(slides ~ s(slope, k = 4)+s(hcurv, k =4) +
# #                   s(vcurv, k = 4)+s(log.carea, k = 4)+s(cslope, k = 4))
# # train_data = ecuador
# # fit <- Landslide_Susceptibility_Modeling(fo, train_data)


Landslide_Susceptibility_Modeling <- function(formula, train_data){

  if(!require("mgcv")) install.packages("mgcv")

  fitgam = mgcv::gam(formula, data = train_data, method = "REML",family = "binomial")

  return(fitgam)

}
