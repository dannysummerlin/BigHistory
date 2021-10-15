@isTest 
private class BigHistoryTest {
	static List<BigHistoryComparison.comparisonData> testFactory() {
		Contact test1 = new Contact();
			test1.FirstName = 'Lincoln';
			test1.LastName = 'Summerlin';
		Contact test2 = new Contact();
			test2.FirstName = 'Bob';
			test2.LastName = 'Belcher';
		BigHistoryComparison.comparisonData testData = new BigHistoryComparison.comparisonData(); 
		testData.oldRecord = test1;
		testData.newRecord = test2;
		testData.fieldsToExcludeList = 'Id,Birthdate';
		BigHistoryComparison.comparisonData testData2 = new BigHistoryComparison.comparisonData();
		testData2.oldRecord = test2;
		testData2.newRecord = test1;
		BigHistoryComparison.comparisonData testData3 = new BigHistoryComparison.comparisonData();
		testData3.oldRecord = test1;
		testData3.newRecord = test1;
		return new List<BigHistoryComparison.comparisonData>{testData, testData2, testData3};
	}

	@isTest
	static void getBigHistory() {
		String results = BigHistoryController.getBigHistory('00341000022UgJFAA0', null);
		System.debug(results);
	}

	@isTest
	static void testBigHistoryBatch() {
		// List<BigHistoryComparison.comparisonData> testData = testFactory();
		List<BigHistory__b> createEntries = new List<BigHistory__b>();
		BigHistory__b item = new BigHistory__b();
		item.OldValue__c = 'test';
		item.FieldLabel__c = 'testField';
		item.NewValue__c = 'newTest';
		item.FieldType__c = 'text';
		item.RecordId__c = '0031K00002h9IBcQAM';
		createEntries.add(item);
		Test.startTest();
			BigHistoryHandler handler = new BigHistoryHandler(createEntries);
			Id batchId = Database.executeBatch(handler);
		Test.stopTest();
	}

	@isTest
	static void addBigHistory() {
		List<BigHistoryComparison.comparisonData> testData = testFactory();
		Test.startTest();
			List<String> results = BigHistoryController.recordBigHistory(testData);
		Test.stopTest();
		System.debug(results);
	}
	@isTest
	static void failBigHistory() {
		Contact test1 = new Contact();
			test1.FirstName = 'Lincoln';
			test1.LastName = 'Summerlin';
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