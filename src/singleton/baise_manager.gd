# Manageur de baise
extends Node
const BAISE_EFFECT = preload("res://src/scene/baise_effect.tscn")

func make_baise_happen(lapin_1: Rabbit, lapin_2: Rabbit):
	lapin_1.stop()
	lapin_2.stop()
	var baise_instance := BAISE_EFFECT.instantiate()
	get_tree().current_scene.add_child(baise_instance)
	var baise_position = lapin_1.global_position + (lapin_2.global_position - lapin_1.global_position) * 0.5
	baise_instance.global_position = baise_position
	baise_instance.set_participants(lapin_1, lapin_2)
	
	


			
	
	
