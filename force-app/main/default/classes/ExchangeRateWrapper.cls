/**
 * @description Wrapper class to deserialize the JSON response from the Exchange Rate API
 * Students will implement the properties and methods to process the data
 */
public class ExchangeRateWrapper {



    // TODO: Implement properties to match the JSON structure of the API response
    // Sample response:
    // {
    //   "base_code": "USD",
    //   "time_last_update_unix": 1740690001,
    //   "conversion_rates": {
    //     "EUR": 0.9488,
    //     "GBP": 0.8393,
    //     "JPY": 136.57,
    //     ...
    //   }
    // }

    public String base_code;

    public String time_last_update_unix;    // seems like Integer would be a better type match

    public Map<String, Decimal> conversion_rates;

    public String externalId; // baseCurrency + '_' + targetCurrency


    /**
     * @description Converts the wrapper data to a list of Exchange_Rate__c records
     * @return List<Exchange_Rate__c> The list of exchange rate records
     */
    public List<Exchange_Rate__c> toExchangeRates() {
        List<Exchange_Rate__c> exchangeRates = new List<Exchange_Rate__c>();

        for(String targetCurrency : conversion_rates.keySet()){
            Exchange_Rate__c exchangeRate = new Exchange_Rate__c();
            exchangeRate.Base_Currency__c = base_code;
            exchangeRate.Target_Currency__c = targetCurrency;
            exchangeRate.Rate__c = conversion_rates.get(targetCurrency);
            exchangeRate.Last_Updated__c = System.now();
            exchangeRate.External_Id__c = exchangeRate.Base_Currency__c + '_' + exchangeRate.Target_Currency__c;
            exchangeRates.add(exchangeRate);
        }

        return exchangeRates;
    }

    /**
     * @description Static method to parse the JSON response into the wrapper class
     * @param jsonResponse The JSON response from the API
     * @return ExchangeRateWrapper The parsed wrapper instance
     */
    public static ExchangeRateWrapper parse(String jsonResponse) {
        ExchangeRateWrapper wrapper = (ExchangeRateWrapper) JSON.deserialize(jsonResponse, ExchangeRateWrapper.class);
        return wrapper;
    }
}
