#Microplastics 24hr analysis
#Lisa Watkins
#Begun on 11/7/17, updated 5/8/2020 & 8/5/2022

#### load librarys-----
library(ggplot2)
library(dplyr)
library(readr)
library(knitr)
library(tidyr)
library(plyr)
library(wesanderson)
library(ggthemes)

#### csv's needed -----
# 24hr_combined_Rmanipulated.csv
# 24hr_combined_Rmanipulated_10.23.17_withblanks021618.csv
# perc_persampleday.csv

#### data cleaning ----
# calculate concentration (with air blank contamination removed), add cyclical time
plastics_airblanks = read_csv("24hr_combined.csv") %>% 
  mutate(fiber_lessairblank = fiber.line-6.7) %>% 
  mutate(totalcount = fiber_lessairblank+film+fragment+foam+bead.pellet) %>%
  mutate(mean_v_ft.s = (StartVelocity_ft.s+EndVelocity_ft.s)/2) %>% 
  mutate(samplearea_ft2 = ((WaterHeighta_in)+(WaterHeightb_in))/2/12*3) %>% 
  mutate(totalvolume_ft3 = SampleTime_s*mean_v_ft.s*samplearea_ft2) %>% 
  mutate(totalvolume_m3 = totalvolume_ft3/35.3147) %>% 
  mutate(conc_lessairblank_m3 = totalcount/totalvolume_m3)  %>% 
  select(-samplearea_ft2,-totalvolume_ft3,-mean_v_ft.s)

# Calculate seasonal flow averages
plastics_airblanks %>% 
  group_by(Site,timepoint) %>% 
  mutate(USGSStreamDischarge_m3.s = USGSStreamDischarge_ft3.s/35.3147) %>% 
  summarize(AverageFlow_m3.s = mean(USGSStreamDischarge_m3.s)) %>% 
  kable()
# where t1 = August 2016 sampling (low flow) and t2 = April 2017 sampling (high flow)

# Calculate average flux and concentration
plastics_airblanks %>% 
  group_by(timepoint, Site) %>% 
  mutate(USGSStreamDischarge_m3.s = USGSStreamDischarge_ft3.s/35.3147) %>% 
  mutate(Flux_no.s = USGSStreamDischarge_m3.s*conc_lessairblank_m3) %>% 
  mutate(Flux_no.s_100000ppl = Flux_no.s*100000) %>% 
  summarize(AverageFlux_no.s = mean(Flux_no.s),AverageFlux_no.s_per100000ppl = mean(Flux_no.s_100000ppl), AverageConc_m3 = mean(conc_lessairblank_m3)) %>% 
  kable()
#### 5/8/2020 note: must figure out where super high flux values
#### in paper came from! I mean, YIKES DUDE.

# Add additional columns to plastics_airblanks to create "plastics"
plastics = plastics_airblanks %>% 
  mutate(totalcount = fiber.line +film+fragment+foam) %>% 
  mutate(avgvelocity_ft.s = mean(c(StartVelocity_ft.s,EndVelocity_ft.s))) %>% 
  mutate(netarea_ft2 = 3*(WaterHeighta_in/12 + WaterHeightb_in/12)/2) %>% 
  mutate(volumesampled_ft3 = netarea_ft2 * avgvelocity_ft.s * SampleTime_s) %>% 
  mutate(conc_plast.ft3 = totalcount/volumesampled_ft3) %>% 
  mutate(time_24 = c(0,3,6,9,12,15,18,21,24,0,3,6,9,12,15,18,21,24,0,3,9,15,18,21,24,0,3,9,12,15,18,21,24)) %>% 
  mutate(fib_per = plastics$fiber.line/plastics$totalcount) %>% 
  #make a group where SMt2,FCt2,SMt1,FCt1 are groups 1,2,3,4 as strings
   mutate(group = c('1','1','1','1','1','1','1','1','1','2','2','2','2','2','2','2','2','2','3','3','3','3','3','3','3','4','4','4','4','4','4','4','4'))

