# Manageur de baise
extends Node


var baise_list = []
var index_done = []
var baise_todo = []

func add_rencontre(lapin_1: Rabbit, lapin_2: Rabbit):
	baise_list.append([lapin_1, lapin_2])
	

func _process(delta: float) -> void:
	if baise_list.is_empty(): return
	
	for baise_index in range(baise_list.size()):
		if baise_index in index_done: continue
		var baise = baise_list[baise_index]
		for other_baise_index in range(baise_list.size()):
			var other_baise = baise_list[other_baise_index]
			if other_baise == baise: continue
			
			if other_baise.all(func(x): return x in baise):
				#Baise Happened
				print("Une bonne baise est prévu aux index ", baise_index, " et ", other_baise_index)
				index_done.append_array(baise)
				baise_todo.append([baise, other_baise])
	
	for baise in baise_todo:
		print("Une baise !")
	
	for index in index_done:
		baise_list.erase(index)
			
	
	
