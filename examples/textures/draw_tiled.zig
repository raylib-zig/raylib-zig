//!*******************************************************************************************
//!
//!   raylib-zig port of the [textures] example - Draw part of the texture tiled
//!
//!   Example complexity rating: [★★★☆] 3/4
//!
//!   Example originally created with raylib 3.0, last time updated with raylib 4.2
//!
//!   Example contributed by Vlad Adrian (@demizdor) and reviewed by Ramon Santamaria (@raysan5)
//!
//!   Example licensed under an unmodified zlib/libpng license, which is an OSI-certified,
//!   BSD-like license that allows static linking with closed source software
//!
//!   Copyright (c) 2020-2025 Vlad Adrian (@demizdor) and Ramon Santamaria (@raysan5)
//!
//!*******************************************************************************************/

// I'm not sure if this one is rendering correctly the example on the raylib website is broken.

const rl = @import("raylib");

/// Max width for the options container
const opt_width: comptime_float = 220;
/// Size for the margins
const margin_size: comptime_float = 8;
/// Size of the color select buttons
const color_size: comptime_float = 16;

//------------------------------------------------------------------------------------
// Program main entry point
//------------------------------------------------------------------------------------
pub fn main() anyerror!void {
    // Initialization
    //--------------------------------------------------------------------------------------
    const screen_width = 800;
    const screen_height = 450;

    rl.setConfigFlags(.{ .window_resizable = true }); // Make the window resizable
    rl.initWindow(screen_width, screen_height, "raylib [textures] example - Draw part of a texture tiled");
    defer rl.closeWindow();

    // NOTE: Textures MUST be loaded after Window initialization (OpenGL context is required)
    const tex_pattern = try rl.loadTexture("examples/textures/resources/patterns.png");
    defer rl.unloadTexture(tex_pattern);
    rl.setTextureFilter(tex_pattern, .trilinear); // Makes the texture smoother when upscaled

    // Coordinates for all patterns inside the texture
    const rec_patterns = [_]rl.Rectangle{
        .{ .x = 3, .y = 3, .width = 66, .height = 66 },
        .{ .x = 75, .y = 3, .width = 100, .height = 100 },
        .{ .x = 3, .y = 75, .width = 66, .height = 66 },
        .{ .x = 7, .y = 156, .width = 50, .height = 50 },
        .{ .x = 85, .y = 106, .width = 90, .height = 45 },
        .{ .x = 75, .y = 154, .width = 100, .height = 60 },
    };

    // Setup colors
    const colors = [_]rl.Color{ .black, .maroon, .orange, .blue, .purple, .beige, .lime, .red, .dark_gray, .sky_blue };

    var color_recs: [colors.len]rl.Rectangle = @splat(.{ .x = 0, .y = 0, .width = 0, .height = 0 });

    // Calculate rectangle for each color
    var x: f32 = 0;
    var y: f32 = 0;
    for (&color_recs, 0..) |*rec, i| {
        rec.x = 2 + margin_size + x;
        rec.y = 22 + 256 + margin_size + y;
        rec.width = color_size * 2;
        rec.height = color_size;

        if (i == (@divFloor(colors.len, 2) - 1)) {
            x = 0;
            y += color_size + margin_size;
        } else x += (color_size * 2 + margin_size);
    }

    var active_pattern: rl.Rectangle = rec_patterns[0];
    var active_color_index: usize = 0;
    var scale: f32 = 1.0;
    var rotation: f32 = 0.0;

    rl.setTargetFPS(60);
    //---------------------------------------------------------------------------------------

    // Main game loop
    while (!rl.windowShouldClose()) // Detect window close button or ESC key
    {
        // Update
        //----------------------------------------------------------------------------------
        // Handle mouse
        if (rl.isMouseButtonPressed(.left)) {
            const mouse = rl.getMousePosition();

            // Check which pattern was clicked and set it as the active pattern
            for (rec_patterns) |pattern| {
                if (rl.checkCollisionPointRec(mouse, .{
                    .x = 2 + margin_size + pattern.x,
                    .y = 40 + margin_size + pattern.y,
                    .width = pattern.width,
                    .height = pattern.height,
                })) {
                    active_pattern = pattern;
                    break;
                }
            }

            // Check to see which color was clicked and set it as the active color
            for (color_recs, 0..) |rec, i| {
                if (rl.checkCollisionPointRec(mouse, rec)) {
                    active_color_index = i;
                    break;
                }
            }
        }

        // Handle keys

        // Change scale
        if (rl.isKeyPressed(.up)) scale += 0.25;
        if (rl.isKeyPressed(.down)) scale -= 0.25;
        if (scale > 10.0) {
            scale = 10.0;
        } else if (scale < 0.25) {
            scale = 0.25;
        }

        // Change rotation
        if (rl.isKeyPressed(.left)) rotation -= 25.0;
        if (rl.isKeyPressed(.right)) rotation += 25.0;

        // Reset
        if (rl.isKeyPressed(.space)) {
            rotation = 0.0;
            scale = 1.0;
        }
        //----------------------------------------------------------------------------------

        // Draw
        //----------------------------------------------------------------------------------
        rl.beginDrawing();
        defer rl.endDrawing();
        rl.clearBackground(.ray_white);

        // Draw the tiled area
        drawTextureTiled(tex_pattern, active_pattern, .{
            .x = opt_width + margin_size,
            .y = margin_size,
            .width = @as(f32, @floatFromInt(rl.getScreenWidth())) - opt_width - 2.0 * margin_size,
            .height = @as(f32, @floatFromInt(rl.getScreenHeight())) - 2.0 * margin_size,
        }, .{ .x = 0.0, .y = 0.0 }, rotation, scale, colors[active_color_index]);

        // Draw options
        rl.drawRectangle(@intFromFloat(margin_size), @intFromFloat(margin_size), @intFromFloat(opt_width - margin_size), rl.getScreenHeight() - 2 * @as(i32, @intFromFloat(margin_size)), rl.colorAlpha(.light_gray, 0.5));

        rl.drawText("Select Pattern", 2 + margin_size, 30 + margin_size, 10, .black);
        rl.drawTexture(tex_pattern, 2 + margin_size, 40 + margin_size, .black);
        rl.drawRectangle(@intFromFloat(2 + margin_size + active_pattern.x), @intFromFloat(40 + margin_size + active_pattern.y), @intFromFloat(active_pattern.width), @intFromFloat(active_pattern.height), rl.colorAlpha(.dark_blue, 0.3));

        rl.drawText("Select Color", 2 + margin_size, 10 + 256 + margin_size, 10, .black);
        for (colors, color_recs, 0..) |color, rec, i| {
            rl.drawRectangleRec(rec, color);
            if (active_color_index == i) rl.drawRectangleLinesEx(rec, 3, rl.colorAlpha(.white, 0.5));
        }

        rl.drawText("Scale (UP/DOWN to change)", 2 + margin_size, 80 + 256 + margin_size, 10, .black);
        rl.drawText(rl.textFormat("%.2fx", .{scale}), 2 + margin_size, 92 + 256 + margin_size, 20, .black);

        rl.drawText("Rotation (LEFT/RIGHT to change)", 2 + margin_size, 122 + 256 + margin_size, 10, .black);
        rl.drawText(rl.textFormat("%.0f degrees", .{rotation}), 2 + margin_size, 134 + 256 + margin_size, 20, .black);

        rl.drawText("Press [SPACE] to reset", 2 + margin_size, 164 + 256 + margin_size, 10, .dark_blue);

        // Draw FPS
        rl.drawText(rl.textFormat("%i FPS", .{rl.getFPS()}), 2 + margin_size, 2 + margin_size, 20, .black);
        //----------------------------------------------------------------------------------
    }
}

