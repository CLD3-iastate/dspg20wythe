library(readr)
library(tidyverse)
library(readxl)
#install.packages("ggalluvial")
library(ggalluvial)
library(viridis)
library(forcats)
library(ggrepel)
library(ggthemes)
#install.packages("collapsibleTree")
library(collapsibleTree)

#Import and clean data from ONET
All_Career_Clusters<- read_csv("data/All_Career_Clusters short.csv")
All_Industries <- read_csv("data/All_Industries.csv")
Education_Training_and_Experience <- read_excel("data/Education, Training, and Experience short.xlsx")
Education_Training_and_Experience_Categories <- read_excel("data/Education, Training, and Experience Categories short.xlsx")
Knowledge <- read_excel("data/Knowledge.xlsx")%>%
  filter(`Scale Name`=="Importance")%>%
  select(Code=`O*NET-SOC Code`,Element_Name=`Element Name`,Importance=`Data Value`)
Projected_openings<-All_Industries%>%
  select(Code,Job_Openings=`Projected Job Openings (2018-2028)`)

#Put data in the proper form for a collapsible tree
Tree<-left_join(All_Career_Clusters,Projected_openings,by="Code")%>%
  left_join(Knowledge,by="Code")%>%
  select(-Code,Career_Cluster=`Career Cluster`,Career_Pathway=`Career Pathway`)

#Rename Onet SOC code column to Code
names(Education_Training_and_Experience)[names(Education_Training_and_Experience) == "O*NET-SOC Code"] <- "Code"

#Generate New column in Education CSVs
Education_Training_and_Experience$ScaleCat <- paste(Education_Training_and_Experience$`Scale Name`, Education_Training_and_Experience$Category)
Education_Training_and_Experience_Categories$ScaleCat <- paste(Education_Training_and_Experience_Categories$`Scale Name`, Education_Training_and_Experience_Categories$Category)

#Create Education, Training and Experience csvs
Education_cat <- Education_Training_and_Experience_Categories[1:12,]
Experience_cat <- Education_Training_and_Experience_Categories[13:23,]
Site_Training_cat <- Education_Training_and_Experience_Categories[23:32,]
Job_Training_cat <- Education_Training_and_Experience_Categories[33:41,]

#Merge Education and training CSVs
Education <- left_join(Education_cat, Education_Training_and_Experience, by="ScaleCat")
Experience <- left_join(Experience_cat, Education_Training_and_Experience, by="ScaleCat")
Site_Training <- left_join(Site_Training_cat, Education_Training_and_Experience, by="ScaleCat")
Job_Training <- left_join(Job_Training_cat, Education_Training_and_Experience, by="ScaleCat")


#Rename Data Value
names(Education)[names(Education) == "Data Value"] <- "Data_Value"
names(Experience)[names(Experience) == "Data Value"] <- "Data_Value"
names(Site_Training)[names(Site_Training) == "Data Value"] <- "Data_Value"
names(Job_Training)[names(Job_Training) == "Data Value"] <- "Data_Value"

#Rename Category Description
names(Education)[names(Education) == "Category Description"] <- "Category_Description"
names(Experience)[names(Experience) == "Category Description"] <- "Category_Description"
names(Site_Training)[names(Site_Training) == "Category Description"] <- "Category_Description"
names(Job_Training)[names(Job_Training) == "Category Description"] <- "Category_Description"

#Strip White Space and Rename Category Description
#Education$Category_Description <- trimws(Education$'Category Description', which = c("both"))
#Experience$Category_Description <- trimws(Experience$'Category Description', which = c("both"))
#Site_Training$Category_Description <- trimws(Site_Training$'Category Description', which = c("both"))
#Job_Training$Category_Description <- trimws(Job_Training$'Category Description', which = c("both"))

#names(Education)[names(Education) == "Category Description"] <- "Category_Description"
#names(Experience)[names(Experience) == "Category Description"] <- "Category_Description"
#names(Site_Training)[names(Site_Training) == "Category Description"] <- "Category_Description"
#names(Job_Training)[names(Job_Training) == "Category Description"] <- "Category_Description"

#Subset Data Value > 40%
#min(Education$Data_Value)
#Inmax(Experience$Data_Value)
#max(Site_Training$Data_Value)
#max(Job_Training$Data_Value)

Education40 <- subset(Education, Data_Value > 15)
Education40$Cat_Val <- paste(Education40$Category_Description, Education40$Data_Value)

