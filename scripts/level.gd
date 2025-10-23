extends Node2D

@export var levelName:String
@onready var text = %text
@onready var game = get_node("/root/game")
var timesOverlapped:int = 0

func _process(_delta):
	game.text.visible = timesOverlapped > 0

func _on_entry_door_body_entered(body):
	if body == %player:
		print("yeah")
		timesOverlapped += 1
		game.text.text = "I don't know why I'd need to go back there. It sucks."

#entry door level 2
func _on_entry_door_body_exited(body):
	if body == %player:
		print("buh bye")
		timesOverlapped -= 1

#basic controls
func _on_basic_controls_body_entered(body):
	if body == %player:
		print("yeah")
		timesOverlapped += 1
		game.text.text = "Attention: All android workers, this sign is up as a notice.
			New controls for motor function include: W-A-S-D.
			Verticality increase falls under: Spacebar.
			Verticality decrease falls under: S."


func _on_basic_controls_body_exited(body):
	if body == %player:
		print("buh bye")
		timesOverlapped -= 1

#respawn
func _on_respawn_body_entered(body):
	if body == %player:
		print("yeah")
		timesOverlapped += 1
		game.text.text = "Attention: All android workers, this sign is up as a reminder.
			If your android is immovable from a position, and there has been at least 48 hours notice,
			you are permitted to use the recovery beacon attached to your android to return to your printer by using: R."


func _on_respawn_body_exited(body):
	if body == %player:
		print("buh bye")
		timesOverlapped -= 1

#walljump
func _on_walljump_body_entered(body):
	if body == %player:
		print("yeah")
		timesOverlapped += 1
		game.text.text = "Attention: All android workers, this sign is up as a warning.
						Due to unforeseen circumstances, the RoboCorp Motorised Elevator 
						has been deactivated and uninstalled. We apologise for this inconvenience,
						but until this matter is resolved, utilise your Wallbounce function
						to ascend."


func _on_walljump_body_exited(body):
	if body == %player:
		print("buh bye")
		timesOverlapped -= 1


func _on_pencilling_body_entered(body):
	if body == %player:
		print("yeah")
		timesOverlapped += 1
		game.text.text = "Attention: All android workers, this sign is up as a reminder.
						Under the advice of Site Manager 94603, we at administration have
						found reminding android pilots of the Personalised Energy Repulser.
						The P.E.R unit can be utilised by holding: S while unsupported by 
						solid ground."


func _on_pencilling_body_exited(body):
	if body == %player:
		print("buh bye")
		timesOverlapped -= 1

#kill/grey blocks
func _on_kill_blocks_body_entered(body):
	if body == %player:
		print("yeah")
		timesOverlapped += 1
		game.text.text = "Attention: All android workers, this sign is up as a warning.
						Due to some unnecessary workplace accidents, we here at adminisitration
						feel the requirement to warn you. DO NOT, UNDER ANY CIRCUMSTANCES, PUT YOUR
						ANDROID IN THE LASERS."


func _on_kill_blocks_body_exited(body):
	if body == %player:
		print("buh bye")
		timesOverlapped -= 1


func _on_slideboosting_body_entered(body):
	if body == %player:
		print("yeah")
		timesOverlapped += 1
		game.text.text = "Attention: All android workers, this sign is up as a reminder.
						If you're stuck in a collapsing tunnel or similar situation, and
						the inbuilt crawling functionality is unsatisfactory, you can use
						the P.E.R system to boost yourself along the ground."


func _on_slideboosting_body_exited(body):
	if body == %player:
		print("buh bye")
		timesOverlapped -= 1
