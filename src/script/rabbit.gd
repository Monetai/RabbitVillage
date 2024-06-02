class_name Rabbit
extends Node2D

@onready var navigation_agent: NavigationAgent2D = $NavigationAgent2D
@onready var baise_detector: Area2D = $BaiseDetector
@onready var baise_cooldown: Timer = $BaiseCooldown
@onready var poop_cooldown: Timer = $PoopCooldown
@onready var run_cooldown: Timer = $RunCooldown
@onready var sprite: AnimatedSprite2D = $Sprite2D

const CROTTE = preload("res://src/scene/crotte.tscn")

# Deplacements
@export var SPEED : int = 100

# Occupations
var can_fuck : bool = true

enum OCCUPATION {
	FUCK,
	POOP,
	NOTHING
}

var occupation = OCCUPATION.NOTHING

var stopped : bool = false

@export var poop_delay := Vector2(4, 7)


func _ready():
	baise_cooldown.timeout.connect(on_baise_cooldown_ended)
	poop_cooldown.timeout.connect(on_poop_cooldown_ended)
	baise_detector.area_entered.connect(on_gros_baiseur_detected)
	poop_cooldown.start(randf_range(poop_delay.x, poop_delay.y))

func _physics_process(delta: float) -> void:
	if !navigation_agent.is_navigation_finished() and !stopped:
		var direction = global_position.direction_to(navigation_agent.get_next_path_position())
		if direction.x != 0:
			scale.x = sign(direction.x * -1)

		direction = direction.normalized()
		translate(direction * SPEED * delta)
	set_animation()
	
func set_navigation_agent(new_target: Vector2):
	navigation_agent.target_position = new_target

func spawn_poop():
	var rand_poop_number = randi_range(1,3)
	for i in range(rand_poop_number):
		var crotte = CROTTE.instantiate()
		get_tree().current_scene.add_child(crotte)
		(crotte as Crotte).eject($PoopSpawner.global_position, scale.x)
	stopped = false
	occupation = OCCUPATION.NOTHING
	baise_cooldown.paused = true
	poop_cooldown.start(randf_range(poop_delay.x, poop_delay.y))

func set_animation():
	if occupation != OCCUPATION.NOTHING:
		if occupation == OCCUPATION.POOP:
			sprite.animation= "poop"
	else:
		if navigation_agent.is_navigation_finished():
			sprite.animation= "idle"
		else:
			sprite.animation= "walk"	


func fuck():
	poop_cooldown.paused = true
	occupation = OCCUPATION.FUCK
	stopped = true
	visible = false

func end_fuck():
	occupation = OCCUPATION.NOTHING
	stopped = false
	visible = true
	poop_cooldown.paused = false
	baise_cooldown.start(5)

# Timeout Signals
func _on_navigation_agent_2d_navigation_finished() -> void:
	run_cooldown.start(3)

func _on_run_cooldown_timeout() -> void:
	navigation_agent.target_position = Vector2(randf_range(0,1920), randf_range(0,1080))

func on_baise_cooldown_ended():
	can_fuck = true
	
func on_poop_cooldown_ended():
	baise_cooldown.paused = false
	occupation = OCCUPATION.POOP
	stopped = true
	await get_tree().create_timer(1).timeout
	spawn_poop()
	
func on_gros_baiseur_detected(baiseur: Area2D):
	if can_fuck == false or occupation != OCCUPATION.NOTHING: return
	
	var autre_baiseur : Rabbit = baiseur.owner
	if autre_baiseur.can_fuck == false or occupation != OCCUPATION.NOTHING: return
	
	can_fuck = false
	autre_baiseur.can_fuck = false
	BaiseManager.call_deferred("make_baise_happen", self, autre_baiseur)
