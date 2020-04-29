devtools::load_all('/imppc/labs/lplab/share/marc/repos/trackHubeR')

pathHub <- '/imppc/labs/lplab/share/marc/browser/insulinomasHg38'
hubName <- 'insulinomas'
hubShortLabel <- 'insulinomas'
hubLongLabel <- 'insulinomas'
emailAddress <- 'msubirana@igtp.cat'
assemblyDatabase <- 'hg38'
gattacaHtml <- 'http://gattaca.imppc.org/genome_browser/lplab'
gattacaFolderHub <- 'marcHubs'


hubGenerator(pathHub = pathHub,
             hubName = hubName,
             hubShortLabel = hubShortLabel,
             hubLongLabel = hubLongLabel,
             emailAddress = emailAddress,
             assemblyDatabase = assemblyDatabase,
             gattacaHtml = gattacaHtml,
             gattacaFolderHub = gattacaFolderHub)


# Delete old trackDb if exists (avoid duplicates in the file)

unlink(file.path(pathHub, assemblyDatabase, 'trackDb.txt')) # put inside trackDb function

# pathBigWig <- '/imppc/labs/lplab/share/marc/browser/parserProve/hg19'

pathVcf <- '/imppc/labs/lplab/share/marc/browser/insulinomasHg38/hg38'

tracksVcf <- list.files(pathVcf,
                     pattern = "\\.vcf.gz$",
                     full.names = T)


type <- 'vcfTabix'
visibility <- 'dense'
color <- '0, 0, 0'
# paste(as.vector(col2rgb('blue')), collapse = ",")
# autoScale <- 'on'

for (track in tracksVcf){

  trackhubTrack(gattacaHtml = gattacaHtml,
                gattacaFolderHub = gattacaFolderHub,
                pathHub = pathHub,
                track = track,
                type = type,
                visibility = visibility,
                color = color,
                autoScale = autoScale)
}

gattacaDir <- '/data/apache/htdocs/genome_browser/lplab'
gattacaUser <- 'msubirana@gattaca'

rsyncHub(gattacaHtml = gattacaHtml,
         gattacaDir = gattacaDir,
         gattacaFolderHub = gattacaFolderHub,
         gattacaUser = gattacaUser)

pathBigWig <- '/imppc/labs/lplab/share/marc/browser/insulinomasHg38/hg38'


tracksigWigAtac <- list.files(pathBigWig,
                        pattern = "\\ATAC.bw$",
                        full.names = T)


type <- 'bigWig'
visibility <- 'full'
color <- '255, 204, 153'
autoScale <- 'on'

for (track in tracksigWigAtac){

  trackhubTrack(gattacaHtml = gattacaHtml,
                gattacaFolderHub = gattacaFolderHub,
                pathHub = pathHub,
                track = track,
                type = type,
                visibility = visibility,
                color = color,
                autoScale = autoScale)
}

tracksigWigChip <- list.files(pathBigWig,
                              pattern = "\\ChIP.bw$",
                              full.names = T)


type <- 'bigWig'
visibility <- 'full'
color <- '153, 204, 255'
autoScale <- 'on'

for (track in tracksigWigChip){

  trackhubTrack(gattacaHtml = gattacaHtml,
                gattacaFolderHub = gattacaFolderHub,
                pathHub = pathHub,
                track = track,
                type = type,
                visibility = visibility,
                color = color,
                autoScale = autoScale)
}

gattacaDir <- '/data/apache/htdocs/genome_browser/lplab'
gattacaUser <- 'msubirana@gattaca'

rsyncHub(gattacaHtml = gattacaHtml,
         gattacaDir = gattacaDir,
         gattacaFolderHub = gattacaFolderHub,
         gattacaUser = gattacaUser)





