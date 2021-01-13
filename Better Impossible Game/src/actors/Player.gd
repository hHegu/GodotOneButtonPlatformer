extends KinematicBody2D

const GRAVITY := 1900.0
const WALK_SPEED := 140.0
const JUMP_SPEED := 300.8

const COLLISION_LAYERS = {
	HAZARD = 2,
	JUMP_POWERUP = 8
}

const powerups := []

const POWERUPS = {EXTRA_JUMP= 1}

var dead := false
var started := false
var win := false

onready var anim_tree : AnimationNodeStateMachinePlayback = $AnimationTree.get("parameters/playback")
onready var sprite : Sprite = $Sprite
onready var particles : Particles2D = $Particles2D

var _velocity := Vector2()

func _physics_process(delta):
	gravity(delta)
	if !dead && started && !win:
		movement(delta)
		jumping()
		use_powerups()
	
	_velocity = move_and_slide(_velocity, Vector2.UP)

	if !started && Input.is_action_just_pressed("jump"):
		started = true

	if is_on_wall():
		die()

func gravity(delta):
	_velocity.y += delta * GRAVITY

func movement(delta):
	_velocity.x = WALK_SPEED

func jump():
	var currentNode = anim_tree.get_current_node()
	var newNode = "jump_2" if currentNode == "jump_1" else "jump_1"
	anim_tree.travel(newNode)
	_velocity.y = -JUMP_SPEED

func jumping():
	if is_on_floor() and Input.is_action_pressed("jump"):
		jump()

func use_powerups():
	if !is_on_floor() and Input.is_action_just_pressed("jump") and powerups.size() > 0:
		var next_powerup = powerups.pop_front()
		if(next_powerup == "extra_jump"):
			jump()
		print(next_powerup)
	

func _process(_delta):
	if Input.is_action_just_pressed("reset"):
		get_tree().reload_current_scene()
	#if Input.is_action_just_pressed("special"):
	#	Engine.time_scale = 0.5

func _on_Hitbox_area_entered(area):
	var layer = area.collision_layer
	if layer == COLLISION_LAYERS.HAZARD:
		particles.emitting = true
		die()
	if layer == COLLISION_LAYERS.JUMP_POWERUP:
		powerups.push_front("extra_jump")
	
func on_level_finished():
	win = true
	anim_tree.travel("win")
	_velocity.x = 0
	GameStates.level_complete()
	
func die():
	anim_tree.travel("death")
	dead = true
	_velocity.x = 0


func _on_Winbox_area_entered(area):
	on_level_finished()
