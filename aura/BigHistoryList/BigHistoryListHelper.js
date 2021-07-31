({
	displayEntries: function(c, e, h, entries) {
		let allRows = []
		for (var i = entries.length - 1; i >= 0; i--) {
			const entry = entries[i]
			allRows.push(`<tr>
				<td role="gridcell" class="slds-cell-edit slds-cell-error errorColumn cellContainer" tabindex="-1">
					<span class="slds-grid slds-grid--align-spread">
						<div class="slds-cell-edit errorColumn slds-cell-error">
							<div class="slds-m-horizontal--xx-small forceStatusIcon"></div>
							<span class="slds-row-number slds-text-body--small slds-text-color--weak"></span>
						</div>
					</span>
				</td>
				<th scope="row" class="slds-cell-edit cellContainer" tabindex="-1">
					<span class="slds-grid slds-grid--align-spread">
						<span class="slds-truncate uiOutputDateTime">${entry.CreatedDate__c}</span>
					</span>
				</th>
				<td role="gridcell" class="slds-cell-edit cellContainer" tabindex="-1">
					<span class="slds-grid slds-grid--align-spread">
						<span class="slds-truncate">${entry.FieldName__c}</span>
					</span>
				</td>
				<td role="gridcell" class="slds-cell-edit cellContainer" tabindex="-1">
					<span class="slds-grid slds-grid--align-spread">
						<a class="slds-truncate outputLookupLink slds-truncate forceOutputLookup" data-refid="recordId" data-recordid="${entry.userId__c}" data-special-link="true" data-navigable="true" href="/lightning/r/${entry.userId__c}/view" target="_blank" rel="noreferrer">
							${entry.username__c}
						</a>
					</span>
				</td>
				<td role="gridcell" class="slds-cell-edit cellContainer" tabindex="-1">
					<span class="slds-grid slds-grid--align-spread">
						<span class="slds-truncate">
							<span  class="uiOutputText">${entry.oldValue__c}</span>
						</span>
					</span>
				</td>
				<td role="gridcell" class="slds-cell-edit cellContainer" tabindex="-1">
					<span class="slds-grid slds-grid--align-spread">
						<span class="slds-truncate">
							<span  class="uiOutputText">${entry.newValue__c}</span>
						</span>
					</span>
				</td>
			</tr>`)
		}
		c.set('v.listContent', allRows.join("\n"))
	},
	handleError: function(c,e,h,response) {
		// error message
		console.log(response)
	},
	refreshData: function(c,e,h) {
		let spinner = c.find('spinner')
		$A.util.removeClass(spinner, "slds-hide")
		let action = c.get("c.getBigHistory")
		// TODO more filtering options later
		// const startDate = c.get("v.startDate")
		// const endDate = c.get("v.endDate")
		const resultCount = c.get("v.resultCount")
		action.setParams({
			recordId : c.get("v.recordId"),
			resultCount : resultCount
		})
		action.setCallback(this, function(response){
			const state = response.getState()
			const exclusionList = c.get('v.exclusionCSV').split(',').reduce((l,e) => l.push(e.trim()), [])
			if (state === "SUCCESS") {
				let bigHistoryEntries = JSON.parse(response.getReturnValue())
				try {
					bigHistoryEntries = bigHistoryEntries.filter(e=>(!exclusionList.includes(e)))
				} catch (err) {
					bigHistoryEntries = []
					console.log(err)
				}
				h.displayEntries(c,e,h,bigHistoryEntries)
			} else {
				h.handleError(c,e,h,response)
			}
			let spinner = c.find('spinner');
			$A.util.addClass(spinner, "slds-hide")
		})
		$A.enqueueAction(action)
	}
})