
//function collision_static() {
//	// check for collisions based on current position - make adjustments to boundaries
	
//	// Assumes that all objects in collision detection are square
//	var _tolerance = 0.5;

//	// if we have bottom collision on multiple boxes, we want to match bottom of character to top of lowest box
//	var _character_bottom = -1;

//	// iteratively check each instance of solid surface for collision
//	for (var _i=0; _i<instance_number(obj_solid_surface); ++_i) {

//		// get current instance of the solid boundary object
//		var _current = instance_find(obj_solid_surface, _i);
		
//		// initialise sprite to be non-collided wall
//		_current.sprite_index  = spr_wall1;
		
//		// initialise if there is collision for this block
//		var _collision_l = false;
//		var _collision_r = false;
//		var _collision_t = false;
//		var _collision_b = false;
		
//		// check if there is collision initially on each corner
//		var _collision_lt = point_in_rectangle(bbox_left, bbox_top, _current.bbox_left, _current.bbox_top, _current.bbox_right, _current.bbox_bottom);;
//		var _collision_lb = point_in_rectangle(bbox_left, bbox_bottom, _current.bbox_left, _current.bbox_top, _current.bbox_right, _current.bbox_bottom);;
//		var _collision_rt = point_in_rectangle(bbox_right, bbox_top, _current.bbox_left, _current.bbox_top, _current.bbox_right, _current.bbox_bottom);;
//		var _collision_rb = point_in_rectangle(bbox_right, bbox_bottom, _current.bbox_left, _current.bbox_top, _current.bbox_right, _current.bbox_bottom);;
		
//		// check static collisions on each side
//		if (_collision_lb) or (_collision_lt) {
//			_collision_l = true
//		}
//		if (_collision_rb) or (_collision_rt) {
//			_collision_r = true;
//		}
//		if (_collision_lb) or (_collision_rb) {
//			_collision_b = true;
//			_character_bottom = max(_character_bottom, _current.bbox_top)
//		}
//		//if () or () {
			
//		//}
		
//		if (_collision_l) and (!_collision_b) and (!_collision_t) {
//			_current.sprite_index  = spr_collision_l;
//		} else if (_collision_r) and (!_collision_b) and (!_collision_t) {
//			_current.sprite_index  = spr_collision_r;
//		} else if (_collision_l) and (_collision_b) {
//			_current.sprite_index  = spr_collision_BL;
//		} else if (_collision_r) and (_collision_b) {
//			_current.sprite_index  = spr_collision_BR;
//		}
//	}
	
	
//	if (_character_bottom >= 0) {
//		y = _character_bottom - (sprite_height/2);
//	}

//}


function move_collide(_hvel, _vvel) {

	/// Assumes that all objects in collision detection are square
	var _tol = 0.5;

	// call function for left collision
	var _player_x_min = check_left_collision(_hvel);
	var _player_x_max = check_right_collision(_hvel);
	var _player_y_min = check_top_collision(_vvel);
	var _player_y_max = check_bottom_collision(_vvel);

	// if we had any left or right collision, modify position accordingly
	if (_player_x_min >= 0) {
		x = _player_x_min + (sprite_width/2) + _tol;
	} else if (_player_x_max >= 0) {
		x = _player_x_max - (sprite_width/2) - _tol;
	} else {
		x += _hvel;
	}
	
	// if we had any top or bottom collision, modify position accordingly
	if (_player_y_min >= 0) {
		y = _player_y_min + (sprite_height/2) + _tol;
	} else if (_player_y_max >= 0) {
		y = _player_y_max - (sprite_height/2) - _tol;
	} else {
		y += _vvel;
	}
	
	return;
}



function check_left_collision(_hvel) {
	// If no collision, return -1.
	// If collision, returns the right-most extent of bbox of colliding boundary.
	
	// check for positive horizontal velocity before continuing
	if (_hvel > 0.) {
		return -1;
	
	// 
	} else {
	
		// set a tolerance value
		var _tol = 0.5
		
		// initialise right-most extent of bbox of colliding boundary.
		var _x_collide = -1;
	
		// iteratively check each instance of solid surface for collision
		for (var _i=0; _i<instance_number(obj_solid_surface); ++_i) {

			// get current instance of the solid boundary object
			var _current = instance_find(obj_solid_surface, _i);
		
			// only check this boundary object if within reasonable distance of player
			if (sqrt(power((x-_current.x), 2) + power(y-_current.y, 2)) < sqrt(sprite_width*sprite_height)*2.5) {
				
				// iteratively check for intersection of boundary and left extent
				for (var _j=bbox_top; _j<=bbox_bottom; ++_j) {
					if (do_intersect(bbox_left, _j, bbox_left+_hvel, _j, _current.bbox_right, _current.bbox_top+_tol, _current.bbox_right, _current.bbox_bottom-_tol)) {
						_x_collide = max(_x_collide, _current.bbox_right);
					}
				}
			}
		}
		
		// if nothing collided, return -1, otherwise return the right-most extent of bbox of colliding boundary.
		if (_x_collide < 0) {
			return -1;
		} else {
			return _x_collide;
		}
	}
}


