/**
 * @description Test class for the ExchangeRateScheduler
 * This will be provided to students to test their scheduler implementation
 */
@isTest
private class ExchangeRateSchedulerTest {

    /**
     * @description Tests the execute method of the scheduler
     */
    @isTest
    static void testExecute() {
        Test.setMock(HttpCalloutMock.class, new ExchangeRateMock());

        ExchangeRateScheduler scheduler = new ExchangeRateScheduler();

        Test.startTest();
        scheduler.execute(null);
        Test.stopTest();

        List<Exchange_Rate__c> rates = [
            SELECT Id, Base_Currency__c, Target_Currency__c, Rate__c
            FROM Exchange_Rate__c
        ];
        System.assertEquals(9, rates.size(), 'Should have 9 exchange rate records');
    }

    /**
     * @description Tests error handling in the execute method
     */
    @isTest
    static void testExecute_Error() {
        Test.setMock(HttpCalloutMock.class, new ExchangeRateMock(true));

        ExchangeRateScheduler scheduler = new ExchangeRateScheduler();

        Test.startTest();
        try {
            scheduler.execute(null);
        } catch (Exception e) {
            System.assert(false, 'The execute method should handle exceptions: ' + e.getMessage());
        }
        Test.stopTest();

        List<Exchange_Rate__c> rates = [
            SELECT Id FROM Exchange_Rate__c
        ];
        System.assertEquals(0, rates.size(), 'Should have no exchange rate records due to error');
    }
}
