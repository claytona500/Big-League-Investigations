# Big-League-Investigations
This is a repository where I am going to post some of the stuff that I do with publicly available statcast data. 
--
## Catcher Framing
I started off with a logistic regression to predict called strikes. However, I switched to an XGboost model that gives me the probability of a given pitch being a called strike. I liked that better for a lot of reasons because it allowed me to quantify **strike probability added**.
This became the foundation for my model, as catchers who consistently create strike probability are better at framing than those who do not. 
