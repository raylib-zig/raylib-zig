//!******************************************************************************************
//!
//!   raylib-zig port of the [textures] example - Texture loading and drawing
//!   https://github.com/raysan5/raylib/blob/master/examples/textures/textures_image_text.c
//!   Example complexity rating: [★☆☆☆] 1/4
//!
//!   Example originally created with raylib 1.0, last time updated with raylib 1.0
//!
//!   Translated to raylib-zig by Timothy Fiss (@TheFissk)
//!
//!   Example licensed under an unmodified zlib/libpng license, which is an OSI-certified,
//!   BSD-like license that allows static linking with closed source software
//!
//!   Copyright (c) 2014-2025 Ramon Santamaria (@raysan5)
//!
//!*******************************************************************************************

const rl = @import("raylib");

//------------------------------------------------------------------------------------
// Program main entry point
//------------------------------------------------------------------------------------
pub fn main() anyerror!void {
    // Initialization
    //--------------------------------------------------------------------------------------
    const screen_width = 800;
    const screen_height = 450;

    rl.initWindow(screen_width, screen_height, "raylib [textures] example - texture loading and drawing");
    defer rl.closeWindow();

    // NOTE: Textures MUST be loaded after Window initialization (OpenGL context is required)
    const texture = try rl.loadTexture("examples/textures/resources/raylib_logo.png");
    defer texture.unload();

    rl.setTargetFPS(60); // Set our game to run at 60 frames-per-second
    //---------------------------------------------------------------------------------------

    // Main game loop
    while (!rl.windowShouldClose()) // Detect window close button or ESC key
    {
        // Draw
        //----------------------------------------------------------------------------------
        rl.beginDrawing();
        defer rl.endDrawing();

        rl.clearBackground(.ray_white);

        rl.drawTexture(texture, @divFloor(screen_width - texture.width, 2), @divFloor(screen_height - texture.height, 2), .white);

        rl.drawText("this IS a texture!", 360, 370, 10, .gray);

        //----------------------------------------------------------------------------------
    }
}
