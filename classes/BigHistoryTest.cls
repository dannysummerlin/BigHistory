@isTest 
private class BigHistoryTest {
	static testMethod void simpleBigHistory() {
		String results = BigHistoryController.getBigHistory('00341000022UgJFAA0', null);
		System.debug(results);
	}
	static testMethod void addBigHistory() {
		List<BigHistoryController.BigHistoryEntry> tests = new List<BigHistoryController.BigHistoryEntry>();
		BigHistoryController.BigHistoryEntry test1 = new BigHistoryController.BigHistoryEntry();
			test1.RecordId = '00341000022UgJFAA0';
			test1.sObjectType = 'Contact';
			test1.FieldName = 'FirstName';
			test1.FieldType = 'Text';
			test1.OldValue = 'Lincoln';
			test1.NewValue = 'Bob';
			test1.Username = 'admin';
			test1.UserId = '00541000000gF40AAE';
		BigHistoryController.BigHistoryEntry test2 = new BigHistoryController.BigHistoryEntry();
			test1.RecordId = '00341000022UgJFAA0';
			test1.sObjectType = 'Contact';
			test1.FieldName = 'LastName';
			test1.FieldType = 'Text';
			test1.OldValue = 'Summerlin';
			test1.NewValue = 'Belcher';
			test1.Username = 'admin';
			test1.UserId = '00541000000gF40AAE';
		tests.add(test1);
		tests.add(test2);
		List<String> results = BigHistoryController.addBigHistory(tests);
		System.debug(results);
	}
}
