extends Node

export var websocket_url = "ws://127.0.0.1:8080"

var _client = WebSocketClient.new()

func _ready():
	_client.connect("connection_error", self, "_on_closed")
	_client.connect("data_received", self, "_on_data")

	var err = _client.connect_to_url(websocket_url)

	if err != OK:
		set_process(false)

func _closed(was_clean = false):
	set_process(false)

func _on_data():
	var data = get_message()

	if not data:
		return

	if data.type == "connect" or data.type == "position" or data.type == "name" or data.type == "message":
		Globals.update_player(data)

	if data.type == "disconnect":
		Globals.remove_player(data)

func _process(delta):
	_client.poll()

func put_message(data: Dictionary) -> void:
	_client.get_peer(1).put_packet(JSON.print(data).to_utf8())

func get_message() -> Dictionary:
	var message = _client.get_peer(1).get_packet().get_string_from_utf8()
	return JSON.parse(message).result

func _on_name_timer_timeout():
	put_message({
		"name": OS.get_name(),
		"type": "name",
	})

func _on_position_timer_timeout():
	put_message({
		"position": {
			"x": Globals.player.position.x,
			"y": Globals.player.position.y,
		},
		"type": "position",
	})


func _on_messages_text_entered(new_text):
	put_message({
		"message": new_text,
		"type": "message",
	})
