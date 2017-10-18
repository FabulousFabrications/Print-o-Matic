include <globals.scad>;

use <mgn.scad>;
use <profiles.scad>;
use <nema.scad>;
use <hole.scad>;

module gt2pulley() {
    cylinder(d=16, h=16, center=true);
}

nema_offset_x = 20+(10+2.3/2);
nema_offset_y = -profile_width-10-2-2.3/2;

function corner_bracket_l() = abs(nema_offset_y)+nema17_d()/2;

module gantryside() {
    translate([0, gantry_length/2, 0]) {
        translate([nema_offset_x, nema_offset_y, -34+10]) nema17();
        translate([0, 0, 10]) print() motor_corner_bracket();
        scale([1, -1, 1]) gantry_bearings();
    }
    
    translate([0, -gantry_length/2, 0]) {
        translate([0, 0, 10]) print() corner_bracket();
        translate([0, 0, -(10+gantry_mount_thickness)]) print() corner_bracket_under();
        gantry_bearings();
    }
    
    translate([0, 8-gantry_length/2, 20]) gt2pulley();
    translate([0, gantry_length/2-8, 20]) gt2pulley();
    rotate([90, 0, 0]) {
        translate([-10, 0, 0]) rotate([0, 0, 90]) mgn12(rail_length);
        rotate(90) 2020Profile(gantry_length);
    }
}

gantry_bearing_x_offset = (20+15)/2;
gantry_bearing_y_offset = -5;
gantry_bearing_2_offset = 12.5;
gantry_mount_bearing_extra = gantry_bearing_id+4;
module gantry_bearings() {
    translate([gantry_bearing_x_offset, gantry_bearing_y_offset, -10+gantry_mount_bearing_extra/2]) {
        rotate([90, 0, 0]) %bearing();
        translate([gantry_bearing_2_offset, gantry_bearing_2_offset, 0])
        rotate([0, 90, 0]) %bearing();
    }
}

module gantrymiddle() {
    translate()
    rotate([90, 0, 90]) {
        translate([0, 10, 0]) mgn12(rail_length);
        2020Profile(gantry_width);
    }
    translate([gantry_width/2+carriage_mount_thickness/2, 0, 0]) rotate(180) gantry_idler();
    translate([-(gantry_width/2+carriage_mount_thickness/2), 0, 0]) gantry_idler();
}

module bearing(od=gantry_bearing_od, id=gantry_bearing_id, r=gantry_bearing_r) {
    difference() {
        cylinder(d=od, h=r, center=true);
        cylinder(d=id, h=r+1, center=true);
    }
}

module corner_bracket_side(l, t) {
    translate([0, -l/2, 0]) {
        difference() {
            cube([20, l, t], center=true);
            o=10;
            for (i = [0 : (l-o*2)/2 : l+8]) {
                translate([0, l/2-i-o, 0]) hole(d=gantry_hole_d, h=t, center=true);
            }
        }
    }
}

module corner_bracket() {
    l=corner_bracket_l();
    t=gantry_mount_thickness;
    scale([1, -1, 1]) {
        translate([-10, -20, 0]) rotate(180) prism(20, 20, t);
        translate([0, 0, t/2]) {
            corner_bracket_side(l, t);
            translate([10, -10, 0]) rotate(-90) corner_bracket_side(l, t);
        }
    }
}

module motor_corner_bracket() {
    t=gantry_mount_thickness;
    scale([1, -1, 1]) corner_bracket();
    translate([0, 0, t/2]) {
        translate([nema_offset_x, nema_offset_y, 0]) {
            difference() {
                cube([nema17_d(), nema17_d(), t], center=true);
                nema17_holes() hole(d=gantry_nema_hole_d, h=t, center=true);
                cylinder(d=25, h=t+2, center=true);
            }
        }
    }
}

module corner_bracket_under() {
    l=corner_bracket_l();
    t=gantry_mount_thickness;
    corner_bracket();
    
    gap=3;
    offsets = [gantry_bearing_x_offset-gantry_bearing_od/2, gantry_bearing_y_offset+gantry_bearing_r/2, 0];
    goffsets = [offsets[0], offsets[1]+gap/2, offsets[2]];
    
    s=[gantry_bearing_2_offset+gantry_bearing_od/2-gantry_bearing_r/2, gantry_bearing_od/2-gantry_bearing_r/2+gantry_bearing_2_offset, t];
    gs = [s[0]-gap/2, s[1]-gap, s[2]];
    
    translate(goffsets) cube(gs);
    
    
    d=gantry_mount_bearing_extra;
    translate(offsets + [(gs[1]+s[1])/2-t, gap/2, t+d/2])
    bearing_slider(t, s, gs, offsets, goffsets, gap, d, true);
    translate(offsets + [(gs[1]+s[1])/2, gap/2, t+d/2])
    rotate([0, 0, 90]) bearing_slider(t, s, gs, offsets, goffsets, gap, d);
    
    //cube([s[0], gantry_bearing_r, gantry_mount_bearing_extra]);
    
    //translate(offsets+s) prism();
}

module bearing_slider(t, s, gs, offsets, goffsets, gap, d, r=false) {
    
    rotate([0, 90, 0])
    difference() {
        hull() {
            translate([0, d/2, 0]) cylinder(d=d, h=t);
            translate([r?-d/2:0, 0, 0]) cube([d/(r?1:2)+0.1, d, t]);
            translate([0, gs[1]-d/2, 0]) cylinder(d=d, h=t);
            translate([0, gs[1]-d, 0]) cube([d/2+0.1, d, t]);
        }
        #hull() {
            translate([0, d/2, t/2]) hole(d=gantry_bearing_id, h=t+0.1);
            translate([0, gs[1]-d/2, t/2]) hole(d=gantry_bearing_id, h=t+0.1);
        }
    }
}

module prism(l, w, h) {
    linear_extrude(h) polygon([[0, 0], [l, 0], [0, w]]);
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

module gantry_parts_flip(s) {
    translate([0, 0, 0]) scale([s, 1, 1]) motor_corner_bracket();
    translate([0, -200, 0]) scale([s, 1, 1]) corner_bracket();
    translate([0, -300, 0]) scale([s, 1, 1]) corner_bracket_under();
}

module gantry_parts() {
    translate([100, 0, 0]) gantry_parts_flip(1);
    translate([250, 0, 0]) gantry_parts_flip(-1);
}

module gantry_idler() {
    color("brown") cube([carriage_mount_thickness, 27, 20], center=true);
}

%gantry();

gantry_parts();