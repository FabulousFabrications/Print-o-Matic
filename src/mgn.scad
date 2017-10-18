module mgn12(l) {
    color("green")
    linear_extrude(height = l, center = true, convexity = 10)
    import (file = "../dxf/mgn12.dxf");
    
    color("blue")
    translate([0, 13/2, 0]) rotate([0, 90, 90]) cube([27, 20, 13], center=true);
}
