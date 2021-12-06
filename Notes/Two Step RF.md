# Two Step RF Results

I now test the performance of the random forest with the added *column* class. We also include some extra training data obtained from the verification app.

The first step random forest still predicts with 100% accuracy now that the column class has been added.

We now assess the performance of the second step random forest, predicting class based on parameters.

### Before adding extra training data

![image-20211130104446386](/Users/oliverlountain/Library/Application Support/typora-user-images/image-20211130104446386.png)

### After extra training data

![image-20211130104510594](/Users/oliverlountain/Library/Application Support/typora-user-images/image-20211130104510594.png)



### Confusion Matrix

![image-20211130142925120](/Users/oliverlountain/Library/Application Support/typora-user-images/image-20211130142925120.png)

We see that the poorest performance is in the other class. In particular, the low sensitivity suggests a higher false negative rate, that is, true "other" swarms are classified into other classes.



## Variable Importance

![image-20211130104635147](/Users/oliverlountain/Library/Application Support/typora-user-images/image-20211130104635147.png)



### fa

![image-20211130104657840](/Users/oliverlountain/Library/Application Support/typora-user-images/image-20211130104657840.png)

Small values of *fa* seem to result in fans and comets while large values result in streams and compacts. Small to medium values result in columns.

### jumpD

![image-20211130104710677](/Users/oliverlountain/Library/Application Support/typora-user-images/image-20211130104710677.png)

Small values of *jumpD* seem to result in compact and fan. Medium seems to result in comet and column. Large seems to result in streams.

### fr

![image-20211130104728610](/Users/oliverlountain/Library/Application Support/typora-user-images/image-20211130104728610.png)

It is difficult to see a clear distinction between classes in *fr*.

### fal

![image-20211130104822456](/Users/oliverlountain/Library/Application Support/typora-user-images/image-20211130104822456.png)

### rproba

![image-20211130104841355](/Users/oliverlountain/Library/Application Support/typora-user-images/image-20211130104841355.png)

### pause

![image-20211130104859131](/Users/oliverlountain/Library/Application Support/typora-user-images/image-20211130104859131.png)

rproba and pause seem to have virtually no effect - at least on their own



## jumpD and fa

![image-20211130133549382](/Users/oliverlountain/Library/Application Support/typora-user-images/image-20211130133549382.png)



