@isTest 
private class BigHistoryTest {
	static testMethod void simpleBigHistory() {
		String results = BigHistoryController.getBigHistory('00341000022UgJFAA0', null);
		System.debug(results);
	}
	static testMethod void checkCompareRecords() {
		Contact test1 = new Contact();
			test1.FirstName = 'Lincoln';
			test1.LastName = 'Summerlin';
		Insert test1;
		Contact test2 = new Contact();
			test2.FirstName = 'Bob';
			test2.LastName = 'Belcher';
		BigHistoryComparison.comparisonData test = new BigHistoryComparison.comparisonData(); 
		test.oldRecord = test1;
		test.newRecord = test2;
		List<List<BigHistoryComparison.comparisonResult>> results = new List<List<BigHistoryComparison.comparisonResult>>();
		results = BigHistoryComparison.compareRecords(new List<BigHistoryComparison.comparisonData>{test});
		System.debug(results);
	}
	static testMethod void addBigHistory() {
		Contact test1 = new Contact();
			test1.FirstName = 'Lincoln';
			test1.LastName = 'Summerlin';
		Insert test1;
		Contact test2 = new Contact();
			test2.FirstName = 'Bob';
			test2.LastName = 'Belcher';
		BigHistoryComparison.comparisonData test = new BigHistoryComparison.comparisonData(); 
		test.oldRecord = test1;
		test.newRecord = test2;
		List<String> results = BigHistoryController.recordBigHistory(new List<BigHistoryComparison.comparisonData>{test});
		System.debug(results);
	}
}
