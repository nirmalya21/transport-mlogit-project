install.packages("rsconnect")
library(rsconnect)

rsconnect::setAccountInfo(name='wupqf2-nirmalya-rajpandit',
			  token='3745A1CA32B44606EFC92C3422D4B9E6',
			  secret='AMQVBPkYBf8vScZGm1OFODrpmFTCf43LI5mH6GW1')

library(rsconnect)
    rsconnect::deployApp('transport_model.R')
