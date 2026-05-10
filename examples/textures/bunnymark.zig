//!******************************************************************************************
//!
//!   raylib-zig port of the [textures] example - Bunnymark
//!   https://github.com/raysan5/raylib/blob/master/examples/textures/textures_bunnymark.c
//!
//!   Example complexity rating: [★★★☆] 3/4
//!
//!   Example originally created with raylib 1.6, last time updated with raylib 2.5
//!
//!   Translated to raylib-zig by Timothy Fiss (@TheFissk)
//!
//!   Example licensed under an unmodified zlib/libpng license, which is an OSI-certified,
//!   BSD-like license that allows static linking with closed source software
//!
//!   Copyright (c) 2014-2025 Ramon Santamaria (@raysan5)
//!
//!*******************************************************************************************/

const rl = @import("raylib");
const std = @import("std");

/// 50K bunnies limit
const max_bunnies = 50000;

/// This is the maximum amount of elements (quads) per batch
/// NOTE: This value is defined in [rlgl] module and can be changed there
const max_batch_elements = 8192;

const Bunny = struct {
    position: rl.Vector2,
    speed: rl.Vector2,
    color: rl.Color,
};

//------------------------------------------------------------------------------------
// Program main entry point
//------------------------------------------------------------------------------------
pub fn main() anyerror!void {
    //--------------------------------------------------------------------------------------
    const screen_width = 800;
    const screen_height = 450;

    rl.initWindow(screen_width, screen_height, "raylib [textures] example - bunnymark");
    defer rl.closeWindow();

    // Load bunny texture
    const texBunny = try rl.loadTexture("examples/textures/resources/wabbit_alpha.png");

    var dba = std.heap.DebugAllocator(.{}){};
    defer _ = dba.deinit();
    const allocator = dba.allocator();

    var bunnies = std.ArrayList(Bunny).empty;
    defer bunnies.deinit(allocator);

    rl.setTargetFPS(60); // Set our game to run at 60 frames-per-second
    //--------------------------------------------------------------------------------------

    // Main game loop
    while (!rl.windowShouldClose()) // Detect window close button or ESC key
    {
        // Update
        //----------------------------------------------------------------------------------
        if (rl.isMouseButtonDown(.left)) {
            // Create more bunnies
            for (0..100) |_| {
                if (bunnies.items.len < max_bunnies) {
                    try bunnies.append(allocator, .{ .position = rl.getMousePosition(), .speed = .{
                        .x = @as(f32, @floatFromInt(rl.getRandomValue(-250, 250))) / 60,
                        .y = @as(f32, @floatFromInt(rl.getRandomValue(-250, 250))) / 60,
                    }, .color = .{
                        .r = @intCast(rl.getRandomValue(50, 240)),
                        .g = @intCast(rl.getRandomValue(80, 240)),
                        .b = @intCast(rl.getRandomValue(10, 240)),
                        .a = 255,
                    } });
                }
            }
        }

        // Update bunnies
        for (bunnies.items) |*bunny| {
            bunny.position.x += bunny.speed.x;
            bunny.position.y += bunny.speed.y;

            if (((@as(i32, @intFromFloat(bunny.position.x)) + @divFloor(texBunny.width, 2)) > rl.getScreenWidth()) or
                ((@as(i32, @intFromFloat(bunny.position.x)) + @divFloor(texBunny.width, 2)) < 0)) bunny.speed.x *= -1;
            if (((@as(i32, @intFromFloat(bunny.position.y)) + @divFloor(texBunny.height, 2)) > rl.getScreenHeight()) or
                ((@as(i32, @intFromFloat(bunny.position.y)) + @divFloor(texBunny.height, 2) - 40) < 0)) bunny.speed.y *= -1;
        }
        //----------------------------------------------------------------------------------

        // Draw
        //----------------------------------------------------------------------------------
        rl.beginDrawing();
        defer rl.endDrawing();

        rl.clearBackground(.ray_white);

        for (bunnies.items) |bunny| {
            // NOTE: When internal batch buffer limit is reached (MAX_BATCH_ELEMENTS),
            // a draw call is launched and buffer starts being filled again;
            // before issuing a draw call, updated vertex data from internal CPU buffer is send to GPU...
            // Process of sending data is costly and it could happen that GPU data has not been completely
            // processed for drawing while new data is tried to be sent (updating current in-use buffers)
            // it could generates a stall and consequently a frame drop, limiting the number of drawn bunnies
            rl.drawTexture(texBunny, @intFromFloat(bunny.position.x), @intFromFloat(bunny.position.y), bunny.color);
        }

        rl.drawRectangle(0, 0, screen_width, 40, .black);
        rl.drawText(rl.textFormat("bunnies: %i", .{bunnies.items.len}), 120, 10, 20, .green);
        rl.drawText(rl.textFormat("batched draw calls: %i", .{1 + @divFloor(bunnies.items.len, max_batch_elements)}), 320, 10, 20, .maroon);

        rl.drawFPS(10, 10);

        //----------------------------------------------------------------------------------
    }
}
