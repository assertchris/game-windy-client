extends Area2D

export(NodePath) var _camera_path
export(NodePath) var _entrance_position_path

func _on_room_exit_body_entered(body):
	var _camera = get_node(_camera_path)
	var _entrance_position = get_node(_entrance_position_path)

	_camera.current = true
	Globals.player.path = PoolVector2Array()
	Globals.player.position = _entrance_position.position