Experience40 <- subset(Experience, Data_Value > 15)
Experience40$Cat_Val <- paste(Experience40$Category_Description, Experience40$Data_Value)

Site_Training40 <- subset(Site_Training, Data_Value > 15)
Site_Training40$Cat_Val <- paste(Site_Training40$Category_Description, Site_Training40$Data_Value)

Job_Training40 <- subset(Job_Training, Data_Value > 15)                                         
Job_Training40$Cat_Val <- paste(Job_Training40$Category_Description, Job_Training40$Data_Value)
#trimws(Education40$'Category_Description', which = c("both"))


#Total Industry Trees
Tree_Ed<-left_join(All_Career_Clusters,Projected_openings,by="Code")%>%
  left_join(Knowledge, by ="Code") %>% 
  left_join(Education40,by="Code")%>%
  select(-Code,Career_Cluster=`Career Cluster`,Career_Pathway=`Career Pathway`)

Tree_Ex<-left_join(All_Career_Clusters,Projected_openings,by="Code")%>%
  left_join(Knowledge, by ="Code") %>% 
  left_join(Experience40,by="Code")%>%
  select(-Code,Career_Cluster=`Career Cluster`,Career_Pathway=`Career Pathway`)

Tree_Site<-left_join(All_Career_Clusters,Projected_openings,by="Code")%>%
  left_join(Knowledge, by ="Code") %>% 
  left_join(Site_Training40,by="Code")%>%
  select(-Code,Career_Cluster=`Career Cluster`,Career_Pathway=`Career Pathway`)

Tree_Job<-left_join(All_Career_Clusters,Projected_openings,by="Code")%>%
  left_join(Knowledge, by ="Code") %>% 
  left_join(Job_Training40,by="Code")%>%
  select(-Code,Career_Cluster=`Career Cluster`,Career_Pathway=`Career Pathway`)

#Information TEch
Tree_IT_Ed<-left_join(All_Career_Clusters,Projected_openings,by="Code")%>%
  left_join(Knowledge, by ="Code") %>% 
  left_join(Education40,by="Code")%>%
  select(-Code,Career_Cluster=`Career Cluster`,Career_Pathway=`Career Pathway`)

Tree_IT_skills<-left_join(All_Career_Clusters,Projected_openings,by="Code")%>%
  left_join(Knowledge,by="Code")%>%
  select(-Code,Career_Cluster=`Career Cluster`,Career_Pathway=`Career Pathway`)

Tree_IT_Ex<-left_join(All_Career_Clusters,Projected_openings,by="Code")%>%
  left_join(Knowledge, by ="Code") %>% 
  left_join(Experience40,by="Code")%>%
  select(-Code,Career_Cluster=`Career Cluster`,Career_Pathway=`Career Pathway`)

Tree_IT_Site<-left_join(All_Career_Clusters,Projected_openings,by="Code")%>%
  left_join(Knowledge, by ="Code") %>% 
  left_join(Site_Training40,by="Code")%>%
  select(-Code,Career_Cluster=`Career Cluster`,Career_Pathway=`Career Pathway`)

Tree_IT_Job<-left_join(All_Career_Clusters,Projected_openings,by="Code")%>%
  left_join(Knowledge, by ="Code") %>% 
  left_join(Job_Training40,by="Code")%>%
  select(-Code,Career_Cluster=`Career Cluster`,Career_Pathway=`Career Pathway`)

#Manufacturing
Tree_Man_Ed<-left_join(All_Career_Clusters,Projected_openings,by="Code")%>%
  left_join(Knowledge, by ="Code") %>% 
  left_join(Education40,by="Code")%>%
  select(-Code,Career_Cluster=`Career Cluster`,Career_Pathway=`Career Pathway`)

Tree_Man_skills<-left_join(All_Career_Clusters,Projected_openings,by="Code")%>%
  left_join(Knowledge,by="Code")%>%
  select(-Code,Career_Cluster=`Career Cluster`,Career_Pathway=`Career Pathway`)

Tree_Man_Ex<-left_join(All_Career_Clusters,Projected_openings,by="Code")%>%
  left_join(Knowledge, by ="Code") %>% 
  left_join(Experience40,by="Code")%>%
  select(-Code,Career_Cluster=`Career Cluster`,Career_Pathway=`Career Pathway`)

Tree_Man_Site<-left_join(All_Career_Clusters,Projected_openings,by="Code")%>%
  left_join(Knowledge, by ="Code") %>% 
  left_join(Site_Training40,by="Code")%>%
  select(-Code,Career_Cluster=`Career Cluster`,Career_Pathway=`Career Pathway`)

