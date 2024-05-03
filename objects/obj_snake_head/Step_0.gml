/// @description Snake follows mouse

//move_snake_head(obj_player.x, obj_player.y)
//move_snake_head(mouse_x, mouse_y)

// reduce path frame counter by 1
snake_frames_to_next_path--;

// get a new path to start when frame counter hits zero
if (snake_frames_to_next_path == 0) {
	// delete existing path
	//path_delete(snake_path_to_target)
	
	// if clear line of sight to target, get optimal path
	var _is_clear_los = check_clear_los(x, y, player_id_a.x, player_id_a.y)
	
	if (_is_clear_los) {
		snake_path_to_target = pathing_astar(x, y, player_id_a.x, player_id_a.y, global.snake_node_size, global.snake_node_count_cap );
		// smooth this path
		path_set_precision(snake_path_to_target, 8);
		
		path_start(snake_path_to_target, global.snake_speed, path_action_stop, true);
	}
	
	// reset the frame counter to make another pathing decision
	snake_frames_to_next_path += snake_frames_between_path;
}

// modify path for body
path_change_point(body_path, 0, x, y, global.snake_speed)
path_change_point(body_path, 1, instance_body1.x, instance_body1.y, global.snake_speed)
path_change_point(body_path, 2, instance_body2.x, instance_body2.y, global.snake_speed)
path_change_point(body_path, 3, instance_body3.x, instance_body3.y, global.snake_speed)
path_change_point(body_path, 4, instance_body4.x, instance_body4.y, global.snake_speed)
path_change_point(body_path, 5, instance_body5.x, instance_body5.y, global.snake_speed)
path_change_point(body_path, 6, instance_body6.x, instance_body6.y, global.snake_speed)
path_change_point(body_path, 7, instance_body7.x, instance_body7.y, global.snake_speed)
path_change_point(body_path, 8, instance_body8.x, instance_body8.y, global.snake_speed)
path_change_point(body_path, 9, instance_body9.x, instance_body9.y, global.snake_speed)
path_change_point(body_path, 10, instance_body10.x, instance_body10.y, global.snake_speed)

// modify path for front feet
path_change_point(body1_feet_path, 0, instance_body1_foot_left.x, instance_body1_foot_left.y, global.snake_speed)
path_change_point(body1_feet_path, 1, instance_body1.x, instance_body1.y, global.snake_speed)
path_change_point(body1_feet_path, 2, instance_body1_foot_right.x, instance_body1_foot_right.y, global.snake_speed)

// modify path for front feet
path_change_point(body6_feet_path, 0, instance_body6_foot_left.x, instance_body6_foot_left.y, global.snake_speed)
path_change_point(body6_feet_path, 1, instance_body6.x, instance_body6.y, global.snake_speed)
path_change_point(body6_feet_path, 2, instance_body6_foot_right.x, instance_body6_foot_right.y, global.snake_speed)


