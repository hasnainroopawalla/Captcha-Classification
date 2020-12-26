# Captcha Classification
This project was built for the course - "Introduction to Image Analysis" (1MD110) at Uppsala University

The objective is to accurately solve noisy CAPTCHA images (distorted images containing letters and digits used in cyber-security). In this task, each CAPTCHA image is extremely noisy and consists of 3 digits in very erratic orientations as well as several stray marks.

## Input Examples
![Example 1](https://github.com/hasnainroopawalla/Captcha-Classification/blob/main/images/ex1.png)
![Example 2](https://github.com/hasnainroopawalla/Captcha-Classification/blob/main/images/ex2.png)


## Pre-Processing Pipeline
![Pipeline](https://github.com/hasnainroopawalla/Captcha-Classification/blob/main/images/pipeline.PNG)

Result of Pre-Processing (Example):

![Pre-processing example](https://github.com/hasnainroopawalla/Captcha-Classification/blob/main/images/op1.png)

## Feature Selection
The set of features used to train the model are as follows:
* Circularity
* Area
* Centroid
* Orientation
* Solidity


## General Flow
Each training image is split into 3 distinct props (digits) and the above mentioned features are extracted for each prop. Following is the result of splitting into 3 props:

![Prop 1](https://github.com/hasnainroopawalla/Captcha-Classification/blob/main/images/p1.png)
![Prop 1](https://github.com/hasnainroopawalla/Captcha-Classification/blob/main/images/p2.png)
![Prop 1](https://github.com/hasnainroopawalla/Captcha-Classification/blob/main/images/p3.png)

Each **prop** returns a `1 x 6` feature vector

Each **image** returns a `3 x 1 x 6` feature vector (each dimension corresponds to each digit)

## Training and Evaluation
Training images - 1100

Validation images - 100

3 digits are extracted from each image which corresponds to 3300 training samples

3 models were trained and the results are reported below:
* KNN (k=3)
* Linear SVM
* Decision Trees with Adaptive Boosting (maxSplits=30)

## Results
![Results 1](https://github.com/hasnainroopawalla/Captcha-Classification/blob/main/images/results.PNG)
![Results 2](https://github.com/hasnainroopawalla/Captcha-Classification/blob/main/images/results2.PNG)

Best results were obtained by using *Decision Trees with Adaptive Boosting (maxSplits=30)* with the following metrics:

* A training accuracy of ~97% was obtained
* Validation accuracy of ~82% was obtained (better evaluation can be performed using cross-validation)
* Accuracy of ~61% was obtained on a Hidden Test Set

## Future work
* Splitting of Digits can be optimized for overlapping digits by conducting repeated (and controlled) Erosion followed by Dilation to break connected components
* Resize image to the same size before feature extraction for consistency (or flatten the image itself)
* Train a CNN architecture to improve accuracy and performance
* Perform cross-validation for better evaluation
