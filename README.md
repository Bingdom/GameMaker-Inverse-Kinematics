<h1 align="center">GMS Inverse Kinematics</h1>

![](https://github.com/Bingdom/GameMaker-Inverse-Kinematics/blob/main/github/intro-anim.gif)

## An inverse kinematics project for GameMaker Studio v2023.x!
This is a fairly small project. I hope someone finds it useful.
It includes a simple physics object that interacts with IK.

Most of the IK functionality is available in the ``ik_armature`` script.

### Getting started
To create an armature, you first need to generate an array of ``ik_point`` structs
```js
// Generate a list of points
var points = []
var pos = {x: x, y: y};
var point_count = irandom_range(4, 6);

for (var i=0; i<point_count; i++) {
	var len = irandom_range(20, 80);
	if (i==0) {
		//Set our initial direction instead for first point
		ang = irandom_range(-180, 180);
	} else {
		// Set the point as an offset from the previous point
		ang += irandom_range(-60, 60);
		pos = {x: pos.x + lengthdir_x(len, ang), y: pos.y + lengthdir_y(len, ang)};
	}
	
	array_push(points, new ik_point(pos.x, pos.y, len))
}
// My armature is created here:
armature = new ik_armature(points);
```

The positions don't really matter that much. You can just worry about the ``length`` argument, and then calculate for it to choose the positions for you.

Then you can calculate the point locations by calling this method
```js
armature.calculate({x: room_width/2, y: room_height/2}, {x: mouse_x, y: mouse_y});
```
