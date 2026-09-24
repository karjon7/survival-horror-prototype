extends Node3D
class_name Door

@onready var nav_link: NavigationLink3D = $NavigationLink3D
@onready var fade: ColorRect = $DoorUI/Fade
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _on_interactable_area_interacted_with(interactor: Node3D) -> void:
	var is_outside: bool = global_position.direction_to(interactor.global_position).z < 0
	
	if interactor is Player:
		process_mode = Node.PROCESS_MODE_ALWAYS
		get_tree().paused = true
		animation_player.play("fade_in")
		await animation_player.animation_finished
		
		interactor.global_position = to_global(nav_link.end_position) \
			if is_outside else to_global(nav_link.start_position)
		
		animation_player.play("fade_out")
		await animation_player.animation_finished
		get_tree().paused = false
		process_mode = Node.PROCESS_MODE_INHERIT
		
