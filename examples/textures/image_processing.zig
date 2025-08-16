//!******************************************************************************************
//!
//!   raylib-zig port of the [textures] example - Image processing
//!   https://github.com/raysan5/raylib/blob/master/examples/textures/textures_image_processing.c
//!
//!   Example complexity rating: [★★★☆] 3/4
//!
//!   NOTE: Images are loaded in CPU memory (RAM); textures are loaded in GPU memory (VRAM)
//!
//!   Example originally created with raylib 1.4, last time updated with raylib 3.5
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

const NUM_PROCESSES = 9;

const ImageProcess = enum(u8) {
    none,
    color_grayscale,
    color_tint,
    color_invert,
    color_contrast,
    color_brightness,
    gaussian_blur,
    flip_vertical,
    flip_horizontal,
};

const processText = [_][:0]const u8{ "NO PROCESSING", "COLOR GRAYSCALE", "COLOR TINT", "COLOR INVERT", "COLOR CONTRAST", "COLOR BRIGHTNESS", "GAUSSIAN BLUR", "FLIP VERTICAL", "FLIP HORIZONTAL" };

//------------------------------------------------------------------------------------
// Program main entry point
//------------------------------------------------------------------------------------
pub fn main() anyerror!void {
    // Initialization
    //--------------------------------------------------------------------------------------
    const screenWidth = 800;
    const screenHeight = 450;

    rl.initWindow(screenWidth, screenHeight, "raylib [textures] example - image processing");
    defer rl.closeWindow();

    // NOTE: Textures MUST be loaded after Window initialization (OpenGL context is required)

    // Loaded in CPU memory (RAM)
    var imOrigin = try rl.loadImage("examples/textures/resources/parrots.png");
    defer rl.unloadImage(imOrigin); // Unload image from RAM
    // Format image to RGBA 32bit (required for texture update) <-- ISSUE
    rl.imageFormat(&imOrigin, .uncompressed_r8g8b8a8);
    const texture = try rl.loadTextureFromImage(imOrigin); // Image converted to texture, GPU memory (VRAM)

    var imCopy = rl.imageCopy(imOrigin);

    var currentProcess = ImageProcess.none;
    var textureReload = false;

    var mouseHoverRec: ?usize = 0;

    const toggleRecs: [NUM_PROCESSES]rl.Rectangle = init: {
        var vals: [NUM_PROCESSES]rl.Rectangle = undefined;
        for (&vals, 0..) |*rec, i| {
            rec.* = .{ .x = 40, .y = @floatFromInt(50 + 32 * i), .width = 150, .height = 30 };
        }
        break :init vals;
    };
    rl.setTargetFPS(60);
    //---------------------------------------------------------------------------------------

    // Main game loop
    while (!rl.windowShouldClose()) // Detect window close button or ESC key
    {
        // Update
        //----------------------------------------------------------------------------------

        // Mouse toggle group logic
        for (0..NUM_PROCESSES) |i| {
            if (rl.checkCollisionPointRec(rl.getMousePosition(), toggleRecs[i])) {
                mouseHoverRec = i;

                if (rl.isMouseButtonReleased(.left)) {
                    currentProcess = @enumFromInt(i);
                    textureReload = true;
                }
                break;
            } else mouseHoverRec = null;
        }

        // Keyboard toggle group logic
        if (rl.isKeyPressed(.down)) {
            var proc: i32 = @intFromEnum(currentProcess) + 1;
            if (proc > (NUM_PROCESSES - 1)) proc = 0;
            currentProcess = @enumFromInt(proc);
            textureReload = true;
        } else if (rl.isKeyPressed(.up)) {
            var proc: i32 = @intFromEnum(currentProcess) - 1;
            if (proc < 0) proc = 7;
            currentProcess = @enumFromInt(proc);
            textureReload = true;
        }

        // Reload texture when required
        if (textureReload) {
            rl.unloadImage(imCopy); // Unload image-copy data
            imCopy = rl.imageCopy(imOrigin); // Restore image-copy from image-origin

            // NOTE: Image processing is a costly CPU process to be done every frame,
            // If image processing is required in a frame-basis, it should be done
            // with a texture and by shaders
            switch (currentProcess) {
                .color_grayscale => rl.imageColorGrayscale(&imCopy),
                .color_tint => rl.imageColorTint(&imCopy, .green),
                .color_invert => rl.imageColorInvert(&imCopy),
                .color_contrast => rl.imageColorContrast(&imCopy, -40),
                .color_brightness => rl.imageColorBrightness(&imCopy, -80),
                .gaussian_blur => rl.imageBlurGaussian(&imCopy, 10),
                .flip_vertical => rl.imageFlipVertical(&imCopy),
                .flip_horizontal => rl.imageFlipHorizontal(&imCopy),
                .none => {},
            }

            const pixels = try rl.loadImageColors(imCopy); // Load pixel data from image (RGBA 32bit)
            rl.updateTexture(texture, pixels.ptr); // Update texture with new image data
            rl.unloadImageColors(pixels); // Unload pixels data from RAM

            textureReload = false;
        }
        //----------------------------------------------------------------------------------

        // Draw
        //----------------------------------------------------------------------------------
        rl.beginDrawing();
        defer rl.endDrawing();

        rl.clearBackground(.ray_white);

        rl.drawText("IMAGE PROCESSING:", 40, 30, 10, .dark_gray);

        // Draw rectangles
        for (0..NUM_PROCESSES) |i| {
            const rectangle_color: rl.Color = if ((i == @intFromEnum(currentProcess)) or (i == mouseHoverRec)) .sky_blue else .light_gray;
            const rectangle_lines_color: rl.Color = if ((i == @intFromEnum(currentProcess)) or (i == mouseHoverRec)) .blue else .gray;
            const text_color: rl.Color = if ((i == @intFromEnum(currentProcess)) or (i == mouseHoverRec)) .dark_blue else .dark_gray;
            rl.drawRectangleRec(toggleRecs[i], rectangle_color);
            // toggleRecs[i].x + toggleRecs[i].width / 2 - MeasureText(processText[i], 10) / 2;
            rl.drawRectangleLines(@intFromFloat(toggleRecs[i].x), @intFromFloat(toggleRecs[i].y), @intFromFloat(toggleRecs[i].width), @intFromFloat(toggleRecs[i].height), rectangle_lines_color);
            const posX = @as(i32, @intFromFloat(toggleRecs[i].x + toggleRecs[i].width / 2)) - @divFloor(rl.measureText(processText[i], 10), 2);
            rl.drawText(processText[i], posX, @intFromFloat(toggleRecs[i].y + 11), 10, text_color);
        }

        rl.drawTexture(texture, screenWidth - texture.width - 60, screenHeight / 2 - @divFloor(texture.height, 2), .white);
        rl.drawRectangleLines(screenWidth - texture.width - 60, screenHeight / 2 - @divFloor(texture.height, 2), texture.width, texture.height, .black);

        //----------------------------------------------------------------------------------
    }
}
