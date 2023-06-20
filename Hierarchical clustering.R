
### Title: Code of hierarchical clustering 


setwd("~/Desktop")

#prepare the packages
install.packages("gridExtra")
library(gridExtra)
install.packages("ggdendro")
library(ggdendro)
install.packages("cluster")
library(cluster)
install.packages("ggfortify")
library(ggplot2)
library(ggfortify)
install.packages("dplyr")
library(dplyr)
install.packages("readxl")
library("readxl")

#read data
my_data<- read_excel("664data_code.xlsx")
engagement_data<-my_data[10:13]
#check missing values
summary(is.na(engagement_data))
print(engagement_data)
summary(engagement_data)
## frequency description
install.packages('epiDisplay')
library(epiDisplay)
tab1(my_data$gender,sort.group = "decreasing", cum.percent = TRUE)
tab1(my_data$StageID ,sort.group = "decreasing", cum.percent = TRUE)
tab1(my_data$Topic ,sort.group = "decreasing", cum.percent = TRUE)
tab1(my_data$GradeID, sort.group = "decreasing", cum.percent = TRUE)
tab1(my_data$Class, sort.group = "decreasing", cum.percent = TRUE)
###normalized the dara
install.packages("caret")
library("caret")
preproc1<- preProcess(engagement_data[1:4],method = c("range"))
norm_data <- predict(preproc1,engagement_data[1:4])
summary(norm_data)


#------------Hierarchical clustering
#---------------------------------------------
#Calculate Euclidean distance between students
dist_engagement<- dist(norm_data,method = 'euclidean')
#Generate a complete linkage analysis
hc_engagement<- hclust(dist_engagement,method = 'complete')
#plot the dendrogram
plot(hc_engagement)
install.packages("dendextend")
library(dendextend)
dend_engagement2 <- as.dendrogram(hc_engagement)
dend_colored2<- color_branches(dend_engagement2,k = 2, groupLabels = TRUE)
plot(dend_colored2, main = "Cluster Dendrogram(cluster=2)",
     sub = "Index of students")

dend_engagement3 <- as.dendrogram(hc_engagement)
dend_colored3<- color_branches(dend_engagement3,k = 3, groupLabels = TRUE)
plot(dend_colored3, main = "Cluster Dendrogram(cluster=3)",
     sub = "Index of students")

dend_engagement4 <- as.dendrogram(hc_engagement)
dend_colored4<- color_branches(dend_engagement4,k = 4)
plot(dend_colored4)

dend_engagement5 <- as.dendrogram(hc_engagement)
dend_colored5<- color_branches(dend_engagement5,k = 5)
plot(dend_colored5)

rect.hclust(hc_engagement,k=2,border = "blue")
rect.hclust(hc_engagement,k=3,border = "red")
rect.hclust(hc_engagement,k=4,border = "green")
rect.hclust(hc_engagement,k=5,border = "yellow")


#Creat a cluster assignment vector at k=2
cluster_engagament2 <- cutree(hc_engagement,k = 2)
#Generate the segmented students data frame
segment_engagament2 <- mutate(norm_data,cluster = cluster_engagament2)
#Silhouette width S(i)
sis2 <- silhouette(segment_engagament2$cluster,dist(norm_data,method = 'euclidean'))
# Calculate the average silhouette width
average_silhouette_width <- mean(sis2[, "sil_width"])
# Print the average silhouette width
cat("Average Silhouette Width:", average_silhouette_width, "\n")


# Create a cluster assignment vector at k=3
cluster_engagament3 <- cutree(hc_engagement, k = 3)
# Generate the segmented students data frame
segment_engagament3 <- mutate(norm_data, cluster = cluster_engagament3)
# Calculate the silhouette width
sis3 <- silhouette(segment_engagament3$cluster, dist(norm_data, method = 'euclidean'))
# Calculate the average silhouette width
average_silhouette_width <- mean(sis3[, "sil_width"])
# Print the average silhouette width
cat("Average Silhouette Width:", average_silhouette_width, "\n")


#Creat a cluster assignment vector at k=4
cluster_engagament4 <- cutree(hc_engagement,k = 4)
#Generate the segmented students data frame
segment_engagament4 <- mutate(norm_data,cluster = cluster_engagament4)
#Silhouette width S(i)
sis4 <- silhouette(segment_engagament4$cluster,dist(norm_data,method = 'euclidean'))
# Calculate the average silhouette width
average_silhouette_width <- mean(sis4[, "sil_width"])
# Print the average silhouette width
cat("Average Silhouette Width:", average_silhouette_width, "\n")

#Creat a cluster assignment vector at k=5
cluster_engagament5 <- cutree(hc_engagement,k = 5)
#Generate the segmented students data frame
segment_engagament5 <- mutate(norm_data,cluster = cluster_engagament5)
#Silhouette width S(i)
sis5 <- silhouette(segment_engagament5$cluster,dist(norm_data,method = 'euclidean'))
# Calculate the average silhouette width
average_silhouette_width <- mean(sis5[, "sil_width"])
# Print the average silhouette width
cat("Average Silhouette Width:", average_silhouette_width, "\n")

#Count the number of students that fall into each cluster
count(segment_engagament3,cluster)
count(segment_engagament4,cluster)
count(segment_engagament5,cluster)
#bulid the total data frame
total <- mutate(my_data,cluster = segment_engagament3$cluster)
print(total)


#————————————————Scatter Plot of Students Engagement Behaviors in Each Cluster-------------

averages <- total %>% 
  group_by(cluster) %>% 
  summarize(avg_indicator1 = mean(raisedhands),
            avg_indicator2 = mean(VisITedResources),
            avg_indicator3 = mean(AnnouncementsView),
            avg_indicator4 = mean(Discussion))

# Create a named vector that maps the value of the "cluster" variable to the corresponding label
labels <- c("1" = "Inactive Engagers",
            "2" = "Proactive Engagers",
            "3" = "Selective Engagers")

ggplot(averages, aes(x = factor(cluster))) +
  geom_point(aes(y = avg_indicator1, color = "Raisedhands"), shape = 16, size = 2) +
  geom_point(aes(y = avg_indicator2, color = "VisitedResources"), shape = 17, size = 2) +
  geom_point(aes(y = avg_indicator3, color = "AnnouncementsView"), shape = 15, size = 2) +
  geom_point(aes(y = avg_indicator4, color = "Discussion"), shape = 18, size = 2) +
  labs(x = "Cluster", y = "Average Count", color = "Engagement Behaviors") +
  scale_x_discrete(labels = labels, expand = c(0.1, 0.1)) +
  scale_color_manual(values = c("blue", "red", "green", "purple"),
                     breaks = c("Raisedhands", "VisitedResources", "AnnouncementsView", "Discussion"),
                     labels = c("Raisedhands", "VisitedResources", "AnnouncementsView", "Discussion")) +
  guides(color = guide_legend(override.aes = list(shape = c(16, 17, 15, 18), size = 2))) +
  theme(panel.grid = element_blank(),
        panel.background = element_rect(fill = "white"),
        axis.line = element_line(color = "black", size = 0.2),
        axis.ticks = element_blank(),
        axis.text.x = element_text(size = 8, color = "black", hjust = 0.5),
        axis.text.y = element_text(size = 8, color = "black"),
        legend.key = element_blank())






