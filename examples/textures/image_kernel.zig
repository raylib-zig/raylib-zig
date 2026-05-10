//!******************************************************************************************
//!
//!   raylib-zig port of the [textures] example - Image loading and texture creation
//!
//!   Example complexity rating: [★★★★] 4/4
//!
//!   NOTE: Images are loaded in CPU memory (RAM); textures are loaded in GPU memory (VRAM)
//!
//!   Example contributed by Karim Salem (@kimo-s) and reviewed by Ramon Santamaria (@raysan5)
//!   Translated to raylib-zig by Timothy Fiss (@TheFissk)
//!
//!   Example originally created with raylib 1.3, last time updated with raylib 1.3
//!
//!   Example licensed under an unmodified zlib/libpng license, which is an OSI-certified,
//!   BSD-like license that allows static linking with closed source software
//!
//!   Copyright (c) 2015-2025 Karim Salem (@kimo-s)
//!
//!*******************************************************************************************

const rl = @import("raylib");
const std = @import("std");

fn normalizeKernel(kernel: [*]f32, length: usize) void {
    var sum: f32 = 0.0;
    for (kernel[0..length]) |value| {
        sum += value;
    }

    if (sum != 0.0) {
        for (kernel[0..length]) |*value| {
            value.* /= sum;
        }
    }
}

//------------------------------------------------------------------------------------
// Program main entry point
//------------------------------------------------------------------------------------
pub fn main() anyerror!void {
    // Initialization
    //--------------------------------------------------------------------------------------
    const screen_width = 800;
    const screen_height = 450;

    rl.initWindow(screen_width, screen_height, "raylib [textures] example - image convolution");
    defer rl.closeWindow();

    var image = try rl.loadImage("examples/textures/resources/cat.png"); // Loaded in CPU memory (RAM)
    defer rl.unloadImage(image);

    var gaussian_kernel = [_]f32{ 1.0, 2.0, 1.0, 2.0, 4.0, 2.0, 1.0, 2.0, 1.0 };
    var sobel_kernel = [_]f32{ 1.0, 0.0, -1.0, 2.0, 0.0, -2.0, 1.0, 0.0, -1.0 };
    var sharpen_kernel = [_]f32{ 0.0, -1.0, 0.0, -1.0, 5.0, -1.0, 0.0, -1.0, 0.0 };

    normalizeKernel(&gaussian_kernel, gaussian_kernel.len);
    normalizeKernel(&sobel_kernel, sobel_kernel.len);
    normalizeKernel(&sharpen_kernel, sharpen_kernel.len);

    var cat_sharpened = rl.imageCopy(image);
    defer rl.unloadImage(cat_sharpened);
    rl.imageKernelConvolution(&cat_sharpened, &sharpen_kernel);

    var cat_sobel = rl.imageCopy(image);
    defer rl.unloadImage(cat_sobel);
    rl.imageKernelConvolution(&cat_sobel, &sobel_kernel);

    var cat_gaussian = rl.imageCopy(image);
    defer rl.unloadImage(cat_gaussian);

    for (0..6) |_| {
        rl.imageKernelConvolution(&cat_gaussian, &gaussian_kernel);
    }

    rl.imageCrop(&image, .{ .x = 0, .y = 0, .width = 200, .height = 450 });
    rl.imageCrop(&cat_gaussian, .{ .x = 0, .y = 0, .width = 200, .height = 450 });
    rl.imageCrop(&cat_sobel, .{ .x = 0, .y = 0, .width = 200, .height = 450 });
    rl.imageCrop(&cat_sharpened, .{ .x = 0, .y = 0, .width = 200, .height = 450 });

    // Images converted to texture, GPU memory (VRAM)
    const texture = try rl.loadTextureFromImage(image);
    defer rl.unloadTexture(texture);
    const cat_sharpend_texture = try rl.loadTextureFromImage(cat_sharpened);
    defer rl.unloadTexture(cat_sharpend_texture);
    const cat_sobel_texture = try rl.loadTextureFromImage(cat_sobel);
    defer rl.unloadTexture(cat_sobel_texture);
    const cat_gaussian_texture = try rl.loadTextureFromImage(cat_gaussian);
    defer rl.unloadTexture(cat_gaussian_texture);

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

        rl.drawTexture(cat_sharpend_texture, 0, 0, .white);
        rl.drawTexture(cat_sobel_texture, 200, 0, .white);
        rl.drawTexture(cat_gaussian_texture, 400, 0, .white);
        rl.drawTexture(texture, 600, 0, .white);

        //----------------------------------------------------------------------------------
    }
}
