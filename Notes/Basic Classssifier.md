# Basic Classifier

Confusion Matrix and Statistics

            Reference
Prediction   compact comet fan stream dense_blob other
  compact          6     5   0      0          0     0
  comet            1    14   0      5          0     9
  fan              0     3  21      0          0     0
  stream           0     3   0     13          0     0
  dense_blob       5     0   0      0          0     0
  other            0     0   0      0          0     0

Overall Statistics
                                          
               Accuracy : 0.6353          
                 95% CI : (0.5238, 0.7371)
    No Information Rate : 0.2941          
    P-Value [Acc > NIR] : 7.882e-11       
                                          
                  Kappa : 0.5274          
                                          
 Mcnemar's Test P-Value : NA              

Statistics by Class:

                     Class: compact Class: comet Class: fan Class: stream Class: dense_blob Class: other
Sensitivity                 0.50000       0.5600     1.0000        0.7222                NA       0.0000
Specificity                 0.93151       0.7500     0.9531        0.9552           0.94118       1.0000
Pos Pred Value              0.54545       0.4828     0.8750        0.8125                NA          NaN
Neg Pred Value              0.91892       0.8036     1.0000        0.9275                NA       0.8941
Prevalence                  0.14118       0.2941     0.2471        0.2118           0.00000       0.1059
Detection Rate              0.07059       0.1647     0.2471        0.1529           0.00000       0.0000
Detection Prevalence        0.12941       0.3412     0.2824        0.1882           0.05882       0.0000
Balanced Accuracy           0.71575       0.6550     0.9766        0.8387                NA       0.5000