public class BigHistoryHandler implements Queueable {
	private List<BigHistory__b> entries;
	public BigHistoryHandler(List<BigHistory__b> entries) {
		this.entries = entries;
	}
	public void execute(QueueableContext context) {		
		try {
			List<Database.SaveResult> srList = Database.insertImmediate(entries);
			// for(Database.SaveResult sr: srList) {
			// 	if(!sr.isSuccess()) {
			// 		for(Database.Error err : sr.getErrors()) {
			// 			System.debug(err.getStatusCode() + ': ' + err.getMessage() + '; ' +
			// 				'Error fields: ' + err.getFields());
			// 		}
			// 	}
			// }
		}
		catch (Exception e) {
			System.debug('Exception: ' + e.getTypeName() + ', ' + e.getMessage());
		}
	}
}