@isTest 
private class BigHistoryTest {
	@isTest
	static void simpleBigHistory() {
		String results = BigHistoryController.getBigHistory('00341000022UgJFAA0', null);
		System.debug(results);
	}
	// static testMethod void checkCompareRecords() {
	// 	Contact test1 = new Contact();
	// 		test1.FirstName = 'Lincoln';
	// 		test1.LastName = 'Summerlin';
	// 	Insert test1;
	// 	Contact test2 = new Contact();
	// 		test2.FirstName = 'Bob';
	// 		test2.LastName = 'Belcher';
	// 	BigHistoryComparison.comparisonData test = new BigHistoryComparison.comparisonData(); 
	// 	test.oldRecord = test1;
	// 	test.newRecord = test2;
	// 	List<List<BigHistoryComparison.comparisonResult>> results = new List<List<BigHistoryComparison.comparisonResult>>();
	// 	results = BigHistoryComparison.compareRecords(new List<BigHistoryComparison.comparisonData>{test});
	// 	System.debug(results);
	// }
	@isTest
	static void testBigHistoryQueue() {
		List<BigHistory__b> createEntries = new List<BigHistory__b>();
		BigHistory__b entry = new BigHistory__b();
		entry.RecordId__c = '00341000022UgJFAA0';
		entry.sObjectType__c = 'Contact';
		entry.FieldName__c = 'FirstName';
		entry.FieldLabel__c = 'First Name';
		entry.FieldType__c = 'STRING';
		entry.OldValue__c = 'Lincoln';
		entry.NewValue__c = 'Danny';
		entry.Username__c = 'SystemAdministrator@Summerlin.co';
		entry.ModifiedDate__c = System.now();
		createEntries.add(entry);

		Test.startTest();
		BigHistoryHandler handler = new BigHistoryHandler(createEntries);
		System.enqueueJob(handler);
		Test.stopTest();
	}
	@isTest
	static void addBigHistory() {
		Contact test1 = new Contact();
			test1.FirstName = 'Lincoln';
			test1.LastName = 'Summerlin';
		// Insert test1;
		Contact test2 = new Contact();
			test2.FirstName = 'Bob';
			test2.LastName = 'Belcher';
		BigHistoryComparison.comparisonData testData = new BigHistoryComparison.comparisonData(); 
		testData.oldRecord = test1;
		testData.newRecord = test2;
		Test.startTest();
			List<String> results = BigHistoryController.recordBigHistory(new List<BigHistoryComparison.comparisonData>{testData});
		Test.stopTest();
		System.debug(results);
	}
}