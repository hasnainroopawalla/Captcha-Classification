# Captcha Classification
This project was built for Introduction to Image Analysis (1MD110)

The task is to solve a noisy CAPTCHA image consisting of 3 digits of varying sizes/orientation
## Examples
![Example 1](https://github.com/hasnainroopawalla/Captcha-Classification/blob/main/images/ex1.png)
![Example 2](https://github.com/hasnainroopawalla/Captcha-Classification/blob/main/images/ex2.png)


## Pre-Processing Pipeline
![Pipeline](https://github.com/hasnainroopawalla/Captcha-Classification/blob/main/images/pipeline.png)



## Feature Selection
The set of features used to train the model are as follows:
* Circularity
* Area
* Centroid
* Orientation
* Solidity


## General Flow
Each training image is split into 3 distinct props (digits) and the above mentioned features are extracted for each prop

Each **prop** returns a `1 x 6` feature vector

Each **image** returns a `3 x 1 x 6` feature vector (each dimension corresponds to each digit)

## Training and Evaluation
Training images - 1100
Validation images - 100

3 digits are extracted from each image which corresponds to 3300 training samples

## Results
![Pipeline](https://github.com/hasnainroopawalla/Captcha-Classification/blob/main/images/results.png)
