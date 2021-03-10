extends Control

onready var _stage := $Playable/Center/Stage
onready var _player := $Playable/Center/Stage/Player
onready var _navigation := $Playable/Center/Stage/Navigation
onready var _camera_1 := $RoomCamera1
onready var _camera_2 := $RoomCamera2
onready var _camera_3 := $RoomCamera3
onready var _camera_4 := $RoomCamera4
onready var _room_2_top_entrance := $Room2TopEntrance
onready var _room_1_bottom_entrance := $Room1BottomEntrance
onready var _room_1_spawn := $Room1Spawn
onready var _interactable := $Interactable
onready var _message := $Interactable/Margin/Columns/Rows/Message

var is_pressed := false

func _ready() -> void:
	Globals.player = _player

func _process(_delta: float) -> void:
	var click_position = get_local_mouse_position() - _stage.rect_position
	var player_position = _player.position

	if is_pressed:
		var path = _navigation.get_simple_path(
			player_position,
			click_position
		)

		_player.path = path

		Globals.emit_signal("on_unhandled_press", click_position, player_position)
	else:
		Globals.emit_signal("on_unhandled_release", click_position, player_position)

	create_player_nodes()
	position_player_nodes()

func create_player_nodes() -> void:
	for id in Globals.players:
		var player = Globals.players[id]

		if player.has("node") and player.node is Node:
			return

		var other_player_node = load("res://scenes/other-player.tscn").instance()

		Globals.update_player({
			"id": player.id,
			"node": other_player_node,
		})

		_stage.add_child(other_player_node)

		other_player_node.position = _room_1_spawn.position

func position_player_nodes() -> void:
	for id in Globals.players:
		var player = Globals.players[id]

		if player.has("node") and player.node is Node and player.has("position"):
			player.node.position = Vector2(player.position.x, player.position.y)

func _unhandled_input(event: InputEvent) -> void :
	if not event is InputEventMouseButton:
		return

	is_pressed = event.is_pressed()

func _on_messages_text_entered(new_text):
	_message.text = ""

func _on_room_1_bottom_exit_body_entered(body):
	_camera_3.current = true
	_player.path = PoolVector2Array()
	_player.position = _room_2_top_entrance.position

func _on_room_2_top_exit_body_entered(body):
	_camera_1.current = true
	_player.path = PoolVector2Array()
	_player.position = _room_1_bottom_entrance.position

func _on_room_3_top_exit_body_entered(body):
	pass # Replace with function body.

func _on_room_3_bottom_exit_body_entered(body):
	pass # Replace with function body.
