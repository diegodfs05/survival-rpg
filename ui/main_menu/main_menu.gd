extends Control

# Caminho para a cena principal do jogo
const WORLD_SCENE_PATH = "res://world.tscn"

@onready var start_button: Button = %StartButton
@onready var game_modes_button: Button = %GameModesButton
@onready var settings_button: Button = %SettingsButton
@onready var quit_button: Button = %QuitButton

func _ready() -> void:
	# Foca no botão de iniciar para suportar controle/teclado de cara
	start_button.grab_focus()
	
	# Conexão de sinais
	start_button.pressed.connect(_on_start_pressed)
	game_modes_button.pressed.connect(_on_game_modes_pressed)
	settings_button.pressed.connect(_on_settings_pressed)
	quit_button.pressed.connect(_on_quit_pressed)

func _on_start_pressed() -> void:
	# Troca para a cena do mundo
	get_tree().change_scene_to_file(WORLD_SCENE_PATH)

func _on_game_modes_pressed() -> void:
	# Aqui você pode abrir um sub-menu ou trocar de cena
	print("Abrir Seleção de Modos")

func _on_settings_pressed() -> void:
	# Sugestão: Instanciar um popup de configurações ou trocar de cena
	print("Abrir Configurações")

func _on_quit_pressed() -> void:
	get_tree().quit()
