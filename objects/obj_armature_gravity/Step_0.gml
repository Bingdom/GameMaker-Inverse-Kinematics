///@description Control points

#region Drag logic
if mouse_check_button_pressed(mb_left) {
	var end_point = armature.point_end();
	var ini_point = armature.point_start();
	if (point_range > point_distance(mouse_x, mouse_y, end_point.x, end_point.y)) {
		point_clicked = 2;
	} else if (point_range > point_distance(mouse_x, mouse_y, ini_point.x, ini_point.y)) {
		point_clicked = 1;
	} else {
		point_clicked = false;	
	}
	
}

if mouse_check_button(mb_left) {
	var new_point;
	switch(point_clicked) {
		case 1:
			new_point = {x: mouse_x, y: mouse_y};
			x = new_point.x;
			y = new_point.y;
			armature.calculate(new_point, armature.point_end());
		break;
		
		case 2:
			new_point = {x: mouse_x, y: mouse_y};
			armature.calculate({x:x, y:y}, new_point);
			
			ball_pos = new_point;
			hspd = 0;
			vspd = 0;
		break;
	}
}

if mouse_check_button_released(mb_left) {
	if (point_clicked) {
		show_debug_message("Released point");
	}
	point_clicked = false;
	
}
#endregion

#region Motion / Gravity logic
	// Need to create a copy so we don't edit the original struct
	// Need a copy so we can compare the calculated difference (and therefore, get our acceleration)
	ball_pos.x += hspd;
	ball_pos.y += vspd;
	
	armature.calculate({x: x, y: y}, ball_pos);
	
	//show_debug_message("Calculated delta: " + string({dx: armature.point_end().x - point_target.x, dy: armature.point_end().y - point_target.y}))
	hspd += (armature.point_end().x - ball_pos.x);
	vspd += (armature.point_end().y - ball_pos.y);
	
	hspd *= frict
	vspd *= frict
	
	// Finally, let's add our gravity
	vspd += grav;
#endregion