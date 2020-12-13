extends KinematicBody2D


enum STATES {
	ON_AIR,
	ON_GROUND
}

const GRAV := 35
const MAX_Y_SPEED := 800
const AIR_H_SPEED := 600
const AIR_H_ACCEL := 100
const AIR_H_DACCEL := 25
const WALK_H_SPEED := 500
const WALK_H_ACCEL := 100
const WALK_H_DACCEL := 100
const JUMP := 420

onready var Animations := $Animations

var state = STATES.ON_AIR

var speed := Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _physics_process(delta):
	match state:
		STATES.ON_AIR:
			speed.y = move_toward(speed.y, MAX_Y_SPEED, GRAV)
			
			if Input.is_key_pressed(KEY_LEFT):
				speed.x = move_toward(speed.x, -AIR_H_SPEED, AIR_H_ACCEL)
			elif Input.is_key_pressed(KEY_RIGHT):
				speed.x = move_toward(speed.x, AIR_H_SPEED, AIR_H_ACCEL)
			else:
				speed.x = move_toward(speed.x, 0, AIR_H_DACCEL)
				
			if is_on_floor():
				state = STATES.ON_GROUND
				
		STATES.ON_GROUND:
			speed.y = move_toward(speed.y, 200, INF)
			if Input.is_key_pressed(KEY_LEFT):
				speed.x = move_toward(speed.x, -WALK_H_SPEED, WALK_H_ACCEL)
			elif Input.is_key_pressed(KEY_RIGHT):
				speed.x = move_toward(speed.x, WALK_H_SPEED, WALK_H_ACCEL)
			else:
				speed.x = move_toward(speed.x, 0, WALK_H_DACCEL)
				
			if Input.is_key_pressed(KEY_UP):
				speed.y = -JUMP - abs(speed.x/3)
			
			if not is_on_floor():
				state = STATES.ON_AIR
	move_and_slide_with_snap(speed, Vector2.DOWN)

func _process(delta):
	match state:
		STATES.ON_AIR:
			if speed.y > 0:
				Animations.current_anim = Animations.ANIMS.falling
			else:
				Animations.current_anim = Animations.ANIMS.jumping
			
		STATES.ON_GROUND:
			if abs(speed.x) > 0:
				Animations.current_anim = Animations.ANIMS.running
			else:
				Animations.current_anim = Animations.ANIMS.idle

func is_on_floor():
	return $RayCast2D.is_colliding()
