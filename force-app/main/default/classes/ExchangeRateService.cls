/**
 * @description Service class that handles API callouts to the Exchange Rate API
 * Students will implement the methods to make callouts and process responses
 */
public class ExchangeRateService {

    // The named credential to use for the callout
    private static final String NAMED_CREDENTIAL = 'ExchangeRate_API';

    // The base currency to use for exchange rates
    private static final String BASE_CURRENCY = 'USD';

    /**
     * @description Makes an HTTP callout using the named credential
     * @param endpoint The endpoint path after the API key
     * @param method The HTTP method (GET, POST, etc.)
     * @return String The response body from the API
     * @throws CalloutException if the callout fails
     */
    private static String makeCallout(String endpoint, String method) {
        try {
            HttpRequest request = new HttpRequest();
            request.setEndpoint('callout:' + NAMED_CREDENTIAL + endpoint);
            request.setMethod(method);

            Http http = new Http();
            HttpResponse response = http.send(request);

            if (response.getStatusCode() >= 200 && response.getStatusCode() < 300) {
                return response.getBody();
            } else {
                String errorMessage = 'API Error: HTTP ' + response.getStatusCode() + ' - ' + response.getBody();
                throw new CalloutException(errorMessage);
            }

        } catch (CalloutException e) {
            System.debug(LoggingLevel.ERROR, 'Callout failed: ' + e.getMessage());
            throw e;
        } catch (Exception e) {
            System.debug(LoggingLevel.ERROR, 'Unexpected error: ' + e.getMessage());
            throw new CalloutException('Failed to make callout: ' + e.getMessage());
        }
    }

    /**
     * @description Makes a callout to the Exchange Rate API to get the latest exchange rates
     * @return ExchangeRateWrapper containing the response data
     */
    public static ExchangeRateWrapper getLatestRates() {
        String responseBody = makeCallout('/latest/' + BASE_CURRENCY, 'GET');
        return ExchangeRateWrapper.parse(responseBody);
    }

    /**
     * @description Processes the exchange rate data and creates or updates records
     * @param rateData The wrapper containing exchange rate data
     * @return List<Exchange_Rate__c> The list of records created or updated
     */
    public static List<Exchange_Rate__c> processRates(ExchangeRateWrapper rateData) {
        List<Exchange_Rate__c> exchangeRates = rateData.toExchangeRates();
        upsert exchangeRates External_Id__c;
        return exchangeRates;
    }

    /**
     * @description Combines getting and processing rates into a single operation
     * @return List<Exchange_Rate__c> The list of records created or updated
     */
    public static List<Exchange_Rate__c> updateExchangeRates() {
        ExchangeRateWrapper latestRates = getLatestRates();
        List<Exchange_Rate__c> processedRates = processRates(latestRates);
        return processedRates;
    }
}
