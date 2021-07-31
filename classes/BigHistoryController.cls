public with sharing class BigHistoryController {
	public class HistoryEntryResult {
		public String recordId {get;set;}
		public Integer resultCount {get;set;}
		// public DateTime CreatedDate {get;set;}
		// and anything else we might want to filter by, and have the initial filter included in the output
		public List<BigHistory__b> entries {get;set;}

		public HistoryEntryResult(String recordId) {
			this.recordId = recordId;
			this.resultCount = 0;
			// this.CreatedDate = new DateTime();
			this.entries = new List<BigHistory__b>();
		}
	}
	@AuraEnabled
	public static String getBigHistory(String recordId, Integer resultCount) {
		// , DateTime endDate and more for filtering later maybe
		if(resultCount == null) {
			resultCount = 200;
		}
		system.debug('RESULTS: ' + resultCount);
		/* might make it dynamic from web....maybe */
		List<BigHistory__b> historyEntries = [
				SELECT RecordId__c, sObjectType__c, FieldName__c, FieldType__c, OldValue__c, NewValue__c, Username__c, UserId__c, CreatedDate__c
				FROM BigHistory__b
				WHERE recordId__c = :recordId
				LIMIT :Integer.valueof(resultCount)
		];
		// AND CreatedDate__c <: endDate for later with filtering

		HistoryEntryResult hr = new HistoryEntryResult(recordId);
		hr.resultCount = resultCount;
		hr.entries = historyEntries;
		return JSON.serialize(hr);
	}
}