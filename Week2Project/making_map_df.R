#Making map_df.csv


```{r, eval = FALSE, echo=FALSE, message=FALSE}
df<-read.csv("WPo_Police_Shooting_DB.csv", header =T)
df$address<- paste(df$city,", ",df$state,sep="")

location_df<-read.csv("latlons.csv",header =T)

get_lat<-function(address){
    location_df[location_df$location==address,2]
}

get_lon<-function(address){
    location_df[location_df$location==address,3]
}

# get latitude and longitude of cities
df$lat<-sapply(df$address,get_lat)
df$lon<-sapply(df$address,get_lon)

# Subset to the northeast
ne<-grepl("(NY|MA|CT|RI|VT|NH|ME)$",df$address)
df<-df %>% filter(ne, df$address!="Wales, ME")

```


```{r, message = FALSE, warning = FALSE}
map_df<-df %>% group_by(address) %>%
    summarise(total_shootings = n(),
              lat = mean(lat, na.rm = T),
              lon = mean(lon, na.rm = T),
              popup = paste("<strong>",address,"</strong><br>",
                            "<strong> Total Shootings:</strong>",total_shootings)) 

map_df[map_df$address == "Old Town, ME",c("lat","lon")]<-rbind(c( 44.9341667, -68.6458333),c( 44.9341667, -68.6458333))

map_df[which(map_df$address == "Hiram, ME"),c("lat","lon")] <- list(43.878684, -70.8033959)

map_df[map_df$address == "Portland, ME",c("lat","lon")]<-list( 43.6613889, -70.2558333)

map_df[map_df$address == "Belgrade, ME",c("lat","lon")]<-list( 44.4472889, -69.832549)

map_df[map_df$address == "Bangor, ME",c("lat","lon")]<-list( 44.8011111, -68.7783333)

map_df[map_df$address == "Smyrna, ME",c("lat","lon")]<-list( 46.136111, -68.0975)

write.csv(map_df,"map_df.csv",row.names = F)

```