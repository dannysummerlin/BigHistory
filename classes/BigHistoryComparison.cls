global class BigHistoryComparison {
	public static List<BigHistoryComparison.comparisonResult> compare(List<BigHistoryComparison.comparisonData> inputs) {
		List<BigHistoryComparison.comparisonResult> wrapper = new List<BigHistoryComparison.comparisonResult>{};
		for(Integer count = 0; count < inputs.size(); count++) {
			BigHistoryComparison.comparisonData current = inputs[count];
			if(current.oldRecord == null) {
				BigHistoryComparison.comparisonResult output = new BigHistoryComparison.comparisonResult();
				output.hasError = true;
				output.errorMessage = 'Empty original record';
				wrapper.add(output);
			} else {
				try {
					if(current.oldRecord.getSObjectType() != current.newRecord.getSObjectType()) {
						SObjectException e = new SObjectException();
						e.setMessage('Comparison records must be the same type in order to compare');
						throw e;
					}
					DescribeSObjectResult objDef = current.oldRecord.getSObjectType().getDescribe();
					Type classType = Type.forName(objDef.getName());
					Map<String, SObjectField> fields = objDef.fields.getMap();

					String sObjectType = (String) objDef.getName();
					String recordId = (String) current.oldRecord.get('Id');

					Set<String> fieldsToInclude = new Set<String>{};
					if(current.fieldsToIncludeList != null)
						fieldsToInclude = new Set<String>(current.fieldsToIncludeList.replaceAll('\\s','').split(','));

					Set<String> fieldsToExclude = new Set<String>{};
					// fields that always change and should be ignored
						fieldsToExclude.add('createdbyid');
						fieldsToExclude.add('createddate');
						fieldsToExclude.add('lastactivitydate');
						fieldsToExclude.add('lastmodifiedbyid');
						fieldsToExclude.add('lastmodifieddate');
						fieldsToExclude.add('lastreferenceddate');
						fieldsToExclude.add('lasttransferdate');
						fieldsToExclude.add('lastvieweddate');
						fieldsToExclude.add('systemmodstamp');
					if(current.fieldsToExcludeList != null)
						fieldsToExclude = new Set<String>(current.fieldsToExcludeList.replaceAll('\\s','').split(','));

					for(String fieldName : fields.keySet()) {
						BigHistoryComparison.comparisonResult output = new BigHistoryComparison.comparisonResult();
						try {
							output.sObjectType = sObjectType;
							output.recordId = recordId;
							if ((fieldsToInclude.isEmpty() && !fieldsToExclude.contains(fieldName))
								|| fieldsToInclude.contains(fieldName)) {
									if(
										(!current.isSame && current.oldRecord.get(fieldName) != current.newRecord.get(fieldName))
										|| (current.isSame && current.oldRecord.get(fieldName) == current.newRecord.get(fieldName) && current.oldRecord.get(fieldName) != null)
									) {
										output.fieldName = fieldName;
										output.fieldLabel = objDef.fields.getMap().get(fieldName).getDescribe().getLabel();
										output.fieldType = objDef.fields.getMap().get(fieldName).getDescribe().getType().name();
										output.oldValue = String.valueOf(current.oldRecord.get(fieldName));
										output.newValue = String.valueOf(current.newRecord.get(fieldName));
										wrapper.add(output);
									}
							}
						} catch (Exception e) {
							output.hasError = true;
							output.errorMessage = e.getMessage();
							wrapper.add(output);
							System.debug('An exception occurred: ' + e.getMessage());
						}
					}
				} catch (Exception e) {
					System.debug('An exception occurred: ' + e.getMessage());
				}
			}
		}
		return wrapper;
	}
	@InvocableMethod(label='Compare Records' description='returns the fields with a difference in value between two records. Toggle the "Same" option to find matching values.')
	public static List<List<BigHistoryComparison.comparisonResult>> compareRecords(List<BigHistoryComparison.comparisonData> inputs) {
		List<List<BigHistoryComparison.comparisonResult>> outList = new List<List<BigHistoryComparison.comparisonResult>>{};
		outList.add( BigHistoryComparison.compare(inputs) );
		return outList;
	}
	public class comparisonData {
		@AuraEnabled @InvocableVariable(label='New Record' description='Second record for comparison' required=true)
		public sObject newRecord;
		@AuraEnabled @InvocableVariable(label='Original Record' description='First record for comparison')
		public sObject oldRecord;
		@AuraEnabled @InvocableVariable(label='Find Same Values?' description='by default the differences are returned, check this to find matching values instead')
		public Boolean isSame = false;
		@AuraEnabled @InvocableVariable(label='Fields to Include' description='(optional, takes precedence over Exclusion) comma-separated list of fields to include')
		public String fieldsToIncludeList;
		@AuraEnabled @InvocableVariable(label='Fields to Exclude' description='(optional) comma-separated list of fields to skip')
		public String fieldsToExcludeList;
	}
	public class comparisonResult {
		@AuraEnabled @InvocableVariable(label='Record ID' description='' required=true) public String recordId = '';
		@AuraEnabled @InvocableVariable(label='sObject Type' description='' required=true) public String sObjectType = '';
		@AuraEnabled @InvocableVariable(label='Field Name' description='Field Name' required=true) public String fieldName = '';
		@AuraEnabled @InvocableVariable(label='Field Label' description='Field Label' required=true) public String fieldLabel = '';
		@AuraEnabled @InvocableVariable(label='Field Type' description='Field Type' required=true) public String fieldType = '';
		@AuraEnabled @InvocableVariable(label='Original Value' description='' required=false) public String oldValue = '';
		@AuraEnabled @InvocableVariable(label='New Value' description='' required=false) public String newValue = '';
		@AuraEnabled @InvocableVariable(label='Has Error' description='' required=false) public Boolean hasError = false;
		@AuraEnabled @InvocableVariable(label='Error Message' description='' required=false) public String errorMessage = '';
	}
}