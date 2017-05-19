################################################################################
# Einführung in Räumliche Daten I/O in R
# Hanna Meyer
################################################################################
rm(list=ls())
library(rgdal)
library(raster)
library(mapview)

setwd("/home/hanna/Documents/Lehre/SoSe2017/Projektseminar/data/W4/")

###################### VEKTOR DATEN ############################################
### Shapefile laden
caldernpoints <- readOGR(dsn = "samplingpoints.shp",
                         layer=ogrListLayers("samplingpoints.shp"))
print(caldernpoints)

### Shapefile ausschreiben
writeOGR(caldernpoints,
         "myshp.shp",
         layer="myshp",
         driver="ESRI Shapefile")

### Daten Plotten
plot(caldernpoints)
spplot(caldernpoints)
mapview(caldernpoints)

###################### RASTER DATEN ############################################
# einzelne Raster laden
ch5 <- raster("L8_20170506/L8_20170506_4.tif")
ch5
# mehrere Kanäle als Stack laden
l8 <- stack("L8_20170506/L8_20170506_2.tif",
            "L8_20170506/L8_20170506_3.tif",
            "L8_20170506/L8_20170506_4.tif")

# daten plotten
plot(ch5)
plot(l8)

#raster zuschneiden mit ausdehnung der Samplingpoints
l8_crop <- crop(l8,caldernpoints)
plotRGB(l8_crop,r=3,g=2,b=1,
        stretch='hist')
# samplingpoints zum composite hinzufügen
plot(caldernpoints,add=TRUE)

###################### PROJEKTIONEN ############################################
#on the fly?
roads <- readOGR(dsn = "Caldern_roads.shp",
                 layer=ogrListLayers("Caldern_roads.shp"))
plot(roads)

plotRGB(l8_crop,r=3,g=2,b=1,
        stretch='hist')
plot(caldernpoints,add=TRUE)
plot(roads,add=TRUE)

# Vektordaten in UTM umprojizieren
roadsUTM <- spTransform(roads,
                        "+proj=utm +zone=32 +datum=WGS84 +units=m +no_defs +ellps=WGS84 +towgs84=0,0,0")

# Projektionen zuweisen
caldernf <- raster("CaldernerForst.tif")
projection(caldernf) # keine Projektioninformation!
plot(caldernf,axes=T) # Koordinaten deuten auf longlat hin!
projection(caldernf) <- "+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs "
#erst nach dem zuweisen umprojizieren:
caldernf_proj <- projectRaster(caldernf,
                         crs="+proj=utm +zone=32 +datum=WGS84 +units=m +no_defs +ellps=WGS84 +towgs84=0,0,0")

