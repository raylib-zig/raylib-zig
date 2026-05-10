//!******************************************************************************************
//!
//!   raylib-zig port of the [textures] example - Draw a texture along a segmented curve
//!   https://github.com/raysan5/raylib/blob/master/examples/textures/textures_textured_curve.c
//!
//!   Example complexity rating: [★★★☆] 3/4
//!
//!   Example originally created with raylib 4.5, last time updated with raylib 4.5
//!
//!   Example contributed by Jeffery Myers (@JeffM2501) and reviewed by Ramon Santamaria (@raysan5)
//!   Translated to raylib-zig by Timothy Fiss (@TheFissk)
//!
//!   Example licensed under an unmodified zlib/libpng license, which is an OSI-certified,
//!   BSD-like license that allows static linking with closed source software
//!
//!   Copyright (c) 2022-2025 Jeffery Myers (@JeffM2501) and Ramon Santamaria (@raysan5)
//!
//!*******************************************************************************************

const rl = @import("raylib");
const std = @import("std");

//----------------------------------------------------------------------------------
// Global Variables Definition
//----------------------------------------------------------------------------------
var texture_road: rl.Texture = undefined;

var show_curve: bool = false;

var curve_width: f32 = 50;
var curve_segments: usize = 24;

var curve_start_position = rl.Vector2{ .x = 0, .y = 0 };
var curve_start_position_tangent = rl.Vector2{ .x = 0, .y = 0 };

var curve_end_position = rl.Vector2{ .x = 0, .y = 0 };
var curve_end_position_tangent = rl.Vector2{ .x = 0, .y = 0 };

var curve_selected_point: ?*rl.Vector2 = null;

//------------------------------------------------------------------------------------
// Program main entry point
//------------------------------------------------------------------------------------
pub fn main() anyerror!void {
    // Initialization
    //--------------------------------------------------------------------------------------
    const screen_width = 800;
    const screen_height = 450;

    rl.setConfigFlags(.{ .vsync_hint = true, .msaa_4x_hint = true });
    rl.initWindow(screen_width, screen_height, "raylib [textures] examples - textured curve");
    defer rl.closeWindow(); // Close window and OpenGL context

    // Load the road texture
    texture_road = try rl.loadTexture("examples/textures/resources/road.png");
    defer texture_road.unload();
    rl.setTextureFilter(texture_road, .bilinear);

    // Setup the curve
    curve_start_position = rl.Vector2{ .x = 80, .y = 100 };
    curve_start_position_tangent = rl.Vector2{ .x = 100, .y = 300 };

    curve_end_position = rl.Vector2{ .x = 700, .y = 350 };
    curve_end_position_tangent = rl.Vector2{ .x = 600, .y = 100 };

    rl.setTargetFPS(60); // Set our game to run at 60 frames-per-second
    //--------------------------------------------------------------------------------------

    // Main game loop
    while (!rl.windowShouldClose()) // Detect window close button or ESC key
    {
        // Update
        //----------------------------------------------------------------------------------
        // Curve config options
        if (rl.isKeyPressed(.space)) show_curve = !show_curve;
        if (rl.isKeyPressed(.equal)) curve_width += 2;
        if (rl.isKeyPressed(.minus)) curve_width -= 2;
        if (curve_width < 2) curve_width = 2;

        // Update segments
        if (rl.isKeyPressed(.left)) curve_segments -= 2;
        if (rl.isKeyPressed(.right)) curve_segments += 2;

        if (curve_segments < 2) curve_segments = 2;

        // Update curve logic
        // If the mouse is not down, we are not editing the curve so clear the selection
        if (!rl.isMouseButtonDown(.left)) curve_selected_point = null;

        // If a point was selected, move it
        if (curve_selected_point) |point| {
            point.* = point.add(rl.getMouseDelta());
        }

        // The mouse is down, and nothing was selected, so see if anything was picked
        const mouse = rl.getMousePosition();
        if (rl.checkCollisionPointCircle(mouse, curve_start_position, 6)) {
            curve_selected_point = &curve_start_position;
        } else if (rl.checkCollisionPointCircle(mouse, curve_start_position_tangent, 6)) {
            curve_selected_point = &curve_start_position_tangent;
        } else if (rl.checkCollisionPointCircle(mouse, curve_end_position, 6)) {
            curve_selected_point = &curve_end_position;
        } else if (rl.checkCollisionPointCircle(mouse, curve_end_position_tangent, 6)) {
            curve_selected_point = &curve_end_position_tangent;
        }
        //----------------------------------------------------------------------------------

        // Draw
        //----------------------------------------------------------------------------------
        rl.beginDrawing();
        defer rl.endDrawing();

        rl.clearBackground(.ray_white);

        drawTexturedCurve(); // Draw a textured Spline Cubic Bezier

        // Draw spline for reference
        if (show_curve) rl.drawSplineSegmentBezierCubic(curve_start_position, curve_end_position, curve_start_position_tangent, curve_end_position_tangent, 2, .blue);

        // Draw the various control points and highlight where the mouse is
        rl.drawLineV(curve_start_position, curve_start_position_tangent, .sky_blue);
        rl.drawLineV(curve_start_position_tangent, curve_end_position_tangent, rl.fade(.light_gray, 0.4));
        rl.drawLineV(curve_end_position, curve_end_position_tangent, .purple);

        if (rl.checkCollisionPointCircle(mouse, curve_start_position, 6)) rl.drawCircleV(curve_start_position, 7, .yellow);
        rl.drawCircleV(curve_start_position, 5, .red);

        if (rl.checkCollisionPointCircle(mouse, curve_start_position_tangent, 6)) rl.drawCircleV(curve_start_position_tangent, 7, .yellow);
        rl.drawCircleV(curve_start_position_tangent, 5, .maroon);

        if (rl.checkCollisionPointCircle(mouse, curve_end_position, 6)) rl.drawCircleV(curve_end_position, 7, .yellow);
        rl.drawCircleV(curve_end_position, 5, .green);

        if (rl.checkCollisionPointCircle(mouse, curve_end_position_tangent, 6)) rl.drawCircleV(curve_end_position_tangent, 7, .yellow);
        rl.drawCircleV(curve_end_position_tangent, 5, .dark_green);

        // Draw usage info
        rl.drawText("Drag points to move curve, press SPACE to show/hide base curve", 10, 10, 10, .dark_gray);
        rl.drawText(rl.textFormat("Curve width: %2.0f (Use + and - to adjust)", .{curve_width}), 10, 30, 10, .dark_gray);
        rl.drawText(rl.textFormat("Curve segments: %d (Use LEFT and RIGHT to adjust)", .{curve_segments}), 10, 50, 10, .dark_gray);

        //----------------------------------------------------------------------------------
    }
}

