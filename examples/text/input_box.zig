//!******************************************************************************************
//!
//!   raylib-zig port of the [raylib-zig port of the [text] example - Input Box
//!   https://github.com/raysan5/raylib/blob/master/examples/text/text_input_box.c
//!
//!   Example complexity rating: [★★☆☆] 2/4
//!
//!   Example originally created with raylib 1.7, last time updated with raylib 3.5
//!
//!   Translated to raylib-zig by Timothy Fiss (@TheFissk)
//!
//!   Example licensed under an unmodified zlib/libpng license, which is an OSI-certified,
//!   BSD-like license that allows static linking with closed source software
//!
//!   Copyright (c) 2017-2025 Ramon Santamaria (@raysan5)
//!
//!*******************************************************************************************

const rl = @import("raylib");

const max_input_chars = 9;

//------------------------------------------------------------------------------------
// Program main entry point
//------------------------------------------------------------------------------------
pub fn main() anyerror!void {
    // Initialization
    //--------------------------------------------------------------------------------------
    const screen_width = 800;
    const screen_height = 450;

    rl.initWindow(screen_width, screen_height, "raylib [text] example - input box");
    defer rl.closeWindow();

    var name = [_:0]u8{0} ** max_input_chars;
    var letter_count: usize = 0;

    const text_box = rl.Rectangle{
        .x = @as(f32, @floatFromInt(screen_width)) / 2.0 - 100,
        .y = 180,
        .width = 255,
        .height = 50,
    };
    var mouse_on_text = false;

    var framesCounter: usize = 0;

    rl.setTargetFPS(60); // Set our game to run at 60 frames-per-second
    //--------------------------------------------------------------------------------------

    // Main game loop
    while (!rl.windowShouldClose()) // Detect window close button or ESC key
    {
        // Update
        //----------------------------------------------------------------------------------
        mouse_on_text = rl.checkCollisionPointRec(rl.getMousePosition(), text_box);

        if (mouse_on_text) {
            // Set the window's cursor to the I-Beam
            rl.setMouseCursor(.ibeam);

            // Get char pressed (unicode character) on the queue
            // Check if more characters have been pressed on the same frame
            var key = rl.getKeyPressed();
            while (key != .null) : (key = rl.getKeyPressed()) {
                // NOTE: Only allow keys in range [32..125]
                const keyInt: c_int = @intFromEnum(key);
                if ((keyInt >= 32) and (keyInt <= 125) and (letter_count < name.len)) {
                    name[letter_count] = @intCast(keyInt);
                    letter_count += 1;
                }
            }

            if (rl.isKeyPressed(.backspace)) {
                if (letter_count <= 1) {
                    letter_count = 0;
                } else {
                    letter_count -= 1;
                }
                name[letter_count] = 0;
            }
        } else rl.setMouseCursor(.default);

        if (mouse_on_text) {
            framesCounter += 1;
        } else {
            framesCounter = 0;
        }
        //----------------------------------------------------------------------------------

        // Draw
        //----------------------------------------------------------------------------------
        rl.beginDrawing();
        defer rl.endDrawing();

        rl.clearBackground(.ray_white);

        rl.drawText("PLACE MOUSE OVER INPUT BOX!", 240, 140, 20, .gray);

        rl.drawRectangleRec(text_box, .light_gray);
        rl.drawRectangleLines(
            @intFromFloat(text_box.x),
            @intFromFloat(text_box.y),
            @intFromFloat(text_box.width),
            @intFromFloat(text_box.height),
            if (mouse_on_text) .red else .dark_gray,
        );

        rl.drawText(&name, @intFromFloat(text_box.x + 5), @intFromFloat(text_box.y + 8), 40, .maroon);

        rl.drawText(rl.textFormat("INPUT CHARS: %i/%i", .{ letter_count, @as(usize, @intCast(max_input_chars)) }), 315, 250, 20, .dark_gray);

        if (mouse_on_text) {
            if (letter_count < max_input_chars) {
                // Draw blinking underscore char
                if (((framesCounter / 20) % 2) == 0) {
                    rl.drawText("_", @as(i32, @intFromFloat(text_box.x)) + 8 + rl.measureText(&name, 40), @intFromFloat(text_box.y + 12), 40, .maroon);
                }
            } else {
                rl.drawText("Press BACKSPACE to delete chars...", 230, 300, 20, .gray);
            }
        }

        //----------------------------------------------------------------------------------
    }
}
