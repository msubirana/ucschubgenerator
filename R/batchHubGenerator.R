#' batchHubGenerator
#'
#' Performs all the necessary steps for the creation of an UCSC hub with all the files in a the defined
#' folder. All the tracks saved in the \code{path_tracks} will present the same track format.
#'
#' @param path_local_hub Local folder of the hub where the files generated will be saved. A folder with the \code{hub_name}
#' will be generated.
#' @param hub_name Single-word name of the directory containing the track hub files. Not displayed to hub users.
#' @param hub_short_label The short name for the track hub. Suggested maximum length is 17 characters.
#' Displayed as the hub name on the Track Hubs page and the track group name on the browser tracks page.
#' @param hub_long_label Longer descriptive label for the track hub. Suggested maximum length is 80 characters.
#' Displayed in the description field on the Track Hubs page.
#' @param email_address Email that will be provided in the hub for contact info.
#' @param description_url URL to HTML page with a description of the hub's contents.
#' @param assembly_database Reference genome used for alignment.
#' @param gattaca_folder_hub Folder in the server where to save hub directory
#' @param gattaca_user User of gattaca server ('user@gattaca')
#' @param gattaca_dir Gattaca base directory. Default=''/data/apache/htdocs/genome_browser/lplab'
#' @param track File to upload in the UCSC hub.
#' @param short_label Specifies the track's "short label", which is used in a number of places in the Browser to identify the track.
#' For example, the short label is displayed alongside the track in the Browser image. By default the basename
#' of the sample.
#' @param long_label Specifies the track's "long label", which is also used in numerous places in the Browser to identify a track.
#' For instance, the long label is displayed above the track's data in the Browser image.
#' This label should be descriptive enough to allow users to uniquely identify the track within the Browser.
#' By default the basename of the sample.
#' @param type Declares the format of the data and is used to determine display methods and options. Valid settings:
#' altGraphX, bam, bed, bed5FloatScore, bedGraph, bedRnaElements, bigBarChart, bigBed, bigInteract, bigPsl, bigChain,
#' bigMaf, bigWig, broadPeak, chain, clonePos, coloredExon, ctgPos, downloadsOnly, encodeFiveC, expRatio, factorSource,
#' genePred, gvf, hic, ld2, narrowPeak, netAlign, peptideMapping, psl, rmsk, snake, vcfTabix, wig, wigMaf
#' @param visibility Visibility (i.e. "display mode") specifies which of 5 modes (including 'hide') should be used to display the track within the Browser image.
#' This setting is almost always dynamically customizable by each user.
#' The exact configuration of the display for each mode depends upon the track's type,
#' and some modes may not be supported for certain track types.
# 'Valid settings:
#' \itemize{
#'  \item hide: DEFAULT. The track is not displayed in the Browser image unless the user changes the display setting.
#'  \item dense: The track is displayed as a single line or ribbon. In many cases multiple items are summarized or drawn on top of one another, and the long labels are not displayed.
#'  \item squish: Each item is drawn individually, but at half height and without a label. (Not supported for all types.)
#'  \item pack: Items are displayed individually at full height, but in a much more compact vertical space than in full mode. (Not supported for all types.)
#'  \item full: Each item is displayed as a separate line in the Browser image. Graphed signals may be displayed in varying heights.
#'   }
#' @param color Many track types allow the color of the data displayed in the image to be specified with this setting.
#' The setting accepts red, green and blue values, each in the range of 0-255 and delimited by commas.
#' Though this setting is widely supported, some track types in certain display modes ignore it,
#' such as the EST tracks in dense mode. "255, 204, 153"
#' @param autoScale The graph of the data displayed in the Browser image is usually scaled on the y-axis in absolute coordinates.
#' However, you can display the data in two types of autoScale which will ensure either that the high score in the current
#' viewing window will peak at the top of the graph, or that all tracks in a composite will be scaled according to the
#' highest point in the viewing window of any visible tracks in the same composite. "on" or "off"
#' @param path_tracks Path with all the tracks desired in the hub. All of them will present the
#' format defined.
#' @param  quote_label By defult shortLabel and longLabel are set up as the basename of the file. Is it possible
#' to add more information using this parameter. The result long and short label will be "basename"_"quote_label".
#' By default empty.
#' @param pattern_tracks Filtering pattern to use in the \code{path_tracks} for the track selection.
#' @return A hub folder with all the elements and tracks saved in a local host and in the server and the
#' hub.txt to load into UCSC browser.
#' @examples
#' path <- downloadUcschubgenerator()
#' path_tracks <- path
#' pattern_tracks <- '.vcf.gz$'
#' hub_name <- 'example_hub_unique'
#' path_local_hub <- file.path(path, 'hubs')
#' dir.create(path_local_hub)
#' hub_short_label <- hub_name
#' hub_long_label <- 'Example of ucschubgenerator using only one type of file with a unique set of parameters'
#' email_address <- 'example@email.com'
#' assembly_database <- 'hg38'
#' gattaca_folder_hub <- 'exampleHub'
#' type <- 'vcfTabix'
#' visibility <- 'dense'
#' color <- '0, 0, 0'
#' gattaca_user <- 'msubirana@gattaca'
#' quote_label <- 'example'
#'
#' batchHubGenerator(path_tracks = path_tracks,
#'                   pattern_tracks = pattern_tracks,
#'                   path_local_hub = path_local_hub,
#'                   hub_name = hub_name,
#'                   hub_short_label = hub_short_label,
#'                   hub_long_label = hub_long_label,
#'                   email_address = email_address,
#'                   assembly_database = assembly_database,
#'                   gattaca_folder_hub = gattaca_folder_hub,
#'                   type = type,
#'                   visibility = visibility,
#'                   color = color,
#'                   quote_label = quote_label,
#'                   gattaca_user = gattaca_user)
#'
#' @export
batchHubGenerator <- function(path_tracks,
                              pattern_tracks,
                              path_local_hub,
                              hub_name,
                              hub_short_label,
                              hub_long_label,
                              email_address,
                              description_url = NULL,
                              assembly_database,
                              gattaca_html='http://gattaca.imppc.org/genome_browser/lplab',
                              gattaca_folder_hub,
                              short_label = NULL,
                              long_label = NULL,
                              type = NULL,
                              visibility = NULL,
                              color = NULL,
                              autoScale = NULL,
                              gattaca_user,
                              gattaca_dir = '/data/apache/htdocs/genome_browser/lplab',
                              quote_label = ''){

  hubGenerator(path_local_hub = path_local_hub,
               hub_name = hub_name,
               hub_short_label = hub_short_label,
               hub_long_label = hub_long_label,
               email_address = email_address,
               description_url = NULL,
               assembly_database = assembly_database,
               gattaca_html= gattaca_html,
               gattaca_folder_hub = gattaca_folder_hub)

  # Delete old trackDb if exists (avoid duplicates in the file)
  path_local_hub_name <- file.path(path_local_hub, hub_name)
  unlink(file.path(path_local_hub_name, assembly_database, 'trackDb.txt'))

  tracks <- list.files(path_tracks,
                       pattern = pattern_tracks,
                       full.names = T)

  for(track in tracks){

    trackhubTrack(gattaca_html = gattaca_html,
                  gattaca_folder_hub = gattaca_folder_hub,
                  path_local_hub = path_local_hub,
                  hub_name = hub_name,
                  assembly_database = assembly_database,
                  track = track,
                  short_label = short_label,
                  long_label = long_label,
                  type = type,
                  visibility = visibility,
                  color = color,
                  autoScale = autoScale,
                  quote_label = quote_label)
  }

  rsyncHub (gattaca_html= gattaca_html,
            gattaca_dir = gattaca_dir,
            gattaca_folder_hub = gattaca_folder_hub,
            gattaca_user = gattaca_user,
            path_local_hub = path_local_hub,
            hub_name = hub_name)
}