Tree_Man_Job<-left_join(All_Career_Clusters,Projected_openings,by="Code")%>%
  left_join(Knowledge, by ="Code") %>% 
  left_join(Job_Training40,by="Code")%>%
  select(-Code,Career_Cluster=`Career Cluster`,Career_Pathway=`Career Pathway`)

#Agriculture
Tree_Ag_Ed<-left_join(All_Career_Clusters,Projected_openings,by="Code")%>%
  left_join(Knowledge, by ="Code") %>% 
  left_join(Education40,by="Code")%>%
  select(-Code,Career_Cluster=`Career Cluster`,Career_Pathway=`Career Pathway`)

Tree_Ag_skills<-left_join(All_Career_Clusters,Projected_openings,by="Code")%>%
  left_join(Knowledge,by="Code")%>%
  select(-Code,Career_Cluster=`Career Cluster`,Career_Pathway=`Career Pathway`)

Tree_Ag_Ex<-left_join(All_Career_Clusters,Projected_openings,by="Code")%>%
  left_join(Knowledge, by ="Code") %>% 
  left_join(Experience40,by="Code")%>%
  select(-Code,Career_Cluster=`Career Cluster`,Career_Pathway=`Career Pathway`)

Tree_Ag_Site<-left_join(All_Career_Clusters,Projected_openings,by="Code")%>%
  left_join(Knowledge, by ="Code") %>% 
  left_join(Site_Training40,by="Code")%>%
  select(-Code,Career_Cluster=`Career Cluster`,Career_Pathway=`Career Pathway`)

Tree_Ag_Job<-left_join(All_Career_Clusters,Projected_openings,by="Code")%>%
  left_join(Knowledge, by ="Code") %>% 
  left_join(Job_Training40,by="Code")%>%
  select(-Code,Career_Cluster=`Career Cluster`,Career_Pathway=`Career Pathway`)

#Fix long names
#Tree[(24235:24267),3]<-"Grinding and Buffing Machine Operators"
#Tree_Ed$Category_Description <- strtrim(Tree_Ed$Category_Description, 20)
#Tree_Ex$Category_Description <- strtrim(Tree_Ex$Category_Description, 20)
#Tree_Site$Category_Description <- strtrim(Tree_Site$Category_Description, 20)
#Tree_Job$Category_Description <- strtrim(Tree_Job$Category_Description, 40)

#code to create tree.  A version of this is used in the shiny app
Tree%>%
  filter(Job_Openings>5300)%>%
  mutate_if(is.numeric, ~replace(., is.na(.), 0))%>%
  filter(Importance>=2.88)%>%
  collapsibleTree(hierarchy = c("Career_Cluster","Career_Pathway","Occupation","Element_Name"),
                        root="Industries",
                         attribute = "Importance",
                  width=1450,
                  zoomable=F 
                  )
#Education Tree
Tree_Ed%>%
  filter(Job_Openings>5300)%>%
  mutate_if(is.numeric, ~replace(., is.na(.), 0))%>%
  filter(Importance>=2.88)%>%
  collapsibleTree(hierarchy = c("Career_Cluster","Career_Pathway","Occupation","Cat_Val"),
                  root="Industries",
                  attribute = "Job_Openings",
                  width=1500,
                  zoomable=F 
  )

Tree_Ex%>%
  filter(Job_Openings>5300)%>%
  mutate_if(is.numeric, ~replace(., is.na(.), 0))%>%
  filter(Importance>=2.88)%>%
  collapsibleTree(hierarchy = c("Career_Cluster","Career_Pathway","Occupation","Cat_Val"),
                  root="Industries",
                  attribute = "Job_Openings",
                  width=1500,
                  zoomable=F 
  )

Tree_Site%>%
  filter(Job_Openings>5300)%>%
  mutate_if(is.numeric, ~replace(., is.na(.), 0))%>%
  filter(Importance>=2.88)%>%
  collapsibleTree(hierarchy = c("Career_Cluster","Career_Pathway","Occupation","Cat_Val"),
                  root="Industries",
                  attribute = "Job_Openings",
                  width=1500,
                  zoomable=F 
  )
