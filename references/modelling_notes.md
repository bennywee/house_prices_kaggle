# Modelling notes

## Start with univariate linear model - basic design choices and transformations
By taking the log of $\beta_{LotArea}$, I assume the relationship between LotArea and SalesPrice is _strictly positive_. Is there a linear relationship by the logs of the variables? Interrogate linearity as an assumption a bit more rigorously (Hill, podcast).

Plot relationship between sales price and lot area. On log and real scales for prior predictive checks - log/real prior distributions or data? Maybe do both. Log normal prior on lotarea. 

Choose a range of numbers (between min and max lot area) and use that as part of prior predictive checks. What does the prior imply the relationship is with salesprice over this range? pg 98 for example

standardise all variables to mean zero, should also standardise priors to mean zero, esp intercept. Check standard deviation of predictor to determine what is the implied relationship of beta pg 130

Priors in transformed linear space vs outcome space

We want the lines to stay within the high probability region of the observable data Pg 151

reason for log - multiplicative scale (orders of magntiude) pg 152, and regression and other stories https://statmodeling.stat.columbia.edu/wp-content/uploads/2020/07/raos_tips.pdf

Priors centred at zero (average value). 

alpha -> Expected value of the outcome when all the predictors are zero. When predictors are standardised, zero is their mean. Don't have any prior knowledge about the mean sales price (before seeing data), so I set my expectation around the mean.
https://youtu.be/e0tO64mtYMU?list=PLDcUM9US4XdNM4Edgs7weiyIguLSToZRI&t=1359

Standardise log sales price by the mean of log sales price. So it's prorpotional to average sales price. 1.1 is 10% larger than average, 0.8 is 20% less than average. Z scores for log lot area because  we want to interpret alpha as mean value of outcome when predictors are at their mean. pg 246
Horizontal lines showing maximum/min value of outcome? 

"The two slopes
are centered on zero, implying no prior information about direction. This is obviously less
information than we have—basic botany informs us that water should have a positive slope
and shade a negative slope. But these priors allow us to see which trend the sample shows, while still bounding the slopes to reasonable values." pg 259,

If prior predictive checks live outside 2 standrd deviations (which is the likely space of values occurring), then it's likely the prior is putting weight on implausible values (outside range of observable values). Also pg248. Should be within 2sd for plausible values. Also simulations should cross the mean values of each.

Exponential distributions are skeptical of extremely large values

End lec 5 - Dummy vs index variables. Dummy apriori assigns extra uncertainty (alpha and beta). 

Check for issues in model comparison in multilevel models (224-225) - problems with train/test simuluations. Don't necessarily have representative sample in test set.


https://stats.stackexchange.com/questions/418107/converting-log-standard-deviation-in-terms-of-the-original-units -  log standard deviation interpretation and conversion

## Multilevel model

- WHat do prior