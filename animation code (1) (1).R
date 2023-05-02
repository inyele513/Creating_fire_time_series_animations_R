
library(ggplot2)
library(gganimate)
library(gifski)
library(sf)
library(rgdal)
library(transformr)

Tigray <-st_read("C:/Users/juliet.inyele/Downloads/ethiopiaregion/Eth_Region_2013.shp")

Tigray<-Tigray[Tigray$REGIONNAME=="Tigray",]

ggplot() + 
  geom_sf(data = Tigray, size = 3, color = "black", fill = "white") + 
  ggtitle("Tigray") + 
  coord_sf()


fires <- read.csv("D:/Tasks/Ethiopia RS/Results/fires_2019_1.csv", header=TRUE, stringsAsFactors=FALSE)

#view structure of data
str(fires)

fires %>% 
  ggplot(aes(x = longitude, y = latitude))+
  geom_point()+
  labs(title = "Fires")

fires %>% 
  ggplot(aes(x = longitude, y = latitude, group = "Month"))+
  geom_point()+
  labs(title = "Fires/Month")

dat <- st_as_sf(
  fires,
  coords = c("longitude", "latitude"),
  crs = 4326
)

dat %>% 
  ggplot()+
  geom_sf()+
  labs(title = "Fires")+
  xlab("Longitude")+
  ylab("Latitude")

ggplot()+
  geom_sf(data = Tigray)+
  geom_sf(data = dat, aes(color = "red",group = month))+
  labs(title = "Fire",
       color = "Brightness"
       )+
  xlab("Longitude")+
  ylab("Latitude")

map_with_data <-ggplot()+
  geom_sf(data = Tigray)+
  geom_sf(data = dat, aes(color = Brightness,group = month))+
  labs(title = "Fire",
       color = "Brightness"
  )+
  xlab("Longitude")+
  ylab("Latitude")
class(dat$month)
dat$month1<-NA
dat$year<-gsub("0:00|00:00","",dat$Date)

#dat$year2<-str_extract(dat$year,"2021|2022 |2019|2020")
#dat$month<-ifelse(dat$month==5,"May",ifelse(dat$month==6,"June",ifelse(dat$month==7,"July",ifelse(dat$month==8,"Aug",ifelse(dat$month==9,"Sept",ifelse(dat$month==10,"Oct",ifelse(dat$month==11,"Nov",ifelse(dat$month==12,"Dec",NA))))))))
#dat$month<-paste(dat$month,dat$year2)
map_with_data

map_with_animation <- map_with_data +
  transition_time(month) +
  ggtitle('month: {frame_time}',
          subtitle = 'Frame {frame} of {nframes}')
num_months <- max(dat$month) - min(dat$month) + 1
animate(map_with_animation, nframes =num_months, fps = 2)
View(dat)
