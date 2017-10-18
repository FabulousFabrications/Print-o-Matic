include <globals.scad>;

module 2Profile(width) {
    echo(str("BOM ",profile_width, "x", profile_width*2, "x", width,"mm extrusion"));
    translate([0, profile_width/2, 0]) Profile(width, false);
    translate([0, -profile_width/2, 0]) Profile(width, false);
}

module Profile2D() {
    if (profile_type == 0) {
        import(str("../dxf/", profile_width, "x", profile_width, ".dxf"));
    } else {
        difference() {
            square(profile_width, center=true);
            square(profile_width-profile_thickness*2, center=true);
        }
    }
}

module Profile(width, e=true) {
    if (e) {
        echo(str("BOM ",profile_width, "x", profile_width, "x", width,"mm extrusion"));
    }
    linear_extrude(width, center=true) Profile2D();
}

module 2020Profile(width) {
    echo(str("BOM ",gantry_profile_width, "x", gantry_profile_width, "x", width,"mm extrusion"));
    linear_extrude(width, center=true) import("../dxf/20x20.dxf");
}
