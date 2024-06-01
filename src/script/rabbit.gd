class_name Rabbit
extends Node2D

@onready var navigation_agent: NavigationAgent2D = $NavigationAgent2D
@onready var baise_cooldown: Timer = $BaiseCooldown
@onready var baise_detector: Area2D = $BaiseDetector

@export var target : Marker2D
@export var SPEED : int = 100
var can_fuck : bool = true:
	set(new_value):
		can_fuck = new_value
		if can_fuck == false:
			baise_cooldown.start(15)

var stopped : bool = false


func _ready():
	baise_cooldown.timeout.connect(on_baise_cooldown_ended)
	baise_detector.area_entered.connect(on_gros_baiseur_detected)
	call_deferred("set_navigation_agent")

func _physics_process(delta: float) -> void:
	if navigation_agent.is_navigation_finished() or stopped:
		return
		
	var direction = global_position.direction_to(navigation_agent.get_next_path_position())
	direction = direction.normalized()
	translate(direction * SPEED * delta)
	
func set_navigation_agent():
	if not target:
		navigation_agent.target_position = Vector2(randf_range(0, 300), randf_range(0,300))		
	else:
		navigation_agent.target_position = target.global_position
	
func on_baise_cooldown_ended():
	can_fuck = true
	
func on_gros_baiseur_detected(baiseur: Area2D):
	if can_fuck == false: return
	
	var autre_baiseur : Rabbit = baiseur.owner
	if autre_baiseur.can_fuck == false: return
	print("J'viens de faire une rencontre")
	
	can_fuck = false
	autre_baiseur.can_fuck = false
	BaiseManager.make_baise_happen(self, autre_baiseur)


# Lié a la baise
func stop():
	visible = false
	stopped = true
	
func unstop():
	visible = true
	stopped = false
