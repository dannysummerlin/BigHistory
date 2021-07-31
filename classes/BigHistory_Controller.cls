public with sharing class BigHistoryController {
	@AuraEnabled
	public static String getBigHistory(String recordId, Integer resultCount, DateTime endDate) {
		if(resultCount == null) {
			resultCount = 200;
		}
		system.debug('RESULTS: ' + resultCount);
		/* might make it dynamic from web....maybe */
		List<BigHistory__b> historyEntries = [
				SELECT RecordId__c, sObjectType__c, FieldName__c, FieldType__c, OldValue__c, NewValue__c, Username__c, UserId__c, CreatedDate__c
				FROM BigHistory__b
				WHERE recordId__c = :recordId AND CreatedDate__c <: endDate
				LIMIT :Integer.valueof(resultCount)
		];
		return JSON.serialize(historyEntries);
	}
}