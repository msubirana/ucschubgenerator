#' Download ucschubgenerator example datasets
#'
#' Downloads the required ucschubfenerator example datasets.
#' @param output_dir Output directory for the datasets.
#' @param file_dir Path to the compressed database file.
#' @return It creates the \code{output_dir} with the example ucschubgenerator files used
#'  by the vignette.
#' @examples
#' path <- downloadUcschubgenerator()
#' @importFrom utils download.file untar
#' @export
downloadUcschubgenerator <- function(output_dir="./",
                                     file_dir="http://gattaca.imppc.org/genome_browser/lplab/exampleHub/example_data.tar.gz") {
  tf <- tempfile()
  message("Will begin downloading datasets to ", tf)
  ret <- download.file(file_dir, tf, mode='wb')

  if (ret != 0) stop("Couldn't download file from ", file_dir)

  untar(tf, exdir=output_dir, verbose=TRUE)
  message("Done writing ucschubgenerator example files to ", output_dir)

  return(invisible(file.path(output_dir, "example_data")))
}
