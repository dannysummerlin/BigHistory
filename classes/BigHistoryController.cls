public class BigHistoryController {
	@InvocableMethod(label='Create BigHistory Entry' description='Adds an entry for the changes to a record')
	public static List<String> recordBigHistory(List<BigHistoryComparison.comparisonData> inputs) {
		Set<String> results = new Set<String>();
		List<BigHistoryComparison.comparisonResult> comparisonResults = BigHistoryComparison.compare(inputs);
		List<BigHistory__b> createEntries = new List<BigHistory__b>();
		if(comparisonResults.size() > 0) {
			for (Integer ii = 0; ii < comparisonResults.size(); ii++) {
				BigHistory__b entry = new BigHistory__b();
				try {
					entry.RecordId__c = comparisonResults[ii].recordId;
					entry.sObjectType__c = comparisonResults[ii].sObjectType;
					entry.FieldName__c = comparisonResults[ii].fieldName;
					entry.FieldLabel__c = comparisonResults[ii].fieldLabel;
					entry.FieldType__c = comparisonResults[ii].fieldType;
					entry.OldValue__c = (String) comparisonResults[ii].oldValue;
					entry.NewValue__c = (String) comparisonResults[ii].newValue;
					entry.Username__c = UserInfo.getUserName();
					entry.ModifiedDate__c = System.now();
					createEntries.add(entry);
					results.add('Success for ' + comparisonResults[ii].RecordId);
				} catch (Exception e) {
					results.add('Error: ' + e.getMessage());
					System.debug(e);
				}
			}
			List<String> output = new List<String>(results);
			if(output.size() < inputs.size()) {
				Integer toMatch = inputs.size() - results.size();
				for(;toMatch > 0; toMatch--) {
					results.add(String.valueOf(Math.random() * 100));
				}
			}
			try {
				if(!Test.isRunningTest()) {
					BigHistoryHandler handler = new BigHistoryHandler(createEntries);
					//System.enqueueJob(handler);
					Database.executeBatch(handler);
				}
				return output;
			} catch (Exception e) {
				output[inputs.size() - 1] = e.getMessage();
				System.debug(e);
				System.debug(output);
				return output;
			}
		} else {
			return (new String[inputs.size()]);
		}
	}

	@AuraEnabled
	public static String getBigHistory(String recordId, Integer resultCount) {
		// , DateTime endDate and more for filtering later maybe
		if(resultCount == null) {
			resultCount = 200;
		}
		// system.debug('RESULTS: ' + resultCount);
		List<BigHistory__b> historyEntries = [
				SELECT RecordId__c, sObjectType__c, FieldName__c, FieldLabel__c, FieldType__c, OldValue__c, NewValue__c, Username__c, CreatedDate
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
	public class BigHistoryEntryResult {
		public String recordId {get;set;}
		public Integer resultCount {get;set;}
		// public DateTime CreatedDate {get;set;}
		// and anything else we might want to filter by, and have the initial filter included in the output
		public List<BigHistory__b> entries {get;set;}

		public BigHistoryEntryResult(String recordId) {
			this.recordId = recordId;
			this.resultCount = 0;
			this.entries = new List<BigHistory__b>();
		}
	}
}