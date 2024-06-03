@tool
class_name Farm
extends StaticBody2D

@onready var collision_shape : CollisionShape2D = $DetectionArea/CollisionShape2D
var show_radius : bool = false


var production : float = 1.2
@export var radius : float = 20

func _ready() -> void:
	var shape = collision_shape.shape
	radius = (shape as CircleShape2D).radius
	toggle_radius(true)

func _draw() -> void:
	if show_radius:
		draw_circle($DetectionArea.position, radius, Color(1,0,1, 0.2))

func toggle_radius(state: bool):
	show_radius = state
	queue_redraw()
