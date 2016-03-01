public class Structure{
	public ArrayList<Node> NODES;
	public Node HOVER;
	public boolean RUN;
	public int MODE;

	Structure(){
		this.NODES = new ArrayList<Node>();
		this.RUN = true;
	}

	public void add(Node node){
		if(this.RUN){
			this.NODES.add(node);
			node.INDEX = this.NODES.size();
			if(!FORCE_UPDATE_LINKS) for(Node n : this.NODES) this.find_links(n);
		}
	}

	private void find_links(Node n){
		// clear all previous links
		n.LINKS.clear();

		// copy NODES in a new sortable ArrayList
		ArrayList<Node> sortable_nodes = (ArrayList<Node>) this.NODES.clone();

		// no need to compare the Node n to itself
		sortable_nodes.remove(n);

		// sort the new ArrayList by distance from the Node n
		Collections.sort(sortable_nodes, new DistanceComparator(n));

		// link the first "STRUCTURE_STABILITY" nodes to the Node n
		for(int i=0; i<min(STRUCTURE_STABILITY, sortable_nodes.size()); i++){
			Node l = sortable_nodes.get(i);
			if(l!=n && l.LINKS.size()<STRUCTURE_STABILITY && n.POSITION.dist(l.POSITION) < DISTANCE*2) n.LINKS.add(l);
		}

	}

	//-------------------------------------------------------------

	public void update(){
		s.HOVER = null;

		for(Node n : this.NODES){
			if(this.RUN) n.update();
			if(FORCE_UPDATE_LINKS) this.find_links(n);
		}
	}

	public void play(float amt){
		for(Node n : this.NODES) n.POSITION = PVector.lerp(n.START_POS, n.STOP_POS, amt);
	}

	public void stop_simulation(){
		this.RUN = false;
		for(Node n : this.NODES){
			n.STOP_POS = n.POSITION;
			n.POSITION = n.START_POS;
		}
	}

	public void draw(){
		strokeWeight(5);
		for(Node n : this.NODES){
			if(!this.RUN){
				noStroke();
				fill(255,0,0,50);
				pushMatrix();
					translate(n.STOP_POS.x, n.STOP_POS.y, n.STOP_POS.z);
					sphere(4.9);
				popMatrix();
				stroke(255,0,0,50);
				line(n.START_POS.x, n.START_POS.y, n.START_POS.z, n.STOP_POS.x, n.STOP_POS.y, n.STOP_POS.z);
			}

			stroke(0);
			for(Node link : n.LINKS) line(n.POSITION.x, n.POSITION.y, n.POSITION.z, link.POSITION.x, link.POSITION.y, link.POSITION.z);
		}

		for(Node n : this.NODES){
			n.draw();
			if(this.RUN && n.hover()) this.HOVER = n;
		}
	}


}