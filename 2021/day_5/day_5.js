// (c) 2021 Joseph HENRY
// This code is licensed under MIT license (see LICENSE for details)

setup=_=>{createCanvas(s=500,s);h=s/2};o=0;draw=_=>{background("#003344");rectMode(CENTER);noFill();stroke(255,150);y=(l)=>{push();rotate(cos(o/2+l*0.1));square(0,0,l);pop()};translate(h,h);for(t=0;t<h;t%10?y(t++):t+=5)o+=0.001}

