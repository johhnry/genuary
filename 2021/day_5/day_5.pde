// (c) 2021 Joseph HENRY
// This code is licensed under MIT license (see LICENSE for details)

// Press Ctrl+T in the Processing IDE to discover the real code :)
float h;void setup(){size(500,500);h=width/2;}float o=0;void y(float l){push();rotate(cos(o/2+l*0.1));square(0,0,l);pop();}void draw(){background(#003344);rectMode(CENTER);noFill();stroke(255, 150);translate(h, h);for(int t=0;t<h;){if(t%10!=0){y(t++);}else{t+=5;}}o+=0.1;}
