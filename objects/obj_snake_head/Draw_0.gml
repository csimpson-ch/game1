/// @description Insert description here
// You can write your code in this editor


draw_path(snake_path_to_target, x, y, true);
//draw_path(body1_feet_path, instance_body1_foot_left.x, instance_body1_foot_left.y, false);

draw_set_color(c_white);


// create polygons for body
draw_primitive_begin_texture(pr_trianglestrip, snake_texture);
for (i=0; i<1; i+=0.01) {
	
	px = path_get_x(body_path, i);
	py = path_get_y(body_path, i);

	nx = path_get_x(body_path, i+0.01);
	ny = path_get_y(body_path, i+0.01);

	d = point_direction(px, py, nx, ny) + 90;
	l = body_width / 2;

	vx = lengthdir_x(l, d);
	vy = lengthdir_y(l, d);

	draw_vertex_texture(px+vx, py+vy, i, 0);
	draw_vertex_texture(px-vx, py-vy, i, 1);
}
draw_primitive_end()


// create polygons for front feet
draw_primitive_begin_texture(pr_trianglestrip, snake_texture);
for (i=0; i<1; i+=0.01) {
	
	px = path_get_x(body1_feet_path, i);
	py = path_get_y(body1_feet_path, i);

	nx = path_get_x(body1_feet_path, i+0.01);
	ny = path_get_y(body1_feet_path, i+0.01);

	d = point_direction(px, py, nx, ny) + 90;
	l = leg_width / 2;

	vx = lengthdir_x(l, d);
	vy = lengthdir_y(l, d);

	draw_vertex_texture(px+vx, py+vy, i, 0);
	draw_vertex_texture(px-vx, py-vy, i, 1);
}
draw_primitive_end()


// create polygons for back feet
draw_primitive_begin_texture(pr_trianglestrip, snake_texture);
for (i=0; i<1; i+=0.01) {
	
	px = path_get_x(body6_feet_path, i);
	py = path_get_y(body6_feet_path, i);

	nx = path_get_x(body6_feet_path, i+0.01);
	ny = path_get_y(body6_feet_path, i+0.01);

	d = point_direction(px, py, nx, ny) + 90;
	l = leg_width / 2;

	vx = lengthdir_x(l, d);
	vy = lengthdir_y(l, d);

	draw_vertex_texture(px+vx, py+vy, i, 0);
	draw_vertex_texture(px-vx, py-vy, i, 1);
}
draw_primitive_end()