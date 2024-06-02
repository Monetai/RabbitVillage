class_name Vacuum
extends Area2D

@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

var rotation_speed : float = 0
@export var max_rotation_speed : float = 4

var used : bool = false

func start():
	used = true
	collision_shape_2d.disabled = false
	
func stop():
	used = false
	collision_shape_2d.disabled = true



