# Machine Learning

## Correlation

**Correlation** is a statistical technique that can show whether and how strongly pairs of variables are related. 
For example, height and weight are related; taller people tend to be heavier than shorter people. 
The relationship isn't perfect. People of the same height vary in weight, and you can easily think of two people 
you know where the shorter one is heavier than the taller one. Nonetheless, the average weight of people 5'5'' 
is less than the average weight of people 5'6'', and their average weight is less than that of people 5'7'', etc. 
Correlation can tell you just how much of the variation in peoples' weights is related to their heights.

The main result of a correlation is called the ***correlation coefficient or "r"***. It ranges from **-1.0 to +1.0**. 
The closer r is to +1 or -1, the more closely the two variables are related.

If r is close to 0, it means there is **no relationship between** the variables. If r is ***positive***, it means that as 
one variable gets larger the other gets larger. If r is ***negative*** it means that as one gets larger, 
the other gets smaller (often called an "inverse" correlation).

The **Pearson product-moment correlation coefficient** is a measure of the 
strength of a linear association between two variables and is **denoted by r**. Basically, a Pearson product-moment correlation 
attempts to draw a line of best fit through the data of two variables, and the Pearson correlation coefficient, r, 
indicates how far away all these data points are to this line of best fit.

The ***cor(x, y) function*** will compute the Pearson product-moment correlation between variables, x and y. Since this quantity is symmetric 
with respect to x and y, it doesn't matter in which order you put the variables.


## Unsupervised Learning

It is a type of machine learning algorithm used to draw inferences from datasets consisting of input data **without labeled responses**.
It allows for modeling of probability densities over inputs. 
It's types are :

  - Clustering
    * Hierarchical Clustering
    * K-means Clustering
  - Principal Component Analysis (PCA) for dimension reduction
  
  
## K - means Clustering

The objective of K-means is to group similar data points together and discover underlying patterns. To achieve this objective, K-means looks for a **fixed number (k) of clusters** in a dataset.You’ll define a target number k, which refers to the number of centroids you need in the dataset. A **centroid** is the imaginary or real location representing the center of the cluster.Every data point is allocated to each of the clusters through reducing the ***in-cluster sum of squares***.
    
    1. Randomly assign data points to a cluster.
    2. Compute cluster centroids.
    3. Assign data point to the nearest centroid.
    4. Keep repeating till centroids do not change and new clusters are not formed.

**Choosing a K value can be done through the Elbow Method**. We can plot SSE v/s K and find an optimal K.
  
## Supervised Learning

It is a machine learning algorithm that maps an input to an output based on example **input-output pairs**. It infers a function from labeled training data consisting of a set of training examples. Each example is a pair consisting of an input object and a desired output value. It analyzes the training data and produces an inferred function, which can be used for mapping new examples.
It's types are:

- Regression
  * Linear Regression
  * Logistic Regression
- Classification
  * K-nearest Neighbours
  * Naive Bayes
  * Decision Trees
  * Support Vector Machines (SVM)
- Neural Networks

## Linear Regression

Linear regression assumes a linear relationship between the input variables (x) and the single output variable (y). More specifically, that y can be calculated from a linear combination of the input variables (x).
When there is a single input variable (x), the method is referred to as simple linear regression. When there are multiple input variables, literature from statistics often refers to the method as multiple linear regression.
It is of the following type :

          Y = ßº + ß1.X + E
Where ßº = Intercept
      ß1 = slope
      E = noise
      
Y is the ***actual observed value*** and Y' is the ***expected value*** based on the model.

      e = Y - Y'
e is called **residual**.
The linear Regression model works to find ßº and ß1 such that **sum(e^2) is min**.

        ßº = cor(x,y) *  sd(y) / sd(x)
        
        ß1 = mean(y) - ( ßº * mean(x))


## Logistic Regression

Logistic Regression is used when the dependent variable(target) is **categorical**. For example, to predict whether an email is spam (1) or (0)
It is used for **classification of categorical variables**. It involves a **sigmoidal activation function** that provides an **output between o and 1
for any input**.

          Sig(x) = 1 / (1 + e^(-x) )
          
