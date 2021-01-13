extends Node2D

onready var Animator = $AnimationPlayer

func _on_Area2D_area_entered(area):
	Animator.play("disappear")
