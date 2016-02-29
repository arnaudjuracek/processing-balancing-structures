public class Node{
	ArrayList<Node> LINKS = new ArrayList<Node>();
	PVector POSITION, DIRECTION;
	float VELOCITY;

	boolean FIXED = false, HOVER = false;
	float SIZE = 0, TSIZE = 10;
	int INDEX = 0;

	Node(float x, float y){
		this.POSITION = new PVector(x,y);
		this.DIRECTION = new PVector(0,0);
		this.VELOCITY = random(0,1);
	}

	//-------------------------------------------------------------

	void update(){
		this.HOVER = this.hover();

		if(!this.FIXED){

			for(Node link : this.LINKS){
				float distance = this.POSITION.dist(link.POSITION);
				float acceleration = int(map(dist(0, DISTANCE, 0, distance), 0, width, 0, 50))*.05;

				if(distance > DISTANCE*.9){
					this.DIRECTION
						= link.DIRECTION
						= PVector.sub(this.POSITION, link.POSITION);

					if(!link.FIXED) link.POSITION.add(link.DIRECTION.mult(acceleration*this.VELOCITY));
					if(!this.HOVER) this.POSITION.sub(link.DIRECTION.mult(acceleration*this.VELOCITY*DEBUG_PAUSE*DEBUG_SPEED));
				}else if(distance < DISTANCE*1.1){
					this.DIRECTION
						= link.DIRECTION
						= PVector.sub(this.POSITION, link.POSITION);

					if(!link.FIXED) link.POSITION.sub(link.DIRECTION.mult(acceleration*this.VELOCITY));
					if(!this.HOVER) this.POSITION.add(link.DIRECTION.mult(acceleration*this.VELOCITY*DEBUG_PAUSE*DEBUG_SPEED));
				}
			}

			// wall collisions
			this.POSITION.x = max(boundaries.x, this.POSITION.x);
			this.POSITION.x = min(this.POSITION.x, boundaries.width);
			this.POSITION.y = max(boundaries.y, this.POSITION.y);
			this.POSITION.y = min(this.POSITION.y, boundaries.height);
		}

	}

	//-------------------------------------------------------------

	boolean hover(){
		return this.POSITION.dist(new PVector(mouseX, mouseY)) < 10;
	}

	//-------------------------------------------------------------

	void draw(){
		// eye candy
		float dsize = TSIZE - SIZE;
		SIZE += dsize*.3;

		stroke(0);
		strokeWeight(3);
		if(this.FIXED) fill(0);
		else fill(255);

		if(this.hover()) TSIZE = 30;
		else TSIZE = 20;

		ellipse(this.POSITION.x, this.POSITION.y, SIZE, SIZE);

		// draw index
		// fill(255, 0, 0);
		// text(this.INDEX, this.POSITION.x + 10, this.POSITION.y + 10);

		// draw real links
		// strokeWeight(1);
		// for(Node l : this.LINKS) line(this.POSITION.x, this.POSITION.y, l.POSITION.x, l.POSITION.y);
	}
}