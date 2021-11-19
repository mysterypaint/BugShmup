/// @description Insert description here
a = clamp(a + (fade * 0.05), 0, 1);

if (a == 1) {
	switch (transition_type) {
		case TransitionTypes.LEVEL_RESET: // Reset the level; subtract a life from the player
			with (parent_id) {
				// Reset the room
				if (instance_exists(PilotBug))
					instance_destroy(PilotBug);
		
				if (instance_exists(Textbox))
					instance_destroy(Textbox);
			
				//if (instance_exists(LevelData))
					//instance_destroy(LevelData);
		
				//read_json("testmap0.json");
				
				Game.player_lives--;
				dead = false;
				draw_me = true;
				init_player = init_player_reset;
				
				respawn_room_entities();
				
				x = 120;
				y = 64;
				
			}
			
			with (Camera) {
				x = 0;
				y = 0;
				move_x = prev_move_x;
				move_y = prev_move_y;
				camera_set_view_pos(view_camera[0], Camera.x, Camera.y);
			}
			break;
	}
	fade = -1;
} else if ((a == 0) && (fade == -1)) {
	instance_destroy();
}

draw_set_color(c_black);
draw_set_alpha(a);

var _brw = Game.base_res_width;
var _brh = Game.base_res_height;
var _padding = _brw;
var _x = Camera.x;
var _y = Camera.y;
draw_rectangle(_x - _padding, _y - _padding, _x + _brw + _padding, _y + _brh + _padding, false);

_x = camera_get_view_x(view_camera[0]);
_y = camera_get_view_y(view_camera[0]);
draw_rectangle(_x - _padding, _y - _padding, _x + _brw + _padding, _y + _brh + _padding, false);

draw_set_alpha(1);