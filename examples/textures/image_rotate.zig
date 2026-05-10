//!******************************************************************************************
//!
//!   raylib-zig port of the [textures] example - Image Rotation
//!   https://github.com/raysan5/raylib/blob/master/examples/textures/textures_image_rotate.c
//!
//!   Example complexity rating: [★★☆☆] 2/4
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
//!*******************************************************************************************/

const rl = @import("raylib");

const NUM_TEXTURES = 3;

//------------------------------------------------------------------------------------
// Program main entry point
//------------------------------------------------------------------------------------
pub fn main() anyerror!void {

    // Initialization
    //--------------------------------------------------------------------------------------
    const screen_width = 800;
    const screen_height = 450;

    rl.initWindow(screen_width, screen_height, "raylib [textures] example - texture rotation");
    defer rl.closeWindow();

    // NOTE: Textures MUST be loaded after Window initialization (OpenGL context is required)
    var image45 = try rl.loadImage("examples/textures/resources/raylib_logo.png");
    var image90 = try rl.loadImage("examples/textures/resources/raylib_logo.png");
    var imageNeg90 = try rl.loadImage("examples/textures/resources/raylib_logo.png");

    rl.imageRotate(&image45, 45);
    rl.imageRotate(&image90, 90);
    rl.imageRotate(&imageNeg90, -90);

    const textures = [_]rl.Texture2D{ try rl.loadTextureFromImage(image45), try rl.loadTextureFromImage(image90), try rl.loadTextureFromImage(imageNeg90) };
    defer {
        for (&textures) |*texture| {
            texture.unload();
        }
    }

    var current_texture: usize = 0;

    rl.setTargetFPS(60); // Set our game to run at 60 frames-per-second
    //---------------------------------------------------------------------------------------

    // Main game loop
    while (!rl.windowShouldClose()) // Detect window close button or ESC key
    {
        // Update
        //----------------------------------------------------------------------------------
        if (rl.isMouseButtonPressed(.left) or rl.isKeyPressed(.right)) {
            current_texture = (current_texture + 1) % NUM_TEXTURES; // Cycle between the textures
        }
        //----------------------------------------------------------------------------------

        // Draw
        //----------------------------------------------------------------------------------
        rl.beginDrawing();
        defer rl.endDrawing();

        rl.clearBackground(.ray_white);

        rl.drawTexture(textures[current_texture], screen_width / 2 - @divFloor(textures[current_texture].width, 2), screen_height / 2 - @divFloor(textures[current_texture].height, 2), .white);

        rl.drawText("Press LEFT MOUSE BUTTON to rotate the image clockwise", 250, 420, 10, .dark_gray);

        //----------------------------------------------------------------------------------
    }
}