function check_right_collision(_hvel) {
	// If no collision, return inf.
	// If collision, returns the right-most extent of bbox of colliding boundary.
	
	// check for negative horizontal velocity before continuing
	if (_hvel < 0.) {
		return -1;
	
	// 
	} else {
	
		// set a tolerance value
		var _tol = 0.5
		
		// initialise right-most extent of bbox of colliding boundary.
		var _x_collide = infinity;
	
		// iteratively check each instance of solid surface for collision
		for (var _i=0; _i<instance_number(obj_solid_surface); ++_i) {

			// get current instance of the solid boundary object
			var _current = instance_find(obj_solid_surface, _i);
		
			// only check this boundary object if within reasonable distance of player
			if (sqrt(power((x-_current.x), 2) + power(y-_current.y, 2)) < sqrt(sprite_width*sprite_height)*2.5) {
				
				// iteratively check for intersection of boundary and left extent
				for (var _j=bbox_top; _j<=bbox_bottom; ++_j) {
					if (do_intersect(bbox_right, _j, bbox_right+_hvel, _j, _current.bbox_left, _current.bbox_top+_tol, _current.bbox_left, _current.bbox_bottom-_tol)) {
						_x_collide = min(_x_collide, _current.bbox_left);
					}
				}
			}
		}
		
		// if nothing collided, return -1, otherwise return the right-most extent of bbox of colliding boundary.
		if (_x_collide == infinity) {
			return -1;
		}
		return _x_collide;
	}
}


function check_bottom_collision(_vvel) {
	// if velocity negative or zero, cant collide so return -1 for no collision
	if (_vvel <= 0.) {
		return -1;
	} else {
	
		// set a tolerance value
		var _tol = 0.5
		
		// initialise top-most extent of bbox of colliding boundary.
		var _y_collide = infinity;
	
		// iteratively check each instance of solid surface for collision
		for (var _i=0; _i<instance_number(obj_solid_surface); ++_i) {

			// get current instance of the solid boundary object
			var _current = instance_find(obj_solid_surface, _i);
		
			// only check this boundary object if within reasonable distance of player
			if (sqrt(power((x-_current.x), 2) + power(y-_current.y, 2)) < sqrt(sprite_width*sprite_height)*2.5) {
				
				// iteratively check for intersection of boundary and left extent
				for (var _j=bbox_left; _j<=bbox_right; ++_j) {
					if (do_intersect(_j, bbox_bottom, _j, bbox_bottom+_vvel, _current.bbox_left+_tol, _current.bbox_top, _current.bbox_right-_tol, _current.bbox_top)) {
						_y_collide = min(_y_collide, _current.bbox_top);
					}
				}
			}
		}
		
		// if nothing collided, return -1, otherwise return the top-most extent of bbox of colliding boundary.
		if (_y_collide == infinity) {
			return -1;
		} else {
			return _y_collide;
		}
	}
}


function check_top_collision(_vvel) {
	// if velocity positive, cant collide so return -1
	if (_vvel > 0.) {
		return -1;
	} else {
	
		// set a tolerance value
		var _tol = 0.5
		
		// initialise top-most extent of bbox of colliding boundary.
		var _y_collide = -infinity;
	
		// iteratively check each instance of solid surface for collision
		for (var _i=0; _i<instance_number(obj_solid_surface); ++_i) {

			// get current instance of the solid boundary object
			var _current = instance_find(obj_solid_surface, _i);
		
			// only check this boundary object if within reasonable distance of player
			if (sqrt(power((x-_current.x), 2) + power(y-_current.y, 2)) < sqrt(sprite_width*sprite_height)*2.5) {
				
				// iteratively check for intersection of boundary and left extent
				for (var _j=bbox_left; _j<=bbox_right; ++_j) {
					if (do_intersect(_j, bbox_top, _j, bbox_top+_vvel, _current.bbox_left+_tol, _current.bbox_bottom, _current.bbox_right-_tol, _current.bbox_bottom)) {
						_y_collide = max(_y_collide, _current.bbox_bottom);
					}
				}
			}
		}
		
		// if nothing collided, return -1, otherwise return the top-most extent of bbox of colliding boundary.
		if (_y_collide == -infinity) {
			return -1;
		} else {
			return _y_collide;
		}
	}
}



