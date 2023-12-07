install.packages("readxl")
install.packages("corrplot")
install.packages("sjPlot")
install.packages("sjmisc")
install.packages("sjlabelled")
library(sjPlot)
library(sjmisc)
library(sjlabelled)
rm(list=ls())
library(readxl)
library(corrplot)
# Load the dataset
credit_data <- read_excel("CreditRating.xlsx")

#display data
credit_data

#changing column names to lower
colnames(credit_data)=tolower(make.names(colnames(credit_data)))
attach(credit_data)

#converting categorical values as factors
credit_data$gender=factor(credit_data$gender)
credit_data$student=factor(credit_data$student)
credit_data$married=factor(credit_data$married)
credit_data$ethnicity=factor(credit_data$ethnicity)
levels(credit_data$gender)
levels(credit_data$student)
levels(credit_data$married)
levels(credit_data$ethnicity)


#running a simple regression model
full_model = lm(rating~.-id,data = credit_data)
summary(full_model)

#the credit score is affected by the credit utilization
#to find it, we create a new column "creditused"

credit_data$creditused = credit_data$limit-credit_data$balance
num_credit_data = subset(credit_data,select = -c(gender,ethnicity,married,student))
cor(num_credit_data)
lm1 = lm(rating~gender+ethnicity+married+student,data = credit_data)
summary(lm1)
confint(lm1)

#finding histogram of the dependent vaiable "rating"
hist((credit_data$rating), breaks = 30, col = "blue", main = "Histogram of rating", xlab = "Value")

hist(log(credit_data$rating), breaks = 30, col = "blue", main = "Logarithmic Histogram of rating", xlab = "Value")

#finding statistical values of "rating"
summary(log(credit_data$rating))

# the normal hist is positive skewed
#we found that log function have better shape with mean and median close to each other and less skewness

#finding the plots to find the nature of relation between rating and columns affecting it.

#limit, balance, no of accounts opened affect the credit score directly
#income, age, education affect the credit rating indirectly

#lets plot how rating is behaving wrt credit used.

plot(log(credit_data$creditused), log(credit_data$rating), main = "Scatter plot of credit used vs rating", xlab = "credit utilized", ylab = "credit rating")

#the relation is linear

#let us create a regression model using selected independent variables

lm_mod1=lm(rating~income+limit+balance+cards+age+education,data = credit_data)
summary(lm_mod1)
# let us see if there is biased with respect to gender
lm_gender=lm(rating~income+limit+balance+cards+age+education+gender,data = credit_data)
summary(lm_gender)
lm_creditused = lm(rating~creditused,data = credit_data)

summary(lm_creditused)

plot(credit_data$rating,lm_creditused$fitted.values,
     pch=19,main="Actuals v. Fitted, price")
abline(0,1,col="red",lwd=3)

qqnorm(lm_creditused$residuals,pch=19,
       main="Normality Plot, rating")
qqline(lm_creditused$residuals,lwd=3,col="red")



lm_secdegree_1=lm(rating~income+limit+balance+cards+age+I(cards^2),data = credit_data)



summary(lm_secdegree_1)

plot(credit_data$creditused,rating,
     pch=19,main="Actuals v. Fitted, price")
abline(20.23416549,0.07929724,col="red",lwd=3)
summary(lm1)
summary(lm_mod1)
summary(lm_gender)
summary(lm_secdegree_1)
tab_model(lm_secdegree_1,lm_gender,lm1)








#plotting all the lines and scatters

#with respect to income
lm_income=lm(rating~income,data = credit_data)
summary(lm_income)
plot(income,rating,
     pch=19,main="income vs rating")
abline(lm_income, col ="red")


#with respect to limit
lm_limit=lm(rating~limit,data = credit_data)
summary(lm_limit)
plot(limit,rating,
     pch=19,main="limit vs rating")
abline(lm_limit, col="red")

#with respect to age
lm_age=lm(rating~age,data = credit_data)
summary(lm_age)
plot(age,rating,
     pch=19,main="age vs rating")
abline(lm_age, col="red")

#with respect to education
lm_education=lm(rating~education,data = credit_data)
summary(lm_education)
plot(education,rating,
     pch=19,main="education vs rating")
abline(lm_education, col="red")


#with respect to balance
lm_balance=lm(rating~balance,data = credit_data)
summary(lm_balance)
plot(balance,rating,
     pch=19,main="balance vs rating")
abline(lm_balance, col="red")


#finding the linearity of the model
plot(credit_data$rating,lm_secdegree_1$fitted.values,
     pch=19,main="Actuals v. Fitted, price")
abline(0,1,col="red",lwd=3)

#finding the normality of the residuals
qqnorm(lm_secdegree_1$residuals,pch=19,
       main="Normality Plot, rating")
qqline(lm_secdegree_1$residuals,lwd=3,col="red")


hist(lm_secdegree_1$residuals,col="red",
     main="Residuals, rating",
     probability=TRUE)
curve(dnorm(x,mean(lm_secdegree_1$residuals),
            sd(lm_secdegree_1$residuals)),
      from=min(lm_secdegree_1$residuals),
      to=max(lm_secdegree_1$residuals),
      lwd=3,col="blue",add=TRUE)




sum(credit_data[which(credit_data$gender=='Male'),4])/sum(gender=="Male")

sum(credit_data[which(credit_data$gender=='Female'),4])/sum(gender=="Female")

sum(rating)/400