This results in a probability between 0 and 1 of belonging in the 1 class( binary classification : 0 or 1 )
We can then cut a cutoff point at 0.5, below which everything belongs to class 0.
We evaluate the model performace using a **confusion matrix**.
**Confusion Matrix** is a table that is often used to describe the performance of a classification model on a set of test data for which 
the true values are known. It allows the visualization of the performance of an algorithm.
    
|    . | Predicted NO | Predicted YES|
|------| -------------|---------------|
|Actual NO| TN | FP |
|Actual YES | FN | TP |

Accuracy =    ( TP + TN ) / ( TP + FP + TN + FN )

## K - Nearest Neighbors (KNN)

K nearest neighbors is a simple **classification algorithm** that stores all available cases and classifies new cases based on a similarity measure.
the output is a class membership. An object is **classified by a plurality vote of its neighbors**, with the object being assigned to 
the class most common among its k nearest neighbors (k is a positive integer, typically small). 
If k = 1, then the object is simply assigned to the class of that single nearest neighbor.

For a given **K**, the closest neighbours of the test data are considered with count = k. The majority class of these K neighbours
is then given to the test data.
These neighbours are found based on their distance from the data point.
The distance can be :

    - Euclidian , Manhattan , Minkowski (continous variables)
    - Hamming (categorical variables)
    
The values of **K** directly affects the class to which the the data point will be assigned to.

The similarity is defined by the distance between the points. Lesser the distance between the points, more is the similarity and vice versa.
All such distance based algorithms are affected by the scale of the variables. 
Let there be an age variable and an income varaible. The scale for income will be much greater than that of age.
The high magnitude of income affected the distance between the two points. This will impact the performance of all distance based model as it will **give higher weightage to variables which have higher magnitude** (income in this case).
We do not want our algorithm to be affected by the magnitude of these variables. The algorithm **should not be biased** towards variables with higher magnitude. To overcome this problem, we can bring down all the variables to the same scale.

  - Normalisation :       Z = ( X - mean(X) ) / sd(X)
  
  - Min - Max Scaling :     X' = ( X - X min ) / ( X max - X min )

## Decision Trees and Random Forest

A **decision tree** is a decision support tool that uses a tree-like model of decisions and their possible consequences, including chance event outcomes, resource costs, and utility. A decision tree is drawn upside down with its **root** at the top, which is the first internal node that performs the first split. It is a flowchart-like structure in which each **internal node** represents a "test" on an attribute (e.g. whether a coin flip comes up heads or tails), each **branch** represents the outcome of the test, and each **leaf** node represents a class label (decision taken after computing all attributes). The paths from root to leaf represent classification rules.

      ROOT ----> MULTIPLE INTERNAL NODES -----> CORRESPONDING LEAF OR INTERNAL NODES
      
The drawback of decision trees is that they dont tend to have the best prediction accuracy due to **high variance**.
**Bagging** is a general-purpose procedure for reducing the variance of a statistical learning method.
Building upon bagging , we use **random forests**. These are an ensemble of decision trees sampled from the training set with replacement.
Each time a tree is being sampled, a **random "m" features** are selected from the **total of "p" features**.
A fresh sample of m predictors is taken at each split and the split is allowed to use only one of those m predictors. 
           
           m  =  sqrt( p )
            
We use random forests because the presence of a strong feature can lead to correlated results in a bagged environment.
Random forests provide an improvement over bagged trees by way of a small tweak that **decorrelates the trees** and 
hence independent of each other.

The **complexity parameter (cp)** is used to control the size of the decision tree and to select the optimal tree size. If the cost of adding another variable to the decision tree from the current node is above the value of cp, then tree building does not continue. We could also say that tree construction does not continue unless it would decrease the overall lack of fit by a factor of cp.


## Support Vector Machines (SVM)

A support vector machine (SVM) is a supervised machine learning model that uses classification algorithms for two-group classification problems.
Given a set of training examples, each marked for belonging to one of two categories, an SVM training algorithm builds a model that assigns
new examples to one category or another, making it a **non-probailistic binary linear classififer**.

A support vector machine takes these data points and outputs the **hyperplane** (which in two dimensions it’s simply a line) that best separates the tags. This line is the decision boundary. New examples are then mapped into the same space and then predicted based on the side of the hyperplane they fall on.

