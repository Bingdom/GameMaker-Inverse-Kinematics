var col = merge_color(c_aqua, c_blue, 0.5);

armature.draw(col, c_aqua);

if (point_at_clicked) {
	draw_line(point_at[0], point_at[1], mouse_x, mouse_y);
	draw_text(mouse_x, mouse_y-16, point_distance(point_at[0], point_at[1], mouse_x, mouse_y));
}