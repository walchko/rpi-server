// MIT License 2018 Kevin J. Walchko

$fn=90;

/* use <lib/pi.scad>; */

module hex(side,t){
    intersection(){
        cube([side, side, 1.5*t],center=true);
        rotate([0,0,45]) cube([side, side, 1.5*t], center=true);
    }
}

module M3(){
    cylinder(h=40, d=3.5, center=true);
    translate([0,0,2]) cylinder(h=6, d=7, center=false);
}

module M2(){
    cylinder(h=40, d=2.6, center=false);
}

module base(width, length, thick, dia){
    linear_extrude(height=thick) hull(){
        circle(d=dia);
        translate([width,0,0]) circle(d=dia);
        translate([width,length,0]) circle(d=dia);
        translate([0,length,0]) circle(d=dia);
    }
}

module hcut(dia, length){
    // along x-axis
    translate([0,0,-5]) linear_extrude(height=15) hull(){
        circle(d=dia);
        translate([length,0,0]) circle(d=dia);
    }
}

module vcut(dia, length){
    // along y-axis
    translate([0,0,-5]) linear_extrude(height=15) hull(){
        circle(d=dia);
        translate([0,length,0]) circle(d=dia);
    }
}

module plate(width, length, thick=3){
    dia = 4;
    scale = 0.63;
    xbase = (width - 49)/2;
    ybase = (length-58)/2;

    dx = (1-scale)*width/2;
    dy = (1-scale)*length/2;
    difference()
    {
        union(){
            base(width, length, thick, dia);
            // stand-offs
            translate([xbase, ybase, thick-1]){
                sd1 = 13;
                sd2 = 5;
                up = 5;
                translate([0,0,0]) cylinder(h=up, d1=sd1,d2=sd2);
                translate([49,0,0]) cylinder(h=up, d1=sd1, d2=sd2);
                translate([49,58,0]) cylinder(h=up, d1=sd1, d2=sd2);
                translate([0,58,0]) cylinder(h=up, d1=sd1, d2=sd2);
            }
        }

        // center cut
        translate([dx,dy,-thick/2]) base(scale*width, scale*length, thick*5, dia);

        // HD mounting holes
        hdw = 61.72;
        hdl = 76.6;
        hdx = (width - hdw)/2;
        hdy = (length - hdl)/2;
        translate([hdx,hdy,0]){
            translate([0,0,0]) M3();
            translate([hdw,0,0]) M3();
            translate([hdw,hdl,0]) M3();
            translate([0,hdl,0]) M3();
        }

        // pi mounting holes
        translate([xbase, ybase, 0]){
            translate([0,0,0]) M2();
            translate([49,0,0]) M2();
            translate([49,58,0]) M2();
            translate([0,58,0]) M2();
        }

        // horizontal cuts - along x-axis
        cw = 30;
        cd = 8;
        /* translate([(width-cw)/2,cd/1.5,0]) hcut(cd, cw);
        translate([(width-cw)/2,cd/1.5-5,0]) hcut(cd, cw); */
        translate([(width-cw)/2,cd/1.5-7,-1]) base(30, 10, thick*5, dia);
        translate([(width-cw)/2,length-cd/1.5,0]) hcut(cd, cw);

        // vertical cuts - along y-axis
        cl = 38;
        cld = 6;
        translate([cld/1.5,(length-cl)/2,0]) vcut(cld, cl);
        translate([width-cld/1.5,(length-cl)/2,0]) vcut(cld, cl);

        // nut cutouts
        translate([xbase, ybase, -1]){
            side = 4.1;
            t = 7;
            /* translate([0,0,0]) cylinder(h=up, d=sdia); */
            translate([0,0,0]) hex(side, t);
            translate([49,0,0]) hex(side, t);
            translate([49,58,0]) hex(side, t);
            translate([0,58,0]) hex(side, t);
        }
    }

    /* translate([xbase, ybase, 0]){
        dia = 7;
        up = 6;
        translate([0,0,0]) cylinder(h=up, d=dia);
        translate([49,0,0]) cylinder(h=up, d=dia);
        translate([49,58,0]) cylinder(h=up, d=dia);
        translate([0,58,0]) cylinder(h=up, d=dia);
    } */

    /* cl = 40;
    cd = 6;
    translate([cd/2,(length-cl)/2,0]) vcut(cd, cl);
    translate([width-cd/2,(length-cl)/2,0]) vcut(cd, cl); */

}

width = 65;
height = 80;
thickness = 4;
plate(width, height, thickness);

/* translate([49/2,58/2, 10]) rotate([0,0,-90]) rpi3(); */
