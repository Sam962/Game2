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

	power_up +=1   //.05 is the ideal charge up rate?

} else if (power_up > 100){
	power_up = 100;
}

//manual shooting 
image_angle = point_direction(x, y, mouse_x, mouse_y);
if (mouse_check_button_pressed(mb_right)){
	  var bullet_instance = instance_create_layer(x, y, "Instances", obj_bullet);
    //bullet fires in front of the player
    bullet_instance.x += lengthdir_x(20, image_angle);
    bullet_instance.y += lengthdir_y(20, image_angle);
}