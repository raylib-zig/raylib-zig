//!*******************************************************************************************
//!
//!   raylib-zig port of the [text] example - Font SDF loading
//!   https://github.com/raysan5/raylib/blob/master/examples/text/text_font_sdf.c
//!
//!   Example complexity rating: [★★★☆] 3/4
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

const std = @import("std");
const rl = @import("raylib");

//------------------------------------------------------------------------------------
// Program main entry point
//------------------------------------------------------------------------------------
pub fn main() anyerror!void {
    // Initialization
    //--------------------------------------------------------------------------------------
    const screen_width = 800;
    const screen_height = 450;

    rl.initWindow(screen_width, screen_height, "raylib [text] example - SDF fonts");
    defer rl.closeWindow();

    // NOTE: Textures/Fonts MUST be loaded after Window initialization (OpenGL context is required)

    const msg = "Signed Distance Fields";

    // Loading file to memory
    const font_default = try rl.loadFontEx("examples/text/resources/anonymous_pro_bold.ttf", 16, null);
    defer font_default.unload();
    var font_sdf: rl.Font = font_default;
    defer font_sdf.unload();
    {
        // SDF font generation from TTF font
        const file_data = try rl.loadFileData("examples/text/resources/anonymous_pro_bold.ttf");
        defer rl.unloadFileData(file_data); // Free memory from loaded file

        font_sdf = .{
            .baseSize = 16,
            .glyphCount = 95,
            .glyphPadding = 0,
            .glyphs = @ptrCast(try rl.loadFontData(@ptrCast(file_data), 16, null, .sdf)),
            .texture = undefined,
            .recs = undefined,
        };
        const atlas_image, const atlas_recs = try rl.genImageFontAtlas(font_sdf.glyphs[0..@intCast(font_sdf.glyphCount)], font_sdf.baseSize, 0, 1);
        defer atlas_image.unload();
        font_sdf.texture = try rl.loadTextureFromImage(atlas_image);
        font_sdf.recs = @ptrCast(atlas_recs);
    }

    // Load SDF required shader (we use default vertex shader)
    const shader = try rl.loadShader(null, "examples/text/resources/shaders/glsl330/sdf.fs");
    defer rl.unloadShader(shader);
    rl.setTextureFilter(font_sdf.texture, .bilinear); // Required for SDF font

    var font_position = rl.Vector2{ .x = 40, .y = @as(f32, @floatFromInt(screen_height)) / 2.0 - 50 };
    var text_size = rl.Vector2{ .x = 0.0, .y = 0.0 };
    var font_size: f32 = 16.0;
    var current_font: i32 = 0; // 0 - fontDefault, 1 - fontSDF

    rl.setTargetFPS(60); // Set our game to run at 60 frames-per-second
    //--------------------------------------------------------------------------------------

    // Main game loop
    while (!rl.windowShouldClose()) // Detect window close button or ESC key
    {
        // Update
        //----------------------------------------------------------------------------------
        font_size += rl.getMouseWheelMove() * 8.0;

        if (font_size < 6) font_size = 6;

        if (rl.isKeyDown(.space)) {
            current_font = 1;
        } else {
            current_font = 0;
        }

        if (current_font == 0) {
            text_size = rl.measureTextEx(font_default, msg, font_size, 0);
        } else {
            text_size = rl.measureTextEx(font_sdf, msg, font_size, 0);
        }

        font_position.x = @as(f32, @floatFromInt(rl.getScreenWidth())) / 2 - text_size.x / 2;
        font_position.y = @as(f32, @floatFromInt(rl.getScreenHeight())) / 2 - text_size.y / 2 + 80;
        //----------------------------------------------------------------------------------

        // Draw
        //----------------------------------------------------------------------------------
        rl.beginDrawing();
        defer rl.endDrawing();

        rl.clearBackground(.ray_white);

        if (current_font == 1) {
            // NOTE: SDF fonts require a custom SDf shader to compute fragment color
            rl.beginShaderMode(shader); // Activate SDF font shader
            rl.drawTextEx(font_sdf, msg, font_position, font_size, 0, .black);
            rl.endShaderMode(); // Activate our default shader for next drawings

            rl.drawTexture(font_sdf.texture, 10, 10, .black);
        } else {
            rl.drawTextEx(font_default, msg, font_position, font_size, 0, .black);
            rl.drawTexture(font_default.texture, 10, 10, .black);
        }

        if (current_font == 1) {
            rl.drawText("SDF!", 320, 20, 80, .red);
        } else {
            rl.drawText("default font", 315, 40, 30, .gray);
        }

        rl.drawText("FONT SIZE: 16.0", rl.getScreenWidth() - 240, 20, 20, .dark_gray);
        rl.drawText(rl.textFormat("RENDER SIZE: %02.02f", .{font_size}), rl.getScreenWidth() - 240, 50, 20, .dark_gray);
        rl.drawText("Use MOUSE WHEEL to SCALE TEXT!", rl.getScreenWidth() - 240, 90, 10, .dark_gray);
        rl.drawText("HOLD SPACE to USE SDF FONT VERSION!", 340, rl.getScreenHeight() - 30, 20, .maroon);

        //----------------------------------------------------------------------------------
    }
}
