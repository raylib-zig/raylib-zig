//!******************************************************************************************
//!
//!   raylib-zig port of the [textures] example - blend modes
//!   https://github.com/raysan5/raylib/blob/master/examples/textures/textures_blend_modes.c
//!
//!   Example complexity rating: [★☆☆☆] 1/4
//!
//!   NOTE: Images are loaded in CPU memory (RAM); textures are loaded in GPU memory (VRAM)
//!
//!   Example originally created with raylib 3.5, last time updated with raylib 3.5
//!
//!   Example contributed by Karlo Licudine (@accidentalrebel) and reviewed by Ramon Santamaria (@raysan5)
//!   Translated to raylib-zig by Timothy Fiss (@TheFissk)
//!
//!   Example licensed under an unmodified zlib/libpng license, which is an OSI-certified,
//!   BSD-like license that allows static linking with closed source software
//!
//!   Copyright (c) 2020-2025 Karlo Licudine (@accidentalrebel)
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

    rl.initWindow(screen_width, screen_height, "raylib [textures] example - blend modes");
    defer rl.closeWindow();

    // NOTE: Textures MUST be loaded after Window initialization (OpenGL context is required)

    var bg_texture: rl.Texture = undefined;
    defer rl.unloadTexture(bg_texture);
    var fg_texture: rl.Texture = undefined;
    defer rl.unloadTexture(fg_texture);

    {
        const bg_image = try rl.loadImage("examples/textures/resources/cyberpunk_street_background.png"); // Loaded in CPU memory (RAM)
        // Once image has been converted to texture and uploaded to VRAM, it can be unloaded from RAM
        defer rl.unloadImage(bg_image);
        bg_texture = try rl.loadTextureFromImage(bg_image); // Image converted to texture, GPU memory (VRAM)

        const fg_image = try rl.loadImage("examples/textures/resources/cyberpunk_street_foreground.png"); // Loaded in CPU memory (RAM)
        defer rl.unloadImage(fg_image);
        fg_texture = try rl.loadTextureFromImage(fg_image); // Image converted to texture, GPU memory (VRAM)
    }

    var blend_mode = rl.BlendMode.alpha;

    rl.setTargetFPS(60); // Set our game to run at 60 frames-per-second
    //---------------------------------------------------------------------------------------

    // Main game loop
    while (!rl.windowShouldClose()) // Detect window close button or ESC key
    {
        // Update
        //----------------------------------------------------------------------------------
        if (rl.isKeyPressed(.space)) {
            blend_mode = switch (blend_mode) {
                .alpha => .additive,
                .additive => .multiplied,
                .multiplied => .add_colors,
                .add_colors => .alpha,
                else => .alpha,
            };
        }
        //----------------------------------------------------------------------------------

        // Draw
        //----------------------------------------------------------------------------------
        rl.beginDrawing();
        defer rl.endDrawing();

        rl.clearBackground(.ray_white);

        rl.drawTexture(bg_texture, @divFloor(screen_width, 2) - @divFloor(bg_texture.width, 2), @divFloor(screen_height, 2) - @divFloor(bg_texture.height, 2), .white);

        // Apply the blend mode and then draw the foreground texture
        {
            rl.beginBlendMode(blend_mode);
            defer rl.endBlendMode();
            rl.drawTexture(fg_texture, @divFloor(screen_width, 2) - @divFloor(fg_texture.width, 2), @divFloor(screen_height, 2) - @divFloor(fg_texture.height, 2), .white);
        }

        // Draw the texts
        rl.drawText("Press SPACE to change blend modes.", 310, 350, 10, .gray);

        switch (blend_mode) {
            .alpha => rl.drawText("Current: BlendMode.alpha", (screen_width / 2) - 60, 370, 10, .gray),
            .additive => rl.drawText("Current: BlendMode.additive", (screen_width / 2) - 60, 370, 10, .gray),
            .multiplied => rl.drawText("Current: BlendMode.multiplied", (screen_width / 2) - 60, 370, 10, .gray),
            .add_colors => rl.drawText("Current: BlendMode.add_colors", (screen_width / 2) - 60, 370, 10, .gray),
            else => unreachable,
        }

        rl.drawText("(c) Cyberpunk Street Environment by Luis Zuno (@ansimuz)", screen_width - 330, screen_height - 20, 10, .gray);

        //----------------------------------------------------------------------------------
    }
}