Tree_Job%>%
  filter(Job_Openings>5300)%>%
  mutate_if(is.numeric, ~replace(., is.na(.), 0))%>%
  filter(Importance>=2.88)%>%
  collapsibleTree(hierarchy = c("Career_Cluster","Career_Pathway","Occupation","Cat_Val"),
                  root="Industries",
                  attribute = "Job_Openings",
                  width=1500,
                  zoomable=F 
  )
#Information TEch
Tree_IT_skills%>%
  filter(Job_Openings>5300)%>%
  mutate_if(is.numeric, ~replace(., is.na(.), 0))%>%
  filter(Importance>=2.88 & Career_Cluster=="Information Technology")%>%
  collapsibleTree(hierarchy = c("Career_Cluster","Career_Pathway","Occupation","Element_Name"),
                  root="Industries",
                  attribute = "Job_Openings",
                  width=1500,
                  zoomable=F 
  )

Tree_IT_Ed%>%
  filter(Job_Openings>5300)%>%
  mutate_if(is.numeric, ~replace(., is.na(.), 0))%>%
  filter(Importance>=2.88 & Career_Cluster=="Information Technology")%>%
  collapsibleTree(hierarchy = c("Career_Cluster","Career_Pathway","Occupation","Cat_Val"),
                  root="Industries",
                  attribute = "Job_Openings",
                  width=1500,
                  zoomable=F 
  )

Tree_IT_Ex%>%
  filter(Job_Openings>5300)%>%
  mutate_if(is.numeric, ~replace(., is.na(.), 0))%>%
  filter(Importance>=2.88 & Career_Cluster=="Information Technology")%>%
  collapsibleTree(hierarchy = c("Career_Cluster","Career_Pathway","Occupation","Cat_Val"),
                  root="Industries",
                  attribute = "Job_Openings",
                  width=1500,
                  zoomable=F 
  )

Tree_IT_Site%>%
  filter(Job_Openings>5300)%>%
  mutate_if(is.numeric, ~replace(., is.na(.), 0))%>%
  filter(Importance>=2.88 & Career_Cluster=="Information Technology")%>%
  collapsibleTree(hierarchy = c("Career_Cluster","Career_Pathway","Occupation","Cat_Val"),
                  root="Industries",
                  attribute = "Job_Openings",
                  width=1500,
                  zoomable=F 
  )
Tree_IT_Job%>%
  filter(Job_Openings>5300)%>%
  mutate_if(is.numeric, ~replace(., is.na(.), 0))%>%
  filter(Importance>=2.88 & Career_Cluster=="Information Technology")%>%
  collapsibleTree(hierarchy = c("Career_Cluster","Career_Pathway","Occupation","Cat_Val"),
                  root="Industries",
                  attribute = "Job_Openings",
                  width=1500,
                  zoomable=F 
  )

#Manufacturing
Tree_Man_skills%>%
  filter(Job_Openings>5300)%>%
  mutate_if(is.numeric, ~replace(., is.na(.), 0))%>%
  filter(Importance>=2.88 & Career_Cluster=="Manufacturing")%>%
  collapsibleTree(hierarchy = c("Career_Cluster","Career_Pathway","Occupation","Element_Name"),
                  root="Industries",
                  attribute = "Job_Openings",
                  width=1500,
                  zoomable=F 
  )

Tree_Man_Ed%>%
  filter(Job_Openings>5300)%>%
  mutate_if(is.numeric, ~replace(., is.na(.), 0))%>%
  filter(Importance>=2.88 & Career_Cluster=="Manufacturing")%>%
  collapsibleTree(hierarchy = c("Career_Cluster","Career_Pathway","Occupation","Cat_Val"),
                  root="Industries",
                  attribute = "Job_Openings",
                  width=1500,
                  zoomable=F 
  )
Tree_Man_Ex%>%
  filter(Job_Openings>5300)%>%
  mutate_if(is.numeric, ~replace(., is.na(.), 0))%>%
  filter(Importance>=2.88 & Career_Cluster=="Manufacturing")%>%
  collapsibleTree(hierarchy = c("Career_Cluster","Career_Pathway","Occupation","Cat_Val"),
                  root="Industries",
                  attribute = "Job_Openings",
                  width=1500,
                  zoomable=F 
  )

Tree_Man_Site%>%
  filter(Job_Openings>5300)%>%
  mutate_if(is.numeric, ~replace(., is.na(.), 0))%>%
  filter(Importance>=2.88 & Career_Cluster=="Manufacturing")%>%
  collapsibleTree(hierarchy = c("Career_Cluster","Career_Pathway","Occupation","Cat_Val"),
                  root="Industries",
                  attribute = "Job_Openings",
                  width=1500,
                  zoomable=F 
  )
