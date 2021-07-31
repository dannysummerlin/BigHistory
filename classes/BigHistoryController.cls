public with sharing class BigHistoryController {
	public class BigHistoryEntry {
		@InvocableVariable(label='Record ID' description='' required=true)
		public String RecordId;
		@InvocableVariable(label='sObject Type' description='')
		public String sObjectType; // optional
		@InvocableVariable(label='Field Name' description='' required=true)
		public String FieldName;
		@InvocableVariable(label='Field Type' description='' required=true)
		public String FieldType;
		@InvocableVariable(label='Original Value' description='')
		public String OldValue; // can be null
		@InvocableVariable(label='New Value' description='')
		public String NewValue; // can be null
		@InvocableVariable(label='Salesforce Username' description='' required=true)
		public String Username;
		@InvocableVariable(label='Salesforce User ID' description='' required=true)
		public String UserId;
	}
	public class BigHistoryEntryResult {
		public String recordId {get;set;}
		public Integer resultCount {get;set;}
		// public DateTime CreatedDate {get;set;}
		// and anything else we might want to filter by, and have the initial filter included in the output
		public List<BigHistory__b> entries {get;set;}

		public BigHistoryEntryResult(String recordId) {
			this.recordId = recordId;
			this.resultCount = 0;
			// this.CreatedDate = new DateTime();
			this.entries = new List<BigHistory__b>();
		}
	}
	@InvocableMethod(label='Create BigHistory Entry' description='Adds an entry for the changes to a record')
	public static List<String> recordBigHistory(List<CompareRecords.comparisonData> inputs) {
		List<BigHistoryEntry> newEntries = new List<BigHistoryEntry>();
		List<CompareRecords.comparisonResult> comparisonResults = CompareRecords.compare(inputs);
		for (Integer ii = 0; ii < comparisonResults.size(); ii++) {
			BigHistoryEntry entry = new BigHistoryEntry();
			entry.RecordId = comparisonResults[ii].recordId;
			entry.sObjectType = comparisonResults[ii].sObjectType;
			entry.FieldName = comparisonResults[ii].fieldName;
			entry.FieldType = comparisonResults[ii].fieldType;
			entry.OldValue = comparisonResults[ii].oldValue;
			entry.NewValue = comparisonResults[ii].newValue;
			entry.Username = UserInfo.getUserName();
			entry.UserId = UserInfo.getUserId();
			newEntries.add(entry);
		}
		List<String> results = BigHistoryController.addBigHistory(newEntries);
		return results;
	}
	// @InvocableMethod(label='Create BigHistory Entry' description='Adds an entry for the changes to a record')
	public static List<String> addBigHistory(List<BigHistoryEntry> entries) {
		List<BigHistory__b> createEntries = new List<BigHistory__b>();
		List<String> results = new List<String>();
		for (Integer ii = 0; ii < entries.size(); ii++) {
			BigHistory__b entry = new BigHistory__b();
			try {
				entry.RecordId__c = entries[ii].RecordId;
				entry.sObjectType__c = entries[ii].sObjectType;
				entry.FieldName__c = entries[ii].FieldName;
				entry.FieldType__c = entries[ii].FieldType;
				entry.OldValue__c = entries[ii].OldValue;
				entry.NewValue__c = entries[ii].NewValue;
				entry.Username__c = entries[ii].Username;
				entry.UserId__c = entries[ii].UserId;
				entry.CreatedDate__c = System.now();
				createEntries.add(entry);
				results.add('Success for ' + entries[ii].RecordId);
			} catch (Exception e) {
				results.add('Error: ' + e.getMessage());
				System.debug(e);
			}
		}
		try {
			Insert createEntries;
			return results;
		} catch (DmlException e) {
			results[0] = e.getMessage();
			System.debug(e);
			return results;
		}
	}

	@AuraEnabled
	public static String getBigHistory(String recordId, Integer resultCount) {
		// , DateTime endDate and more for filtering later maybe
		if(resultCount == null) {
			resultCount = 200;
		}
		system.debug('RESULTS: ' + resultCount);
		/* might make SOQL dynamic from web....maybe...more likely just add filtering options */
		List<BigHistory__b> historyEntries = [
				SELECT RecordId__c, sObjectType__c, FieldName__c, FieldType__c, OldValue__c, NewValue__c, Username__c, UserId__c, CreatedDate__c
				FROM BigHistory__b
				WHERE recordId__c = :recordId
				LIMIT :Integer.valueof(resultCount)
		];
		// AND CreatedDate__c <: endDate for later with filtering

		BigHistoryEntryResult hr = new BigHistoryEntryResult(recordId);
		hr.resultCount = resultCount;
		hr.entries = historyEntries;
		return JSON.serialize(hr);
	}
}