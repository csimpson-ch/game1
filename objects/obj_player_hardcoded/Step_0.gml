// Movement controls with collision detection
var _right_key = keyboard_check(vk_right);
var _left_key = keyboard_check(vk_left);
var _down_key = keyboard_check(vk_down);
var _up_key = keyboard_check(vk_up);
var _jump_key = keyboard_check_pressed(vk_space);
var _grab_key = keyboard_check_pressed(vk_shift);


// INCREMENT KEY PRESS COUNTERS
// ----------------------------

// right key
if (keyboard_check(vk_right)) {
	frames_right_key_pressed += 1;
} else {
	frames_right_key_pressed = 0;
}

// left key
if (keyboard_check(vk_left)) {
	frames_left_key_pressed += 1;
} else {
	frames_left_key_pressed = 0;
}

// jump key
if (keyboard_check(vk_space)) {
	frames_jump_key_pressed += 1;
} else {
	frames_jump_key_pressed = 0;
}


// SET HORIZONTAL MOVEMENT DIRECTION
// ---------------------------------

// set state for horizontal movement
var _move_right = false;
var _move_left = false;
if (frames_right_key_pressed > 0) and (frames_left_key_pressed == 0) {
	_move_right = true;
} else if (frames_right_key_pressed > 0) and (frames_left_key_pressed > 0) and (frames_right_key_pressed < frames_left_key_pressed) {
	_move_right = true;
} else if (frames_right_key_pressed == 0) and (frames_left_key_pressed > 0) {
	_move_left = true;
} else if (frames_right_key_pressed > 0) and (frames_left_key_pressed > 0) and (frames_right_key_pressed > frames_left_key_pressed) {
	_move_left = true;
}



// FREE MOVE HORIZONTAL
//---------------------
if (state_move==1) or (state_move==2) or (state_move==3) or (state_move==4) or (state_move==5) {

	// accelerate to right if moving that way or stationary, otherwise decelerate 
	if (_move_right) {
		sprite_index = spr_player_right;
		if (horizontal_velocity >= 0.) {
			horizontal_velocity = min(horizontal_velocity+horizontal_acceleration, horizontal_max_speed);
		} else {
			horizontal_velocity = max(horizontal_velocity-horizontal_deceleration, 0.);
		}

	// accelerate to left if moving that way or stationary, otherwise decelerate 
	} else if (_move_left) {
		sprite_index = spr_player_left;
		if (horizontal_velocity <= 0.) {	
			horizontal_velocity = max(horizontal_velocity-horizontal_acceleration, -1.*horizontal_max_speed);
		} else {
			horizontal_velocity = min(horizontal_velocity+horizontal_deceleration, 0.);
		}
	
	// decelerate if no key pressed
	} else if (!_move_right) and (!_move_left) {
		if (horizontal_velocity > 0.) {
			horizontal_velocity = max(horizontal_velocity - horizontal_deceleration, 0.);
		} else if (horizontal_velocity < 0.) {
			horizontal_velocity = min(horizontal_velocity + horizontal_deceleration, 0.);
		}
	}
	
	// check for a wall grab during horizontal movement
	is_wall_grabbing = false;
	if (can_wall_grab) {
		if (_move_right) and (check_right_collision(horizontal_velocity) >= 0) {
			is_wall_grabbing = true;
			state_move = 8;
		} else if (_move_left) and (check_left_collision(horizontal_velocity) >= 0) {
			is_wall_grabbing = true;
			state_move = 6;
		}
	}
	if (is_wall_grabbing) {
		state_move = 3
	}
}





// VERTICAL MOVEMENT
//--------------------

// on floor if there is bottom collision and not wall grabbing
is_on_floor = false;
if (check_bottom_collision(0.5) >= 0) and (!is_wall_grabbing) {
	is_on_floor = true;
}

// reset vertical velocity to zero if we are on the floor, otherwise add gravity
vertical_velocity += gravitational_acceleration;
if (is_on_floor) or (is_wall_grabbing) {
	vertical_velocity = 0;
	is_jumping = false;
}

// initiate a jump when on floor and jump key pressed
if (is_on_floor) and (keyboard_check(vk_space)) {
	is_jumping = true;
	frames_jump_key_pressed = 0;
	jump_counter = 1;
} else if (is_wall_grabbing) and (keyboard_check(vk_space)) {
	is_jumping = true;
	jump_counter = 1;
	frames_jump_key_pressed = 0;
	vertical_velocity += first_jump_acceleration[0]
	if (check_right_collision(horizontal_velocity) >= 0) {
		horizontal_velocity -= 50.;
	} else if (check_left_collision(horizontal_velocity) >= 0) {
		horizontal_velocity += 50.;
	}
}

// stop jump action if we let go of space
if (!keyboard_check(vk_space)) {
	is_jumping = false;
	frames_jump_key_pressed = 0;
}



// if we are actively jumping, increment frame counter to give different levels of jump height
if (is_jumping) and (keyboard_check(vk_space)) {
	frames_jump_key_pressed += 1;
	
	// add acceleration based on number of frames jump key held
	for (var _i=0; _i<array_length(first_jump_frames); _i++) {
		if (frames_jump_key_pressed == first_jump_frames[_i]) {
			vertical_velocity += first_jump_acceleration[_i];
		}
	}
}



// apply a terminal velocity cap for falling
vertical_velocity = min(vertical_velocity, terminal_velocity)


// APPLY MOVEMENT WITH COLLISION
// -----------------------------
move_collide(horizontal_velocity, vertical_velocity)


// cancel jump if a little upward movement would collide
if (check_top_collision(vertical_velocity) >= 0) {
	is_jumping = false;
	vertical_velocity = 0.;
}

