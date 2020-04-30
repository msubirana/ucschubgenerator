Welcome to UcscHubgeneratoR
================

Displaying and managing custom tracks into a Genome Browser (UCSC) can be annoying.

![](vignettes/img/giphy.gif)

For this reason we have created a R package that facilitates the creation and upload of custom tracks based on [track hubs](https://genome.ucsc.edu/goldenPath/help/hgTrackHubHelp.html). A track hub is way of organizing large numbers of genome-wide data sets, configured with a set of plain-text files that determine the organization, UI, labels, color, and other details. The data underlying the tracks and optional sequence in a hub reside on the remote server of the data provider rather than at UCSC. Genomic annotations are stored in compressed binary indexed files in bigBed, bigBarChart, bigGenePred, bigNarrowPeak, bigPsl, bigChain, bigInteract, bigMaf, bigWig, BAM, CRAM, HAL or VCF format that contain the data at several resolutions. For more information about the types and parameters visit [trackDb information](https://genome.ucsc.edu/goldenPath/help/trackDb/trackDbHub.html). Currently the allowed parameters are: type, visibility, color and autoScale, shortLabel and longLabel.

Ucscgenerator package requires a GATTACA SSH Key of the GATTACA user saved in the host where it will be run. For a detailed guide please check [SSH Key](https://www.ssh.com/ssh/keygen/).

Installation
------------

The following code demonstrates a track hub built out of all bigWig files found in a directory.

``` r
library(devtools)
#> Loading required package: usethis
install_github("msubirana/ucschubgenerator")
#> Downloading GitHub repo msubirana/ucschubgenerator@master
#>   
   checking for file ‘/tmp/RtmpZ1bFWd/remotes3292632218f3/msubirana-ucschubgenerator-e92c087/DESCRIPTION’ ...
  
✓  checking for file ‘/tmp/RtmpZ1bFWd/remotes3292632218f3/msubirana-ucschubgenerator-e92c087/DESCRIPTION’
#> 
  
─  preparing ‘ucschubgenerator’:
#> 
  
   checking DESCRIPTION meta-information ...
  
✓  checking DESCRIPTION meta-information
#> 
  
─  checking for LF line-endings in source and make files and shell scripts
#> 
  
─  checking for empty or unneeded directories
#> 
  
─  building ‘ucschubgenerator_0.0.0.9000.tar.gz’
#> 
  
   
#> 
#> Installing package into '/home/msg/R/x86_64-pc-linux-gnu-library/3.6'
#> (as 'lib' is unspecified)
```

Basic Example
-------------

### Download example dataset

``` r
# Import libraries
library(ucschubgenerator)
# Download example data 
path <- downloadUcschubgenerator()
#> Will begin downloading datasets to /tmp/RtmpZ1bFWd/file32923d0f0a27
#> untar: using cmd = '/bin/tar -xf '/tmp/RtmpZ1bFWd/file32923d0f0a27' -C './''
#> Done writing ucschubgenerator example files to ./
```

### Create the trackhub

In this example, a trackhub with the same type of tracks and parameters will be created. In the following example will be face trackhubs with different file types and parameters.

In this case we will select the '.vcf.gz' of the 'example\_data' download previously and saved in the 'path' variable. All the 'vcf.gz' will present the same parameters defined for this particular hub.

``` r
# Import libraries
library(ucschubgenerator)

# Define variables
path_tracks <- path
pattern_tracks <- '.vcf.gz$'
hub_name <- 'example_hub_unique'
path_local_hub <- file.path(path, 'hubs')
dir.create(path_local_hub)
#> Warning in dir.create(path_local_hub): './/example_data/hubs' already exists
hub_short_label <- hub_name
hub_long_label <- 'Example of ucschubgenerator using only one type of file with a unique set of parameters'
email_address <- 'example@email.com'
assembly_database <- 'hg38'
gattaca_folder_hub <- 'exampleHub'
type <- 'vcfTabix'
visibility <- 'dense'
color <- '0, 0, 0'
gattaca_user <- 'msubirana@gattaca'
quote_label <- 'example'

batchHubGenerator(path_tracks = path_tracks,
                              pattern_tracks = pattern_tracks,
                              path_local_hub = path_local_hub,
                              hub_name = hub_name,
                              hub_short_label = hub_short_label,
                              hub_long_label = hub_long_label,
                              email_address = email_address,
                              assembly_database = assembly_database,
                              gattaca_folder_hub = gattaca_folder_hub,
                              type = type,
                              visibility = visibility,
                              color = color,
                              quote_label = quote_label,
                              gattaca_user = gattaca_user)
#> 2020-04-30 11:49:39 
#>  Starting hubGenerator using:
#>  >Path local hub: .//example_data/hubs 
#>  >Hub name: example_hub_unique 
#>  >Hub short label: example_hub_unique 
#>  >Hub long label: Example of ucschubgenerator using only one type of file with a unique set of parameters 
#>  >Email address: example@email.com 
#>  >Description url:  
#>  >Assembly database: hg38 
#>  >Gattaca html: http://gattaca.imppc.org/genome_browser/lplab 
#>  >Gattaca folder hub: exampleHub
#> 2020-04-30 11:49:39 
#>  Finished hubGenerator
#> [1] "http://gattaca.imppc.org/genome_browser/lplab/exampleHub/example_hub_unique/hub.txt"
```

Once the script ends, you can upload the hub in the [USCS web](https://genome.ucsc.edu/cgi-bin/hgHubConnect?hubCheckUrl=http%3A%2F%2Fgattaca.imppc.org%2Fgenome_browser%2Flplab%2FmarcHubs%2FparserProve%2Fhub.txt&hgsid=759593043_P7LJWoCqmm0BrJx4xCRwGGvMCkRt). selecting My Hubs and pasting the link generated (server link of the hub.txt file).

To visualize it, is necessary to open the appropriate human assembly and the track hub will appear under the Custom Tracks.

![](vignettes/img/Screenshot-from-2019-09-17-15-25-59.png)

This time we will create a hub with different types of tracks and different parameters.

``` r
path_tracks <- path
hub_name <- 'example_hub_multiple'
path_local_hub <- file.path(path, 'hubs')
dir.create(path_local_hub)
#> Warning in dir.create(path_local_hub): './/example_data/hubs' already exists
hub_short_label <- hub_name
hub_long_label <- 'Example of ucschubgenerator using different type of files and parameters'
email_address <- 'example@email.com'
assembly_database <- 'hg38'
gattaca_folder_hub <- 'exampleHub'
gattaca_user <- 'msubirana@gattaca'

# Generation of the basic hub structure
hubGenerator(path_local_hub = path_local_hub,
             hub_name = hub_name,
             hub_short_label = hub_short_label,
             hub_long_label = hub_long_label,
             email_address = email_address,
             description_url = NULL,
             assembly_database = assembly_database,
             gattaca_folder_hub = gattaca_folder_hub)
#> 2020-04-30 11:49:40 
#>  Starting hubGenerator using:
#>  >Path local hub: .//example_data/hubs 
#>  >Hub name: example_hub_multiple 
#>  >Hub short label: example_hub_multiple 
#>  >Hub long label: Example of ucschubgenerator using different type of files and parameters 
#>  >Email address: example@email.com 
#>  >Description url:  
#>  >Assembly database: hg38 
#>  >Gattaca html: http://gattaca.imppc.org/genome_browser/lplab 
#>  >Gattaca folder hub: exampleHub
#> 2020-04-30 11:49:40 
#>  Finished hubGenerator

# Delete old trackDb if exists (avoid duplicates in the file)
path_local_hub_name <- file.path(path_local_hub, hub_name)
unlink(file.path(path_local_hub_name, assembly_database, 'trackDb.txt'))

# Upload "vcf.gz" files
pattern_tracks <- '.vcf.gz$'
tracks <- list.files(path_tracks,
                       pattern = pattern_tracks,
                       full.names = T)

quote_label = 'vcf_examples'
type <- 'vcfTabix'
visibility <- 'dense'
color <- '0, 0, 0'

for(track in tracks){

  trackhubTrack(path_local_hub = path_local_hub,
                hub_name = hub_name,
                gattaca_folder_hub = gattaca_folder_hub,
                assembly_database = assembly_database,
                track = track,
                short_label = short_label,
                long_label = long_label,
                type = type,
                visibility = visibility,
                color = color,
                quote_label = quote_label)
}

# Upload "bw" files with parameters 1
pattern_tracks <- '_t1.bw$'
tracks <- list.files(path_tracks,
                       pattern = pattern_tracks,
                       full.names = T)

quote_label = '_bw_examples1'
type <- 'bigWig'
visibility <- 'full'
color <- '255, 204, 153'
autoScale <- 'on'

for(track in tracks){

  trackhubTrack(path_local_hub = path_local_hub,
                hub_name = hub_name,
                gattaca_folder_hub = gattaca_folder_hub,
                assembly_database = assembly_database,
                track = track,
                short_label = short_label,
                long_label = long_label,
                type = type,
                visibility = visibility,
                color = color,
                quote_label = quote_label)
}

# Upload "bw" files with parameters 2
pattern_tracks <- '_t2.bw$'
tracks <- list.files(path_tracks,
                       pattern = pattern_tracks,
                       full.names = T)

quote_label = '_bw_examples2'
type <- 'bigWig'
visibility <- 'full'
color <- '153, 204, 255'
autoScale <- 'on'

for(track in tracks){

  trackhubTrack(path_local_hub = path_local_hub,
                hub_name = hub_name,
                gattaca_folder_hub = gattaca_folder_hub,
                assembly_database = assembly_database,
                track = track,
                short_label = short_label,
                long_label = long_label,
                type = type,
                visibility = visibility,
                color = color,
                quote_label = quote_label)
}

# rsync to the gattaca server and generate the UCSC link
rsyncHub (gattaca_folder_hub = gattaca_folder_hub,
          gattaca_user = gattaca_user,
          path_local_hub = path_local_hub,
          hub_name = hub_name)
#> [1] "http://gattaca.imppc.org/genome_browser/lplab/exampleHub/example_hub_multiple/hub.txt"
```
