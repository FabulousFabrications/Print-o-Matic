include <globals.scad>;

use <profiles.scad>;
use <gantry.scad>;
use <components/kfl08.scad>;

// TODO:
// single big bearing roller on extrusion -> 2 small ones
// 30x60 profile -> 30x30 profile. Should still be rigid enough, currently frame cost is too high.

module frame_horiz() {
    o=profile_width/2;
    translate([width/2, profile_width/2, o]) rotate([90, 0, 90])
    Profile(width-profile_width*2);
    translate([width/2, length-profile_width/2, o]) rotate([90, 0, 90])
    Profile(width-profile_width*2);
    
    translate([profile_width/2, (length-profile_width*2)/2 + profile_width, o]) rotate([90, 0, 0])
    Profile(length-profile_width*2);
    translate([width-profile_width/2, (length-profile_width*2)/2 + profile_width, o]) rotate([90, 0, 0])
    Profile(length-profile_width*2);
}

module frame_vertical_quarter() {
    vertical_offset = corner_size;
    
    translate([0, 0, (vertical_extrusion_height)/2 + vertical_offset])
    Profile(vertical_extrusion_height);
    
    translate([0, 0, corner_size/2]) print() cube(corner_size, center=true);
    translate([0, 0, vertical_extrusion_height+corner_size*1.5]) print() cube(corner_size, center=true);
}

module frame_vertical() {
    translate([profile_width/2, profile_width/2, 0])
    frame_vertical_quarter();
    
    translate([width-profile_width/2, profile_width/2, 0])
    frame_vertical_quarter();
    
    translate([profile_width/2, length-profile_width/2, 0])
    frame_vertical_quarter();
    
    translate([width-profile_width/2, length-profile_width/2, 0])
    frame_vertical_quarter();
}

module frame() {
    frame_horiz();
    frame_vertical();
    translate([0, 0, height-profile_width])
    frame_horiz();
    
    //top
    *translate([0, 0, height-profile_width]) {
        translate([width/2, profile_width/2, profile_width/2]) rotate([90, 0, 90]) Profile(width);
        translate([width/2, length-profile_width/2, profile_width/2]) rotate([90, 0, 90]) Profile(width);
        
        translate([profile_width/2, (length-profile_width*2)/2 + profile_width, profile_width/2]) rotate([90, 0, 0]) Profile(length-profile_width*2);
        translate([width-profile_width/2, (length-profile_width*2)/2 + profile_width, profile_width/2]) rotate([90, 0, 0]) Profile(length-profile_width*2);
    }
}

module verticalrod(l) {
    echo(str("BOM 8x",l,"mm threaded rod"));
    color("red") {
        cylinder(d=8, h=l, center=true);
        rotate(90) {
            translate([0, 0, -l/2]) kfl08();
            translate([0, 0, -(-l/2)]) rotate([180, 0, 0]) kfl08();
        }
        translate([0, 0, l/2-30]) cylinder(d=27.5, h=17.5, center=true);
    }
}

module fixed_guides() {
    /*
    bottom_gap = 60;
    guide_height = rail_length;
    translate([width-20, 30, bottom_gap+guide_height/2])
    rotate(90) mgn12(guide_height);
    
    translate([width-20, length-30, bottom_gap+guide_height/2])
    rotate(90) mgn12(guide_height);
    
    translate([20, length-30, bottom_gap+guide_height/2])
    rotate(270) mgn12(guide_height);
    
    translate([20, 30, bottom_gap+guide_height/2])
    rotate(270) mgn12(guide_height);
    */
    
    b=z_screw_offset;
    a=profile_width/2;
    rod_height = inner_frame_height;
    translate([a, b, bottom_frame_height+inner_frame_height/2]) verticalrod(rod_height);
    translate([width-a, length-b, bottom_frame_height+inner_frame_height/2]) verticalrod(rod_height);
    translate([width-a, b, bottom_frame_height+inner_frame_height/2]) verticalrod(rod_height);
    translate([a, length-b, bottom_frame_height+inner_frame_height/2]) verticalrod(rod_height);
}

module machine() {
    frame();
    fixed_guides();
    translate([0, 0, 60+vertical_extrusion_height/2]) gantry();
    translate([width/2, length/2, bottom_frame_height]) bed();
}

module bed() {
    color("orange") cube([bed_width, bed_length, 3], center=true); 
}

machine();