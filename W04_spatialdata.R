################################################################################
# Einführung in Räumliche Daten I/O in R
# Author: Hanna
################################################################################
rm(list=ls())
library(rgdal)
library(raster)
library(mapview)

setwd("/home/hanna/Documents/Lehre/SoSe18/LAI/daten/w04/")

###################### VEKTOR DATEN ############################################
### Shapefile laden
fielddat <- shapefile("fielddat/fielddat.shp")
print(fielddat)
plot(fielddat)
mapview(fielddat)

### Shapefile ausschreiben
shapefile(fielddat, filename='myshapefile.shp')

### Daten Plotten
plot(fielddat)
spplot(fielddat,"LAI")
mapview(fielddat)

###################### RASTER DATEN ############################################

# einzelne Raster laden
ch4 <- raster("Sentinel201705110/T32UMB_20170510T103031_B04.jp2")
ch4
# mehrere Kanäle als Stack laden
sentinel2 <- stack("Sentinel201705110/T32UMB_20170510T103031_B02.jp2",
            "Sentinel201705110/T32UMB_20170510T103031_B03.jp2",
            "Sentinel201705110/T32UMB_20170510T103031_B04.jp2")

# daten plotten
plot(ch4)
plot(sentinel2)

#raster zuschneiden mit ausdehnung der Samplingpoints
sentinel2_crop <- crop(sentinel2,fielddat)
plotRGB(sentinel2_crop,r=3,g=2,b=1,stretch='lin')
# samplingpoints zum composite hinzufügen
plot(fielddat,add=TRUE,col="yellow")

###################### PROJEKTIONEN ############################################
#on the fly?
roads <- shapefile("Caldern_roads.shp")
plot(roads)

plotRGB(sentinel2_crop,r=3,g=2,b=1,
        stretch='lin',axes=TRUE)
plot(fielddat,add=TRUE,col="yellow")
plot(roads,add=TRUE)

# Vektordaten in UTM umprojizieren
roadsUTM <- spTransform(roads,
                        "+proj=utm +zone=32 +datum=WGS84 +units=m +no_defs +ellps=WGS84 +towgs84=0,0,0")
plot(roadsUTM,add=TRUE)

# Projektionen zuweisen
caldernf <- raster("CaldernerForst.tif")
projection(caldernf) # keine Projektioninformation!
plot(caldernf,axes=T) # Koordinaten deuten auf longlat hin!


projection(caldernf) <- "+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs "
crs(caldernf) <-"+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs "
#erst nach dem zuweisen dürfen wir umprojizieren:
caldernf_proj <- projectRaster(caldernf,
                         crs="+proj=utm +zone=32 +datum=WGS84 +units=m +no_defs +ellps=WGS84 +towgs84=0,0,0")

