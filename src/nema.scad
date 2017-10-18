function nema17_d() = 42.3;

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
        translate([0, 0, motor_height-4.5]) nema17_holes() cylinder(h=5, r=1.5, $fn=24);
	}
}

module nema17_holes() {
    for(i=[0:3]){
        rotate([0, 0, 90*i]) translate([15.5, 15.5, 0]) children();
    }
}
