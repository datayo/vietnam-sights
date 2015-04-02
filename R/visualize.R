library(leaflet)

m = leaflet() %>% addTiles()

sights <- sights %>% na.omit() %>% filter()

m = m %>%
    setView(105.8, 15.9, zoom = 5)

for(i in 1:nrow(sights)){
    shape = list(
        type = 'Feature',
        properties = list(
            popup = paste(sights[i, ]$name, sights[i, ]$address, sep=", ") 
        ),
        geometry = list(
            type = 'MultiPoint',
            coordinates = cbind(sights[i, ]$lng, sights[i, ]$lat)
        )
    )
    m = m %>% addGeoJSON(shape)
}

print(m)