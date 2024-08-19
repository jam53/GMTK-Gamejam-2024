extends Node2D

@export var chunk_texture: Texture2D  # Texture to be used for chunks
@export var player: CharacterBody2D
@export_range(9, 10000) var amount_of_chunks := 25  # Number of chunks, must be a perfect square

var chunk_size: int  # Size of a chunk, inferred from `chunk_texture`
var chunks_pool: Dictionary  # Key: Vector2 (position), Value: Sprite2D (chunk in world).

func _ready():
    assert(chunk_texture.get_size().x == chunk_texture.get_size().y, "Chunk texture isn't square") # Ensure that the chunk texture is square to prevent any issues when tiling
    assert(amount_of_chunks > 0 and fmod(sqrt(amount_of_chunks), 1) == 0, "The amount of chunks (" + str(amount_of_chunks) + ") is not a perfect square.") # Ensure the number of chunks forms a square

    chunk_size = chunk_texture.get_size().x # Initialize chunk size from texture size

    spawn_initial_chunks(player.position) # Spawn the initial set of chunks around the player

func _process(_delta: float):
    # Check if the player's position is within the chunk area with some margin
    if !is_position_within_any(chunks_pool.keys(), player.position, chunk_size / 4):
        # Determine which chunks need to be moved based on player's position
        var chunk_positions_to_change: Array[Vector2] = get_furthest_side_chunks_positions(chunks_pool.keys(), player.position)

        for chunk_pos in chunk_positions_to_change:
            var chunk_sprite: Sprite2D = chunks_pool[chunk_pos]
            chunks_pool.erase(chunk_pos)

            var grid_size := get_grid_size()

            # Move chunks to the opposite side of the grid based on player’s position
            if are_chunks_row(chunk_positions_to_change) and chunk_positions_to_change[0].y < player.position.y:
                chunk_pos.y += chunk_size * grid_size  # Move chunks down
            elif are_chunks_row(chunk_positions_to_change) and chunk_positions_to_change[0].y > player.position.y:
                chunk_pos.y -= chunk_size * grid_size  # Move chunks up
            elif !are_chunks_row(chunk_positions_to_change) and chunk_positions_to_change[0].x < player.position.x:
                chunk_pos.x += chunk_size * grid_size  # Move chunks right
            elif !are_chunks_row(chunk_positions_to_change) and chunk_positions_to_change[0].x > player.position.x:
                chunk_pos.x -= chunk_size * grid_size  # Move chunks left

            # Update chunk sprite position
            chunk_sprite.position = chunk_pos

            # Re-add the chunk to the pool with the new position
            chunks_pool[chunk_pos] = chunk_sprite

func spawn_initial_chunks(player_pos: Vector2):
    # Generate initial positions for chunks around the player
    var chunk_locations_to_spawn: Array[Vector2] = generate_positions_around(player_pos, amount_of_chunks)
    chunk_locations_to_spawn.append(player_pos)  

    for chunk_loc in chunk_locations_to_spawn:
        spawn_tile(chunk_loc)

# Instantiates a tile at a given position
func spawn_tile(pos: Vector2):
    var tile := Sprite2D.new()
    tile.texture = chunk_texture
    tile.position = pos

    chunks_pool[pos] = tile  
    add_child(tile) 

func generate_positions_around(center: Vector2, num_positions: int) -> Array[Vector2]:
    var positions: Array[Vector2] = []
    var distance := chunk_size  # Distance from the center point

    var grid_size = get_grid_size()

    # Generate positions in a grid around the center
    for x in range(-grid_size / 2, grid_size / 2 + 1):
        for y in range(-grid_size / 2, grid_size / 2 + 1):
            if x == 0 and y == 0:
                continue  # Skip the center point

            positions.append(center + Vector2(x * distance, y * distance))
            
            if positions.size() >= num_positions:
                return positions  # Return early if enough positions are generated

    return positions

# Checks if a position is within a given distance of any chunk 
func is_position_within_any(chunks_array: Array, position: Vector2, distance: float) -> bool:
    for chunk in chunks_array:
        if position.distance_to(chunk) <= distance:
            return true
    return false


# Determines which side of the chunk grid is furthest from the given position and returns the chunks on that side.
func get_furthest_side_chunks_positions(chunks_array: Array, position: Vector2) -> Array[Vector2]:
    if chunks_array.size() == 0:
        return []
    
    # Initialize boundary values
    var min_x = INF
    var max_x = -INF
    var min_y = INF
    var max_y = -INF
    
    # Dictionaries to store chunks on each boundary side
    var top_row_chunks: Array[Vector2] = []
    var bottom_row_chunks: Array[Vector2] = []
    var left_column_chunks: Array[Vector2] = []
    var right_column_chunks: Array[Vector2] = []
    
    # Determine the boundaries of the grid
    for chunk in chunks_array:
        if chunk.x < min_x:
            min_x = chunk.x
        if chunk.x > max_x:
            max_x = chunk.x
        if chunk.y < min_y:
            min_y = chunk.y
        if chunk.y > max_y:
            max_y = chunk.y
    
    # Categorize chunks based on their positions
    for chunk in chunks_array:
        if chunk.y == max_y:
            top_row_chunks.append(chunk)
        if chunk.y == min_y:
            bottom_row_chunks.append(chunk)
        if chunk.x == min_x:
            left_column_chunks.append(chunk)
        if chunk.x == max_x:
            right_column_chunks.append(chunk)
    
    # Calculate distances from the position to each boundary side
    var top_distance = INF
    for chunk in top_row_chunks:
        var dist = position.distance_to(chunk)
        if dist < top_distance:
            top_distance = dist
    
    var bottom_distance = INF
    for chunk in bottom_row_chunks:
        var dist = position.distance_to(chunk)
        if dist < bottom_distance:
            bottom_distance = dist
    
    var left_distance = INF
    for chunk in left_column_chunks:
        var dist = position.distance_to(chunk)
        if dist < left_distance:
            left_distance = dist
    
    var right_distance = INF
    for chunk in right_column_chunks:
        var dist = position.distance_to(chunk)
        if dist < right_distance:
            right_distance = dist
    
    # Determine the furthest side
    var furthest_side_chunks = []
    
    if top_distance >= bottom_distance and top_distance >= left_distance and top_distance >= right_distance:
        furthest_side_chunks = top_row_chunks
    elif bottom_distance >= top_distance and bottom_distance >= left_distance and bottom_distance >= right_distance:
        furthest_side_chunks = bottom_row_chunks
    elif left_distance >= top_distance and left_distance >= bottom_distance and left_distance >= right_distance:
        furthest_side_chunks = left_column_chunks
    elif right_distance >= top_distance and right_distance >= bottom_distance and right_distance >= left_distance:
        furthest_side_chunks = right_column_chunks
    
    return furthest_side_chunks

# Checks if the provided chunks are lined next to each other in a row
func are_chunks_row(chunks: Array[Vector2]) -> bool:
    var y_pos = chunks[0].y

    for chunk in chunks:
        if y_pos != chunk.y:
            return false  # Chunks are not in a row

    return true  # Chunks are in a row

# Returns the grid size (number of rows or columns)
func get_grid_size() -> int:
    return int(ceil(sqrt(amount_of_chunks)))
