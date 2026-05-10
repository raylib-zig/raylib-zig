//!******************************************************************************************
//!
//!   raylib-zig port of the [textures] example - Fog of war
//!   https://github.com/raysan5/raylib/blob/master/examples/textures/textures_fog_of_war.c
//!
//!   Example complexity rating: [★★★☆] 3/4
//!
//!   Example originally created with raylib 4.2, last time updated with raylib 4.2
//!
//!   Translated to raylib-zig by Timothy Fiss (@TheFissk)
//!
//!   Example licensed under an unmodified zlib/libpng license, which is an OSI-certified,
//!   BSD-like license that allows static linking with closed source software
//!
//!   Copyright (c) 2018-2025 Ramon Santamaria (@raysan5)
//!
//!*******************************************************************************************/

const rl = @import("raylib");
const std = @import("std");

const map_tile_size = 32; // Tiles size 32x32 pixels
const player_size = 16; // Player size
const player_tile_visibility = 2; // Player can see 2 tiles around its position

/// Map data type
const Map = struct {
    /// Number of tiles in X axis
    tiles_x: i32,
    /// Number of tiles in Y axis
    tiles_y: i32,
    /// Tile ids (tilesX*tilesY), defines type of tile to draw
    tile_ids: []u8,
    /// Tile fog state (tilesX*tilesY), defines if a tile has fog or half-fog
    tile_fog: []u8,
};

