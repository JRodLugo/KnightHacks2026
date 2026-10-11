@abstract class_name Enemy extends CharacterBody2D

@export var sprite : Sprite2D; # The enemy's sprite.
@export var col_shape : CollisionShape2D; # The collision shape itself.
# Used for movement. Note that not all enemies will move.
@export var nav_agent : NavigationAgent2D = null;
var col_form : Shape2D; # The form/shape used to MAKE the collision.
## The position the enemy is attempting to reach.
var cur_goal_pos : Vector2;

enum ENEMY_INDEX
{
	Pace
};
