class_name BaiseEffect
extends Sprite2D

const RABBIT = preload("res://src/scene/rabbit.tscn")

var lapin_1 : Rabbit
var lapin_2: Rabbit

func set_participants(lapin1: Rabbit, lapin2: Rabbit):
	lapin_1 = lapin1
	lapin_2 = lapin2

func spawn_rabbit():
	var rabbit = RABBIT.instantiate()
	get_tree().current_scene.add_child(rabbit)
	rabbit.global_position = self.global_position
	lapin_1.unstop()
	lapin_2.unstop()
	queue_free()
	


func _on_timer_timeout() -> void:
	spawn_rabbit()