plastics_wblanks = read.csv("24hr_combined_Rmanipulated_10.23.17_withblanks021618.csv")
perc_fig4 = read.csv("perc_persampleday.csv")

# Figure 2. Plot: type of each particle in samples
plastics %>% 
  mutate(other = foam+film+bead.pellet) %>% 
  select(fiber.line, fragment, other, totalcount, Site, timepoint) %>%
  mutate(prop_fiber = fiber.line/totalcount, prop_frag= fragment/totalcount, prop_other = other/totalcount) %>% 
  select(-fiber.line,-fragment,-other,-totalcount) %>% rename(stream = Site,timept = timepoint,fiber = prop_fiber, fragment = prop_frag, other = prop_other) %>% 
  mutate(streamtime = paste(stream,timept,sep="")) %>% 
  pivot_longer(fiber:other,names_to ="cat",values_to = "prop" ) %>% 

ggplot(aes(x=streamtime, y=prop, fill = forcats::fct_rev(cat))) + 
  geom_bar(stat="identity", position = "fill") +
  xlab("") +
  ylab("Proportion of total plastics counted")+ 
  guides(fill = guide_legend(reverse = TRUE))+
  scale_fill_manual(values = c("#CCCCCC","#777888","#333333"),labels = c("Other","Fragment","Fiber"), name = "Category")+
  scale_x_discrete(labels=c("FCt1" = "Fall Creek, \n low flow", "FCt2" = "Fall Creek, \n high flow","SMt1"="Six Mile Creek, \n low flow", "SMt2"="Six Mile Creek, \n high flow"))+
  theme_classic()
#ggsave("Proport_categories_other4.tiff", width=6, height = 5, units='in', dpi=1200)

#for fiber by sample/flow anova later

##Six Mile subgroups
SM = subset(plastics,plastics$Site == "SM")
SMt1 = subset(SM,SM$timepoint == "t1")
SMt2 = subset(SM,SM$timepoint == "t2")
##Fall Creek subgroups
FC = subset(plastics, plastics$Site == "FC")
FCt1 = subset(FC,FC$timepoint =="t1")
FCt2 = subset(FC,FC$timepoint =="t2")


#convert category columns into a single column
plastics.long = plastics %>% pivot_longer(c(fiber.line:bead.pellet,Red_fiber:blue_fragment),names_to = "category",values_to = "cat_total") %>% 
  as.data.frame() %>% 
  mutate(reorderedtime = factor(plastics$timeish, levels = c("8a","11a", "14a", "17a", "20a", "23a", "2b", "5b", "8b"))) %>%
  mutate(treatment = paste(Site,timepoint)) %>% 
  mutate(reorder = factor(treatment, levels = c("FC t1", "SM t1", "FC t2", "SM t2"))) 
plastics_wblanks.long = plastics %>% 
  #adjust totalcounts by 60.6666, average particle count in worst-case blanks
  mutate(total_adjusted = totalcount - 60.666666) %>% 
  #remove entries less than zero
  mutate(total_minusblank = ifelse(total_adjusted<0,NA,total_adjusted)) %>% 
  mutate(conc_plastic.ft3_wblank = total_minusblank/volumesampled_ft3) %>% 
  pivot_longer(c(fiber.line:bead.pellet,Red_fiber:blue_fragment),names_to = "category",values_to = "cat_total")  %>%        
  as.data.frame() %>% 
  mutate(treatment = paste(plastics_wblanks.long$Site,plastics_wblanks.long$timepoint)) %>% 
  mutate(reorder= factor(treatment, levels = c("FC t1", "SM t1", "FC t2", "SM t2")))

#Does fiber percentage vary by site/flow condition


t.test(SMt1$fib_per,SMt2$fib_per)#0.04
t.test(SMt1$fib_per,FCt1$fib_per)#0.28
t.test(FCt1$fib_per,FCt2$fib_per)#0.60
t.test(FCt2$fib_per,SMt2$fib_per)#0.37

