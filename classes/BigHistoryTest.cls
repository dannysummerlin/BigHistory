@isTest 
private class BigHistoryTest {
	@isTest
	static void getBigHistory() {
		String results = BigHistoryController.getBigHistory('00341000022UgJFAA0', null);
		System.debug(results);
	}

	@isTest
	static void testBigHistoryQueue() {
		List<BigHistory__b> createEntries = new List<BigHistory__b>();
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
		testData.fieldsToExcludeList = 'Id,Birthdate';
		Test.startTest();
			List<String> results = BigHistoryController.recordBigHistory(new List<BigHistoryComparison.comparisonData>{testData});
		Test.stopTest();
		System.debug(results);
	}
	@isTest
	static void failBigHistory() {
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
		testData.fieldsToExcludeList = 'TEST';
		Test.startTest();
			List<String> results = BigHistoryController.recordBigHistory(new List<BigHistoryComparison.comparisonData>{testData});
		Test.stopTest();
		System.debug(results);
	}
}