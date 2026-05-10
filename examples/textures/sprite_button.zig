//!*******************************************************************************************
//!
//!   raylib-zig port of the [textures] example - sprite button
//!   https://github.com/raysan5/raylib/blob/master/examples/textures/textures_sprite_button.c
//!
//!   Example complexity rating: [★★☆☆] 2/4
//!
//!   Example originally created with raylib 2.5, last time updated with raylib 2.5
//!
//!   Translated to raylib-zig by Timothy Fiss (@TheFissk)
//!
//!   Example licensed under an unmodified zlib/libpng license, which is an OSI-certified,
//!   BSD-like license that allows static linking with closed source software
//!
//!   Copyright (c) 2019-2025 Ramon Santamaria (@raysan5)
//!
//!*******************************************************************************************/

const rl = @import("raylib");

const NUM_FRAMES = 3.0; // Number of frames (rectangles) for the button sprite texture

//------------------------------------------------------------------------------------
// Program main entry point
//------------------------------------------------------------------------------------
pub fn main() anyerror!void {
    // Initialization
    //--------------------------------------------------------------------------------------
    const screen_width = 800;
    const screen_height = 450;

    rl.initWindow(screen_width, screen_height, "raylib [textures] example - sprite button");
    defer rl.closeWindow();

    rl.initAudioDevice(); // Initialize audio device
    defer rl.closeAudioDevice(); // Close audio device

    const fx_button = try rl.loadSound("examples/textures/resources/buttonfx.wav"); // Load button sound
    defer fx_button.unload(); // Unload sound
    const button = try rl.loadTexture("examples/textures/resources/button.png"); // Load button texture
    defer button.unload(); // Unload button texture

    // Define frame rectangle for drawing
    const frame_height: f32 = @as(f32, @floatFromInt(button.height)) / NUM_FRAMES;
    var source_rec = rl.Rectangle{
        .x = 0,
        .y = 0,
        .width = @floatFromInt(button.width),
        .height = frame_height,
    };

    // Define button bounds on screen
    const btnBounds = rl.Rectangle{
        .x = @as(f32, @floatFromInt(screen_width)) / 2.0 - @as(f32, @floatFromInt(button.width)) / 2.0,
        .y = @as(f32, @floatFromInt(screen_height)) / 2.0 - @as(f32, @floatFromInt(button.height)) / NUM_FRAMES / 2.0,
        .width = @as(f32, @floatFromInt(button.width)),
        .height = frame_height,
    };

    var btnState: i32 = 0; // Button state: 0-NORMAL, 1-MOUSE_HOVER, 2-PRESSED
    var btnAction = false; // Button action should be activated

    var mousePoint = rl.Vector2{ .x = 0.0, .y = 0.0 };

    rl.setTargetFPS(60);
    //--------------------------------------------------------------------------------------

    // Main game loop
    while (!rl.windowShouldClose()) // Detect window close button or ESC key
    {
        // Update
        //----------------------------------------------------------------------------------
        mousePoint = rl.getMousePosition();
        btnAction = false;

        // Check button state
        if (rl.checkCollisionPointRec(mousePoint, btnBounds)) {
            btnState = if (rl.isMouseButtonDown(.left)) 2 else 1;

            if (rl.isMouseButtonReleased(.left)) btnAction = true;
        } else {
            btnState = 0;
        }

        if (btnAction) {
            rl.playSound(fx_button);
        }

        // Calculate button frame rectangle to draw depending on button state
        source_rec.y = @as(f32, @floatFromInt(btnState)) * frame_height;
        //----------------------------------------------------------------------------------

        // Draw
        //----------------------------------------------------------------------------------
        rl.beginDrawing();
        defer rl.endDrawing();

        rl.clearBackground(.ray_white);
        rl.drawTextureRec(button, source_rec, rl.Vector2{ .x = btnBounds.x, .y = btnBounds.y }, .white); // Draw button frame

        //----------------------------------------------------------------------------------
    }
}
