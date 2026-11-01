extends DirectionalLight3D

# Geographic calibration for Tucheng (GPS: 24.9765° N, 121.4370° E)
#   +X: East, -X: West, -Z: North, +Z: South, +Y: Up

var auto_rotate = false
var rotate_speed = 30.0

var target_rot = Vector3(-68, 0, 0)
var target_color = Color(1.0, 0.98, 0.92)
var target_energy = 1.6

@onready var world_env = get_node_or_null("../WorldEnvironment")
@onready var hud_label = get_node_or_null("../HUD/Panel/Label")
var current_mode_idx = 0
var fog_enabled_flag = true
var frame_cnt = 0

func _ready():
	rotation_degrees = target_rot
	light_color = target_color
	light_energy = target_energy
	light_volumetric_fog_energy = 1.5
	update_hud("☀️ 土城正午日光 (按 1/2/3 切換日光，按 F 開關體積迷霧，按 R 自動公轉)")

func _process(delta):


	if auto_rotate:
		target_rot.y += rotate_speed * delta
		if target_rot.y >= 360.0:
			target_rot.y -= 360.0
		var rad = deg_to_rad(target_rot.y)
		var h = sin(rad)
		target_rot.x = -10.0 - 60.0 * max(0.0, h)
		if h < 0.25:
			target_color = Color(1.0, 0.52, 0.16)
			target_energy = 2.4
		else:
			target_color = Color(1.0, 0.98, 0.92)
			target_energy = 1.6
	
	rotation_degrees.x = lerp_angle(deg_to_rad(rotation_degrees.x), deg_to_rad(target_rot.x), 0.1) * 180.0 / PI
	rotation_degrees.y = lerp_angle(deg_to_rad(rotation_degrees.y), deg_to_rad(target_rot.y), 0.1) * 180.0 / PI
	rotation_degrees.z = 0.0
	light_color = light_color.lerp(target_color, 0.1)
	light_energy = lerp(light_energy, target_energy, 0.1)

func _input(event):
	if event is InputEventKey and event.pressed and not event.echo:
		if event.keycode == KEY_SPACE:
			toggle_next_mode()
		elif event.keycode == KEY_1:
			set_noon()
		elif event.keycode == KEY_2:
			set_sunset()
		elif event.keycode == KEY_3:
			set_dawn()
		elif event.keycode == KEY_R:
			auto_rotate = !auto_rotate
			update_hud("🔄 太陽公轉中..." if auto_rotate else "⏹️ 太陽旋轉暫停")
		elif event.keycode == KEY_F:
			toggle_fog()

func toggle_next_mode():
	current_mode_idx = (current_mode_idx + 1) % 3
	if current_mode_idx == 0: set_noon()
	elif current_mode_idx == 1: set_sunset()
	elif current_mode_idx == 2: set_dawn()

func set_noon():
	auto_rotate = false
	current_mode_idx = 0
	target_rot = Vector3(-68, 0, 0)
	target_color = Color(1.0, 0.98, 0.92)
	target_energy = 1.6
	light_volumetric_fog_energy = 1.2
	update_hud("☀️ 土城正午日光 (南向直射光・中庭花園透光完整・陰影垂直)")

func set_sunset():
	auto_rotate = false
	current_mode_idx = 1
	target_rot = Vector3(-12, 100, 0)
	target_color = Color(1.0, 0.52, 0.16)
	target_energy = 2.4
	light_volumetric_fog_energy = 2.8
	update_hud("🌇 土城夕陽西下 (大漢溪西方暖陽橫切中庭・穿透公寓拉出長影)")

func set_dawn():
	auto_rotate = false
	current_mode_idx = 2
	target_rot = Vector3(-14, -100, 0)
	target_color = Color(1.0, 0.76, 0.86)
	target_energy = 1.8
	light_volumetric_fog_energy = 2.0
	update_hud("🌅 土城清晨破曉 (東方山脈粉紫晨曦・微光漫射)")

func toggle_fog():
	fog_enabled_flag = !fog_enabled_flag
	if world_env and world_env.environment:
		world_env.environment.volumetric_fog_enabled = fog_enabled_flag
	update_hud("🌫️ 體積迷霧：開啟 (耶穌光)" if fog_enabled_flag else "🌫️ 體積迷霧：關閉 (清晰無霧)")

func update_hud(text):
	if hud_label:
		hud_label.text = text
	print(text)
