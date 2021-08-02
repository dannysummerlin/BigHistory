({
	handleError: function(c,e,h,response) {
		// error message
		console.log(response)
	},
	fetchData: function(c,e,h) {
		let spinner = c.find('bigHistorySpinner')
		$A.util.removeClass(spinner, "slds-hide")
		let action = c.get("c.getBigHistory")
		const resultCount = c.get("v.resultCount")
		action.setParams({
			recordId : c.get("v.recordId"),
			resultCount : resultCount
		})
		action.setCallback(this, function(response){
			const state = response.getState()
			let exclusionList = c.get('v.exclusionCSV').split(',') || []
			exclusionList = exclusionList.reduce((l,e) => l.concat(e.trim()), [])
			if (state === "SUCCESS") {
				let bigHistoryEntries = JSON.parse(response.getReturnValue()).entries
				try {
					bigHistoryEntries = bigHistoryEntries.filter(e=>(!exclusionList.includes(e.FieldName__c)))
				} catch (err) {
					bigHistoryEntries = []
					console.log(err)
				}
				c.set('v.entries', bigHistoryEntries)
			} else {
				h.handleError(c,e,h,response)
			}
			let spinner = c.find('bigHistorySpinner')
			$A.util.addClass(spinner, "slds-hide")
		})
		$A.enqueueAction(action)
	}
})