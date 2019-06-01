# Extraindo e convertendo arquivos dbc

# Importando os modulos
library(RCurl) # extrair os nomes dos arquivos no ftp
library(read.dbc) # ler arquivos no formato dbc

# url com os arquivos da pasta Finais

result <- 'ftp://ftp.datasus.gov.br/dissemin/publicos/SINAN/DADOS/FINAIS/'
result2 <- 'ftp://ftp.datasus.gov.br/dissemin/publicos/SINAN/DADOS/PRELIM/'

# Criando uma função para ler e converter todos os arquivos
down_dbc <- function(url){
  
  # lendo os nomes dos arquivos dbc
  filenames = getURL(url, ftp.use.epsv = FALSE, dirlistonly = TRUE)
  
  # separando os nomes dos arquivos por delimitador
  files <- unlist(strsplit(filenames, "\r\n", fixed = FALSE))
  
  # fazendo download dos arquivos que contenha "DENG"
  
  lapply(files, function(x){
    if (!(is.na(grep("DENG", x)[1]))){
      temp <- paste0(url, x)
      download.file(temp, destfile = x, method="curl")
    }
  }
  )
  
  # Lista com os arquios no diretorio
  dbc_files <- list.files(pattern = 'dbc')
  
  # convertendo dbc para csv
  lapply(dbc_files, function(x){
    temp <- read.dbc(x)
    nome <- gsub('dbc', 'csv', x)
    write.csv(temp, nome, row.names = FALSE)
  })
}


# Definindo o diretorio finais
setwd('C:/Users/CALIXTO/Documents/GitHub/DengueAnalytics/DADOS/FINAIS')

# Baixando e convertendo todos os arquivos
down_dbc(result)

## //##

# Definindo o diretorio preliminar
setwd('C:/Users/CALIXTO/Documents/GitHub/DengueAnalytics/DADOS/PRELIMINAR')

# Baixando e convertendo todos os arquivos
down_dbc(result2)