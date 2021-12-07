####This is a currency-conversion application built on Angular + Springboot.
There are 3 services
1) currency-conversion-ui. This is built on Angular
2) exchange-rate-service. This is a service built on Springboot. This uses an embedded h2 database or MySQL(depends on profile passed as environment variable) and store 
exchange rates for some predefined currencies. There is a cron job which updates exchange rates(based on cron expression passed in)
3) currency-conversion-service. This is again a Springboot service which will calculate the conversion rate and it uses 
exchange-rate-service to get the exchange rate.

