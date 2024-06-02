class_name Farm
extends StaticBody2D

@onready var collision_shape : CollisionShape2D = $DetectionArea/CollisionShape2D


var production : float = 1.2
@export var radius : float = 20

func _ready() -> void:
	var shape = collision_shape.shape
	radius = (shape as CircleShape2D).radius
