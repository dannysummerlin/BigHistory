@isTest 
private class BigHistoryTest {
	static testMethod void simpleBigHistory() {
		String results = BigHistoryController.getBigHistory('00341000022UgJFAA0', null);
		System.debug(results);
	}
	static testMethod void addBigHistory() {
/* 
		List<BigHistoryController.BigHistoryEntry> tests = new List<BigHistoryController.BigHistoryEntry>();
		BigHistory__b test1 = new BigHistory__b();
			test1.RecordId__c = '00341000022UgJFAA0';
			test1.sObjectType__c = 'Contact';
			test1.FieldName__c = 'FirstName';
			test1.FieldType__c = 'Text';
			test1.OldValue__c = 'Lincoln';
			test1.NewValue__c = 'Bob';
			test1.Username__c = 'admin';
			test1.UserId__c = '00541000000gF40AAE';
		BigHistory__b test2 = new BigHistory__b();
			test2.RecordId__c = '00341000022UgJFAA0';
			test2.sObjectType__c = 'Contact';
			test2.FieldName__c = 'LastName';
			test2.FieldType__c = 'Text';
			test2.OldValue__c = 'Summerlin';
			test2.NewValue__c = 'Belcher';
			test2.Username__c = 'admin';
			test2.UserId__c = '00541000000gF40AAE';
*/
		Contact test1 = new Contact();
			test1.FirstName = 'Lincoln';
			test1.LastName = 'Summerlin';
		Insert test1;
		Contact test2 = new Contact();
			test2.FirstName = 'Bob';
			test2.LastName = 'Belcher';
		CompareRecords.comparisonData test = new CompareRecords.comparisonData(); 
		test.oldRecord = test1;
		test.newRecord = test2;
		List<String> results = BigHistoryController.recordBigHistory(new List<CompareRecords.comparisonData>{test});
		System.debug(results);
	}
}
