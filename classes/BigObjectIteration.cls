public class BigObjectIteration {
	public class BigObjectIterator implements Iterator<sObject> {
		private List<sObject> items;
		private Integer maxItems;
		public BigObjectIterator(List<sObject> entries) {
			this.items = entries;
			this.maxItems = entries.size();
		}
		public boolean hasNext() { return maxItems > 0; }
		public sObject next() {
			if(hasNext()) {
				maxItems--;
				return items[maxItems];
			} else {
				throw new NoSuchElementException();
			}
		}
	}

	public class BigObjectIterable implements Iterable<sObject> {
		private List<sObject> items;
        public BigObjectIterable(List<sObject> items) {
            this.items = items;
        }
		public Iterator<sObject> iterator() {
			return new BigObjectIterator(this.items);
		}
	}
}