@abstract class_name Enemy extends CharacterBody2D

@export var sprite : Sprite2D; # The enemy's sprite.
@export var col_form : Shape2D; # The form/shape used to MAKE the collision.
@export var col_shape : CollisionShape2D; # The collision shape itself.
@export var nav_agent : NavigationAgent2D = null;

enum ENEMY_INDEX
{
	Pace
};

var cur_goal_pos : Vector2;


#func get_type
