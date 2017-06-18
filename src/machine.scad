width = 650;
length = 580;
height = 1000;
rail_length = 450;

bed_width = 450;
bed_length = 450;

profile_width=30;
vertical_extrusion_height = height;
top_frame_height=profile_width*2;
bottom_frame_height=profile_width*2;
inner_frame_height = height - bottom_frame_height - top_frame_height;
carriage_mount_thickness = 4;

gantry_profile_width=20;
gantry_offset = profile_width + gantry_profile_width/2 + 30;
gantry_width = width-2*(carriage_mount_thickness+gantry_offset-gantry_profile_width/2+13+gantry_profile_width);
gantry_length = length-profile_width*2;

// TODO:
// single big bearing roller on extrusion -> 2 small ones
// 30x60 profile -> 30x30 profile. Should still be rigid enough, currently frame cost is too high.

module 2Profile(width) {
    echo(str("BOM ",profile_width, "x", profile_width*2, "x", width,"mm extrusion"));
    translate([0, profile_width/2, 0]) Profile(width, false);
    translate([0, -profile_width/2, 0]) Profile(width, false);
}

module Profile(width, e=true) {
    if (e) {
        echo(str("BOM ",profile_width, "x", profile_width, "x", width,"mm extrusion"));
    }
    linear_extrude(width, center=true) import(str("../dxf/", profile_width, "x", profile_width, ".dxf"));
}

module 2020Profile(width) {
    echo(str("BOM ",gantry_profile_width, "x", gantry_profile_width, "x", width,"mm extrusion"));
    linear_extrude(width, center=true) import("../dxf/20x20.dxf");
}

module frame_horiz() {
    translate([width/2, profile_width/2, profile_width]) rotate([90, 0, 90])
    2Profile(width-profile_width*2);
    translate([width/2, length-profile_width/2, profile_width]) rotate([90, 0, 90])
    2Profile(width-profile_width*2);
    
    translate([profile_width/2, (length-profile_width*2)/2 + profile_width, profile_width]) rotate([90, 0, 0])
    2Profile(length-profile_width*2);
    translate([width-profile_width/2, (length-profile_width*2)/2 + profile_width, profile_width]) rotate([90, 0, 0])
    2Profile(length-profile_width*2);
}

module frame_vertical() {
    vertical_offset = 0;
    translate([profile_width/2, profile_width/2, (vertical_extrusion_height)/2 + vertical_offset])
    Profile(vertical_extrusion_height);
    translate([width-profile_width/2, profile_width/2, (vertical_extrusion_height)/2 + vertical_offset])
    Profile(vertical_extrusion_height);
    translate([profile_width/2, length-profile_width/2, (vertical_extrusion_height)/2 + vertical_offset])
    Profile(vertical_extrusion_height);
    translate([width-profile_width/2, length-profile_width/2, (vertical_extrusion_height)/2 + vertical_offset])
    Profile(vertical_extrusion_height);
}

module frame() {
    frame_horiz();
    frame_vertical();
    translate([0, 0, height-profile_width*2])
    frame_horiz();
    
    //top
    *translate([0, 0, height-profile_width]) {
        translate([width/2, profile_width/2, profile_width/2]) rotate([90, 0, 90]) Profile(width);
        translate([width/2, length-profile_width/2, profile_width/2]) rotate([90, 0, 90]) Profile(width);
        
        translate([profile_width/2, (length-profile_width*2)/2 + profile_width, profile_width/2]) rotate([90, 0, 0]) Profile(length-profile_width*2);
        translate([width-profile_width/2, (length-profile_width*2)/2 + profile_width, profile_width/2]) rotate([90, 0, 0]) Profile(length-profile_width*2);
    }
}

module mgn12(l) {
    color("green")
    linear_extrude(height = l, center = true, convexity = 10)
    import (file = "../dxf/mgn12.dxf");
    
    color("blue")
    translate([0, 13/2, 0]) rotate([0, 90, 90]) cube([27, 20, 13], center=true);
}

module verticalrod(l) {
    echo(str("BOM 8x",l,"mm threaded rod"));
    color("red") {
        cylinder(d=8, h=l, center=true);
        rotate(90)
        translate([0, 0, -l/2+13/2]) cube([48, 27, 13], center=true);
        translate([0, 0, -(-l/2+13/2)]) cube([48, 27, 13], center=true);
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
    
    b=profile_width*4;
    a=profile_width/2;
    rod_height = inner_frame_height;
    translate([a, b, bottom_frame_height+inner_frame_height/2]) verticalrod(rod_height);
    translate([width-a, length-b, bottom_frame_height+inner_frame_height/2]) verticalrod(rod_height);
    translate([width-a, b, bottom_frame_height+inner_frame_height/2]) verticalrod(rod_height);
    translate([a, length-b, bottom_frame_height+inner_frame_height/2]) verticalrod(rod_height);
}

module nema17(motor_height=34) {
    echo(str("BOM ",34,"mm depth nema17 motor"));
    color("grey") difference(){
		union(){
			translate([0,0,motor_height/2]){
				intersection(){
					cube([42.3,42.3,motor_height], center = true);
					rotate([0,0,45]) translate([0,0,-1]) cube([74.3*sin(45), 73.3*sin(45) ,motor_height+2], center = true);
				}
			}
			translate([0, 0, motor_height]) cylinder(h=2, r=11, $fn=24);
			translate([0, 0, motor_height+2]) cylinder(h=20, r=2.5, $fn=24);
		}
		for(i=[0:3]){
				rotate([0, 0, 90*i])translate([15.5, 15.5, motor_height-4.5]) cylinder(h=5, r=1.5, $fn=24);
			}
	}
}

module gt2pulley() {
    cylinder(d=16, h=16, center=true);
}

module gantryside() {
    translate([20+(10+2.3/2), gantry_length/2-profile_width-20-2-2.3/2, -34+10]) nema17();
    translate([0, 8-gantry_length/2, 20]) gt2pulley();
    translate([0, gantry_length/2-8, 20]) gt2pulley();
    rotate([90, 0, 0]) {
        translate([-10, 0, 0]) rotate([0, 0, 90]) mgn12(rail_length);
        rotate(90) 2020Profile(gantry_length);
    }
    translate([(20+30)/2, 4.5-gantry_length/2, -20]) rotate([90, 0, 0]) bearing();
    translate([(20+30)/2, -(4.5-gantry_length/2), -20]) rotate([90, 0, 0]) bearing();
}

module gantrymiddle() {
    translate()
    rotate([90, 0, 90]) {
        translate([0, 10, 0]) mgn12(rail_length);
        2020Profile(gantry_width);
    }
}

module bearing(od=30, id=10, r=9) {
    difference() {
        cylinder(d=od, h=r, center=true);
        cylinder(d=id, h=r+1, center=true);
    }
}

module gantry() {
    o=gantry_offset;
    translate([width/2, length/2, 0])
    gantrymiddle();
    translate([o, length/2, 0])
    scale([-1, 1, 1]) gantryside();
    translate([width-o, length/2, 0])
    gantryside();
    rotate([0, 90, 0]) translate([0, length/2-gantry_length/2+gantry_profile_width/2, width/2]) 2020Profile(width-2*(o+10));
    rotate([0, 90, 0]) translate([0, length/2+gantry_length/2-gantry_profile_width/2, width/2]) 2020Profile(width-2*(o+10));
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