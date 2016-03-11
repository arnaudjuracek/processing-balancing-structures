public class Node{
	public ArrayList<Node> LINKS = new ArrayList<Node>();
	public PVector POSITION, DIRECTION, START_POS, STOP_POS;

	public boolean FIXED = false, HOVER = false;
	private float SIZE = 0, TSIZE = 50;
	private int INDEX = 0;

	Node(float x, float y, float z){
		this.POSITION = new PVector(x,y,z);
		this.START_POS = new PVector(x,y,z);
		this.DIRECTION = new PVector(0,0,0);
	}


	//-------------------------------------------------------------

	public void update(){
		this.HOVER = this.hover();

		if(!this.FIXED){

			for(Node link : this.LINKS){
				float distance = int(this.POSITION.dist(link.POSITION)/10)*10;
				float acceleration = map(dist(0, DISTANCE, 0, distance), 0, width, 0, 1);

				if(abs(DISTANCE - distance) > DISTANCE*.2){
					if(distance > DISTANCE*.9){
						this.DIRECTION
							= link.DIRECTION
							= PVector.sub(this.POSITION, link.POSITION);

						if(!link.FIXED) link.POSITION.add(link.DIRECTION.mult(acceleration));
						if(!this.HOVER) this.POSITION.sub(link.DIRECTION.mult(acceleration));
					}else if(distance < DISTANCE*1.1){
						this.DIRECTION
							= link.DIRECTION
							= PVector.sub(this.POSITION, link.POSITION);

						if(!link.FIXED) link.POSITION.sub(link.DIRECTION.mult(acceleration));
						if(!this.HOVER) this.POSITION.add(link.DIRECTION.mult(acceleration));
					}
				}
			}

			// wall collisions
			// this.POSITION.x = max(boundaries.x, this.POSITION.x);
			// this.POSITION.x = min(this.POSITION.x, boundaries.width);
			// this.POSITION.y = max(boundaries.y, this.POSITION.y);
			// this.POSITION.y = min(this.POSITION.y, boundaries.height);
		}

	}

	//-------------------------------------------------------------

	public boolean hover(){ return new PVector(screenX(this.POSITION.x, this.POSITION.y, this.POSITION.z), screenY(this.POSITION.x, this.POSITION.y, this.POSITION.z)).dist(new PVector(mouseX, mouseY)) < 10; }

	//-------------------------------------------------------------

	public void draw(){
		// eye candy
		float dsize = TSIZE - SIZE;
		SIZE += dsize*.3;

		noStroke();
		if(this.FIXED) fill(221, 23, 117);
		else fill(255);

		if(this.hover()) TSIZE = 20;
		else TSIZE = 5;

		pushMatrix();
			translate(this.POSITION.x, this.POSITION.y, this.POSITION.z);
			sphere(SIZE);
		popMatrix();
	}
}