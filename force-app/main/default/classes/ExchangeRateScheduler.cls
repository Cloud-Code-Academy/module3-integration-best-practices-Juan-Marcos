/**
 * @description Scheduler class to run the exchange rate update on a schedule
 * Scheduling should be done in Salesforce Setup Apex Classes -> Schedule Apex
 */
global class ExchangeRateScheduler implements Schedulable {

    /**
     * @description Executes the scheduled job to update exchange rates
     * @param context The SchedulableContext
     */
    public void execute(SchedulableContext SC) {
        try {
            ExchangeRateService.updateExchangeRates();
        }
        catch (Exception e){
            System.debug(LoggingLevel.ERROR, 'ExchangeRateScheduler encountered the following error(s): '
            + e.getMessage() + ' '
            + e.getStackTraceString()
            );
        }
    }
}