Tree_Man_Job%>%
  filter(Job_Openings>5300)%>%
  mutate_if(is.numeric, ~replace(., is.na(.), 0))%>%
  filter(Importance>=2.88 & Career_Cluster=="Manufacturing")%>%
  collapsibleTree(hierarchy = c("Career_Cluster","Career_Pathway","Occupation","Cat_Val"),
                  root="Industries",
                  attribute = "Job_Openings",
                  width=1500,
                  zoomable=F 
  )

#AG
Tree_Ag_skills%>%
  filter(Job_Openings>5300)%>%
  mutate_if(is.numeric, ~replace(., is.na(.), 0))%>%
  filter(Importance>=2.88 & Career_Cluster=="Ag., Food, & Nat. Resources")%>%
  collapsibleTree(hierarchy = c("Career_Cluster","Career_Pathway","Occupation","Element_Name"),
                  root="Industries",
                  attribute = "Job_Openings",
                  width=1500,
                  zoomable=F 
  )

Tree_Ag_Ed%>%
  filter(Job_Openings>5300)%>%
  mutate_if(is.numeric, ~replace(., is.na(.), 0))%>%
  filter(Importance>=2.88 & Career_Cluster=="Ag., Food, & Nat. Resources")%>%
  collapsibleTree(hierarchy = c("Career_Cluster","Career_Pathway","Occupation","Cat_Val"),
                  root="Industries",
                  attribute = "Job_Openings",
                  width=1500,
                  zoomable=F 
  )
Tree_Ag_Ex%>%
  filter(Job_Openings>5300)%>%
  mutate_if(is.numeric, ~replace(., is.na(.), 0))%>%
  filter(Importance>=2.88 & Career_Cluster=="Ag., Food, & Nat. Resources")%>%
  collapsibleTree(hierarchy = c("Career_Cluster","Career_Pathway","Occupation","Cat_Val"),
                  root="Industries",
                  attribute = "Job_Openings",
                  width=1500,
                  zoomable=F 
  )

Tree_Ag_Site%>%
  filter(Job_Openings>5300)%>%
  mutate_if(is.numeric, ~replace(., is.na(.), 0))%>%
  filter(Importance>=2.88 & Career_Cluster=="Ag., Food, & Nat. Resources")%>%
  collapsibleTree(hierarchy = c("Career_Cluster","Career_Pathway","Occupation","Cat_Val"),
                  root="Industries",
                  attribute = "Job_Openings",
                  width=1500,
                  zoomable=F 
  )
Tree_Ag_Job%>%
  filter(Job_Openings>5300)%>%
  mutate_if(is.numeric, ~replace(., is.na(.), 0))%>%
  filter(Importance>=2.88 & Career_Cluster=="Ag., Food, & Nat. Resources")%>%
  collapsibleTree(hierarchy = c("Career_Cluster","Career_Pathway","Occupation","Cat_Val"),
                  root="Industries",
                  attribute = "Job_Openings",
                  width=1500,
                  zoomable=F 
  )

#Save Tree data in the Shiny folder
write_csv(Tree,"Tree")
write_csv(Tree_Ed,"Tree_Ed")
write_csv(Tree_Ex,"Tree_Ex")
write_csv(Tree_Site,"Tree_Site")
write_csv(Tree_Job,"Tree_Job")

write_csv(Tree_IT_skills,"Tree_IT_skills")
write_csv(Tree_IT_Ed,"Tree_IT_Ed")
write_csv(Tree_IT_Ex,"Tree_IT_Ex")
write_csv(Tree_IT_Site,"Tree_IT_Site")
write_csv(Tree_IT_Job,"Tree_IT_Job")

write_csv(Tree_Man_skills,"Tree_Man_skills")
write_csv(Tree_Man_Ed,"Tree_Man_Ed")
write_csv(Tree_Man_Ex,"Tree_Man_Ex")
write_csv(Tree_Man_Site,"Tree_Man_Site")
write_csv(Tree_Man_Job,"Tree_Man_Job")

write_csv(Tree_Ag_skills,"Tree_Ag_skills")
write_csv(Tree_Ag_Ed,"Tree_Ag_Ed")
write_csv(Tree_Ag_Ex,"Tree_Ag_Ex")
write_csv(Tree_Ag_Site,"Tree_Ag_Site")
write_csv(Tree_Ag_Job,"Tree_Ag_Job")
