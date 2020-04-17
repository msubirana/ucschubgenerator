#' R parser for UCSC truckhub creation
#'
#' @param pathHub Trackhub path
#' @param hubName Top-level name of the hub
#' @param hubShortLabel Short label for the hub, alias for UCSC parameter shortLabel
#' @param hubLongLabel Long label for the hub, alias for UCSC parameter longLabel
#' @param emailAddress Email that will be provided in the hub for contact info
#' @param descriptionUrl URL to HTML page with a description of the hub's contents
#' @param assemblyDatabase Reference genome used for alignment
#' @param gattacaHtml Gattaca html
#' @param gattacaDir Gattaca base directory
#' @param gattacaFolderHub Folder in the server where to save hub directory
#' @param gattacaUser User of gattaca server ('user@gattaca')

# Generation of the track hub components
hubGenerator <- function(pathHub,
                         hubName,
                         hubShortLabel,
                         hubLongLabel,
                         emailAddress,
                         descriptionUrl = NULL,
                         assemblyDatabase,
                         gattacaHtml,
                         gattacaFolderHub){

  # hub file generation

  filesGattacaPath <- file.path(gattacaHtml, gattacaFolderHub, basename(pathHub))

  serverGenomes <- file.path(filesGattacaPath, 'genomes.txt')

  hubText <- paste0('hub ', hubName, '\n',
                    'shortLabel ', hubShortLabel, '\n',
                    'longLabel ', hubLongLabel, '\n',
                    'genomesFile ', serverGenomes, '\n',
                    'email ', emailAddress)

  if (!is.null(descriptionUrl)){
    hubText <- paste0(hubText,
                      '\n', 'descriptionUrl ',  descriptionUrl)
  }

  write(hubText, file.path(pathHub, 'hub.txt'))

  # genomes file generation

  localTrackDb <- file.path(pathHub, assemblyDatabase, "trackDb.txt")
  localMetaTab <- file.path(pathHub, assemblyDatabase, "metaTab.txt")

  serverTrackDb <- file.path(filesGattacaPath, assemblyDatabase, "trackDb.txt")
  serverMetaTab <- file.path(filesGattacaPath, assemblyDatabase, "metaTab.txt")

  genomesText <- paste0('genome ', assemblyDatabase, '\n',
                        'trackDb ', serverTrackDb)

  if (exists('metaTab')){
    genomesText <- paste0(genomesText,
                          '\n', 'metaTab ', serverMetaTab)
  }

  write(genomesText, file.path(pathHub, 'genomes.txt'))

}

# track names can't have any spaces or special chars
correctTrackName <- function(name){
  corrName <- stringr::str_replace_all(gsub(" ","" , name ,ignore.case = TRUE), "[^[:alnum:]]", "")
  return(corrName)
}

# Generation of the track hub c trackomponents
trackhubTrack <- function(gattacaHtml,
                          gattacaFolderHub,
                          pathHub,
                          track,
                          shortLabel = NULL,
                          longLabel = NULL,
                          type = NULL,
                          visibility = NULL,
                          color = NULL,
                          autoScale = NULL){

  filesGattacaPath <- file.path(gattacaHtml, gattacaFolderHub, basename(pathHub))

  bigDataUrl <- file.path(filesGattacaPath, assemblyDatabase, basename(track))

  filesGattacaPath <- file.path(gattacaHtml, gattacaFolderHub, basename(pathHub))

  track <- tools::file_path_sans_ext(basename(track))

  track <- correctTrackName(track)

  shortLabel <- track

  longLabel <- track

  trackText <- paste0('track', " ", track)

  trackText <- paste0(trackText,
                     '\n',
                     'bigDataUrl', " ", bigDataUrl)

  trackText <- paste0(trackText,
                     '\n',
                     'shortLabel', " ", shortLabel)

  trackText <- paste0(trackText,
                     '\n',
                     'longLabel', " ", longLabel)

  # get all the arguments of the function
  trackArgs <- as.list(match.call(trackhubTrack))

  trackArgs <- names(trackArgs)

  # discart first two elements (empty and track)
  trackArgs <- trackArgs[-c(seq(1,5))]

    # print to file only arguments that exist and their value

  for (trackArg in trackArgs){
    if (exists(trackArg)){
      trackText <- paste0(trackText,
                          '\n',
                          paste0(substitute(trackArg), " ", eval(parse(text = trackArg))))
    }
  }

  trackText <- paste0(trackText,
                      '\n')

  dir.create(file.path(pathHub, assemblyDatabase), showWarnings = FALSE)
  write(trackText, file.path(pathHub, assemblyDatabase, 'trackDb.txt'), append = T)
}


# rsync trackhub to server
rsyncHub <- function(gattacaHtml,
                     gattacaDir,
                     gattacaFolderHub,
                     gattacaUser){

  gattacaPath <- file.path(gattacaDir, gattacaFolderHub)

  system(paste('rsync -r -a -v -e ssh',
               pathHub,
               paste0(gattacaUser,
                      ':',
                      gattacaPath)))

  # generate hub link

  print(paste0(file.path(gattacaHtml, gattacaFolderHub, basename(pathHub), 'hub.txt')))
}



