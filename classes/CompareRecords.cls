global class CompareRecords {
	public static List<comparisonResult> compare(comparisonData[] inputs) {
		List<comparisonResult> wrapper = new List<comparisonResult>{};
		for(Integer count = 0; count < inputs.size(); count++) {
			comparisonData current = inputs[count];
			comparisonResult output = new comparisonResult();
			try {
				if(current.oldRecord.getSObjectType() != current.newRecord.getSObjectType()) {
					SObjectException e = new SObjectException();
					e.setMessage('Comparison records must be the same type in order to compare');
					throw e;
				}
				DescribeSObjectResult objDef = current.oldRecord.getSObjectType().getDescribe();
				Type classType = Type.forName(objDef.getName());
				Map<String, SObjectField> fields = objDef.fields.getMap();

				output.sObjectType = (String) objDef.getName();
				output.recordId = (String) current.oldRecord.get('Id');

				Set<String> fieldsToExclude = new Set<String>{};
				if(current.fieldsToExcludeList != null)
					fieldsToExclude = new Set<String>(current.fieldsToExcludeList.replaceAll('\\s','').split(','));
				for(String fieldName : fields.keySet()) {
					if (!fieldsToExclude.contains(fieldName)) {
						if(
							(!current.isSame && current.oldRecord.get(fieldName) != current.newRecord.get(fieldName))
							|| (current.isSame && current.oldRecord.get(fieldName) == current.newRecord.get(fieldName) && current.oldRecord.get(fieldName) != null)
						) {
							output.fieldName = fieldName;
							output.fieldType = objDef.fields.getMap().get(fieldName).getDescribe().getType().name();
							output.oldValue = ((String) current.oldRecord.get(fieldName));
							output.newValue = ((String) current.newRecord.get(fieldName));
							wrapper.add(output);
						}
					}
				}
			} catch (Exception e) {
				output.hasError = true;
				output.errorMessage = e.getMessage();
				wrapper.add(output);
				System.debug('An exception occurred: ' + e.getMessage());
			}
		}
		return wrapper;
	}
	@InvocableMethod(label='Compare Records' description='returns the fields with a difference in value between two records. Toggle the "Same" option to find matching values.')
	public static List<List<comparisonResult>> compareRecords(List<comparisonData> inputs) {
		List<List<comparisonResult>> outList = new List<List<comparisonResult>>{};
		outList.add( CompareRecords.compare(inputs) );
		return outList;
	}
	global class comparisonData {
		@AuraEnabled @InvocableVariable(label='Original Record' description='First record for comparison' required=true) public sObject oldRecord;
		@AuraEnabled @InvocableVariable(label='New Record' description='Second record for comparison' required=true) public sObject newRecord;
		@AuraEnabled @InvocableVariable(label='Find Same Values?' description='by default the differences are returned, check this to find matching values instead' required=false) public Boolean isSame = false;
		@AuraEnabled @InvocableVariable(label='Fields to Exclude' description='(optional) comma-separated list of fields to skip' required=false) public String fieldsToExcludeList;
	}
	public class comparisonResult {
		@AuraEnabled @InvocableVariable(label='Record ID' description='' required=true) public String recordId = '';
		@AuraEnabled @InvocableVariable(label='sObject Type' description='' required=true) public String sObjectType = '';
		@AuraEnabled @InvocableVariable(label='Field Name' description='list of fields from comparison' required=true) public String fieldName = '';
		@AuraEnabled @InvocableVariable(label='Field Type' description='list of field types from comparison' required=true) public String fieldType = '';
		@AuraEnabled @InvocableVariable(label='Original Value' description='' required=false) public String oldValue = '';
		@AuraEnabled @InvocableVariable(label='New Value' description='' required=false) public String newValue = '';
		@AuraEnabled @InvocableVariable(label='Has Error' description='' required=false) public Boolean hasError = false;
		@AuraEnabled @InvocableVariable(label='Error Message' description='' required=false) public String errorMessage = '';
	}
}