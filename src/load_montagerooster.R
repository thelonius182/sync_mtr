prep_mtr_data <- function(spreadsheet) {
  sh_montage <- gd_rooster %>% 
    gs_read(ws = "montage") %>% 
    mutate(datum = ymd(uzd), 
           uren = as.integer(str_sub(Tijd.Duur, start = 1, end = 2)),
           mt_feature = !is.na(Presentatie) | !is.na(Techniek) | !is.na(Datum)) %>% 
    filter(Type == "Live" & datum >= today() & mt_feature) %>%
    select(datum, uren, Titel) %>%
    arrange(datum, uren)
  
  montage <<- sh_montage
}
