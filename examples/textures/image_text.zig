//!******************************************************************************************
//!
//!   raylib-zig port of the [textures] example - Image text drawing using TTF generated font
//!   https://github.com/raysan5/raylib/blob/master/examples/textures/textures_image_text.c
//!
//!   Example complexity rating: [★★☆☆] 2/4
//!
//!   Example originally created with raylib 1.8, last time updated with raylib 4.0
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

//------------------------------------------------------------------------------------
// Program main entry point
//------------------------------------------------------------------------------------
pub fn main() anyerror!void {
    // Initialization
    //--------------------------------------------------------------------------------------
    const screen_width = 800;
    const screen_height = 450;

    rl.initWindow(screen_width, screen_height, "raylib [texture] example - image text drawing");
    defer rl.closeWindow();

    var parrots = try rl.loadImage("examples/textures/resources/parrots.png");
    defer parrots.unload();

    // TTF Font loading with custom generation parameters
    const font = try rl.loadFontEx("examples/textures/resources/KAISG.ttf", 64, null);
    defer font.unload();

    // Draw over image using custom font
    rl.imageDrawTextEx(
        &parrots,
        font,
        "[Parrots font drawing]",
        .{ .x = 20.0, .y = 20.0 },
        @floatFromInt(font.baseSize),
        0.0,
        .red,
    );

    const texture = try rl.loadTextureFromImage(parrots); // Image converted to texture, uploaded to GPU memory (VRAM)
    defer texture.unload();

    const position = rl.Vector2{ .x = @floatFromInt(@divFloor(screen_width - texture.width, 2)), .y = @floatFromInt(@divFloor(screen_height - texture.height, 2) - 20) };

    var show_font = false;

    rl.setTargetFPS(60);
    //--------------------------------------------------------------------------------------

    // Main game loop
    while (!rl.windowShouldClose()) // Detect window close button or ESC key
    {
        // Update
        //----------------------------------------------------------------------------------
        if (rl.isKeyDown(.space)) {
            show_font = true;
        } else {
            show_font = false;
        }
        //----------------------------------------------------------------------------------

        // Draw
        //----------------------------------------------------------------------------------
        rl.beginDrawing();
        defer rl.endDrawing();

        rl.clearBackground(.ray_white);

        if (!show_font) {
            // Draw texture with text already drawn inside
            rl.drawTextureV(texture, position, .white);

            // Draw text directly using sprite font
            rl.drawTextEx(font, "[Parrots font drawing]", rl.Vector2{ .x = position.x + 20, .y = position.y + 20 + 280 }, @floatFromInt(font.baseSize), 0.0, .white);
        } else {
            rl.drawTexture(font.texture, @divFloor(screen_width - font.texture.width, 2), 50, .black);
        }

        rl.drawText("PRESS SPACE to SHOW FONT ATLAS USED", 290, 420, 10, .dark_gray);
    }
}