function linspace(_start, _stop, _n)
/// @func _linspace(start, stop, n)
/// @desc Generates a specified number of equally-spaced values within a specified range.
/// @param {real} start - First value of array.
/// @param {real} stop - Last value of array.
/// @param {int} n - Number of values in array. Must be at least 2 (unless the endpoints are equal).
/// @return {real[]} An array with first value start, final value stop, and a total of n elements (or empty array in case of error).

{
	// Verify that number of elements is valid
	if (_n < 2)
	{
		// n=1 is allowed only if the endpoints are equal
		if ((_start == _stop) && (_n == 1))
			return [_start];
		
		// Otherwise we return an empty array
		return [];
	}
	
	// Determine step size
	var _step = (_stop - _start)/(_n - 1);
	
	// Generate array
	var _arr = array_create(_n);
	for (var _i = 0; _i < _n-1; _i++)
		_arr[_i] = _start + _i*_step;
	_arr[_n-1] = _stop; // ensure that final value is exact
	
	return _arr;
}


function on_segment(_p_x, _p_y, _q_x, _q_y, _r_x, _r_y) {
	// Given three collinear points p, q, r, the function checks if point q lies on line segment 'pr'  
    if (_q_x <= max(_p_x, _r_x)) and (_q_x >= min(_p_x, _r_x)) and (_q_y <= max(_p_y, _r_y)) and (_q_y >= min(_p_y, _r_y)) {
        return true;
	}
    return false;
}


function orientation(_p_x, _p_y, _q_x, _q_y, _r_x, _r_y) {
    // to find the orientation of an ordered triplet (p,q,r) 
    // function returns the following values: 
    // 0 : Collinear points 
    // 1 : Clockwise points 
    // 2 : Counterclockwise  
    var _val = ((_q_y-_p_y)*(_r_x-_q_x))-((_q_x-_p_x)*(_r_y-_q_y)); 
    if (_val > 0) {
        return 1;
	} else if (_val < 0) {
        return 2;
	} else {
        return 0;
	}
}
  

function do_intersect(_p1_x, _p1_y, _q1_x, _q1_y, _p2_x, _p2_y, _q2_x, _q2_y) {
	// The main function that returns true if the line segment 'p1q1' and 'p2q2' intersect. 
      
    // find the 4 orientations required for the general and special cases 
    var _o1 = orientation(_p1_x, _p1_y, _q1_x, _q1_y, _p2_x, _p2_y);
    var _o2 = orientation(_p1_x, _p1_y, _q1_x, _q1_y, _q2_x, _q2_y); 
    var _o3 = orientation(_p2_x, _p2_y, _q2_x, _q2_y, _p1_x, _p1_y); 
    var _o4 = orientation(_p2_x, _p2_y, _q2_x, _q2_y, _q1_x, _q1_y); 
  
    // general case 
    if (_o1!=_o2) and (_o3 != _o4) { 
        return true;
	}
	
    // special case: p1 , q1 and p2 are collinear and p2 lies on segment p1q1 
    if (_o1 == 0) and (on_segment(_p1_x, _p1_y, _p2_x, _p2_y, _q1_x, _q1_y)) { 
        return true;
	}
  
    // special case: p1, q1 and q2 are collinear and q2 lies on segment p1q1 
    if (_o2 == 0) and (on_segment(_p1_x, _p1_y, _q2_x, _q2_y, _q1_x, _q1_y)) { 
        return true;
	}
  
    // special case: p2, q2 and p1 are collinear and p1 lies on segment p2q2 
    if (_o3 == 0) and (on_segment(_p2_x, _p2_y, _p1_x, _p1_y, _q2_x, _q2_y)) {
        return true;
	}
  
    //# p2 , q2 and q1 are collinear and q1 lies on segment p2q2 
    if (_o4 == 0) and (on_segment(_p2_x, _p2_y, _q1_x, _q1_y, _q2_x, _q2_y)) { 
        return true;
	}
  
    //# If none of the cases 
    return false;

}