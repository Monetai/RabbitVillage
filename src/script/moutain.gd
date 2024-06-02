@tool
extends StaticBody2D

func _ready():
	$Sprite.frame = randi_range(0,1)
