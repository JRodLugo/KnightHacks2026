class_name LevelData extends Resource

@export var thumbnail: CompressedTexture2D # Thumbnail for level select
@export var level_name: String = "Placeholder Level Title" # Self-explanatory
@export var level_scene: PackedScene # Actual scene for the level
@export var collectible_amount: int = 1 # Amount of collectibles in the level
@export var next: LevelData # Level to transition to after finishing this one
@export var index: int = 0 # Absolute position in the level order, mostly for level select population and saving data
