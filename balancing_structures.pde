import java.util.Iterator;
import java.util.Collections;
import java.util.Comparator;
import java.awt.Rectangle;

import peasy.*;
PeasyCam CAM;

boolean FORCE_UPDATE_LINKS = true;
boolean PAUSE = false;
float DISTANCE = 200;
int STRUCTURE_STABILITY = 6; // default = 3;

Structure s;
Rectangle boundaries;

void setup(){
	size(1200, 800, P3D);
	frameRate(30);

	WRAP = new IsoWrap(this);
	SKELETON = new IsoSkeleton(this);
	SURFACE = new IsoSurface(this, new PVector(0,0,0), new PVector(1000, 1000, 1000), 8);

	CAM = new PeasyCam(this, 800);
	CAM.setWheelScale(.25);

	s = new Structure();

	boundaries = new Rectangle(50, 50, width-50, height-50);
	// populate
	for(int i=0; i<random(200); i++){
		s.add(new Node(random(width), random(height), random(-width*.5,width*.5)));
		if(random(100)>90) s.NODES.get(s.NODES.size()-1).FIXED = true;
	}

	float r = width;
	// PAUSE = true;
	for(float theta=0; theta<PI; theta+=(PI/15)){
		for(float phi=0; phi<TWO_PI; phi+=(TWO_PI/20)){
			float x = r*sin(theta)*cos(phi) + r*.5;
			float y = r*sin(theta)*sin(phi) + r*.5;
			float z = r*cos(theta) + r*.5;

			Node n = new Node(x,y,z);
			n.FIXED = false;
			s.add(n);
		}
	}
}

void draw(){
	background(70);
	if(!PAUSE){
		CAM.setActive(dragged==null);
		s.update();
		if(!s.RUN) s.play(map(sin(frameCount*.1), -1, 1, 0, 1));
	}else{
		CAM.beginHUD();
			fill(255);
			textAlign(RIGHT);
			text("||", width-20, 20);
		CAM.endHUD();
	}

	pushMatrix();
		translate(-width*.5, -height*.5);
		s.draw();
	popMatrix();
}

Node dragged;
void mouseDragged(){
	if(dragged != null){

	}
}
void mousePressed(){ dragged = s.HOVER; }
void mouseReleased(){ dragged = null; }
void mouseClicked(){ if(s.HOVER!=null) s.HOVER.FIXED = !s.HOVER.FIXED; }

void keyPressed(){
	if(key == 'c') s = new Structure();
	if(key == 'd'){
		DISTANCE = random(50, 300);
		println("New linking distance set to " + DISTANCE + "px");
	}
	if(key == 'l') FORCE_UPDATE_LINKS = !FORCE_UPDATE_LINKS;
	if(key == 'f') for(Node n : s.NODES) n.FIXED = (random(1)>.75);
	if(key == 'p') PAUSE = !PAUSE;
	if(key == 'r') for(int i=0; i<random(20); i++) s.add(new Node(random(-width, width), random(-height, height), random(-width,width)));
	if(key == 's'){
		if(s.RUN) s.stop_simulation();
		else s.resume_simulation();
	}
	if(key == ' '){
		s = new Structure();
		for(int i=0; i<random(50,200); i++){
			s.add(new Node(random(width), random(height), random(-width*.5,width*.5)));
			if(random(100)>90) s.NODES.get(s.NODES.size()-1).FIXED = true;
		}
	}

}