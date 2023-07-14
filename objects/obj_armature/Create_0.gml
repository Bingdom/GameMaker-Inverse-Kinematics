///@description Initialization

randomize();

#region IK setup
// Generate a random armature
var points = []
var pos = {x: x, y: y};
var point_count = irandom_range(4, 6);
for (var i=0; i<point_count; i++) {
	var len = irandom_range(20, 80);
	if (i==0) {
		//Set our initial direction instead for first point
		ang = irandom_range(-180, 180);
	} else {
		// Set the point somewhere else
		ang += irandom_range(-60, 60);
		pos = {x: pos.x + lengthdir_x(len, ang), y: pos.y + lengthdir_y(len, ang)};
	}
	
	array_push(points, new ik_point(pos.x, pos.y, len))
}
armature = new ik_armature(points);
#endregion

#region IK Interaction (up to you how you want it set it up)
//* Settings for clicking */ 
point_range = 16; //Range for clicking on IK points to drag around
point_clicked = false;
point_other_end = {x: 0, y: 0}

//* Distance Calculation */
point_at = [0,0];
point_at_clicked = false;
#endregion