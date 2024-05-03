function check_clear_los(_character_x, _character_y, _target_x, _target_y) {
	/// checks for clear line of sight by interpolating points and checking collision
	/// Return: true if clear line of sight, otherwise false
	var _x_linterp = _linspace(_character_x, _target_x, int64(point_distance(_character_x, _character_y, _target_x, _target_y)));
	var _y_linterp = [];
	for (var _i = 0; _i < array_length(_x_linterp); _i++) {
		_y_linterp[_i] = (_character_y * (_target_x - _x_linterp[_i]) + _target_y * (_x_linterp[_i] - _character_x)) / (_target_x - _character_x)
		if (place_meeting(_x_linterp[_i], _y_linterp[_i], obj_solid_surface)) {
			return false;
		}
	}
	return true;
}



function pathing_astar(_character_x, _character_y, _target_x, _target_y, _node_size, _node_count_cap) {
	/// Astar pathing
	/// Inputs 1 and 2: x and y coordinates (global) of object doing the pathing
	/// Inputs 3 and 4: x and y coordinates (global) of object being pathed to
	/// Input 5: size of square node to used for grid-based pathing
	/// Input 6: maximum number of nodes to consider in pathing (CPU resource constraint)

	// if source and target in same node, return a simple straight line path
	// TODO - implement basic collision detection within this node
	if (floor(_character_x/_node_size) == floor(_target_x/_node_size)) and (floor(_character_y/_node_size) == floor(_target_x/_node_size)) {
		var _path_to_target = path_add()
		path_add_point(_path_to_target, _character_x, _character_y, 100.);
		path_add_point(_path_to_target, _target_x, _target_y, 100.);
		path_set_precision(_path_to_target, 1);
		path_set_closed(_path_to_target, false);
		return _path_to_target;
	}

	// create the source node
	var _node_source = {
		key: string(floor(_character_x/_node_size))+"_"+string(floor(y/_node_size)),
		x_node: floor(_character_x/_node_size),
		y_node: floor(_character_y/_node_size),
		x_pixel_mid: floor(_character_x/_node_size)*_node_size + _node_size/2,
		y_pixel_mid: floor(_character_y/_node_size)*_node_size + _node_size/2,
		score_g: 0.,
		score_h: point_distance(_character_x, _character_y, _target_x, _target_y),
		score_f: point_distance(_character_x, _character_y, _target_x, _target_y),
		predecessor : "Source"
	};

	// initialise open set to include only the souce node, and closed set to be empty
	var _set_open = {};
	var _set_closed = {};
	_set_open[$ _node_source.key] = _node_source; 

	// initialise some additional useful variables prior to iterating
	var _count_nodes_x = round(room_width / _node_size);
	var _count_nodes_y = round(room_height / _node_size);
	var _target_found = false;
	count_nodes_solved = 0;
	
	// set node count cap to minimum of entered value and 90% of total number of nodes
	_node_count_cap = min(_node_count_cap, 0.9*_count_nodes_x*_count_nodes_y)

	// iteratively solve nodes until target found or we have exceeded node count cap
	while (count_nodes_solved < _node_count_cap) {
		
		// node with smallest f score from open set is the next node to solve
		var _current_node = _get_node_with_smallest_f_score(_set_open);
		
		// if no node could be solved from open set, return path to the end node from closed set
		// therefore, return path to the node in closed set with smallest f score
		if (_current_node == false) {
			var _end_node = _get_node_with_smallest_f_score(_set_closed);
			var _path_to_target = _construct_path_from_node_chain(_end_node, _set_closed, _character_x, _character_y);
			return _path_to_target;
		}
		
		// add current node to closed set and remove from open set
		_set_closed[$ _current_node.key] = _set_open[$ _current_node.key];
		struct_remove(_set_open, _current_node.key);

		// check if the current node matches the target node - if so, we have found the shortest path
		if (_current_node.x_node ==  floor(_target_x/_node_size)) and (_current_node.y_node ==  floor(_target_y/_node_size)) {
			
			var _path_to_target = _construct_path_from_node_chain(_current_node, _set_closed, _character_x, _character_y)
			return _path_to_target
			
			//// construct a path backwards by following chain of predecessors
			//var _predecessor_key =_current_node.predecessor;
			//var _path_x = [];
			//var _path_y = [];
			//var _j = 0;
			//while (_set_closed[$ _predecessor_key].predecessor != "Source") {
			//	_path_x[_j] = _set_closed[$ _predecessor_key].x_pixel_mid;
			//	_path_y[_j] = _set_closed[$ _predecessor_key].y_pixel_mid;
			//	_predecessor_key = _set_closed[$ _predecessor_key].predecessor
			//	_j++;
			//}
			
			//// first point connects current location to start of path
			//path_add_point(_path_to_target, _character_x, _character_y, 100.)
			
			//// now add points to path in reverse order
			//for (_j=array_length(_path_x)-1; _j>=0; _j--) {
			//	path_add_point(_path_to_target, _path_x[_j], _path_y[_j], 100.)
			//}
			
			//path_set_precision(_path_to_target, 8);
			//path_set_closed(_path_to_target, false);
			//return _path_to_target;
		}

		// iteratively work through all eight neighbouring nodes, add to open set as required, or update their details		
		var _neighbours_x = [_current_node.x_node-1, _current_node.x_node,   _current_node.x_node+1, _current_node.x_node+1, _current_node.x_node+1, _current_node.x_node,   _current_node.x_node-1, _current_node.x_node-1];
		var _neighbours_y = [_current_node.y_node-1, _current_node.y_node-1, _current_node.y_node-1, _current_node.y_node,   _current_node.y_node+1, _current_node.y_node+1, _current_node.y_node+1, _current_node.y_node];
		for (var _i=0; _i<array_length(_neighbours_x); _i++) {

			// work out mid pixel for the current neighbour
			var _current_neighbour_x_pixel_mid = _neighbours_x[_i]*_node_size + _node_size/2;
			var _current_neighbour_y_pixel_mid = _neighbours_y[_i]*_node_size + _node_size/2;

			// boolean representing if neighbour already exists as node in closed set
			var _is_in_closed_set = struct_exists(_set_closed, string(_neighbours_x[_i])+"_"+string(_neighbours_y[_i]));

			// boolean representing if neighbour already exists as node in open set
			var _is_in_open_set = struct_exists(_set_open, string(_neighbours_x[_i])+"_"+string(_neighbours_y[_i]));
			
			// boolean representing if node exists within room e.g. not all neighbours exist at edges and corners
			var _is_valid_neighbour = (_neighbours_x[_i]>=0) and (_neighbours_x[_i]<_count_nodes_x) and (_neighbours_y[_i]>=0) and (_neighbours_y[_i]<_count_nodes_y);
		
			// boolean to check if a straight line from predecessor centre pixel to this centre pixel doesn't encounter a solid boundary
			var _is_a_valid_path = check_clear_los(_current_node.x_pixel_mid, _current_node.y_pixel_mid,  _current_neighbour_x_pixel_mid,  _current_neighbour_y_pixel_mid)
			
			// only bother calculating scores if this neighbour is worthwhile considering from solved node
			if (_is_valid_neighbour) and (_is_a_valid_path) and (!_is_in_closed_set) {
				
				// prospective new g score is sum of current node g score and distance to this neighbour
				var _score_g = _current_node.score_g + point_distance(_current_neighbour_x_pixel_mid, _current_neighbour_y_pixel_mid, _current_node.x_pixel_mid, _current_node.y_pixel_mid);

				// prospective new h score is distance from this neighbour to target pixel
				var _score_h = point_distance(_current_neighbour_x_pixel_mid, _current_neighbour_y_pixel_mid, _target_x, _target_y);
				
				// prospective new f score is sum of g and h
				var _score_f = _score_g + _score_h;
				
				// set the key for this neighbour, will be using it extensively
				var _this_neighbour_key = string(_neighbours_x[_i])+"_"+string(_neighbours_y[_i]);
				
				// if this neighbour is not a node in open set, add it as a new node to the open set
				if (!_is_in_open_set) { 
				
					// create the new node
					var _new_node = {
						key: _this_neighbour_key,
						x_node: _neighbours_x[_i],
						y_node: _neighbours_y[_i],
						x_pixel_mid: _current_neighbour_x_pixel_mid,
						y_pixel_mid: _current_neighbour_y_pixel_mid,
						score_g: _score_g,
						score_h: _score_h,
						score_f: _score_f,
						predecessor: _current_node.key
					};
					
					// add it to the open set
					_set_open[$ _this_neighbour_key] = _new_node;
			
				// if this neighbour already in open set, update its scores and predecessor only if the new f score is lower
				} else {
					if (_score_f < _set_open[$ _this_neighbour_key].score_f) {
						_set_open[$ _this_neighbour_key].score_g = _score_g;
						_set_open[$ _this_neighbour_key].score_h = _score_h;
						_set_open[$ _this_neighbour_key].score_f = _score_f;
						_set_open[$ _this_neighbour_key].predecessor = _current_node.key;
					}
				}
			
			// update counter
			count_nodes_solved++

			}
		}
	}
	
	// if we reach here, we hit node counter cap, so return path to node in closed set with smallest f score
	var _end_node = _get_node_with_smallest_f_score(_set_closed);
	var _path_to_target = _construct_path_from_node_chain(_end_node, _set_closed, _character_x, _character_y);
	return _path_to_target;
}



