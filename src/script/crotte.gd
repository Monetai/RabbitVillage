class_name Crotte
extends Area2D

@export var min_scale : float = 0.1
@export var max_scale : float = 0.5
@export var final_scale : Vector2

var eject_angle : Vector2
var speed : float 

func _ready():
	# Scale
	var rand_scale = randf_range(min_scale, max_scale) 
	scale = Vector2(rand_scale, rand_scale)
	rotation_degrees = randf_range(0,360)
	final_scale = scale
	
func _physics_process(delta: float) -> void:
	if speed != 0:
		speed = lerp(speed, 0.0, delta*2) 
		translate(eject_angle * speed)
	
func eject(new_position: Vector2, direction: float):
	global_position = new_position
	# Movement
	eject_angle = Vector2( direction, randf_range(-1, 1))
	speed = randf_range(0.3, 1.2)


func _on_area_entered(area: Area2D) -> void:
	## Lorsque le vacuum passe au dessus d'une crotte
	Stats.crotte_count += 1
	call_deferred("queue_free")
