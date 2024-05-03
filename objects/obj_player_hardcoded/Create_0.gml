/// @description Insert description here
// You can write your code in this editor

// horizontal movement
horizontal_velocity = 0.;
horizontal_max_speed = 4.;
horizontal_acceleration = 0.2;
horizontal_deceleration = 0.05;



// vertical movement
vertical_velocity = 0.;
first_jump_acceleration = [-4.0, -3., -2.];
first_jump_frames = [1, 5, 10];
second_jump_acceleration = [-2.0];

gravitational_acceleration = 0.25;
terminal_velocity = 6.;
is_on_floor = false;
is_jumping = false;
coyote_frames = 2;
jump_counter = 0;


// special movement
can_double_jump = true;
can_wall_grab = true;

is_wall_grabbing = false;



// set initial movement state
state_move = 3;


frames_right_key_pressed = 0;
frames_left_key_pressed = 0;
frames_jump_key_pressed = 0;