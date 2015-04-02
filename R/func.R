library(jsonlite)
library(dplyr)

Url <- function(address, return.call = "json", sensor = "false") {
    root <- "http://maps.google.com/maps/api/geocode/"
    u <- paste(root, return.call, "?address=", address, "&sensor=", sensor, sep = "")
    return(URLencode(u))
}

GeoCode <- function(address, verbose=FALSE) {
    if(verbose) cat(address,"\n")
    u <- Url(address)
    x <- fromJSON(txt=u)
    if(x$status=="OK") {
        lat <- x$results$geometry$location$lat
        lng <- x$results$geometry$location$lng
        type <- x$results$geometry$location_type
        return(c(lat, lng, type))
    } else {
        return(c(NA,NA))
    }
}

GetLat = function(address){
    GeoCode(address)[1]
}

GetLng = function(address){
    GeoCode(address)[2]
}

GetType = function(address){
    GeoCode(address)[3]
}

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

GetGeoOfSights()