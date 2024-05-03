/// @description Insert description here
// You can write your code in this editor

draw_set_font(Font1)
draw_set_colour(c_black);
//draw_text(x, y+20, instance_foot_left.theta)
draw_text(x, y, instance_player.is_on_floor)
draw_text(x, y+20, instance_player.is_jumping)
draw_text(x, y+40, instance_player.is_wall_grabbing)
//draw_text(x, y+20, instance_player.bbox_top)
//draw_text(x, y+40, instance_player.collision_state_start_of_frame)
//draw_text(x, y+60, instance_player.collision_state_end_of_frame)

