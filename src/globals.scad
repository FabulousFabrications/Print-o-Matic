$fs=0.75;

width = 650;
length = 580;
height = 1060;
rail_length = 450;

bed_width = 500;
bed_length = 500;

//hole size for t-slot bolt/nuts for gantry
gantry_hole_d=5;
gantry_nema_hole_d=4;

profile_type=0;//0 = aluminium extrusion, 1=box section
profile_width=30;
profile_thickness=2.5;//only used for box section
corner_size=profile_type==0?profile_width:0;
vertical_extrusion_height = height-corner_size;
top_frame_height=profile_width;
bottom_frame_height=profile_width;
inner_frame_height = height - bottom_frame_height - top_frame_height;
carriage_mount_thickness = 4;

gantry_profile_width=20;
gantry_offset = profile_width + gantry_profile_width/2 + 15;
gantry_width = width-2*(carriage_mount_thickness+gantry_offset-gantry_profile_width/2+13+gantry_profile_width);
gantry_length = length-profile_width*2;
// thickness of plastic parts for mounting things to gantry
gantry_mount_thickness = 4;
gantry_bearing_od=16;
gantry_bearing_id=5;
gantry_bearing_r=5;

z_screw_offset=profile_width*4;

module print() {
    color("purple") children();
}