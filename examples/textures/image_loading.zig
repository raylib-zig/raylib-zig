// raylib-zig (c) Nikolas Wipper 2023
//
// raylib-zig [textures] example - image loading
//
// Example licensed under an unmodified zlib/libpng license, which is an
// OSI-certified, BSD-like license that allows static linking with closed
// source software

const rl = @import("raylib");
const Color = rl.Color;
const screenWidth = 800;
const screenHeight = 450;

//--------------------------------------------------------------------------------------
// Program entry point
//--------------------------------------------------------------------------------------
pub fn main() anyerror!void {
    //Initialization
    //--------------------------------------------------------------------------------------
    rl.initWindow(
        screenWidth,
        screenHeight,
        "raylib [textures] example - image loading",
    );

    // NOTE: Textures MUST be loaded after Window initialization (OpenGL context is required)

    const image = try rl.loadImage("logo/logo.png"); // Loaded in CPU memory (RAM)
    const texture = try rl.loadTextureFromImage(image); // Image converted to texture, GPU memory (VRAM)
    // Once image has been converted to texture and uploaded to VRAM,
    // it can be unloaded from RAM
    rl.unloadImage(image);

    // De-Initialization
    //--------------------------------------------------------------------------------------
    defer rl.closeWindow(); // Close window and OpenGL context
    defer rl.unloadTexture(texture); // Texture unloading
    //--------------------------------------------------------------------------------------

    rl.setTargetFPS(60); // Set our game to run at 60 frames-per-second
    while (!rl.windowShouldClose()) {
        // Update
        //--------------------------------------------------------------------------------------
        // TODO: Update your variables here
        //--------------------------------------------------------------------------------------

        // Draw
        //--------------------------------------------------------------------------------------
        rl.beginDrawing();
        rl.clearBackground(Color.white);
        rl.drawTexture(
            texture,
            screenWidth / 2 - @divFloor(texture.width, 2),
            screenHeight / 2 - @divFloor(texture.height, 2),
            Color.white,
        );
        rl.drawText(
            "this IS a texture loaded from an image!",
            300,
            370,
            10,
            Color.gray,
        );
        rl.endDrawing();
        //--------------------------------------------------------------------------------------
    }
}