//------------------------------------------------------------------------------------
// Program main entry point
//------------------------------------------------------------------------------------
pub fn main() anyerror!void {
    // Initialization
    //--------------------------------------------------------------------------------------
    const screen_width = 800;
    const screen_height = 450;

    rl.initWindow(screen_width, screen_height, "raylib [textures] example - fog of war");
    defer rl.closeWindow();

    var dba = std.heap.DebugAllocator(.{}){};
    defer _ = dba.deinit();
    var allocator = dba.allocator();
    // NOTE: We can have up to 256 values for tile ids and for tile fog state,
    // probably we don't need that many values for fog state, it can be optimized
    // to use only 2 bits per fog state (reducing size by 4) but logic will be a bit more complex
    var map = Map{
        .tiles_x = 25,
        .tiles_y = 15,
        .tile_ids = try allocator.alloc(u8, 25 * 15),
        .tile_fog = try allocator.alloc(u8, 25 * 15),
    };
    defer allocator.free(map.tile_ids);
    defer allocator.free(map.tile_fog);

    // Load map tiles (generating 2 random tile ids for testing)
    // NOTE: Map tile ids should be probably loaded from an external map file
    for (0..map.tile_ids.len) |i| {
        map.tile_fog[i] = 0; // No fog at the beginning
        map.tile_ids[i] = @intCast(rl.getRandomValue(0, 1));
    }

    // Player position on the screen (pixel coordinates, not tile coordinates)
    var player_position = rl.Vector2{ .x = 180, .y = 130 };
    var player_tile_x: i32 = 0;
    var player_tile_y: i32 = 0;

    // Render texture to render fog of war
    // NOTE: To get an automatic smooth-fog effect we use a render texture to render fog
    // at a smaller size (one pixel per tile) and scale it on drawing with bilinear filtering
    const fog_of_war = try rl.loadRenderTexture(map.tiles_x, map.tiles_y);
    defer rl.unloadRenderTexture(fog_of_war);
    rl.setTextureFilter(fog_of_war.texture, .bilinear);

    rl.setTargetFPS(60); // Set our game to run at 60 frames-per-second
    //--------------------------------------------------------------------------------------

    // Main game loop
    while (!rl.windowShouldClose()) // Detect window close button or ESC key
    {
        // Update
        //----------------------------------------------------------------------------------
        // Move player around
        if (rl.isKeyDown(.right)) player_position.x += 5;
        if (rl.isKeyDown(.left)) player_position.x -= 5;
        if (rl.isKeyDown(.down)) player_position.y += 5;
        if (rl.isKeyDown(.up)) player_position.y -= 5;

        // Check player position to avoid moving outside tilemap limits
        if (player_position.x < 0) {
            player_position.x = 0;
        } else if ((@as(i32, @intFromFloat(player_position.x)) + player_size) > (map.tiles_x * map_tile_size)) {
            player_position.x = @floatFromInt(map.tiles_x * map_tile_size - player_size);
        }
        if (player_position.y < 0) {
            player_position.y = 0;
        } else if ((@as(i32, @intFromFloat(player_position.y)) + player_size) > (map.tiles_y * map_tile_size)) {
            player_position.y = @floatFromInt(map.tiles_y * map_tile_size - player_size);
        }

        // Previous visited tiles are set to partial fog
        for (0..@intCast(map.tiles_x * map.tiles_y)) |i| {
            if (map.tile_fog[i] == 1) map.tile_fog[i] = 2;
        }

        // Get current tile position from player pixel position
        player_tile_x = @intFromFloat((player_position.x + map_tile_size / 2) / map_tile_size);
        player_tile_y = @intFromFloat((player_position.y + map_tile_size / 2) / map_tile_size);

        // Check visibility and update fog
        // NOTE: We check tilemap limits to avoid processing tiles out-of-array-bounds (it could crash program)
        const ymin = @as(usize, @intCast(if (player_tile_y - player_tile_visibility < 0) 0 else player_tile_y - player_tile_visibility));
        const ymax = @as(usize, @intCast(if (player_tile_y + player_tile_visibility >= map.tiles_y) map.tiles_y - 1 else player_tile_y + player_tile_visibility));
        const xmin = @as(usize, @intCast(if (player_tile_x - player_tile_visibility < 0) 0 else player_tile_x - player_tile_visibility));
        const xmax = @as(usize, @intCast(if (player_tile_x + player_tile_visibility >= map.tiles_x) map.tiles_x - 1 else player_tile_x + player_tile_visibility));
        for (ymin..ymax) |y| {
            for (xmin..xmax) |x| {
                map.tile_fog[y * @as(usize, @intCast(map.tiles_x)) + x] = 1;
            }
        }

        //----------------------------------------------------------------------------------

        // Draw
        //----------------------------------------------------------------------------------
        // Draw fog of war to a small render texture for automatic smoothing on scaling
        rl.beginTextureMode(fog_of_war);
        rl.clearBackground(.blank);
        for (0..@as(usize, @intCast(map.tiles_y))) |y| {
            for (0..@as(usize, @intCast(map.tiles_x))) |x| {
                if (map.tile_fog[y * @as(usize, @intCast(map.tiles_x)) + x] == 0) {
                    rl.drawRectangle(@intCast(x), @intCast(y), 1, 1, .black);
                } else if (map.tile_fog[y * @as(usize, @intCast(map.tiles_x)) + x] == 2) {
                    rl.drawRectangle(@intCast(x), @intCast(y), 1, 1, rl.fade(.black, 0.8));
                }
            }
        }
        rl.endTextureMode();

        rl.beginDrawing();
        defer rl.endDrawing();

        rl.clearBackground(.ray_white);

        for (0..@intCast(map.tiles_y)) |y| {
            for (0..@intCast(map.tiles_x)) |x| {
                // Draw tiles from id (and tile borders)
                rl.drawRectangle(@intCast(x * map_tile_size), @intCast(y * map_tile_size), map_tile_size, map_tile_size, if (map.tile_ids[y * @as(usize, @intCast(map.tiles_x)) + x] == 0) .blue else rl.fade(.blue, 0.9));
                rl.drawRectangleLines(@intCast(x * map_tile_size), @intCast(y * map_tile_size), map_tile_size, map_tile_size, rl.fade(.dark_blue, 0.5));
            }
        }

        // Draw player
        rl.drawRectangleV(player_position, .{ .x = player_size, .y = player_size }, .red);

        // Draw fog of war (scaled to full map, bilinear filtering)
        rl.drawTexturePro(fog_of_war.texture, .{
            .x = 0,
            .y = 0,
            .width = @floatFromInt(fog_of_war.texture.width),
            .height = @floatFromInt(-fog_of_war.texture.height),
        }, .{
            .x = 0,
            .y = 0,
            .width = @floatFromInt(map.tiles_x * map_tile_size),
            .height = @floatFromInt(map.tiles_y * map_tile_size),
        }, rl.Vector2.zero(), 0.0, .white);

        // Draw player current tile
        rl.drawText(rl.textFormat("Current tile: [%i,%i]", .{ player_tile_x, player_tile_y }), 10, 10, 20, .ray_white);
        rl.drawText("ARROW KEYS to move", 10, screen_height - 25, 20, .ray_white);

        //----------------------------------------------------------------------------------
    }
}
