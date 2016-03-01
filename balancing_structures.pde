import java.util.Iterator;
import java.util.Collections;
import java.util.Comparator;
import java.awt.Rectangle;

boolean FORCE_UPDATE_LINKS = true;
boolean PAUSE = false;
float DISTANCE = 100;
int STRUCTURE_STABILITY = 6; // default = 3;

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
	if(!PAUSE){
		s.update();
		if(!s.RUN) s.play(abs(sin(frameCount*.01))*100);
	}else{
		fill(0);
		textAlign(RIGHT);
		text("||", width-20, 20);
	}
	s.draw();
}

Node dragged;
void mouseDragged(){ if(dragged != null) dragged.POSITION = new PVector(mouseX, mouseY); }
void mousePressed(){ dragged = s.HOVER; }
void mouseClicked(){
	if(s.HOVER==null) s.add(new Node(mouseX, mouseY));
	else if(dragged != null) dragged.FIXED = !dragged.FIXED;
}

void keyPressed(){
	if(key == 'f') FORCE_UPDATE_LINKS = !FORCE_UPDATE_LINKS;
	if(key == 'p') PAUSE = !PAUSE;
	if(key == 'r') for(int i=0; i<random(20); i++) s.add(new Node(random(width), random(height)));
	if(key == 'c') s = new Structure();
	if(key == 's') if(s.RUN) s.stop();
	if(key == ' '){
		s = new Structure();
		for(int i=0; i<random(200); i++) s.add(new Node(random(width), random(height)));
	}

}