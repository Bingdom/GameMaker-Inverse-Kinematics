/**
* Copyright 2023 James Morrow (Bingdom)

* Permission is hereby granted, free of charge, to any person obtaining a copy of this software 
* and associated documentation files (the “Software”), to deal in the Software without restriction, 
* including without limitation the rights to use, copy, modify, merge, publish, distribute, 
* sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is 
* furnished to do so, subject to the following conditions:

* The above copyright notice and this permission notice shall be included in all copies or 
* substantial portions of the Software.

* THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING 
* BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND 
* NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, 
* DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, 
* OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/

/// @desc Create an IK armature
/// @param {Array<Struct.ik_points>} points A collection of points to build this armature from. First point doesn't contribute to length
function ik_armature(points) constructor {
	tolerance = 0.025; // Position threshold for each point during calculation. The lower, the more precise. But more iterations may occur.
	self.points = points;
	
	// If only there was getters :(
	length = function() {
		return array_reduce(points, function(prev, point) {
			return prev + point.length
		}, 0, 1) // First point doesn't contribute to length 
	}
	
	point_push = function(point) {
		array_push(points, point)
	}
	
	point_insert = function(point, index) {
		array_insert(points, index, point);
	}
	
	point_remove = function(index) {
		array_delete(points, index, 1);
	}
	
	point_start = function() {
		return points[0]	
	}
	
	point_end = function() {
		return points[array_length(points)-1];	
	}

	calculate = function(start_pos, end_pos) {
		//Uses the FABRIK technique

		//Check if we have enough length
		if (length() >= point_distance(start_pos.x, start_pos.y, end_pos.x, end_pos.y)) {
			// Enough length to do calculations
			// Check against our threshold
			// Update end point coords for while loop
	
			var c=0;
			while ((point_distance(start_pos.x, start_pos.y, point_start().x, point_start().y)) >= tolerance ||
				   point_distance(end_pos.x, end_pos.y, point_end().x, point_end().y) >= tolerance) && c<1000 {
		
				//Start from the end point, move it to the target (end - start)
				for(var i=array_length(points)-1; i>=0; --i) {
					if (i == array_length(points)-1) {
						//Set armature end point to the new end point
						var point = points[i];
						
						point.x = end_pos.x;
						point.y = end_pos.y;
					} else {
						//Move with the length in consideration
						var point = points[i];
						var point_next = points[i+1];
				
						var next_point_dir = point_direction(point.x, point.y, point_next.x, point_next.y);
						// Update armature
						point.x = point_next.x + lengthdir_x(point_next.length, next_point_dir + 180)
						point.y = point_next.y + lengthdir_y(point_next.length, next_point_dir + 180);
					}
				}		
						
				//Now do the same, but in the opposite direction (start - end)
				for(var i=0; i<array_length(points); i++) {
					if (i == 0) {
						//Set armature end point to the new end point
						var point = points[i];
						
						point.x = start_pos.x;
						point.y = start_pos.y;
					} else {
						//Move with the length in consideration
						var point = points[i];
						var point_prev = points[i-1];
				
						var next_point_dir = point_direction(point_prev.x, point_prev.y, point.x, point.y);
						
						// Update armature
						point.x = point_prev.x + lengthdir_x(point.length, next_point_dir);
						point.y = point_prev.y + lengthdir_y(point.length, next_point_dir);
					}
				}
		
				c++;
			}
			//show_debug_message("Iteration for IK: " + string(c));
		} else {
			//show_debug_message("Points too far");
			// We'll just make it straight
	
			var end_point_dir = point_direction(start_pos.x, start_pos.y, end_pos.x, end_pos.y);
			
			points[0].x = start_pos.x;
			points[0].y = start_pos.y;
	
			for(var i=1; i<array_length(points); i++) {
				
				var p1 = points[i-1],
					p2 = points[i];
					
				p2.x = p1.x + lengthdir_x(p2.length, end_point_dir);
				p2.y = p1.y + lengthdir_y(p2.length, end_point_dir);
			}
	
		}
	}
	
	draw = function(col_start, col_end) {
		if (array_length(points) <= 1) {
			show_debug_message("Armature is too short to render")
			if (array_length(points) == 1) {
				draw_circle(points[0].x,points[0].y,8,c_red);
			}
			return
		}
		
		draw_circle_color(points[0].x, points[0].y, 12, col_start, col_start, true);
		
		for(var i=1; i<array_length(points); i++) {
			var p1 = points[i-1];
			var p2 = points[i];
			var p3 = {
				x: lerp(p1.x, p2.x, 0.5),
				y: lerp(p1.y, p2.y, 0.5)
			}
			draw_line_color(p1.x, p1.y, p2.x, p2.y, c_white, c_white);
			draw_circle_color(p2.x, p2.y, 8, c_white, c_white, true);
			
			//draw_text(p3.x, p3.y, points[i].length)
		}
		
		var endpoint = points[array_length(points)-1];
		draw_circle_color(endpoint.x, endpoint.y, 8, col_end, col_end, true);
	}
}

function ik_point(x, y, length) constructor {
	self.length = length;
	self.x = x;
	self.y = y;
	
	function set_pos(x, y) {
		self.x = x;
		self.y = y;
	}
}
