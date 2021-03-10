extends Node

signal on_unhandled_press(click_position, player_position)
signal on_unhandled_release(click_position, player_position)

var players = {}
var player = null
var current_room = null

func remove_player(data: Dictionary) -> void:
	if players.has(data.id) and players[data.id].has("node") and players[data.id].node is Node:
		players[data.id].node.queue_free()

	var new_players = {}

	for id in players:
		var player = players[id]

		if player.id != data.id:
			new_players[player.id] = player

	players = new_players

func update_player(data: Dictionary) -> void:
	if players.has(data.id):
		for key in data:
			if key == "id":
				continue

			players[data.id][key] = data[key]
	else:
		players[data.id] = data

	if data.has("type") and data.type == "name" and players[data.id].has("node") and players[data.id].node is Node:
		players[data.id].node.set_name(data.name)

	if data.has("type") and data.type == "message" and players[data.id].has("node") and players[data.id].node is Node:
		players[data.id].node.set_message(data.message)
