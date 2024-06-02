class_name Vacuum
extends Area2D

@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

var rotation_speed : float = 0
@export var max_rotation_speed : float = 4

var used : bool = false
var rotation_tween

func start():
	used = true
	collision_shape_2d.disabled = false
	if rotation_tween:
		rotation_tween.kill()
	
	rotation_tween = get_tree().create_tween()
	rotation_tween.tween_property(self, "rotation_speed", max_rotation_speed, 1).set_trans(Tween.TRANS_QUART).set_ease(Tween.EASE_IN)
	
func stop():
	used = false
	collision_shape_2d.disabled = true
	
	if rotation_tween:
		rotation_tween.kill()
	rotation_tween = get_tree().create_tween()
	rotation_tween.tween_property(self, "rotation_speed", 0, 2).set_trans(Tween.TRANS_QUART).set_ease(Tween.EASE_OUT)
	
func _process(delta: float) -> void:
	if rotation_speed >= 0:
		rotation_degrees += rotation_speed

