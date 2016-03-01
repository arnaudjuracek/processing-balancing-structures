public class Structure{
	ArrayList<Node> NODES;
	Node HOVER;
	boolean RUN;

	Structure(){
		this.NODES = new ArrayList<Node>();
		this.RUN = true;
	}

	void add(Node node){
		if(this.RUN){
			this.NODES.add(node);
			node.INDEX = this.NODES.size();
			if(!FORCE_UPDATE_LINKS) for(Node n : this.NODES) this.find_links(n);
		}
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

		// link the first "STRUCTURE_STABILITY" nodes to the Node n
		for(int i=0; i<min(STRUCTURE_STABILITY, sortable_nodes.size()); i++){
			Node l = sortable_nodes.get(i);
			if(l!=n && l.LINKS.size()<STRUCTURE_STABILITY && n.POSITION.dist(l.POSITION) < DISTANCE*2) n.LINKS.add(l);
		}

	}

	//-------------------------------------------------------------

	void update(){
		s.HOVER = null;

		for(Node n : this.NODES){
			if(this.RUN){
				n.update();
				if(n.HOVER) this.HOVER = n;
			}
			if(FORCE_UPDATE_LINKS) this.find_links(n);
		}
	}

	void play(float frame){
		for(Node n : this.NODES) n.POSITION = PVector.lerp(n.START_POS, n.STOP_POS, map(constrain(frame, 0, 100), 0, 100, 0, 1));
	}

	void stop(){
		this.RUN = false;
		for(Node n : this.NODES){
			n.STOP_POS = n.POSITION;
			n.POSITION = n.START_POS;
		}
	}

	void draw(){
		strokeWeight(5);
		stroke(0);
		for(Node n : this.NODES){
			if(!this.RUN){
				stroke(255, 0, 0, 127);
				ellipse(n.STOP_POS.x, n.STOP_POS.y, 10, 10);
				line(n.START_POS.x, n.START_POS.y, n.STOP_POS.x, n.STOP_POS.y);
			}
			for(Node link : n.LINKS){
				stroke(0);
				line(n.POSITION.x, n.POSITION.y, link.POSITION.x, link.POSITION.y);
			}
		}

		for(Node n : this.NODES) n.draw();
	}


}