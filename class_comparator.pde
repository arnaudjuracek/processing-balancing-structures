public class DistanceComparator implements Comparator<Node>{
	private Node NODE;
	public DistanceComparator(Node node){ this.NODE = node; }

	public int compare(Node n1, Node n2){
		float d1 = 0, d2 = 0;

		try{
			if(n1 != null && n2 != null){
				d1 = this.NODE.POSITION.dist(n1.POSITION);
				d2 = this.NODE.POSITION.dist(n2.POSITION);
			}
		}catch(Exception e){
			throw new RuntimeException("Error while comparing !");
		}

		return (n1 == null) ? -1 : ((n2 == null) ? 1 : ((Comparable<Float>) d1).compareTo(d2));
	}

}