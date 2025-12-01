extends Area2D
class_name Car
# ----------------------------
#         EXPORT VARIABLES
# ----------------------------
@export var is_left: bool = false          # Si vrai, la voiture se déplace vers la gauche
@export var speed: int = 20                # Vitesse de déplacement
@export var model: int = 0                 # Index du sprite à afficher
@export var cars: Array[Texture2D] = []    # Base de données des sprites de voitures

# ----------------------------
#          VARIABLES
# ----------------------------
var camera_offset: int = 50                # Décalage utilisé pour calculer la limite de destruction
var limit: int = 256 + camera_offset       # Limite de position où la voiture est détruite
var dir: int = 1                           # Direction du mouvement (+1 ou -1)


# ----------------------------
#         FONCTION READY
# ----------------------------
func _ready() -> void:
	# Assigne le sprite correspondant au modèle choisi
	$Sprite.texture = cars[model]
	
	# Retourne le sprite si la voiture circule de gauche à droite
	if is_left:
		$Sprite.flip_h = true
		dir = -1


# ----------------------------
#      UPDATE DU MOUVEMENT
# ----------------------------
func _process(delta: float) -> void:
	# Déplace la voiture horizontalement
	position.x += speed * dir * delta

	# Supprime la voiture si elle sort des limites
	if position.x >= limit or position.x <= -limit:
		queue_free()


# ----------------------------
#   COLLISION AVEC LE PLAYER
# ----------------------------
func _on_body_entered(player: Player) -> void:
	# Appelle la mort du joueur lorsqu'il est touché
	player.die()
