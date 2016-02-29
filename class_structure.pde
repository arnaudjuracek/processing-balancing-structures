public class Structure{
	ArrayList<Node> NODES;
	Node HOVER;

	Structure(){ this.NODES = new ArrayList<Node>(); }

	void add(Node node){
		this.NODES.add(node);
		node.INDEX = this.NODES.size();

		if(!FORCE_UPDATE_LINKS) for(Node n : this.NODES) this.find_links(n);
	}

	void find_links(Node n){
		// clear all previous links
		n.LINKS.clear();

		// copy NODES in a new sortable ArrayList
		ArrayList<Node> sortable_nodes = (ArrayList<Node>) this.NODES.clone();

		// no need to compare the Node n to itself
		sortable_nodes.remove(n);

		// sort the new ArrayList by distance from the Node n
		Collections.sort(sortable_nodes, new DistanceComparator(n));

		// link the first 3 nodes to the Node n
		for(int i=0; i<min(3, sortable_nodes.size()); i++){
			Node l = sortable_nodes.get(i);
			if(l!=n && l.LINKS.size()<3 && n.POSITION.dist(l.POSITION) < DISTANCE*2) n.LINKS.add(l);
		}

	}

	//-------------------------------------------------------------

	void update(){
		s.HOVER = null;

		for(Node n : this.NODES){
			n.update();
			if(FORCE_UPDATE_LINKS) this.find_links(n);
			if(n.HOVER) this.HOVER = n;
		}
	}

	void draw(){
		strokeWeight(5);
		stroke(0);
		for(Node n : this.NODES){
			for(Node link : n.LINKS){
				line(n.POSITION.x, n.POSITION.y, link.POSITION.x, link.POSITION.y);
			}
		}

		for(Node n : this.NODES) n.draw();
	}


}