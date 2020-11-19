# Blog notes

- Consider comparing bayesian workflow to ML workflow? e.g. prior predictive checking

## Insights from 'Visualising the Bayesian workflow'
- "Not a full data analysis"
- "Instead, we need to assess the effect of the prior as a multivariate distribution."
- "This is primarily because the vague priors don’t actually respect our contextual knowledge."

## Structure and multiple posts

1) Attempting a principled statistical workflow
    - Spent past few years learning bayesian statistics while working full time. Just finished SR, reading numerous blog posts, fiddling with code and attempting problem sets. t
    - This is an attempts at Will Wolf's "open source masters" - the only real expenditure really being spent on textbooks of authors who have generously made their course material available on youtube and github. 

    - This writeup is inspired by multiple blog posts on statistical workflows. I first came across Jim Savage's many blog posts on the topic (link) and more recently inspired by Monica ALexander's post earlier in the year. McElreath's SR also emphasises the importance of workflow for a variety of important reasons which I will emphasise below.
    
    - This workflow is _not_ exhaustive of all diagnostics and steps that can be taken. Post would be too long. Some steps won't have a problem with such simple models. Treatment and suggested fixes may be addressed in a future post
    
    - Why is workflow imporcotant? This was typically overlooked in my statistics/econometrics courses. Often course curriculus revolved around understanding and proving different statistical tools, tests and algorithms. There is nothing wrong with this, there are finite resources and probably in infinite amount of new things to learn. 
    
    - However, applied statistical modelling is 
    
    - This is an attempt at practicing a typical bayesian workflow. Not as robust or detailed as Betancourt's case studies or the Stan case studies. Rather, a minimal working example of the workflow and the rationale for its steps. 
    
    - Applying visualisations as part of a principled statistical workflow. (link to paper)
    
    - What we want to evaluate:
            + Implications of assumptions
            + Model fit
            + Model selection
    
    - Full workflow:
            **+ EDA, data transformations and plots**
            **+ Write out full probability model**
            **+ Prior predictive checks - simulate fake data from your model**
            **+ Fit model on fake data - can your model capture the known parameters (the parameters used to define the DGP?) If your model cannot capture _known_ parameters on fake data, you can't say for certain if your model is correctly identifying the parameters on _real data_.**
            **+ Estimate model on real data**
            + Check whether MCMC ran efficiently
            **+ Posterior predictive check to evaluate model fit**
            + Parameter inference / predictions (depending on modelling goal)
            + Model selection
    
    - Which parts of the workflow will I emphasise in this post? Proposing simple models first and focussing on design decisions and evaluating assumptions at different levels. Other parts become more relevant in more complicated models which will be covered in separate post. 
     
            - Models are deliberately simple. Want to emphasise workflow and diagnostics and interrogate assumptions. It can certainly be improved.
 
 - WHY prior predictive checks?
         + Interrogate the consquences of modelling assumptions and design choices - expectation of the dataset before seeing data. L02
         + What does the prior _really mean?_ L02
         + "be broader than the distribution of the observed data in line with the principle of weakly informative priors." 
         + For the prior predictive checks, we recommend not cleaving too closely to the observed data and instead aiming for a prior data generating process that can produce plausible data sets, not necessarily ones that are indistinguishable from observed data.
         + "the implied data generating process can still generate data that is much more extreme than we would expect from our domain knowledge."
 

    - Model diagnostics and troubleshooting
    - Practice justifying priors and attempt at multilevel modelling to capture structure and complex relationships in the data
    - Not covered: Chain diagnostics and weak fit (models are quite simple, so unlkely to come into this problem unless priors are really weak)
   
    
2) Applying the basic workflow on richer, multilevels models


3) Prediction, data preprocessing?