function move_snake_head(_target_x, _target_y) {
	// move snake head towards a target location

	// distance to target
	var _distance_to_target = point_distance(x, y, _target_x, _target_y)

	// move towards mouse if within a certain distance
	if (_distance_to_target > target_distance) {
	
		// get the direction of vector between target and current position
		var _direction_to_move = point_direction(x, y, _target_x, _target_y);

		// 

		// set speed of movement - further away means faster, up to terminal
		//hspeed = clamp(global.snake_speed*0.001*power(_distance_to_target, 2), 0., global.snake_terminal_speed)
		//vspeed = clamp(global.snake_speed*0.001*power(_distance_to_target, 2), 0., global.snake_terminal_speed)

		// assign motion to target location
		//hspeed = 0.1;
		//vspeed = 0.1;
		//move_and_collide(0.0001*(_target_x-x), 0.0001*(_target_y-y), obj_solid_surface, 10);
		move_towards_point(_target_x, _target_y, global.snake_speed)
	
	
	// if too closey, stop moving
	} else {
		speed = 0.;	
	}	
}


function move_snake_body() {
	// move main body component of snake - all behave similarly
	
	// set distance to target location
	var _target_distance = parent.sprite_width * global.snake_separation;

	// set distance to parent body component
	var _parent_distance = point_distance(x, y, parent.x, parent.y)
	
	// move towards parent if within a certain distance
	if (_parent_distance > _target_distance) {
		move_towards_point(parent.x, parent.y, global.snake_speed)
	
	// otherwise, set speed to zero so it stops moving
	} else {
		speed = 0.;	
	}
}


function move_snake_foot() {

	// calculate angle based on relative positions of parent and child body parts of parent of foot
	theta = arctan2(parent.parent.y - parent.child.y, parent.parent.x - parent.child.x);

	// calculate optimal foot placement based on current body position
	if (type == "left") {
		x_optimal = parent.x + global.snake_leg_length * cos(theta + global.snake_leg_angle);
		y_optimal = parent.y + global.snake_leg_length * sin(theta + global.snake_leg_angle);
	} else if (type == "right") {
		x_optimal = parent.x + global.snake_leg_length * cos(theta - global.snake_leg_angle);
		y_optimal = parent.y + global.snake_leg_length * sin(theta - global.snake_leg_angle);
	}

	// calculate distance from foot to the optimal position
	distance_from_foot_to_optimal = point_distance(x, y, x_optimal, y_optimal);
	
	// calculate distance from foot to the target position
	distance_from_foot_to_target = point_distance(x, y, x_target, y_target);

	if (distance_from_foot_to_target < 5) {
		in_motion = false;
	}
	
	// if distance exceed leg length, set foot in motion and set target location 
	if (distance_from_foot_to_optimal > global.snake_leg_length) {
		in_motion = true;
		x_target = x_optimal;
		y_target = y_optimal;
	}
	
	if (in_motion) {
		
		//hspeed = 2.;
		//vspeed = 2.;
		//move_and_collide(x_target-x, y_target-y, obj_solid_surface)
		move_towards_point(x_target, y_target, global.snake_leg_speed)		
		
	} else {
		speed = 0.;
	}
}
