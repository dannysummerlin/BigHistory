global class BigHistoryHandler implements Database.Batchable<sObject> {
	private List<BigHistory__b> entries;
	public BigHistoryHandler(List<BigHistory__b> entries) {
		this.entries = entries;
	}
    global Iterable<sObject> start(Database.BatchableContext context) {
       return new BigObjectIteration.BigObjectIterable(this.entries);
    }
	public void execute(Database.BatchableContext context, List<BigHistory__b> entries) {
		try {
            if(!Test.isRunningTest()) {
                List<Database.SaveResult> srList = Database.insertImmediate(this.entries);
            } else {
                List<Database.SaveResult> srList = Database.insertAsync(this.entries);
            }
		} catch (Exception e) {
			System.debug('Exception: ' + e.getTypeName() + ', ' + e.getMessage());
		}
	}
    public void finish(Database.BatchableContext context){} 
}