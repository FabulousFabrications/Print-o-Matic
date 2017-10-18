module cylinder_outer(h,d=undef,d1=undef,d2=undef,fn=15) {
	fudge = cos(180/fn);
	cylinder(h=h,d=d/fudge,d1=d1/fudge,d2=d2/fudge,$fn=fn);
}

module hole(d, h, countersink=0, extra_above=false, center=true) {
    translate([0, 0, center?h/2:0]) { 
        h = h - countersink;
        translate([0, 0, -(h+countersink)]) {
            translate([0, 0, h+0.001]) cylinder_outer(d1=d, d2=d*1.5, h=countersink);
            if (extra_above) {
                translate([0, 0, height+0.001]) cylinder_outer(d1=d, d2=d*2, h=countersink*3/2);
            }
            if (h > 0)
                translate([0, 0, -0.1]) cylinder_outer(d=d, h=h+0.2);
        }
    }
}

module nut_trap(w, h, sides, center=false){
	cylinder(r = w / 2 / cos(180 / 6) + 0.05, h=h, $fn=6, center=center);
}

module rim(id, od, h) {
	difference() {
		cylinder_outer(h=h, d=od);
		translate([0, 0, -1]) cylinder(h=h+2, d=id);
	}
}

rim(8.5, 13, 2);