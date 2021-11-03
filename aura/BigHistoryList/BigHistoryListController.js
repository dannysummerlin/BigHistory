({
	init : function(c,e,h){
		c.set('v.columns', [
			{label: 'Field', fieldName: 'FieldLabel__c', type: 'text'},
			{label: 'Original Value', fieldName: 'OldValue__c', type: 'text'},
			{label: 'New Value', fieldName: 'NewValue__c', type: 'text'},
			{label: 'Editor', fieldName: 'Username__c', type: 'email'},
			{label: 'Date', fieldName: 'CreatedDate', type: 'date',
				typeAttributes:{ year: "numeric",month: "2-digit",day: "2-digit",hour: "2-digit",minute: "2-digit"}
			}
		])
		h.fetchData(c,e,h)
	}
})