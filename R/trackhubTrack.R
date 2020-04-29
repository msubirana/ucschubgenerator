#' trackhubTrack
#'
#' Generates the trackDb file for every file in a defined path and copy the files into the local hub folder
#' in the defined assembly database.
#'
#' @return Creates a folder with the basics (hub.txt and genomes.txt) for the generation of a UCSC hub (based on gattaca server).
#' @examples
#' path_tracks <- path
#' hub_name <- 'example_hub_multiple'
#' path_local_hub <- file.path(path, 'hubs')
#' dir.create(path_local_hub)
#' assembly_database <- 'hg38'
#' gattaca_folder_hub <- 'exampleHub'
#' pattern_tracks <- '.vcf.gz$'
#' tracks <- list.files(path_tracks,
#'                      pattern = pattern_tracks,
#'                      full.names = T)
#' quote_label = 'vcf_examples'
#' type <- 'vcfTabix'
#' visibility <- 'dense'
#' color <- '0, 0, 0'
#'
#' for(track in tracks){
#'   trackhubTrack(gattaca_folder_hub = gattaca_folder_hub,
#'                 path_local_hub = path_local_hub,
#'                 hub_name = hub_name,
#'                 gattaca_folder_hub = gattaca_folder_hub,
#'                 assembly_database = assembly_database,
#'                 track = track,
#'                 short_label = short_label,
#'                 long_label = long_label,
#'                 type = type,
#'                visibility = visibility,
#'                 color = color,
#'                 quote_label = quote_label)
#' }
#' @export
trackhubTrack <- function(gattaca_html = '/data/apache/htdocs/genome_browser/lplab',
                          gattaca_folder_hub,
                          path_local_hub,
                          hub_name = hub_name,
                          assembly_database,
                          track,
                          quote_label = '',
                          short_label = NULL,
                          long_label = NULL,
                          type = NULL,
                          visibility = NULL,
                          color = NULL,
                          autoScale = NULL){

  path_local_hub_name <- file.path(path_local_hub, hub_name)

  gattaca_html_hub <- file.path(gattaca_html, gattaca_folder_hub, basename(path_local_hub_name))

  big_data_url <- file.path(gattaca_html_hub, assembly_database, basename(track))

  sample_name <- gsub('\\..*$', '', basename(track))

  # track names can't have any spaces or special chars
  sample_name <- stringr::str_replace_all(gsub(" ","" , sample_name ,ignore.case = TRUE), "[^[:alnum:]]", "")

  # generate trackDb

  short_label <- paste0(sample_name, "_", quote_label)
  long_label <- paste0(sample_name, "_", quote_label)
  track_text <- paste0('track', " ", sample_name)

  track_text <- paste0(track_text,
                      '\n',
                      'bigDataUrl', " ", big_data_url)

  track_text <- paste0(track_text,
                      '\n',
                      'shortLabel', " ", short_label)

  track_text <- paste0(track_text,
                      '\n',
                      'longLabel', " ", long_label)

  # get all the arguments of the function
  track_args <- as.list(match.call(trackhubTrack))
  track_args <- names(track_args)

  # discart first two elements (empty and track)
  track_args <- track_args[-c(seq(1,5))]

  # print to file only arguments that exist and their value

  for (track_arg in track_args){
    if (exists(track_arg)){
      track_text <- paste0(track_text,
                          '\n',
                          paste0(substitute(track_arg), " ", eval(parse(text = track_arg))))
    }
  }

  track_text <- paste0(track_text,
                      '\n')

  dir.create(file.path(path_local_hub_name, assembly_database), showWarnings = FALSE)
  write(track_text, file.path(path_local_hub_name, assembly_database, 'trackDb.txt'), append = T)

  # copy the file into the assemblyDatabase hub folder
  file.copy(track, file.path(path_local_hub_name, assembly_database))

  # copy '.tbi' if the file is 'vcf.gz'
  extension_file <- substr(track,(nchar(track)+1)-7,nchar(track))
  if(extension_file == '.vcf.gz'){
    file.copy(paste0(track, '.tbi'), file.path(path_local_hub_name, assembly_database))
  }
}