function _construct_path_from_node_chain(_end_node, _set, _initial_x, _initial_y) {
	// construct a path backwards by following chain of predecessors
	// Input 1: _end_node, node struct representing end of the path
	// Input 2: the set (struct) containing the nodes from the path, usually the closed set
	// Inputs 3 and 4: the x and y global coordinates of the object following this path
	// Return 1: path object
	
	// create the path object
	var _path_to_target = path_add()
	
	// set initial predecessor key to that of end node
	var _predecessor_key = _end_node.predecessor;

	// iteratively append x and y locations of prior nodes until source node reached
	var _path_x = [];
	var _path_y = [];
	var _j = 0;
	try {
		while (_set[$ _predecessor_key].predecessor != "Source") {
			_path_x[_j] = _set[$ _predecessor_key].x_pixel_mid;
			_path_y[_j] = _set[$ _predecessor_key].y_pixel_mid;
			_predecessor_key = _set[$ _predecessor_key].predecessor
			_j++;
		} 
	} catch (_exception) {
			a = 1;	
	}
			
	// first point connects current location to start of path
	path_add_point(_path_to_target, _initial_x, _initial_y, 100.)
			
	// now add points to path in reverse order
	for (_j=array_length(_path_x)-1; _j>=0; _j--) {
		path_add_point(_path_to_target, _path_x[_j], _path_y[_j], 100.)
	}
			
	path_set_precision(_path_to_target, 8);
	path_set_closed(_path_to_target, false);
	return _path_to_target;
}


function _get_node_with_smallest_f_score(_set) {
	/// Input 1: the set (struct) that contains nodes to search through
	/// Return 1: node (struct) with smallest f-score (if valid, otherwise False)

	// iterate through each node in set to find with smallest f score
	var _set_keys = variable_struct_get_names(_set);
	var _smallest_value = infinity;
	var _node_key = "";
	var _is_node_key_found = false;
	for (var _i=0; _i<array_length(_set_keys); _i++) {
		if (_set[$ _set_keys[_i]].score_f < _smallest_value) {
			_smallest_value = _set[$ _set_keys[_i]].score_f;
			_node_key = _set_keys[_i];
			_is_node_key_found = true;
		}
	}
	
	// return node if one was found, otherwise false
	if (_is_node_key_found) {
		return _set[$ _node_key];
	} else {
		return false;
	}
}

