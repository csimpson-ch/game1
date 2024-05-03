/// @description

// set some global snake variables
global.snake_acceleration = 0.25;
global.snake_speed = 2.;
global.snake_terminal_speed = 2.;
global.snake_separation = 1.1;
global.snake_leg_length = 50.;
global.snake_leg_angle = pi/5.;
global.snake_leg_speed = 4.;
global.snake_max_width = 20;
global.snake_node_size = 30;
global.snake_node_count_cap = 500;



snake_texture = sprite_get_texture(SnakeTexture, 0);
body_width = 16;
leg_width = 4;

// set some other properties of snake
friction = 0.0
gravity = 0.0;

// set target distance to target before slowing down
target_distance = 30.;

// create an instance of each part of body
instance_body1 = instance_create_depth(x-10, y, depth, obj_snake_body1);
instance_body1_foot_left = instance_create_depth(x, y+10, depth, obj_snake_foot_left);
instance_body1_foot_right = instance_create_depth(x, y+10, depth, obj_snake_foot_right);
instance_body2 = instance_create_depth(x-20, y, depth, obj_snake_body2);
instance_body3 = instance_create_depth(x-30, y, depth, obj_snake_body3);
instance_body4 = instance_create_depth(x-40, y, depth, obj_snake_body4);
instance_body5 = instance_create_depth(x-50, y, depth, obj_snake_body5);
instance_body6 = instance_create_depth(x-60, y, depth, obj_snake_body6);
instance_body6_foot_left = instance_create_depth(x-50, y-10, depth, obj_snake_foot_left);
instance_body6_foot_right = instance_create_depth(x-50, y+10, depth, obj_snake_foot_right);
instance_body7 = instance_create_depth(x-70, y, depth, obj_snake_body7);
instance_body8 = instance_create_depth(x-80, y, depth, obj_snake_body8);
instance_body9 = instance_create_depth(x-90, y, depth, obj_snake_body9);
instance_body10 = instance_create_depth(x-100, y, depth, obj_snake_body10);

// create array containing widths of each part
body_widths = [12, 8, 14, 18, 108, 18, 12, 8, 4, 4];


// set relationship between body parts
instance_body1.parent = id;
instance_body1.child = instance_body2.id;
instance_body1.foot_left = instance_body1_foot_left.id;
instance_body1.foot_right = instance_body1_foot_right.id;
instance_body1_foot_left.parent = instance_body1.id;
instance_body1_foot_right.parent = instance_body1.id;
instance_body2.parent = instance_body1.id;
instance_body3.parent = instance_body2.id;
instance_body4.parent = instance_body3.id;
instance_body5.parent = instance_body4.id;
instance_body6.parent = instance_body5.id;
instance_body6.child = instance_body7.id;
instance_body6.foot_left = instance_body6_foot_left.id;
instance_body6.foot_right = instance_body6_foot_right.id;
instance_body6_foot_left.parent = instance_body6.id;
instance_body6_foot_right.parent = instance_body6.id;
instance_body7.parent = instance_body6.id;
instance_body8.parent = instance_body7.id;
instance_body9.parent = instance_body8.id;
instance_body10.parent = instance_body9.id;


// set additional useful variables for feet
instance_body1_foot_left.type = "left";
instance_body1_foot_left.x_target = instance_body1_foot_left.x;
instance_body1_foot_left.y_target = instance_body1_foot_left.y;
instance_body1_foot_left.in_motion = false;
instance_body1_foot_right.type = "right";
instance_body1_foot_right.x_target = instance_body1_foot_right.x;
instance_body1_foot_right.y_target = instance_body1_foot_right.y;
instance_body1_foot_right.in_motion = false;
instance_body6_foot_left.type = "left";
instance_body6_foot_left.x_target = instance_body6_foot_left.x;
instance_body6_foot_left.y_target = instance_body6_foot_left.y;
instance_body6_foot_left.in_motion = false;
instance_body6_foot_right.type = "right";
instance_body6_foot_right.x_target = instance_body6_foot_right.x;
instance_body6_foot_right.y_target = instance_body6_foot_right.y;
instance_body6_foot_right.in_motion = false;


// create an initial body path
body_path = path_add();
path_add_point(body_path, x, y, global.snake_speed)
path_add_point(body_path, instance_body1.x, instance_body1.y, global.snake_speed)
path_add_point(body_path, instance_body2.x, instance_body2.y, global.snake_speed)
path_add_point(body_path, instance_body3.x, instance_body3.y, global.snake_speed)
path_add_point(body_path, instance_body4.x, instance_body4.y, global.snake_speed)
path_add_point(body_path, instance_body5.x, instance_body5.y, global.snake_speed)
path_add_point(body_path, instance_body6.x, instance_body6.y, global.snake_speed)
path_add_point(body_path, instance_body7.x, instance_body7.y, global.snake_speed)
path_add_point(body_path, instance_body8.x, instance_body8.y, global.snake_speed)
path_add_point(body_path, instance_body9.x, instance_body9.y, global.snake_speed)
path_add_point(body_path, instance_body10.x, instance_body10.y, global.snake_speed)
path_set_closed(body_path, false);


// create another path for front feet
body1_feet_path = path_add();
path_add_point(body1_feet_path, instance_body1_foot_left.x, instance_body1_foot_left.y, global.snake_speed)
path_add_point(body1_feet_path, instance_body1.x, instance_body1.y, global.snake_speed)
path_add_point(body1_feet_path, instance_body1_foot_right.x, instance_body1_foot_right.y, global.snake_speed)
path_set_closed(body1_feet_path, false);


// create another path for back feet
body6_feet_path = path_add();
path_add_point(body6_feet_path, instance_body6_foot_left.x, instance_body6_foot_left.y, global.snake_speed)
path_add_point(body6_feet_path, instance_body6.x, instance_body6.y, global.snake_speed)
path_add_point(body6_feet_path, instance_body6_foot_right.x, instance_body6_foot_right.y, global.snake_speed)
path_set_closed(body6_feet_path, false);

// set properties needed to path to player
player_id_a = instance_nearest(x, y, obj_player);
snake_path_to_target = pathing_astar(x, y, player_id_a.x, player_id_a.y, global.snake_node_size, global.snake_node_count_cap);
snake_frames_between_path = 30;
snake_frames_to_next_path = snake_frames_between_path;