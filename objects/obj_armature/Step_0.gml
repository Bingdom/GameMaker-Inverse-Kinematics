///@description Control points


if mouse_check_button_pressed(mb_left) {
	var end_point = armature.point_end();
	var ini_point = armature.point_start();
	if (point_range > point_distance(mouse_x, mouse_y, end_point.x, end_point.y)) {
		point_clicked = 2;
		point_other_end = {x: ini_point.x, y: ini_point.y}
	} else if (point_range > point_distance(mouse_x, mouse_y, ini_point.x, ini_point.y)) {
		point_clicked = 1;
		point_other_end = {x: end_point.x, y: end_point.y}
	} else {
		point_clicked = false;	
	}
	
}

if mouse_check_button(mb_left) {
	var new_point;
	switch(point_clicked) {
		case 1:
			new_point = {x: mouse_x, y: mouse_y};
			armature.calculate(new_point, point_other_end);
		break;
		
		case 2:
			new_point = {x: mouse_x, y: mouse_y};
			armature.calculate(point_other_end, new_point);
		break;
	}
}

if mouse_check_button_released(mb_left) {
	if (point_clicked) {
		show_debug_message("Released point");
	}
	point_clicked = false;
	
}

if mouse_check_button_pressed(mb_right) {
	point_at = [mouse_x, mouse_y];
	point_at_clicked = true;
}

if mouse_check_button_released(mb_right) {
	point_at_clicked = false;
}