mod_fib = lm(fib_per~Site + timepoint, data = plastics)
anova(mod_fib)
mod_fib_inter = lm(fib_per~timepoint+Site:timepoint, data = plastics)
anova(mod_fib_inter)
#is the average sampling velocity causing the difference between SMt1 and SMt2?
mod_fib = lm(fib_per~Site + timepoint+avgvelocity_ft.s, data = plastics)
mod_group = lm(fib_per~group,data = plastics)
summary(mod_group)
anova(mod_group)
#get a column of proportional values
perc = ddply(plastics.long, "treatment", transform, cat_perc = cat_total/totalcount) %>% 
  filter(category =="film"|category =="foam"|category =="fragment"|category =="bead.pellet"|category =="fiber.line")
perc_wblank = ddply(plastics_wblanks.long, "treatment", transform, cat_perc = cat_total/totalcount)
#make proportional plot of counts divided into categories
perc$category <- factor(perc$category, levels = c("foam","bead.pellet","film","fragment","fiber.line"))

#create other cateogry for film, bead, foam
perc$Category=ifelse(perc$category =="film"|perc$category =="foam"|perc$category =="bead.pellet","other",ifelse(perc$category=="fiber.line","fiber.line",ifelse(perc$category=="fragment","fragment",NA)))
perc$Category = factor(perc$Category, levels = c("other", "fragment","fiber.line"))

#fancy way to make facets properly labeled
treatments <- list(
  'FC t1'="Fall Creek, August",
  'FC t2'="Fall Creek, April",
  'SM t1'="Six Mile Creek, August",
  'SM t2'="Six Mile Creek, April"
)
treatment_labeller <- function(variable,value){
  return(treatments[value])
}
#plot

#modified version of graph from defense (7/22/18)
ggplot(perc, aes(x=reorderedtime, y=cat_total, fill = Category,order = as.numeric(Category))) + 
  geom_bar(stat="identity", position = "fill") +
  xlab("Time of Day Sampled") +
  ylab("Proportion of total plastics counted")+ 
  guides(fill = guide_legend(reverse = TRUE))+
  #scale_fill_manual(values = c("#009E73","#e79f00","#F0E442","#9ad0f3",  "#0072B2"),labels = c("Foam","Bead","Film","Fragment","Fiber"))+
  scale_fill_manual(values = c("#CCCCCC","#777888","#333333"),labels = c("Other","Fragment","Fiber"))+
  scale_x_discrete(labels=c("8a" = "8:00", "11a" = "11:00","14a"="14:00", "17a"="17:00", "20a"="20:00", "23a"="23:00", "2b"="2:00", "5b"="5:00","8b"="8:00"))+
  facet_wrap(~ treatment,labeller=treatment_labeller,scale="free_x",nrow=2)+
  theme_classic()+
  theme(axis.title=element_text(size=14),axis.text.x=element_text(size=12,angle=45,hjust=1),axis.text.y=element_text(size=12),strip.text.x = element_text(size = 13))
#ggsave("Proport_categories_greyother.tiff", width=6, height = 5, units='in', dpi=1000)

#Graph presented at defense
ggplot(perc, aes(x=reorderedtime, y=cat_total, fill = category,order = as.numeric(category))) + 
geom_bar(stat="identity", position = "fill") +
xlab("Time of Day Sampled") +
ylab("Proportion of total plastics counted")+ 
guides(fill = guide_legend(reverse = TRUE))+
#geom_line(aes(x = reorderedtime, y = conc_plast.ft3*10, group =1))+
#scale_y_continuous(sec.axis = sec_axis(~./100 , name = "Concentration of total plastics (plastics/ft3)"))+
# THIS DOES COLOR:  scale_fill_brewer(palette="Pastel1", labels = c("Foam","Bead","Film","Fragment","Fiber"))+
  scale_fill_manual(values = c("#009E73","#e79f00","#F0E442","#9ad0f3",  "#0072B2"),labels = c("Foam","Bead","Film","Fragment","Fiber"))+
  #scale_fill_grey(start=0.8, end=0.35,labels = c("Foam","Bead","Film","Fragment","Fiber"))+
  scale_x_discrete(labels=c("8a" = "8:00", "11a" = "11:00","14a"="14:00", "17a"="17:00", "20a"="20:00", "23a"="23:00", "2b"="2:00", "5b"="5:00","8b"="8:00"))+
