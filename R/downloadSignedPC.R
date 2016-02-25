#' Download a SIF file containing only signed interactions
#' 
#' @param destDir a string, the destination directory for the file to be 
#'   downloaded (Default: NULL). If NULL, then file will be downloaded to cache
#'   directory file.path(Sys.getenv("HOME"), ".paxtoolsRCache")
#' @return a SIF containing interactions that are considered signed (i.e. 
#'   interactions causing an increase on decrease in a molecular species)
#' 
#' @examples 
#' # downloadSignedPC()
#' 
#' @export
downloadSignedPC <- function(destDir=NULL) {
    baseUrl <- Sys.getenv("SIGNED_PC_URL")
    selectedFileName <- Sys.getenv("SIGNED_PC_FILE")
    
    downloadResult <- paxtoolsr::downloadFile(baseUrl=baseUrl, fileName=selectedFileName)
    
    if(is.null(destDir)) {
        stopifnot(Sys.getenv("PAXTOOLSR_CACHE") != "")
        selectedFilePath <- file.path(Sys.getenv("PAXTOOLSR_CACHE"), selectedFileName)
    } else {
        selectedFilePath <- file.path(destDir, selectedFileName)
    }

    if(!downloadResult) {
        stop("ERROR: File was not found.") 
    } 
    
    tmpFile <- gunzip(selectedFilePath, remove=FALSE, temporary=TRUE, skip=TRUE)
    
    results <- read.table(tmpFile, 
                          header=FALSE, 
                          sep="\t", 
                          fill=TRUE, 
                          col.names=c("PARTICIPANT_A",  "INTERACTION_TYPE", "PARTICIPANT_B", "IDS", "SITES"),
                          stringsAsFactors=FALSE, 
                          colClasses=rep("character", 5))

    return(results)    
}