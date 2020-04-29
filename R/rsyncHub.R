#' rsyncHub
#'
#' Rsync local hub to gattaca server and generates the html for uploading in ucsc page.
#'
#' @inheritParams batchHubGenerator
#' @return The hub.txt path of the rsync hub.
#' @examples
#' path <- downloadUcschubgenerator()
#' hub_name <- 'example_hub_multiple'
#' path_local_hub <- file.path(path, 'hubs')
#' gattaca_folder_hub <- 'exampleHub'
#' gattaca_user <- 'msubirana@gattaca'
#' rsyncHub (hub_name = hub_name,
#'           gattaca_folder_hub = gattaca_folder_hub,
#'           gattaca_user = gattaca_user,
#'           path_local_hub = path_local_hub)

# rsync trackhub to server
rsyncHub <- function(path_local_hub,
                     hub_name,
                     gattaca_html='http://gattaca.imppc.org/genome_browser/lplab',
                     gattaca_dir = '/data/apache/htdocs/genome_browser/lplab',
                     gattaca_folder_hub,
                     gattaca_user){

  path_local_hub_name <- file.path(path_local_hub, hub_name)

  gattaca_path <- file.path(gattaca_dir, gattaca_folder_hub)

  system(paste('rsync -r -a -v -e ssh',
               path_local_hub_name,
               paste0(gattaca_user,
                      ':',
                      gattaca_path)))

  # generate hub link
  print(paste0(file.path(gattaca_html, gattaca_folder_hub, basename(path_local_hub_name), 'hub.txt')))
}




