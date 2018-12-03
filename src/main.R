# = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
# Signaleer tegenspraak tussen presentatie- en montagerooster
# Versie: 2018-12-02, CZ/LvdA
# = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Init
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
library(googlesheets)
library(mailR)

config <- read_yaml("config.yaml")

source(config$toolbox, encoding = "UTF-8")

proj_prop <- function(prop) {
  prop_name <- paste0(prop, ".", config$project_status)
  prop <- config[[prop_name]]
}


filter <-
  dplyr::filter # voorkom verwarring met stats::filter

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
# Rooster 3.0 op GD openen
# zonodig: change to new user; onderstaand R-cmd onsterren en uitvoeren; opent een browser dialogue
# gs_auth(new_user = TRUE)
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
ssh <- proj_prop("spreadsheet")

gd_rooster <- gs_title(ssh)

source("src/load_montagerooster.R", encoding = "UTF-8")
prep_mtr_data(gd_rooster)

if (nrow(montage > 0)) {
  sender <- config$from
  recipients <- config$to
  send.mail(from = sender,
            to = recipients,
            subject = "Tegenspraak in de roosters",
            body = paste("Zie ", montage$datum, ", ", montage$uren, ":00, ", montage$Titel, sep = "", collapse = "\n"),
            smtp = list(host.name = "smtp.gmail.com", port = 465, 
                        user.name = config$usr,
                        passwd = config$pwd, ssl = TRUE),
            authenticate = TRUE,
            send = TRUE)
}