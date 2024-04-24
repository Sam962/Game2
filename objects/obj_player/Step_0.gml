/// @description Insert description here
// Clamping the player within the room boundaries
x = clamp(x, sprite_width / 2, room_width - sprite_width / 2);
y = clamp(y, sprite_height / 2, room_height - sprite_height / 2);

var _left = keyboard_check(ord("A"));   //movement inputs
var _right = keyboard_check(ord("D"));  
var _up = keyboard_check(ord("W"));
var _down = keyboard_check(ord("S"));

 

// Stop the animation when not moving - I think its better to maintain the direction
// Faced with idle rather than always facing forward
if (keyboard_check(ord("W")) or keyboard_check(ord("A")) or keyboard_check(ord("S")) or keyboard_check(ord("D"))){
	image_speed = 1;	
} else {
	image_index = 0;
	image_speed = 0;
}

var _xinput = _right - _left;
var _yinput = _down - _up;

// stores the intended position based on input
var default_x = x + _xinput * my_speed;
var default_y = y + _yinput * my_speed;

// horizontal movement and collision
var horizontal_collision = place_meeting(default_x, y, obj_barrier);
if (!horizontal_collision) {
    x = default_x;
}

// vertical movement and collision
var vertical_collision = place_meeting(x, default_y, obj_barrier);
if (!vertical_collision) {
    y = default_y;
}

if (power_up < 100){ //blue bar
	// Power no longer charges between waves.
	if (not instance_exists(obj_buttonNextwave)){
		power_up += .05;   //.05 is the ideal charge up rate?
	}
} else if (power_up > 100){
	power_up = 100;
}


image_angle = point_direction(x, y, mouse_x, mouse_y);


// ================================= Prevent shooting when clicking shop =================================
// TODO: ADD LINE TO ALLOW SHOOTING IF MOUSE ALREADY HELD DOWN PRIOR TO POSITION MEETING (idk yet)
if (mouse_check_button(mb_left) and player_can_shoot) {
    var shop_hover_check = [obj_tower_shop, obj_tower_shop2, obj_tower_shop3, obj_slowmo_shop];
	var tower_hover_check = [obj_tower, obj_tower2, obj_tower3, obj_buff];
    var sure_shoot = true;
    
    for (var i = 0; i < array_length(shop_hover_check); i++) {
        if (position_meeting(mouse_x, mouse_y, shop_hover_check[i]) || shop_hover_check[i].turret_selected) {
            sure_shoot = false;
            break;
        }
    }
	
	for (var i = 0; i < array_length(tower_hover_check); i++) {
        if (position_meeting(mouse_x, mouse_y, tower_hover_check[i])) {
            sure_shoot = false;
            break;
        }
    }
    
    if (sure_shoot) {
        var bullet_instance = instance_create_layer(x, y, "Player", obj_bullet);
        // Bullet fires in front of the player
        bullet_instance.x += lengthdir_x(20, image_angle);
        bullet_instance.y += lengthdir_y(20, image_angle);
        alarm[0] = room_speed * fire_speed;
		player_can_shoot = false;
    } 
}

// ================================= Tower selected when clicked, deselected otherwise =================================
if (position_meeting(mouse_x, mouse_y, obj_tower) and mouse_check_button_pressed(mb_left)){
	var selected_tower = instance_place(mouse_x, mouse_y, obj_tower)
	selected_tower.tower_selected = true;
} else if (not position_meeting(mouse_x, mouse_y, obj_tower) and mouse_check_button_pressed(mb_left)){
	obj_tower.tower_selected = false;
}

// ================================= Buff radius selection =================================
var shops_to_check = [obj_tower_shop, obj_tower_shop2, obj_tower_shop3, obj_slowmo_shop];
var no_collision = true;

// If obj_buff is clicked, it will be marked as selected to show the radius
if (position_meeting(mouse_x, mouse_y, obj_buff) and mouse_check_button_pressed(mb_left)){
	var selected_buff = instance_place(mouse_x, mouse_y, obj_buff)
	selected_buff.turret_selected = true;
} else { // If any shops in the above array "shops_to_check" are clicked, the buff will not be de-selected
	for (var i = 0; i < array_length(shops_to_check); i++) {
	    if (position_meeting(mouse_x, mouse_y, shops_to_check[i]) || shops_to_check[i].turret_selected) {
	        no_collision = false;
	        break;
	    }
	}
	// If anywhere else is on the screen is clicked, the buff will be de-selected
	if (no_collision && mouse_check_button_pressed(mb_left) and not position_meeting(mouse_x, mouse_y, obj_tower)) {
	    obj_buff.turret_selected = false;
	}
}




