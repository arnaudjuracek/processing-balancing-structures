import java.util.Iterator;
import java.util.Collections;
import java.util.Comparator;
import java.awt.Rectangle;

boolean FORCE_UPDATE_LINKS = true;
float DISTANCE = 100;

float DEBUG_SPEED = 1.0, DEBUG_PAUSE = 1;
Structure s;
Rectangle boundaries;

void setup(){
	size(900, 600);
	s = new Structure();
	boundaries = new Rectangle(50, 50, width-50, height-50);
	frameRate(30);
}

void draw(){
	background(#EEEEEE);
	s.update();
	s.draw();

	if(DEBUG_PAUSE == 0){
		fill(0);
		textAlign(RIGHT);
		text("||", width-20, 20);
	}
}

Node dragged;
void mouseDragged(){
	if(dragged != null) dragged.POSITION = new PVector(mouseX, mouseY);
}

void mousePressed(){
	dragged = s.HOVER;
}

void mouseClicked(){
	if(s.HOVER==null) s.add(new Node(mouseX, mouseY));
	else if(dragged != null) dragged.FIXED = !dragged.FIXED;
}

void keyPressed(){
	if(keyCode == RIGHT) DEBUG_SPEED += .1;
	if(keyCode == LEFT) DEBUG_SPEED = DEBUG_SPEED > .1 ? DEBUG_SPEED-.1 : 0;
	if(key == 'p') DEBUG_PAUSE = (DEBUG_PAUSE > 0) ? 0:1;
	if(key == 'r') for(int i=0; i<random(20); i++) s.add(new Node(random(width), random(height)));
	if(key == 'c') s.NODES = new ArrayList<Node>();
	if(key == ' '){
		s.NODES = new ArrayList<Node>();
		for(int i=0; i<random(200); i++) s.add(new Node(random(width), random(height)));
	}

}