/// Draw part of a texture (defined by a rectangle) with rotation and scale tiled into dest.
fn drawTextureTiled(texture: rl.Texture2D, source: rl.Rectangle, dest: rl.Rectangle, origin: rl.Vector2, rotation: f32, scale: f32, tint: rl.Color) void {
    if ((texture.id <= 0) or (scale <= 0.0)) return; // Wanna see a infinite loop?!...just delete this line!
    if ((source.width <= 0) or (source.height <= 0)) return;

    const tile_width_f = source.width * scale;
    const tile_height_f = source.height * scale;
    if ((dest.width < tile_width_f) and (dest.height < tile_height_f)) {
        // Can fit only one tile
        rl.drawTexturePro(texture, .{
            .x = source.x,
            .y = source.y,
            .width = (dest.width / tile_width_f) * source.width,
            .height = (dest.height / tile_height_f) * source.height,
        }, .{
            .x = dest.x,
            .y = dest.y,
            .width = dest.width,
            .height = dest.height,
        }, origin, rotation, tint);
    } else if (dest.width <= tile_width_f) {
        // Tiled vertically (one column)
        var dy: f32 = 0;
        while (dy + tile_height_f < dest.height) : (dy += tile_height_f) {
            rl.drawTexturePro(texture, .{
                .x = source.x,
                .y = source.y,
                .width = (dest.width / tile_width_f) * source.width,
                .height = source.height,
            }, .{
                .x = dest.x,
                .y = dest.y + dy,
                .width = dest.width,
                .height = tile_height_f,
            }, origin, rotation, tint);
        }

        // Fit last tile
        if (dy < dest.height) {
            rl.drawTexturePro(texture, .{
                .x = source.x,
                .y = source.y,
                .width = (dest.width / tile_width_f) * source.width,
                .height = ((dest.height - dy) / tile_height_f) * source.height,
            }, .{
                .x = dest.x,
                .y = dest.y + dy,
                .width = dest.width,
                .height = dest.height - dy,
            }, origin, rotation, tint);
        }
    } else if (dest.height <= tile_height_f) {
        // Tiled horizontally (one row)
        var dx: f32 = 0;
        while (dx + tile_width_f < dest.width) : (dx += tile_width_f) {
            rl.drawTexturePro(texture, .{
                .x = source.x,
                .y = source.y,
                .width = source.width,
                .height = (dest.height / tile_height_f) * source.height,
            }, .{
                .x = dest.x + dx,
                .y = dest.y,
                .width = tile_width_f,
                .height = dest.height,
            }, origin, rotation, tint);
        }

        // Fit last tile
        if (dx < dest.width) {
            rl.drawTexturePro(texture, .{
                .x = source.x,
                .y = source.y,
                .width = ((dest.width - dx) / tile_width_f) * source.width,
                .height = (dest.height / tile_height_f) * source.height,
            }, .{
                .x = dest.x + dx,
                .y = dest.y,
                .width = dest.width - dx,
                .height = dest.height,
            }, origin, rotation, tint);
        }
    } else {
        // Tiled both horizontally and vertically (rows and columns)
        var dx: f32 = 0;
        while (dx + tile_width_f < dest.width) : (dx += tile_width_f) {
            var dy: f32 = 0;
            while (dy + tile_height_f < dest.height) : (dy += tile_height_f) {
                rl.drawTexturePro(texture, source, .{
                    .x = dest.x + dx,
                    .y = dest.y + dy,
                    .width = tile_width_f,
                    .height = tile_height_f,
                }, origin, rotation, tint);
            }

            if (dy < dest.height) {
                rl.drawTexturePro(texture, .{
                    .x = source.x,
                    .y = source.y,
                    .width = source.width,
                    .height = ((dest.height - dy) / tile_height_f) * source.height,
                }, .{
                    .x = dest.x + dx,
                    .y = dest.y + dy,
                    .width = tile_width_f,
                    .height = dest.height - dy,
                }, origin, rotation, tint);
            }
        }

        // Fit last column of tiles
        if (dx < dest.width) {
            var dy: f32 = 0;
            while (dy + tile_height_f < dest.height) : (dy += tile_height_f) {
                rl.drawTexturePro(texture, .{
                    .x = source.x,
                    .y = source.y,
                    .width = ((dest.width - dx) / tile_width_f) * source.width,
                    .height = source.height,
                }, .{
                    .x = dest.x + dx,
                    .y = dest.y + dy,
                    .width = dest.width - dx,
                    .height = tile_height_f,
                }, origin, rotation, tint);
            }

            // Draw final tile in the bottom right corner
            if (dy < dest.height) {
                rl.drawTexturePro(texture, .{
                    .x = source.x,
                    .y = source.y,
                    .width = ((dest.width - dx) / tile_width_f) * source.width,
                    .height = ((dest.height - dy) / tile_height_f) * source.height,
                }, .{
                    .x = dest.x + dx,
                    .y = dest.y + dy,
                    .width = dest.width - dx,
                    .height = dest.height - dy,
                }, origin, rotation, tint);
            }
        }
    }
}
