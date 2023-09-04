#################################################
## map districts by HR using district shp-file ##
#################################################

## load libraries ##
library(sf)
library(tmap)

## note url of the zipped shapefile ##
url <- "https://github.com/s-a-5595/state_districts_by_hr/raw/main/Districts.zip"
# File name you want to save locally
local_filename <- basename(url)

# download the file to your working directory
download.file(url, destfile = local_filename, method = "auto")

if (file.exists(local_filename)) {
  cat("File downloaded successfully:", local_filename, "\n")
} else {
  cat("File download failed.\n")
}

# unzip shapefile
unzip(local_filename)

# read shapefile using sf package
read.shp <- st_read("Districts/2011_Districts_State_HR.shp")

## create new column to combine HR number and HR name ##
read.shp$HR <- paste(read.shp$HR_Nmbr, read.shp$HR_Name, sep = ": ")

## mark states of interest ##
soi <- c('Karnataka', 'Kerala', 'Tamil Nadu')

## filter out 1st state of interest ##
df <- read.shp %>% filter(ST_NM %in% soi[1])

# convert to sf 
karnataka_sf <- sf::st_as_sf(df)

## create map ##
karnataka_map <- tm_shape(karnataka_sf) +
                 tm_polygons("HR") + 
                 tm_text("DISTRCT", size = "AREA", scale = 0.5, just = "center") +
                 tm_layout(main.title = "Karnataka", main.title.position = "center",
                 legend.outside = TRUE, legend.text.size = 0.8)

# save map as png 
tmap_save(karnataka_map, filename = "karnataka_map.png", 
          width = 10, height = 6, units = "in", dpi = 300)

## filter out 2nd state of interest ##
df <- read.shp %>% filter(ST_NM %in% soi[2])

kerala_sf <- sf::st_as_sf(df)

kerala_map <- tm_shape(kerala_sf) +
              tm_polygons("HR") + 
              tm_text("DISTRCT", size = "AREA", scale = 0.5, just = "center") +
              tm_layout(main.title = "Kerala", main.title.position = "center",
              legend.outside = TRUE, legend.text.size = 0.5)

tmap_save(kerala_map, filename = "kerala_map.png", 
          width = 10, height = 6, units = "in", dpi = 300)

## filter out 3rd state of interest ##
df <- read.shp %>% filter(ST_NM %in% soi[3])

tamilnadu_sf <- sf::st_as_sf(df)

tamilnadu_map <- tm_shape(tamilnadu_sf) +
                 tm_polygons("HR") + 
                 tm_text("DISTRCT", size = "AREA", scale = 0.5, just = "center") +
                 tm_layout(main.title = "Tamil Nadu", main.title.position = "center",
                 legend.outside = TRUE, legend.text.size = 0.5) +
                 tmap_options(check.and.fix = TRUE)

tmap_save(tamilnadu_map, filename = "tamilnadu_map.png", 
          width = 10, height = 6, units = "in", dpi = 300)