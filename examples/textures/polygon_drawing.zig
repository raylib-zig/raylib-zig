//!******************************************************************************************
//!
//!   raylib-zig port of the [textures] example - Draw Textured Polygon
//!   https://github.com/raysan5/raylib/blob/master/examples/textures/textures_polygon_drawing.c
//!
//!   Example complexity rating: [★☆☆☆] 1/4
//!
//!   Example originally created with raylib 3.7, last time updated with raylib 3.7
//!
//!   Example contributed by Chris Camacho (@chriscamacho) and reviewed by Ramon Santamaria (@raysan5)
//!   Translated to raylib-zig by Timothy Fiss (@TheFissk)
//!
//!   Example licensed under an unmodified zlib/libpng license, which is an OSI-certified,
//!   BSD-like license that allows static linking with closed source software
//!
//!   Copyright (c) 2021-2025 Chris Camacho (@chriscamacho) and Ramon Santamaria (@raysan5)
//!
//!*******************************************************************************************

const rl = @import("raylib");
const PI = @import("std").math.pi;

const MAX_POINTS = 11; // 10 points and back to the start

//------------------------------------------------------------------------------------
// Program main entry point
//------------------------------------------------------------------------------------
pub fn main() anyerror!void {
    // Initialization
    //--------------------------------------------------------------------------------------
    const screen_width = 800;
    const screen_height = 450;

    rl.initWindow(screen_width, screen_height, "raylib [textures] example - textured polygon");
    defer rl.closeWindow();

    // Define texture coordinates to map our texture to poly
    const texture_coordinates = [MAX_POINTS]rl.Vector2{
        .{ .x = 0.75, .y = 0.0 },
        .{ .x = 0.25, .y = 0.0 },
        .{ .x = 0.0, .y = 0.5 },
        .{ .x = 0.0, .y = 0.75 },
        .{ .x = 0.25, .y = 1.0 },
        .{ .x = 0.375, .y = 0.875 },
        .{ .x = 0.625, .y = 0.875 },
        .{ .x = 0.75, .y = 1.0 },
        .{ .x = 1.0, .y = 0.75 },
        .{ .x = 1.0, .y = 0.5 },
        .{ .x = 0.75, .y = 0.0 }, // Close the poly
    };

    // Define the base poly vertices from the UV's
    // NOTE: They can be specified in any other way
    var points: [MAX_POINTS]rl.Vector2 = undefined;
    for (&points, texture_coordinates) |*point, tex_coord| {
        point.x = (tex_coord.x - 0.5) * 256.0;
        point.y = (tex_coord.y - 0.5) * 256.0;
    }

    // Define the vertices drawing position
    // NOTE: Initially same as points but updated every frame
    var positions: [MAX_POINTS]rl.Vector2 = undefined;
    for (&positions, points) |*pos, point| {
        pos.* = point;
    }

    // Load texture to be mapped to poly
    const texture = try rl.loadTexture("examples/textures/resources/cat.png");
    defer texture.unload();

    rl.setTargetFPS(60); // Set our game to run at 60 frames-per-second
    //--------------------------------------------------------------------------------------

    // Main game loop
    while (!rl.windowShouldClose()) // Detect window close button or ESC key
    {
        // Update
        //----------------------------------------------------------------------------------
        // Update points rotation with an angle transform
        // NOTE: Base points position are not modified
        for (&positions) |*position| {
            position.* = position.rotate(1.0 * (PI / 180.0));
        }
        //----------------------------------------------------------------------------------

        // Draw
        //----------------------------------------------------------------------------------
        rl.beginDrawing();
        defer rl.endDrawing();

        rl.clearBackground(.ray_white);

        rl.drawText("textured polygon", 20, 20, 20, .dark_gray);

        DrawTexturePoly(
            texture,
            .{ .x = @as(f32, @floatFromInt(rl.getScreenWidth())) / 2.0, .y = @as(f32, @floatFromInt(rl.getScreenHeight())) / 2.0 },
            &positions,
            &texture_coordinates,
            .white,
        );

        //----------------------------------------------------------------------------------
    }
}

// Draw textured polygon, defined by vertex and texture coordinates
// NOTE: Polygon center must have straight line path to all points
// without crossing perimeter, points must be in anticlockwise order
fn DrawTexturePoly(texture: rl.Texture2D, center: rl.Vector2, points: []const rl.Vector2, texcoords: []const rl.Vector2, tint: rl.Color) void {
    rl.gl.rlBegin(rl.gl.rl_triangles);
    defer rl.gl.rlEnd();

    rl.gl.rlSetTexture(texture.id);
    defer rl.gl.rlSetTexture(0);

    rl.gl.rlColor4ub(tint.r, tint.g, tint.b, tint.a);

    rl.gl.rlTexCoord2f(0.5, 0.5);
    rl.gl.rlVertex2f(center.x, center.y);

    rl.gl.rlTexCoord2f(texcoords[0].x, texcoords[0].y);
    rl.gl.rlVertex2f(points[0].x + center.x, points[0].y + center.y);

    for (points[1..], texcoords[1..]) |point, texcoord| {
        rl.gl.rlTexCoord2f(texcoord.x, texcoord.y);
        rl.gl.rlVertex2f(point.x + center.x, point.y + center.y);

        rl.gl.rlTexCoord2f(0.5, 0.5);
        rl.gl.rlVertex2f(center.x, center.y);

        rl.gl.rlTexCoord2f(texcoord.x, texcoord.y);
        rl.gl.rlVertex2f(point.x + center.x, point.y + center.y);
    }
}
