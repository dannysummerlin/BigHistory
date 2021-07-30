({
	doinit : function(c,e,h){
		var today = new Date();
		c.set("v.today", today.toISOString())
		h.refreshData(c,e,h)
	},
	refreshData : function(c,e,h) {
		h.refreshData(c,e,h)
	}
})