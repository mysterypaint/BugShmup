/// @description Insert description here
//draw_set_halign(fa_center);

if (hide_camera)
	exit;

draw_set_color(c_white);
draw_set_font(Game.spr_font);

var _ts = Game.TILE_SIZE;
var _hts = _ts / 2;

switch(Game.state) {
	case GameStates.TITLE:
		draw_text(15 * _hts, 1 * _hts, "\n\nBug Shmup");
		if (Game.tick % Game.TITLE_BLINK_SPEED == 0)
			Game.show_titlescreen_prompt = !Game.show_titlescreen_prompt;
		
		draw_set_color(c_yellow);
		if (Game.show_titlescreen_prompt)
			draw_text(13 * _hts, 7 * _hts, "- Press Pause -");
		
		draw_set_color(c_white);
		draw_text(0 * _hts, 10 * _hts, "- Controls -\nWASD/Arrow Keys - Move the Ship\nZ/J - Shoot Bullets, Menu Cancel\nC/L - Cycle through Bug Fighters (Tentative)\nEnter/H - Pause, Menu Confirm\n\nF7 - Window Size\nF4 (or Alt+Enter) - Toggle Fullscreen");
		break;
	case GameStates.GAMEOVER:
		draw_set_color(c_white);
		draw_text(0, 0, "gmae over lol\n\nu fukken died!");
		draw_set_color(c_yellow);
		if (Game.tick % Game.TITLE_BLINK_SPEED == 0)
			Game.show_titlescreen_prompt = !Game.show_titlescreen_prompt;

		if (Game.show_titlescreen_prompt)
			draw_text(5 * _hts, 10 * _hts, "pres Pause to reset the gmae :WUO:");
		
		if (instance_exists(FadeEffect)) {
			with (FadeEffect) {
				event_perform(ev_draw, 0);
			}
		}
		break;
	case GameStates.PAUSED:
	case GameStates.GAMEPLAY:
		var i = 0;
		
		if (instance_exists(LevelData)) {
			if (ds_exists(LevelData.layers, ds_type_list)) {
				var _layers_size = ds_list_size(LevelData.layers);
	
				for (var _i = 0; _i < _layers_size; _i++) {
					if (_i == LevelData.shadow_layer) {
						draw_set_alpha(shadow_layer_alpha);
						var _col = c_black;
						draw_rectangle_color(x-Game.TILE_SIZE, y- Game.TILE_SIZE, x + Game.base_res_width + Game.TILE_SIZE, y + Game.base_res_height + Game.TILE_SIZE, _col, _col, _col, _col, false);
						draw_set_alpha(1);
					}
					
					
					var _this_layer = LevelData.layers[| _i];
					var _this_layer_name = _this_layer[| 0];
		
					if (_this_layer_name != "Instances") {
						var _is_collision_layer = false;
						if (_this_layer_name == "Collision")
							_is_collision_layer = true;
						var _lvl_data_grid = _this_layer[| 1];
					
						draw_level_data(_lvl_data_grid, _is_collision_layer);
					}
				}
			}
		}
		
		draw_set_color(c_white);
		
		// Draw entities

		// Draw all of the Draw objects in order, by their depth		
		var _inst;
		
		var _yy = 0; repeat (num_draw_objects) {
			// pull out an ID
			_inst = ds_draw_object_depth_sort[# 0, _yy];
			// get instance to draw itself
			with (_inst) {
				if (draw_me)
					event_perform(ev_draw, 0);
			}
			_yy++;
		}
		
		// Draw the textbox
		
		if (instance_exists(Textbox)) {
			with(Textbox) {
				event_perform(ev_draw, 0);
			}
		}
		
		
		// Draw the game HUD
		draw_set_alpha(hud_alpha);
		
		// Weapon boxes & Cursor
		var _len = BulletTypes.MAX;
		for (var _i = 0; _i < _len; _i++) {
			draw_sprite(sprHUDWeaponBox, 0, x + (_i * weapon_box_width) + weapon_hud_xoff, y + weapon_hud_yoff);
			draw_sprite(sprHUDWeapons, _i, x + (_i * weapon_box_width) + weapon_hud_xoff, y + weapon_hud_yoff);
			
			if (_i == Ship.bullet_type)
				draw_sprite(sprHUDWeaponCursor, _i, x + (_i * weapon_box_width) + weapon_hud_xoff + 1, y + weapon_hud_yoff + 1);
		}
		
		//draw_text(x + 131, y + 7, "Score: 0");
		
		// Num Lives
		
		var _lives = Game.player_lives;
		
		for (var _i = 0; _i < _lives - 1; _i++) {
			draw_sprite(sprHUDLife, 0, x + (_i * weapon_box_width) + lives_hud_xoff, y + lives_hud_yoff);
		}
		
		//draw_text(x, y, "Bullet Type: " + get_bullet_type_name());
		
		with (ParentEnemyBullet) {
			event_perform(ev_draw, 0);
		}
		
		
		draw_set_alpha(1);
		
		//var _tx = floor(Ship.x / Game.TILE_SIZE);
		//var _ty = floor(Ship.y / Game.TILE_SIZE);
		//draw_text(Camera.x, Camera.y, string(_tx) + ", " + string(_ty));		
		if (Game.state == GameStates.PAUSED) {
			
			if (Game.tick % Game.GAME_PAUSED_TEXT_BLINK_SPEED == 0)
				Game.show_pause_text = !Game.show_pause_text;
		
		
			if (Game.show_pause_text) {
				draw_text(Camera.x + 15 * _hts, Camera.y + 10 * _hts, "- Game Paused -");
			}
		}
		
		if (checkpoint_display_timer > 0) {
			if (checkpoint_display_timer % checkpoint_display_blink_rate == 0)
				checkpoint_display_visible = !checkpoint_display_visible;
			
			if (checkpoint_display_visible) {
				draw_set_color(c_yellow);
				draw_text(x + (8*24), y + (8*21), "Checkpoint reached!");
				draw_set_color(c_white);
			}
			checkpoint_display_timer -= Game.dt;
		}
		
		if (instance_exists(FadeEffect)) {
			with (FadeEffect) {
				event_perform(ev_draw, 0);
			}
		}
		break;
	
}


if (Game.debug) {
	draw_text(x + Game.base_res_width - (8 * 8), y, "fps: " + string(fps));
}