facet_grid(.~ treatment,labeller=treatment_labeller,scale="free_x")+
theme_classic()
#ggsave("Proport_categories.tiff", height=6, width=15, units='in', dpi=700)

#With Blanks: make proportional plot of counts divided into categories
perc$category <- factor(perc$category, levels = c("foam","bead.pellet","film","fragment","fiber"))
perc$cat_conc_m3 = perc$cat_total/perc$volumesampled_ft3*35.3147
ggplot(perc, aes(x=reorderedtime, y=cat_conc_m3, fill = category,order = as.numeric(category))) + 
  geom_bar(stat = "identity", position = "fill") + #to make concentration on y axis, remove position =...
  xlab("Time of Day Sampled") +
  ylab("Proportion of total plastics counted")+ 
  guides(fill = guide_legend(reverse = TRUE))+
   # THIS DOES COLOR: scale_fill_brewer(palette="Pastel1", labels = c("Foam","Bead","Film","Fragment","Fiber"))+
  scale_fill_grey(start = 0.8, end = 0.2, na.value = "yellow", labels = c("Foam","Bead","Film","Fragment","Fiber"))+
  scale_x_discrete(labels=c("8a" = "8:00", "11a" = "11:00","14a"="14:00", "17a"="17:00", "20a"="20:00", "23a"="23:00", "2b"="2:00", "5b"="5:00","8b"="8:00"))+
  facet_grid(.~ reorder,scale="free_x")+
  theme_classic()
##### 8/5/2022. Pick up here for final checks.

#take a look at the same graph but with total counts
ggplot(perc, aes(x=timeish, y=cat_total, fill = category)) + 
  geom_bar(stat="identity") +
  xlab("Time of Day Sampled") +
  ylab("Proportion of total plastics counted")+ 
  guides(fill = guide_legend(reverse = TRUE))+
  scale_fill_brewer(palette="Pastel1", labels = c("Bead/Pellet", "Fiber/Line","Film", "Foam","Fragment"))+
  facet_grid(~ treatment)
#transform into percentage
plastics.long$cat_perc = plastics.long$cat_total/plastics.long$totalcount
perc = ddply(plastics.long, "treatment", transform, cat_perc = cat_total/totalcount)
##Six Mile subgroups
SM.long = subset(plastics.long,plastics.long$Site == "SM")
SMt1.long = subset(SM.long,SM.long$timepoint == "t1")
SMt2.long = subset(SM.long,SM.long$timepoint == "t2")
##Fall Creek subgroups
FC.long = subset(plastics.long, plastics.long$Site == "FC")
FCt1.long = subset(FC.long,FC.long$timepoint =="t1")
FCt2.long = subset(FC.long,FC.long$timepoint =="t2")

plastics.prop$Site = c("FC t1", "FC t2", "SM t1", "SM t2")
plastics.prop$

  

#scale_y_continuous(labels = percent_format())
#another hint
data<- rbind(c(480, 780, 431, 295, 670, 360,  190),
             c(720, 350, 377, 255, 340, 615,  345),
             c(460, 480, 179, 560,  60, 735, 1260),
             c(220, 240, 876, 789, 820, 100,   75))

a <- cbind(data[, 1], 1, c(1:4))
b <- cbind(data[, 2], 2, c(1:4))
c <- cbind(data[, 3], 3, c(1:4))
d <- cbind(data[, 4], 4, c(1:4))
e <- cbind(data[, 5], 5, c(1:4))
f <- cbind(data[, 6], 6, c(1:4))
g <- cbind(data[, 7], 7, c(1:4))

data           <- as.data.frame(rbind(a, b, c, d, e, f, g))
colnames(data) <-c("Time", "Type", "Group")
data$Type      <- factor(data$Type, labels = c("A", "B", "C", "D", "E", "F", "G"))


ggplot(data = data, aes(x = Type, y = Time, fill = Group)) + 
  geom_bar(stat = "identity") +
  opts(legend.position = "none")
