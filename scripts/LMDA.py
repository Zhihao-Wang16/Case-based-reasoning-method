# -*- coding: utf-8 -*-
"""
Created on Thu Sep  2 16:35:21 2021

@author: Zhihao Wang
"""
########### Import Functions ########################################

import numpy as np
from numpy import matrix
import sklearn.metrics
from cvxopt import matrix, solvers
import pandas as pd
import cvxopt
import torch

########### Kernels for Reproducing Kernel Hilbert Space #############
    """
    
    source: ndarray of shape (sample_size_source, feature_size)
    target: ndarray of shape (sample_size_target, feature_size)
    gamma: float, default=None
    return: kernel_matrix: ndarray of shape (n_samples_source, n_samples_target)
            or (n_samples_source, n_samples_source)
            
    """

def kernel(ker, source, target, gamma):
    K = None
    if ker == 'linear':
        if X2 is not None:
            K = sklearn.metrics.pairwise.linear_kernel(np.asarray(X1), np.asarray(X2))
        else:
            K = sklearn.metrics.pairwise.linear_kernel(np.asarray(X1))
    elif ker == 'rbf':
        if X2 is not None:
            K = sklearn.metrics.pairwise.rbf_kernel(np.asarray(X1), np.asarray(X2), gamma)
        else:
            K = sklearn.metrics.pairwise.rbf_kernel(np.asarray(X1), None, gamma)
    return K

########### Convex Optimization for Selecting Landmarks #############
    """
    
    source: ndarray of shape (sample_size_source, feature_size)
    target: ndarray of shape (sample_size_target, feature_size)
    Ys: ndarray of shape (sample_size_source, 1), label of source area
    return: sol: ndarray of shape (n_samples_source, 1)

    """

def selects(source, target, Ys)

    nss = int(source.size()[0])
    mtt = int(target.size()[0])

    XX = kernel('rbf', source, None, 1.0)
    P = matrix(2 * XX)
    XY = kernel('rbf', source, target, 1.0)
    xxy = np.sum(XY, axis =1)
    q = matrix(((-2.0 / mtt) * xxy))
    
    G = matrix(np.vstack((-np.identity(nss), np.identity(nss))))
    h = np.concatenate((np.zeros((nss,1)),np.ones((nss,1))), axis = 0)
    h = matrix(h)
    
    a1 = Ys.reshape([1,nss])
    a2 = np.ones([1,nss])
    A = matrix(np.concatenate((a1,a2), axis = 0))
    
    b = np.array([[(1/nss) * np.sum(Ys)], [1]])
    b = matrix(b)
    sol = solvers.qp(P, q, G, h, A, b)
    
    return sol


# ############################
# # Example
# ############################
# 
# if __name__ == '__main__':
#   ## import source area
#   
#     source_area = pd.DataFrame(pd.read_csv("source_area.csv"),
#                         columns=["x","y","dem","slope","carea", "cslope", "plancurv", "profcurv",
#                                  "log.carea", "slides"])
#     source_label = source_area["slides"].values.astype(int)
#     source_predictors = pd.DataFrame(source_area,
#                         columns=["carea", "slope", "cslope", "plancurv", "profcurv",
#                                  "log.carea"]).values
#     source = torch.tensor(source)
#     
#   ## import target area
# 
#     target = pd.DataFrame(pd.read_csv("target_area.csv"),
#                          columns=["carea", "slope", "cslope", "plancurv", "profcurv",
#                                  "log.carea"]).values
#     target = torch.tensor(target)
#
#   ## Obtaining beta
#   
#     a = selects(source_predictors, target, source_label)
#     beta = np.array(a['x'])
#     
#   ## Save source area with beta as .csv file
#   
#     source_beta = np.append(source_area, beta, axis = 1)
#     np.savetxt("source_beta.csv", source_beta, delimiter=',')
#     