For SVM, it’s the one that maximizes the margins from both tags. In other words: the hyperplane (remember it’s a line in this case) whose distance to the nearest element of each tag is the largest. For SVM, the best hyperplane is the one that maximizes the margins from both tags. In other words: the hyperplane whose distance to the nearest element of each tag is the largest. The points where the margin lines touch are called **support vectors**. This is all applicable to linearly seperable data ie. data that can be seperated with a line through it.

SVM can be extended to non-linearly seperated data through the ***kernel trick***.

**Cost** and **Gamma** are hyperparameters of an SVM.  ***Cost*** controls the tradeoff between a smooth decision boundary and classifying training data correctly. A low C makes the decision surface smooth, while a high C aims at classifying all training examples correctly by giving the model freedom to select more samples as support vectors.

***Gamma*** defines how far the influence of a single example reaches. If gamma has a low value, then every point has a far reach while if gamma is low, examples have a low reach. Hence, for a low value of gamma, the points close to the hyperplane will be considered and some points that are far may be ignored while formulating the model. High value of Gamma leads to more accuracy but biased results

|         | Large Gamma | Small Gamma | Large Cost |  Small Cost  |
|---------|----------|---------|---------|---------|
|**Variance**|  LOW | HIGH  | HIGH  | LOW |
|**Bias**|  HIGH  | LOW | LOW | HIGH  |

## Bias and Variance

The prediction error for any machine learning algorithm can be broken down into three parts:

    -Bias Error
    -Variance Error
    -Irreducible Error
 
          TOTAL ERROR =  ( BIAS )^2    +   VARIANCE   +   IRREDUCIBLE


The irreducible error cannot be reduced regardless of what algorithm is used. It is the error introduced from the chosen framing of the problem and may be caused by factors like unknown variables that influence the mapping of the input variables to the output variable.
In model prediction, it’s important to understand prediction errors (bias and variance). There is a tradeoff between a model’s ability to minimize bias and variance.

**Bias occurs when an algorithm has limited fleixibility to learn the true fit from the dataset**
Bias is the difference between your model's expected predictions and the true values.

Low Bias: Suggests less assumptions about the form of the target function.
High-Bias: Suggests more assumptions about the form of the target function.

*Examples of low-bias machine learning algorithms*: Decision Trees, k-Nearest Neighbors and Support Vector Machines.
*Examples of high-bias machine learning algorithms*: Linear Regression, Linear Discriminant Analysis and Logistic Regression.
It always leads to ***high error on training and test data***.

**Variance referes to the algorithm's sensitivity to specific features in a dataset**.
**Variance** is the variability of model prediction for a given data point or a value which tells us spread of our data. 

Generally, nonlinear machine learning algorithms that have a lot of flexibility have a high variance. For example, decision trees have a high variance, that is even higher if the trees are not pruned before use.

Examples of low-variance machine learning algorithms include: Linear Regression, Linear Discriminant Analysis and Logistic Regression.
Examples of high-variance machine learning algorithms include: Decision Trees, k-Nearest Neighbors and Support Vector Machines.

If our model is *too simple* and has very *few parameters* then it may have **high bias and low variance**. On the other hand if our model has *large number of parameters* then it’s going to have **high variance and low bias**. So we need to find the right/good balance without overfitting and underfitting the data.
This tradeoff in complexity is why there is a tradeoff between bias and variance. An algorithm can’t be more complex and less complex at the same time.


## Underfitting and Overfitting

**Fit** refers to how well you approximate a target function.

***Underfitting*** refers to a model that can neither model the training data nor generalize to new data.
An underfit machine learning model is not a suitable model and will be obvious as it will have poor performance on the training data.
The remedy is to move on and try alternate machine learning algorithms. 

***Overfitting*** refers to a model that models the training data too well.
It happens when a model learns the detail and noise in the training data to the extent that it negatively impacts the performance of the model on new data. This means that the **noise or random fluctuations in the training data is picked up and *learned as concepts* by the model**. 
Overfitting is more likely with nonparametric and nonlinear models that have more flexibility when learning a target function.
For example, **decision trees** are a nonparametric machine learning algorithm that is very flexible and is subject to overfitting training data. This problem can be addressed by pruning a tree after it has learned in order to remove some of the detail it has picked up.
