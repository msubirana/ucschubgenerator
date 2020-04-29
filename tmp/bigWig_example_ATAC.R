devtools::load_all('/imppc/labs/lplab/share/marc/repos/ucschubgenerator')

hubName <- 'ATAC'

pathHub <- file.path('/imppc/labs/lplab/share/marc/refgen/hubs', hubName)
dir.create(pathHub, showWarnings = FALSE)
hubShortLabel <- hubName
hubLongLabel <- hubName
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

path_files <- '/imppc/labs/lplab/share/insulinoma_hg38/data/ATAC/vis'

files_hub <- list.files(path_files,
                        pattern = ".bw$",
                        full.names = TRUE)

new_names <- unlist(lapply(files_hub,
                           function(x) paste0(gsub("\\..*",
                                                   "",
                                                   gsub("\\_.*",
                                                        "",
                                                        basename(x))),
                                              ".bw")))

dir.create(file.path(pathHub, assemblyDatabase), showWarnings = FALSE)
new_names <- file.path(pathHub, assemblyDatabase, new_names)
file.copy(from = files_hub, to = new_names)


# Delete old trackDb if exists (avoid duplicates in the file)

unlink(file.path(pathHub, assemblyDatabase, 'trackDb.txt')) # put inside trackDb function

type <- 'bigWig'
visibility <- 'full'
color <- '153, 204, 255'
autoScale <- 'on'

tracks <- list.files(file.path(pathHub, assemblyDatabase),
                     pattern = ".bw$",
                     full.names = TRUE)

for (track in tracks){

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
