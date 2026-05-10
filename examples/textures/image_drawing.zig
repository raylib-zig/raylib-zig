//!******************************************************************************************
//!
//!   raylib-zig port of the [textures] example - Image loading and drawing on it
//!   https://github.com/raysan5/raylib/blob/master/examples/textures/textures_image_drawing.c
//!
//!   Example complexity rating: [★★☆☆] 2/4
//!
//!   NOTE: Images are loaded in CPU memory (RAM); textures are loaded in GPU memory (VRAM)
//!
//!   Example originally created with raylib 1.4, last time updated with raylib 1.4
//!
//!   Translated to raylib-zig by Timothy Fiss (@TheFissk)
//!
//!   Example licensed under an unmodified zlib/libpng license, which is an OSI-certified,
//!   BSD-like license that allows static linking with closed source software
//!
//!   Copyright (c) 2016-2025 Ramon Santamaria (@raysan5)
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

    rl.initWindow(screenWidth, screenHeight, "raylib [textures] example - image drawing");

    // NOTE: Textures MUST be loaded after Window initialization (OpenGL context is required)

    var cat = try rl.loadImage("examples/textures/resources/cat.png");
    defer rl.unloadImage(cat);
    rl.imageCrop(&cat, .{ .x = 100, .y = 10, .width = 280, .height = 380 });
    rl.imageFlipHorizontal(&cat); // Flip cropped image horizontally
    rl.imageResize(&cat, 150, 200); // Resize flipped-cropped image

    var parrots = try rl.loadImage("examples/textures/resources/parrots.png");
    defer rl.unloadImage(parrots);

    // Draw one image over the other with a scaling of 1.5f
    rl.imageDraw(&parrots, cat, .{
        .x = 0,
        .y = 0,
        .width = @as(f32, @floatFromInt(cat.width)),
        .height = @as(f32, @floatFromInt(cat.height)),
    }, .{
        .x = 30,
        .y = 40,
        .width = @as(f32, @floatFromInt(cat.width)) * 1.5,
        .height = @as(f32, @floatFromInt(cat.height)) * 1.5,
    }, .white);

    // Crop resulting image
    rl.imageCrop(&parrots, .{
        .x = 0,
        .y = 50,
        .width = @floatFromInt(parrots.width),
        .height = @floatFromInt(parrots.height - 100),
    });

    // Draw on the image with a few image draw methods
    rl.imageDrawPixel(&parrots, 10, 10, .ray_white);
    rl.imageDrawCircleLines(&parrots, 10, 10, 5, .ray_white);
    rl.imageDrawRectangle(&parrots, 5, 20, 10, 10, .ray_white);

    // Load custom font for drawing on image
    const font = try rl.loadFont("examples/textures/resources/custom_jupiter_crash.png");
    defer rl.unloadFont(font);

    // Draw over image using custom font
    rl.imageDrawTextEx(&parrots, font, "PARROTS & CAT", .{ .x = 300, .y = 230 }, @floatFromInt(font.baseSize), -2, .white);

    const texture = try rl.loadTextureFromImage(parrots); // Image converted to texture, uploaded to GPU memory (VRAM)
    defer rl.unloadTexture(texture);

    rl.setTargetFPS(60);
    //---------------------------------------------------------------------------------------

    // Main game loop
    while (!rl.windowShouldClose()) // Detect window close button or ESC key
    {

        // Draw
        //----------------------------------------------------------------------------------
        rl.beginDrawing();
        defer rl.endDrawing();

        rl.clearBackground(.ray_white);

        rl.drawTexture(texture, @divFloor(screenWidth - texture.width, 2), @divFloor(screenHeight - texture.height, 2) - 40, .white);
        rl.drawRectangleLines(@divFloor(screenWidth - texture.width, 2), @divFloor(screenHeight - texture.height, 2) - 40, texture.width, texture.height, .dark_gray);

        rl.drawText("We are drawing only one texture from various images composed!", 240, 350, 10, .dark_gray);
        rl.drawText("Source images have been cropped, scaled, flipped and copied one over the other.", 190, 370, 10, .dark_gray);

        //----------------------------------------------------------------------------------
    }
}
