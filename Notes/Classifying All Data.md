# Classifying All Data

## First Stage Classifier

This random forest model classifies the shape of the data based on x to y ratio, number of squares, fractal dimension and density skewness.

![image-20211117164354873](/Users/oliverlountain/Library/Application Support/typora-user-images/image-20211117164354873.png)

Using this model, we have obtained a set of labeled data which can now be used to train a model which predicts shape based on parameter values.

## Second Stage Classifier

This random forest model classifies the shape based on parameter values. I tried this treating the parameters as factors and as numeric variables.

Treating params as **factors**:

![image-20211117164515913](/Users/oliverlountain/Library/Application Support/typora-user-images/image-20211117164515913.png)

![image-20211117165248779](/Users/oliverlountain/Library/Application Support/typora-user-images/image-20211117165248779.png)

Treating params as **numeric**:

![image-20211117164555315](/Users/oliverlountain/Library/Application Support/typora-user-images/image-20211117164555315.png)

![image-20211117165308941](/Users/oliverlountain/Library/Application Support/typora-user-images/image-20211117165308941.png)



The performance is quite good overal, though it is important to note that these metrics only capture one layer of predictive accuracy, as we are using predicted labels as our ground truth for this model. We see that in each case, the poorest performance is in the *other* and *stream* classes. 