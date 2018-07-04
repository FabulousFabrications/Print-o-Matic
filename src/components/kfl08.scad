h=7;
id=8;
od=22;
tol=0.2;

thickness=3;

hole_diameter=4.5;
// usually 36.5 for actual kfl08s
hole_spacing=37.5;

bottom_hole_diameter=id+2;

$fs=1;
$fa=6;

module kfl08() {
    difference() {
        union() {
            hull() {
                cylinder(d=od+thickness*2, h=thickness);
                for (i = [-1, 1])
                    translate([i*hole_spacing/2, 0, 0]) cylinder(d=hole_diameter+thickness*2, h=thickness);
            }
            cylinder(d=od+thickness*2, h=h+thickness-0.01);
        }
        translate([0, 0, 2]) cylinder(d=od+tol, h=h+thickness);
        cylinder(d=bottom_hole_diameter+tol, h=(h+thickness)*3, center=true);
        for (i = [-1, 1])
            translate([i*hole_spacing/2, 0, 0]) cylinder(d=hole_diameter, h=thickness*3, center=true);
    }
}

kfl08();