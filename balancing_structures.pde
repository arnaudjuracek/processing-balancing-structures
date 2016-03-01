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
	size(900, 600, P3D);
	frameRate(30);

	CAM = new PeasyCam(this, 800);
	CAM.setWheelScale(.25);

	s = new Structure();

	boundaries = new Rectangle(50, 50, width-50, height-50);
	// populate
	for(int i=0; i<random(200); i++){
		s.add(new Node(random(width), random(height), random(-width*.5,width*.5)));
		if(random(100)>90) s.NODES.get(s.NODES.size()-1).FIXED = true;
	}
}

void draw(){
	CAM.setActive(dragged==null);
	background(70);
	if(!PAUSE){
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
	if(key == 'f') FORCE_UPDATE_LINKS = !FORCE_UPDATE_LINKS;
	if(key == 'p') PAUSE = !PAUSE;
	if(key == 'r') for(int i=0; i<random(20); i++) s.add(new Node(random(width), random(height), random(-width*.5,width*.5)));
	if(key == 'c') s = new Structure();
	if(key == 's') if(s.RUN) s.stop_simulation();
	if(key == ' '){
		s = new Structure();
		for(int i=0; i<random(50,200); i++){
			s.add(new Node(random(width), random(height), random(-width*.5,width*.5)));
			if(random(100)>90) s.NODES.get(s.NODES.size()-1).FIXED = true;
		}
	}

}