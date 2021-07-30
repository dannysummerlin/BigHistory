({
	displayEntries: function(c, e, h, entries) {
		// construct view table
		// replace entryList content with table
	},
	handleError: function(c,e,h) {
		// error message
	},
	refreshData: function(c,e,h) {
		let spinner = c.find('spinner')
		$A.util.removeClass(spinner, "slds-hide")
		let action = c.get("c.getBigHistory")
		const endDate = c.get("v.today")
		const resultCount = c.get("v.resultCount")
		action.setParams({
			deviceId : c.get("v.recordId"),
			resultCount : resultCount,
			endDate : endDate
		})
		action.setCallback(this, function(response){
			var state = response.getState()
			if (state === "SUCCESS") {
				let bigHistoryEntries = JSON.parse(response.getReturnValue())
				h.displayEntries(c,e,h,bigHistoryEntries)
			} else {
				h.handleError()
			}
			let spinner = c.find('spinner');
			$A.util.addClass(spinner, "slds-hide")
		})
		$A.enqueueAction(action)
	}
})