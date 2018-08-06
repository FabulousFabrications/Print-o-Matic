function mr12_hole_distance() = 20;
module mr12_holes() {
    for (i = [0 : 90 : 270]) {
        rotate(i)
        translate([mr12_hole_distance()/2, mr12_hole_distance()/2]) {
            children();
        }
    }
}

module mgn12(l) {
    color("green")
    linear_extrude(height = l, center = true, convexity = 10)
    import (file = "../dxf/mgn12.dxf");
    
    color("blue")
    translate([0, 13/2, 0]) rotate([0, 90, 90]) {
        difference() {
            cube([45, 27, 13], center=true);
            mr12_holes() cylinder(d=2, h=10);
        }
    }
}

mgn12(100);