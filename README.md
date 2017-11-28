# Multi-level semantic labelling of sky/cloud images

With the spirit of reproducible research, this repository contains all the codes required to produce the results in the manuscript: 
> S. Dev, Y. H. Lee and S. Winkler, Multi-level semantic labelling of sky/cloud images, *Proc. IEEE International Conference on Image Processing (ICIP)*, 2015. 

Please cite the above paper if you intend to use whole/part of the code. This code is only for academic and research purposes.

## Code Organization
The codes are written in MATLAB.

### Dataset
The dataset used in this manuscript is from HYTA dataset 
> Li et. al, A Hybrid Thresholding Algorithm for Cloud Detection on Ground-Based Color Images, Journal of Atmospheric and Oceanic Technology, 2011. 

Please contact the respective authors for the dataset.

### Core functionality
* `RGBPlane.m` Generates the R- G- and B- planes of an image.
* `calculateBeta.m` Calculates the parameter BETA used to generate probabilistic mask.
* `color16.m` Extracts 16 color channels of a sky/cloud image.
* `color16_struct.m` Extracts the 16 color channels in a struct format.
* `create_XY_response.m` Computes the feature vector for a single image.
* `cumulative_score.m` Computes the cumulative score of the proposed approach.
* `features_3labels.py` Computes the vectorised probablistic feature vector.
* `individual_score.m` Computes the score of individual image for the proposed approach.
* `likelihood_estimate.m` Estimates the parameters of the multi-variate gaussian distribution..
* `showasImage.m` Normalizes an array to the range [0,255].

### Reproducibility 
In addition to all the related codes, we have also shared the generated results. These files are contained in the folder `./logs`.

Please run the following to generate all the results and figures in the paper.
* `main.m` Performs the multi-label segmentation for all the images, and also computes the scores.
* `figures.m` Generates the figures in the manuscript. 
