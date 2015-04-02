---
title: "Map Visualization with Leaflet package in R"
author: "Brother Rain"
date: "30/03/2015"
output: html_document
---

> The traveler sees what he sees, the tourist sees what he has come to see.

> [Gilbert K. Chesterton](http://www.brainyquote.com/quotes/quotes/g/gilbertkc100091.html)


There are number of packages in R help you visualize map data such as RGoogleMaps, leafletR or rCharts. 

In this post I will show you how do I collect, transform travel data from [lonelyplanet](http://www.lonelyplanet.com/vietnam/sights), and visualize map collected data using `leaflet` package.


## Data: Collection and Transformation

I use some javascript code to "live" crawl all information of sights in Vietnam from [lonelyplanet](http://www.lonelyplanet.com/vietnam/sights), the result contains 503 sights in Vietnam saved in `sights.json` file

To transform json data, I use `jsonlite` and [geocode service](http://maps.google.com/maps/api/geocode/) to get geo data from name of each sightseeing. For instance, with *Quang Cong Pagoda* place in *Nha Trang* , send request to service via api *http://maps.google.com/maps/api/geocode/json?address=Quang%20Cong%20Pagoda,%20Nha%20Trang* we can have the geo data of Quang Cong pagoda


```r
location: {
  lat: 12.2387911,
  lng: 109.1967488
}
```

This code below show how do I transform json data to csv


```r
GetGeoOfSights <- function(){
  sights.raw <- readLines("data/sights.json")
  sights <- fromJSON(sights.raw)
  sights <- sights %>% mutate(
    fullLocation = paste(name, address, sep=", ")
  ) %>% mutate(
    lat = GetLat(fullLocation),
    lng = GetLng(fullLocation),
    type = GetType(fullLocation)
  )
  write.csv(sights, file="data/sights.csv")
}
```

## Visualization

Now it's fun part, we first load leaflet package


```r
library(leaflet)
```

Then we create a first layer with `leaftlet()` function


```r
m = leaflet() %>% addTiles()
sights <- sights %>% na.omit() %>% filter()
```

The next thing to do is set a view port for map


```r
m = m %>%
    setView(105.8, 15.9, zoom = 5)
```

Finally, we create `MultiPoint` geometry correspond with each sights in map


```r
for(i in 1:nrow(sights)){
  shape = list(
    type = 'Feature',
    properties = list(
      popup = paste(sights[i, ]$name, sights[i, ]$address,
                      sep=", ") 
    ),
    geometry = list(
      type = 'MultiPoint',
      coordinates = cbind(sights[i, ]$lng, sights[i, ]$lat)
    )
  )
  m = m %>% addGeoJSON(shape)
}
print(m)
```

and here are result 

![](http://i.imgur.com/gxPX9oF.png)

Actually, If you run this code, the map can be interactive. You can zoom in and zoom out, and a pop up will show detail informations when you click to shapes.

You can get full project here [https://github.com/rain1024/datayo/tree/master/vietnam-sights](https://github.com/rain1024/datayo/tree/master/vietnam-sights)