//----------------------------------------------------------------------------------
// Module Functions Definition
//----------------------------------------------------------------------------------

// Draw textured curve using Spline Cubic Bezier
fn drawTexturedCurve() void {
    const step: f32 = 1.0 / @as(f32, @floatFromInt(curve_segments));

    var previous = curve_start_position;
    var previous_tangent = rl.Vector2{ .x = 0, .y = 0 };
    var previous_v: f32 = 0;

    // We can't compute a tangent for the first point, so we need to reuse the tangent from the first segment
    var tangent_set = false;

    var current = rl.Vector2{ .x = 0, .y = 0 };
    var t: f32 = 0.0;

    for (1..curve_segments) |i| {
        t = step * @as(f32, @floatFromInt(i));

        const a = std.math.pow(f32, 1.0 - t, 3);
        const b = 3.0 * std.math.pow(f32, 1.0 - t, 2) * t;
        const c = 3.0 * (1.0 - t) * std.math.pow(f32, t, 2);
        const d = std.math.pow(f32, t, 3);

        // Compute the endpoint for this segment
        current.y = a * curve_start_position.y + b * curve_start_position_tangent.y + c * curve_end_position_tangent.y + d * curve_end_position.y;
        current.x = a * curve_start_position.x + b * curve_start_position_tangent.x + c * curve_end_position_tangent.x + d * curve_end_position.x;

        // Vector from previous to current
        const delta = rl.Vector2{ .x = current.x - previous.x, .y = current.y - previous.y };

        // The right hand normal to the delta vector
        const normal = rl.Vector2.normalize(rl.Vector2{ .x = -delta.y, .y = delta.x });

        // The v texture coordinate of the segment (add up the length of all the segments so far)
        const v = previous_v + delta.length();

        // Make sure the start point has a normal
        if (!tangent_set) {
            previous_tangent = normal;
            tangent_set = true;
        }

        // Extend out the normals from the previous and current points to get the quad for this segment
        const prev_pos_normal = previous.add(previous_tangent.scale(curve_width));
        const prev_neg_normal = previous.add(previous_tangent.scale(-curve_width));

        const current_pos_normal = current.add(normal.scale(curve_width));
        const current_neg_normal = current.add(normal.scale(-curve_width));

        // Draw the segment as a quad
        rl.gl.rlSetTexture(texture_road.id);
        rl.gl.rlBegin(rl.gl.rl_quads);
        defer rl.gl.rlEnd();
        rl.gl.rlColor4ub(255, 255, 255, 255);
        rl.gl.rlNormal3f(0.0, 0.0, 1.0);

        rl.gl.rlTexCoord2f(0, previous_v);
        rl.gl.rlVertex2f(prev_neg_normal.x, prev_neg_normal.y);

        rl.gl.rlTexCoord2f(1, previous_v);
        rl.gl.rlVertex2f(prev_pos_normal.x, prev_pos_normal.y);

        rl.gl.rlTexCoord2f(1, v);
        rl.gl.rlVertex2f(current_pos_normal.x, current_pos_normal.y);

        rl.gl.rlTexCoord2f(0, v);
        rl.gl.rlVertex2f(current_neg_normal.x, current_neg_normal.y);

        // The current step is the start of the next step
        previous = current;
        previous_tangent = normal;
        previous_v = v;
    }
}
