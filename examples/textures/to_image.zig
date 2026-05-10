//!*******************************************************************************************
//!
//!   raylib-zig port of the [textures] example - Retrieve image data from texture: LoadImageFromTexture()
//!   https://github.com/raysan5/raylib/blob/master/examples/textures/textures_to_image.c
//!
//!   Example complexity rating: [★☆☆☆] 1/4
//!
//!   NOTE: Images are loaded in CPU memory (RAM); textures are loaded in GPU memory (VRAM)
//!
//!   Example originally created with raylib 1.3, last time updated with raylib 4.0
//!
//!   Translated to raylib-zig by Timothy Fiss (@TheFissk)
//!
//!   Example licensed under an unmodified zlib/libpng license, which is an OSI-certified,
//!   BSD-like license that allows static linking with closed source software
//!
//!   Copyright (c) 2015-2025 Ramon Santamaria (@raysan5)
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

    rl.initWindow(screen_width, screen_height, "raylib [textures] example - texture to image");
    defer rl.closeWindow(); // Close window and OpenGL context

    // NOTE: Textures MUST be loaded after Window initialization (OpenGL context is required)

    var image = try rl.loadImage("examples/textures/resources/raylib_logo.png"); // Load image data into CPU memory (RAM)
    var texture = try rl.loadTextureFromImage(image); // Image converted to texture, GPU memory (RAM -> VRAM)
    image.unload(); // Unload image data from CPU memory (RAM)

    image = try rl.loadImageFromTexture(texture); // Load image from GPU texture (VRAM -> RAM)
    texture.unload();

    texture = try rl.loadTextureFromImage(image); // Recreate texture from retrieved image data (RAM -> VRAM)
    defer texture.unload();
    image.unload(); // Unload retrieved image data from CPU memory (RAM)

    rl.setTargetFPS(60); // Set our game to run at 60 frames-per-second
    //---------------------------------------------------------------------------------------

    // Main game loop
    while (!rl.windowShouldClose()) // Detect window close button or ESC key
    {
        // Update
        //----------------------------------------------------------------------------------
        // TODO: Update your variables here
        //----------------------------------------------------------------------------------

        // Draw
        //----------------------------------------------------------------------------------
        rl.beginDrawing();
        defer rl.endDrawing();

        rl.clearBackground(.ray_white);

        rl.drawTexture(
            texture,
            @divFloor(screen_width, 2) - @divFloor(texture.width, 2),
            @divFloor(screen_height, 2) - @divFloor(texture.height, 2),
            .white,
        );

        rl.drawText("this IS a texture loaded from an image!", 300, 370, 10, .gray);

        //----------------------------------------------------------------------------------
    }
}
