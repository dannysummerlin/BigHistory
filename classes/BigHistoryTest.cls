@isTest 
private class BigHistoryTest {
	static testMethod void simpleBigHistory() {
		String results = BigHistoryController.getBigHistory('00341000022UgJFAA0', null);
		System.debug(results);
	}
}