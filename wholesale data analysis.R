#import wholesale dataset from UC berkeley;
library(readr)
Wholesale_customers_data<- read_csv("C:/Users/snamuduri/OneDrive - Omnitracs/R datasets/Wholesale_customers_data.csv")
View(Wholesale_customers_data)

summary(Wholesale_customers_data)
#no N/As

#2D scatter first;
attach(Wholesale_customers_data)
plot(Region, Grocery, main="2D Scatterplot Grocery by Region", xlab="Region ", ylab="Grocery ", pch=19)

scatter3d()
