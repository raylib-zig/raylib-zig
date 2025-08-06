//!******************************************************************************************
//!
//!   raylib-zig port of the [textures] example - Procedural images generation
//!
//!   Example complexity rating: [★★☆☆] 2/4
//!
//!   Example originally created with raylib 1.8, last time updated with raylib 1.8
//!
//!   Example contributed by Wilhem Barbier (@nounoursheureux) and reviewed by Ramon Santamaria (@raysan5)
//!   Translated to raylib-zig by Timothy Fiss (@TheFissk)
//!
//!   Example licensed under an unmodified zlib/libpng license, which is an OSI-certified,
//!   BSD-like license that allows static linking with closed source software
//!
//!   Copyright (c) 2017-2025 Wilhem Barbier (@nounoursheureux) and Ramon Santamaria (@raysan5)
//!
//!*******************************************************************************************

const rl = @import("raylib");

const num_textures = 9; // Currently we have 8 generation algorithms but some have multiple purposes (Linear and Square Gradients)

//------------------------------------------------------------------------------------
// Program main entry point
//------------------------------------------------------------------------------------
pub fn main() anyerror!void {
    // Initialization
    //--------------------------------------------------------------------------------------
    const screen_width = 800;
    const screen_height = 450;

    rl.initWindow(screen_width, screen_height, "raylib [textures] example - procedural images generation");
    defer rl.closeWindow();

    const vertical_gradient = rl.genImageGradientLinear(screen_width, screen_height, 0, .red, .blue);
    defer rl.unloadImage(vertical_gradient);
    const horizontal_gradient = rl.genImageGradientLinear(screen_width, screen_height, 90, .red, .blue);
    defer rl.unloadImage(horizontal_gradient);
    const diagonal_gradient = rl.genImageGradientLinear(screen_width, screen_height, 45, .red, .blue);
    defer rl.unloadImage(diagonal_gradient);
    const radial_gradient = rl.genImageGradientRadial(screen_width, screen_height, 0.0, .white, .black);
    defer rl.unloadImage(radial_gradient);
    const square_gradient = rl.genImageGradientSquare(screen_width, screen_height, 0.0, .white, .black);
    defer rl.unloadImage(square_gradient);
    const checked = rl.genImageChecked(screen_width, screen_height, 32, 32, .red, .blue);
    defer rl.unloadImage(checked);
    const white_noise = rl.genImageWhiteNoise(screen_width, screen_height, 0.5);
    defer rl.unloadImage(white_noise);
    const perlin_noise = rl.genImagePerlinNoise(screen_width, screen_height, 50, 50, 4.0);
    defer rl.unloadImage(perlin_noise);
    const cellular = rl.genImageCellular(screen_width, screen_height, 32);
    defer rl.unloadImage(cellular);

    const textures = [_]rl.Texture2D{
        try rl.loadTextureFromImage(vertical_gradient),
        try rl.loadTextureFromImage(horizontal_gradient),
        try rl.loadTextureFromImage(diagonal_gradient),
        try rl.loadTextureFromImage(radial_gradient),
        try rl.loadTextureFromImage(square_gradient),
        try rl.loadTextureFromImage(checked),
        try rl.loadTextureFromImage(white_noise),
        try rl.loadTextureFromImage(perlin_noise),
        try rl.loadTextureFromImage(cellular),
    };
    defer {
        for (textures) |texture| {
            rl.unloadTexture(texture);
        }
    }

    var currentTexture: usize = 0;

    rl.setTargetFPS(60);
    //---------------------------------------------------------------------------------------

    // Main game loop
    while (!rl.windowShouldClose()) {
        // Update
        //----------------------------------------------------------------------------------
        if (rl.isMouseButtonPressed(.left) or rl.isKeyPressed(.right)) {
            currentTexture = (currentTexture + 1) % num_textures; // Cycle between the textures
        }
        //----------------------------------------------------------------------------------

        // Draw
        //----------------------------------------------------------------------------------
        rl.beginDrawing();
        defer rl.endDrawing();

        rl.clearBackground(.ray_white);

        rl.drawTexture(textures[currentTexture], 0, 0, .white);

        rl.drawRectangle(30, 400, 325, 30, rl.fade(.sky_blue, 0.5));
        rl.drawRectangleLines(30, 400, 325, 30, rl.fade(.white, 0.5));
        rl.drawText("MOUSE LEFT BUTTON to CYCLE PROCEDURAL TEXTURES", 40, 410, 10, .white);

        switch (currentTexture) {
            0 => rl.drawText("VERTICAL GRADIENT", 560, 10, 20, .ray_white),
            1 => rl.drawText("HORIZONTAL GRADIENT", 540, 10, 20, .ray_white),
            2 => rl.drawText("DIAGONAL GRADIENT", 540, 10, 20, .ray_white),
            3 => rl.drawText("RADIAL GRADIENT", 580, 10, 20, .light_gray),
            4 => rl.drawText("SQUARE GRADIENT", 580, 10, 20, .light_gray),
            5 => rl.drawText("CHECKED", 680, 10, 20, .ray_white),
            6 => rl.drawText("WHITE NOISE", 640, 10, 20, .red),
            7 => rl.drawText("PERLIN NOISE", 640, 10, 20, .red),
            8 => rl.drawText("CELLULAR", 670, 10, 20, .ray_white),
            else => {},
        }
    }
}
