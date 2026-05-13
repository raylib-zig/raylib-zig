//!******************************************************************************************
//!
//!   raylib-zig port of the [textures] example - Mouse painting
//!   https://github.com/raysan5/raylib/blob/master/examples/textures/textures_mouse_painting.c
//!
//!   Example complexity rating: [★★★☆] 3/4
//!
//!   Example originally created with raylib 3.0, last time updated with raylib 3.0
//!
//!   Example contributed by Chris Dill (@MysteriousSpace) and reviewed by Ramon Santamaria (@raysan5)
//!   Translated to raylib-zig by Timothy Fiss (@TheFissk)
//!
//!   Example licensed under an unmodified zlib/libpng license, which is an OSI-certified,
//!   BSD-like license that allows static linking with closed source software
//!
//!   Copyright (c) 2019-2025 Chris Dill (@MysteriousSpace) and Ramon Santamaria (@raysan5)
//!
//!*******************************************************************************************/

const rl = @import("raylib");

//------------------------------------------------------------------------------------
// Program main entry point
//------------------------------------------------------------------------------------
pub fn main() anyerror!void {
    // Initialization
    //--------------------------------------------------------------------------------------
    const screen_width = 800;
    const screen_height = 450;

    rl.initWindow(screen_width, screen_height, "raylib [textures] example - mouse painting");
    defer rl.closeWindow();

    // Colors to choose from
    const colors = [_]rl.Color{
        .ray_white, .yellow,    .gold,      .orange, .pink,   .red,         .maroon, .green, .lime,       .dark_green,
        .sky_blue,  .blue,      .dark_blue, .purple, .violet, .dark_purple, .beige,  .brown, .dark_brown, .light_gray,
        .gray,      .dark_gray, .black,
    };

    // Define colorsRecs data (for every rectangle)
    const color_recs: [colors.len]rl.Rectangle = init: {
        var initial_value: [colors.len]rl.Rectangle = undefined;
        for (&initial_value, 0..) |*rec, i| {
            const fI: f32 = @floatFromInt(i);
            rec.* = rl.Rectangle{
                .x = 10 + 30.0 * fI + 2 * fI,
                .y = 10,
                .width = 30,
                .height = 30,
            };
        }
        break :init initial_value;
    };

    var color_selected: usize = 0;
    var color_selected_previous = color_selected;
    var color_mouse_hover: ?usize = null;
    var brush_size: f32 = 20.0;
    var mouse_was_pressed = false;

    const btn_save_rec = rl.Rectangle{ .x = 750, .y = 10, .width = 40, .height = 30 };
    var btn_save_mouse_hover = false;
    var show_save_message = false;
    var save_message_counter: usize = 0;

    // Create a RenderTexture2D to use as a canvas
    var target = try rl.loadRenderTexture(screen_width, screen_height);
    defer target.unload();

    // Clear render texture before entering the game loop
    rl.beginTextureMode(target);
    rl.clearBackground(colors[0]);
    rl.endTextureMode();

    rl.setTargetFPS(120); // Set our game to run at 120 frames-per-second
    //--------------------------------------------------------------------------------------

    // Main game loop
    while (!rl.windowShouldClose()) // Detect window close button or ESC key
    {
        // Update
        //----------------------------------------------------------------------------------
        const mousePos = rl.getMousePosition();

        // Move between colors with keys
        if (rl.isKeyPressed(.right)) {
            color_selected += 1;
        } else if (rl.isKeyPressed(.left)) {
            color_selected -= 1;
        }

        if (color_selected >= colors.len) {
            color_selected = colors.len - 1;
        } else if (color_selected < 0) {
            color_selected = 0;
        }

        // Choose color with mouse
        for (0..colors.len) |i| {
            if (rl.checkCollisionPointRec(mousePos, color_recs[i])) {
                color_mouse_hover = i;
                break;
            } else color_mouse_hover = null;
        }

        if (rl.isMouseButtonPressed(.left)) {
            color_selected = if (color_mouse_hover) |c| c else color_selected;
            color_selected_previous = color_selected;
        }

        // Change brush size
        brush_size += rl.getMouseWheelMove() * 5;
        if (brush_size < 2) brush_size = 2;
        if (brush_size > 50) brush_size = 50;

        if (rl.isKeyPressed(.c)) {
            // Clear render texture to clear color
            rl.beginTextureMode(target);
            defer rl.endTextureMode();
            rl.clearBackground(colors[0]);
        }

        if (rl.isMouseButtonDown(.left) or (rl.getGestureDetected() == rl.Gesture { .drag = true })) {
            // Paint circle into render texture
            // NOTE: To avoid discontinuous circles, we could store
            // previous-next mouse points and just draw a line using brush size
            rl.beginTextureMode(target);
            defer rl.endTextureMode();
            if (mousePos.y > 50) {
                rl.drawCircle(
                    @intFromFloat(mousePos.x),
                    @intFromFloat(mousePos.y),
                    brush_size,
                    colors[color_selected],
                );
            }
        }

        if (rl.isMouseButtonDown(.right)) {
            if (!mouse_was_pressed) {
                color_selected_previous = color_selected;
                color_selected = 0;
            }

            mouse_was_pressed = true;

            // Erase circle from render texture
            rl.beginTextureMode(target);
            defer rl.endTextureMode();
            if (mousePos.y > 50) {
                rl.drawCircle(
                    @intFromFloat(mousePos.x),
                    @intFromFloat(mousePos.y),
                    brush_size,
                    colors[0],
                );
            }
        } else if (rl.isMouseButtonReleased(.right) and mouse_was_pressed) {
            color_selected = color_selected_previous;
            mouse_was_pressed = false;
        }

        // Check mouse hover save button
        if (rl.checkCollisionPointRec(mousePos, btn_save_rec)) {
            btn_save_mouse_hover = true;
        } else {
            btn_save_mouse_hover = false;
        }

        // Image saving logic
        // NOTE: Saving painted texture to a default named image
        if ((btn_save_mouse_hover and rl.isMouseButtonReleased(.left)) or rl.isKeyPressed(.s)) {
            var image = try rl.loadImageFromTexture(target.texture);
            defer image.unload();
            rl.imageFlipVertical(&image);
            _ = rl.exportImage(image, "my_amazing_texture_painting.png");
            show_save_message = true;
        }

        if (show_save_message) {
            // On saving, show a full screen message for 2 seconds
            save_message_counter += 1;
            if (save_message_counter > 240) {
                show_save_message = false;
                save_message_counter = 0;
            }
        }
        //----------------------------------------------------------------------------------

        // Draw
        //----------------------------------------------------------------------------------
        rl.beginDrawing();
        defer rl.endDrawing();

        rl.clearBackground(.ray_white);

        // NOTE: Render texture must be y-flipped due to default OpenGL coordinates (left-bottom)
        rl.drawTextureRec(
            target.texture,
            .{
                .x = 0,
                .y = 0,
                .width = @floatFromInt(target.texture.width),
                .height = @floatFromInt(-target.texture.height),
            },
            .{ .x = 0, .y = 0 },
            .white,
        );

        // Draw drawing circle for reference
        if (mousePos.y > 50) {
            if (rl.isMouseButtonDown(.right)) {
                rl.drawCircleLines(@intFromFloat(mousePos.x), @intFromFloat(mousePos.y), brush_size, .gray);
            } else {
                rl.drawCircle(@intFromFloat(mousePos.x), @intFromFloat(mousePos.y), brush_size, colors[color_selected]);
            }
        }

        // Draw top panel
        rl.drawRectangle(0, 0, rl.getScreenWidth(), 50, .ray_white);
        rl.drawLine(0, 50, rl.getScreenWidth(), 50, .light_gray);

        // Draw color selection rectangles
        for (color_recs, colors) |rec, color| {
            rl.drawRectangleRec(rec, color);
        }
        rl.drawRectangleLines(10, 10, 30, 30, .light_gray);

        if (color_mouse_hover) |c| rl.drawRectangleRec(color_recs[c], rl.fade(.white, 0.6));

        rl.drawRectangleLinesEx(.{
            .x = color_recs[color_selected].x - 2,
            .y = color_recs[color_selected].y - 2,
            .width = color_recs[color_selected].width + 4,
            .height = color_recs[color_selected].height + 4,
        }, 2, .black);

        // Draw save image button
        const button_save_color: rl.Color = if (btn_save_mouse_hover) .red else .black;
        rl.drawRectangleLinesEx(btn_save_rec, 2, button_save_color);
        rl.drawText("SAVE!", 755, 20, 10, button_save_color);

        // Draw save image message
        if (show_save_message) {
            rl.drawRectangle(0, 0, rl.getScreenWidth(), rl.getScreenHeight(), rl.fade(.ray_white, 0.8));
            rl.drawRectangle(0, 150, rl.getScreenWidth(), 80, .black);
            rl.drawText("IMAGE SAVED:  my_amazing_texture_painting.png", 150, 180, 20, .ray_white);
        }

        //----------------------------------------------------------------------------------
    }
}
