//!******************************************************************************************
//!
//!   raylib-zig port of the [textures] example - Retrive image channel (mask)
//!   https://github.com/raysan5/raylib/blob/master/examples/textures/textures_image_channel.c
//!
//!   NOTE: Images are loaded in CPU memory (RAM); textures are loaded in GPU memory (VRAM)
//!
//!   Example complexity rating: [★★☆☆] 2/4
//!
//!   Example originally created with raylib 5.1-dev, last time updated with raylib 5.1-dev
//!
//!   Example contributed by Bruno Cabral (@brccabral) and reviewed by Ramon Santamaria (@raysan5)
//!   Translated to raylib-zig by Timothy Fiss (@TheFissk)
//!
//!   Example licensed under an unmodified zlib/libpng license, which is an OSI-certified,
//!   BSD-like license that allows static linking with closed source software
//!
//!   Copyright (c) 2024-2025 Bruno Cabral (@brccabral) and Ramon Santamaria (@raysan5)
//!
//!*******************************************************************************************

const rl = @import("raylib");

//------------------------------------------------------------------------------------
// Program main entry point
//------------------------------------------------------------------------------------
pub fn main() anyerror!void {
    // Initialization
    //--------------------------------------------------------------------------------------
    const screenWidth = 800;
    const screenHeight = 450;

    rl.initWindow(screenWidth, screenHeight, "raylib [textures] example - extract channel from image");
    defer rl.closeWindow();

    const fudesumiImage = try rl.loadImage("examples/textures/resources/fudesumi.png");
    defer rl.unloadImage(fudesumiImage);

    var imageAlpha = rl.imageFromChannel(fudesumiImage, 3);
    rl.imageAlphaMask(&imageAlpha, imageAlpha);

    var imageRed = rl.imageFromChannel(fudesumiImage, 0);
    rl.imageAlphaMask(&imageRed, imageAlpha);

    var imageGreen = rl.imageFromChannel(fudesumiImage, 1);
    rl.imageAlphaMask(&imageGreen, imageAlpha);

    var imageBlue = rl.imageFromChannel(fudesumiImage, 2);
    rl.imageAlphaMask(&imageBlue, imageAlpha);

    const backgroundImage = rl.genImageChecked(screenWidth, screenHeight, screenWidth / 20, screenHeight / 20, .orange, .yellow);

    const fudesumiTexture = try rl.loadTextureFromImage(fudesumiImage);
    defer rl.unloadTexture(fudesumiTexture);
    const textureAlpha = try rl.loadTextureFromImage(imageAlpha);
    defer rl.unloadTexture(textureAlpha);
    const textureRed = try rl.loadTextureFromImage(imageRed);
    defer rl.unloadTexture(textureRed);
    const textureGreen = try rl.loadTextureFromImage(imageGreen);
    defer rl.unloadTexture(textureGreen);
    const textureBlue = try rl.loadTextureFromImage(imageBlue);
    defer rl.unloadTexture(textureBlue);
    const backgroundTexture = try rl.loadTextureFromImage(backgroundImage);
    defer rl.unloadTexture(backgroundTexture);

    const fudesumiRec = rl.Rectangle{
        .x = 0,
        .y = 0,
        .width = @floatFromInt(fudesumiImage.width),
        .height = @floatFromInt(fudesumiImage.height),
    };
    const fudesumiPos = rl.Rectangle{
        .x = 50,
        .y = 10,
        .width = @as(f32, @floatFromInt(fudesumiImage.width)) * 0.8,
        .height = @as(f32, @floatFromInt(fudesumiImage.height)) * 0.8,
    };
    const redPos = rl.Rectangle{
        .x = 410,
        .y = 10,
        .width = fudesumiPos.width / 2,
        .height = fudesumiPos.height / 2,
    };
    const greenPos = rl.Rectangle{
        .x = 600,
        .y = 10,
        .width = fudesumiPos.width / 2,
        .height = fudesumiPos.height / 2,
    };
    const bluePos = rl.Rectangle{
        .x = 410,
        .y = 230,
        .width = fudesumiPos.width / 2,
        .height = fudesumiPos.height / 2,
    };
    const alphaPos = rl.Rectangle{
        .x = 600,
        .y = 230,
        .width = fudesumiPos.width / 2,
        .height = fudesumiPos.height / 2,
    };

    rl.setTargetFPS(60); // Set our game to run at 60 frames-per-second
    //--------------------------------------------------------------------------------------

    // Main game loop
    while (!rl.windowShouldClose()) // Detect window close button or ESC key
    {
        // Draw
        //----------------------------------------------------------------------------------
        rl.beginDrawing();
        defer rl.endDrawing();

        rl.drawTexture(backgroundTexture, 0, 0, .white);
        rl.drawTexturePro(fudesumiTexture, fudesumiRec, fudesumiPos, rl.Vector2.zero(), 0, .white);

        rl.drawTexturePro(textureRed, fudesumiRec, redPos, rl.Vector2.zero(), 0, .red);
        rl.drawTexturePro(textureGreen, fudesumiRec, greenPos, rl.Vector2.zero(), 0, .green);
        rl.drawTexturePro(textureBlue, fudesumiRec, bluePos, rl.Vector2.zero(), 0, .blue);
        rl.drawTexturePro(textureAlpha, fudesumiRec, alphaPos, rl.Vector2.zero(), 0, .white);

        //----------------------------------------------------------------------------------
    }
}
