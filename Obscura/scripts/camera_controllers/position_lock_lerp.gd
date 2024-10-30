class_name PositionLockLerp
extends CameraControllerBase

const STUTTER_BUFFER = 0.01

@export var follow_speed:float = 5
@export var catchup_speed:float = 5
@export var leash_distance:float = 5

func _ready() -> void:
	super()
	position = target.position
	

func _process(delta: float) -> void:
	if !current:
		return
	
	if draw_camera_logic:
		draw_logic()
	
	var cpos_vec2:Vector2 = Vector2(global_position.x, global_position.z)
	var tpos_vec2:Vector2 = Vector2(target.global_position.x, target.global_position.z)
	var dist:float = cpos_vec2.distance_to(tpos_vec2)
	# only start lerping when there is a nonzero distance between camera and vessel
	if dist != 0:
		# lerp away from target while target is moving
		if target.velocity != Vector3(0, 0, 0):
			# lerp towards a position leash distance away in negative vessel velocity direction
			var new_pos = target.global_position + -1 * target.velocity.normalized() * leash_distance
			cpos_vec2 = cpos_vec2.lerp(Vector2(new_pos.x, new_pos.z), follow_speed * delta)
			global_position.x = target.velocity.x * delta + cpos_vec2.x
			global_position.z = target.velocity.z * delta + cpos_vec2.y
		# lerp towards from target while target is not moving
		else:
			cpos_vec2 = cpos_vec2.lerp(tpos_vec2, catchup_speed * delta)
			global_position.x = cpos_vec2.x
			global_position.z = cpos_vec2.y
	#if the camera is close enough to the vessel, set their positions equal
	if dist < STUTTER_BUFFER and target.velocity == Vector3(0, 0, 0):
		global_position.x = target.global_position.x	
		global_position.z = target.global_position.z	

	super(delta)
	
func draw_logic() -> void:
	var mesh_instance := MeshInstance3D.new()
	var immediate_mesh := ImmediateMesh.new()
	var material := ORMMaterial3D.new()
	
	mesh_instance.mesh = immediate_mesh
	mesh_instance.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	
	immediate_mesh.surface_begin(Mesh.PRIMITIVE_LINES, material)
	
	immediate_mesh.surface_add_vertex(Vector3(2.5, 0, 0))
	immediate_mesh.surface_add_vertex(Vector3(-2.5, 0, 0))
	
	immediate_mesh.surface_add_vertex(Vector3(0, 0, 2.5))
	immediate_mesh.surface_add_vertex(Vector3(0, 0, -2.5))
	
	immediate_mesh.surface_end()

	material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	material.albedo_color = Color.BLACK
	
	add_child(mesh_instance)
	mesh_instance.global_transform = Transform3D.IDENTITY
	mesh_instance.global_position = Vector3(global_position.x, target.global_position.y, global_position.z)
	
	#mesh is freed after one update of _process
	await get_tree().process_frame
	mesh_instance.queue_free()
