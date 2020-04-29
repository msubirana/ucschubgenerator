#' hubGenerator
#'
#' Generates a local folder with the basic hub structure
#'
#' @inheritParams batchHubGenerator
#' @return Creates a folder with the basics (hub.txt and genomes.txt) for the generation of a UCSC hub (based on gattaca server).
#' @examples
#'path_tracks <- path
#'hub_name <- 'example_hub_multiple'
#'path_local_hub <- file.path(path, 'hubs')
#'dir.create(path_local_hub)
#'hub_short_label <- hub_name
#'hub_long_label <- 'Example of ucschubgenerator using different type of files and parameters'
#'email_address <- 'example@email.com'
#'assembly_database <- 'hg38'
#'gattaca_folder_hub <- 'exampleHub'
#'hubGenerator(path_local_hub = path_local_hub,
#'             hub_name = hub_name,
#'             hub_short_label = hub_short_label,
#'             hub_long_label = hub_long_label,
#'             email_address = email_address,
#'             description_url = NULL,
#'             assembly_database = assembly_database,
#'             gattaca_folder_hub = gattaca_folder_hub)
#' @export
hubGenerator <- function(path_local_hub,
                         hub_name,
                         hub_short_label,
                         hub_long_label,
                         email_address,
                         description_url = NULL,
                         assembly_database,
                         gattaca_html='http://gattaca.imppc.org/genome_browser/lplab',
                         gattaca_folder_hub){

  # local hub files generation
  message(paste(Sys.time(),"\n",
                'Starting hubGenerator using:\n',
                '>Path local hub:', path_local_hub, '\n',
                '>Hub name:', hub_name, '\n',
                '>Hub short label:', hub_short_label, '\n',
                '>Hub long label:', hub_long_label, '\n',
                '>Email address:', email_address, '\n',
                '>Description url:', description_url, '\n',
                '>Assembly database:', assembly_database, '\n',
                '>Gattaca html:', gattaca_html, '\n',
                '>Gattaca folder hub:', gattaca_folder_hub, '\n'))

  # hub text generation
  path_local_hub_name <- file.path(path_local_hub, hub_name)
  gattaca_html_hub <- file.path(gattaca_html, gattaca_folder_hub, basename(path_local_hub_name))

  gattaca_html_hub_genomes <- file.path(gattaca_html_hub, 'genomes.txt')

  hub_text <- paste0('hub ', hub_name, '\n',
                    'shortLabel ', hub_short_label, '\n',
                    'longLabel ', hub_long_label, '\n',
                    'genomesFile ', gattaca_html_hub_genomes, '\n',
                    'email ', email_address)

  if (!is.null(description_url)){
    hub_text <- paste0(hub_text,
                      '\n', 'description_url ',  description_url)
  }

  dir.create(path_local_hub_name, showWarnings = FALSE)
  write(hub_text, file.path(path_local_hub_name, 'hub.txt'))

  # genomes file generation

  gattaca_html_hub_trackdb <- file.path(gattaca_html_hub, assembly_database, "trackDb.txt")
  gattaca_html_hub_metatab <- file.path(gattaca_html_hub, assembly_database, "metaTab.txt")

  genomes_text <- paste0('genome ', assembly_database, '\n',
                        'trackDb ', gattaca_html_hub_trackdb)

  if (exists('metaTab')){
    genomes_text <- paste0(genomes_text,
                          '\n', 'metaTab ', gattaca_html_hub_metatab)
  }

  write(genomes_text, file.path(path_local_hub_name, 'genomes.txt'))

  message(paste(Sys.time(),"\n",
                'Finished hubGenerator'))


}

