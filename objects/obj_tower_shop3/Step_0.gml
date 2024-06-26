/// @description Insert description here
// You can write your code in this editor
if (mouse_check_button_pressed(mb_left) && position_meeting(mouse_x, mouse_y, obj_tower_shop3)){
	
	obj_sell.selling = false                  //addresses text overlap
	obj_tower_shop.turret_selected = false
	obj_tower_shop2.turret_selected = false
	obj_tower4_shop.turret_selected = false
	obj_buff_shop.turret_selected = false
	obj_slowmo_shop.turret_selected = false //don't forget this one
	
	turret_selected = true;
}

var tower_placement_check = [obj_tower, obj_frame, obj_tower2, obj_tower3, obj_buff, obj_sell, obj_flamethrower, obj_buff];

if (turret_selected){
    cursor_sprite = spr_tower3;
    if (placement_delay <= 0){
        if (obj_scoreboard.scrap >= obj_tower3.cost){
            if (mouse_check_button_pressed(mb_left)){
                if not (position_meeting(mouse_x, mouse_y, obj_invalidSpawn)){
                    var collision_found = false;
                    for (var i = 0; i < array_length(tower_placement_check); i++) {
                        if (position_meeting(mouse_x, mouse_y, tower_placement_check[i])){
                            collision_found = true;
                            break; 
                        }
                    }
                    if (!collision_found) {
                        audio_play_sound(snd_gold_sack, 1, false);
                        instance_create_layer(mouse_x, mouse_y, "Instances", obj_tower3);
                        placement_delay = 10;
                        obj_scoreboard.scrap -= obj_tower3.cost;
                    }
                }
            }
        }
    } else {
        placement_delay--;
    }
}

if (mouse_check_button_pressed(mb_right)){
	turret_selected = false;
	placement_delay = 10;
	cursor_sprite = cr_none;
}