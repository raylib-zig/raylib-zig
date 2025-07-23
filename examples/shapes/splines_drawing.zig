const rl = @import("raylib");
const rgui = @import("raygui");

const MAX_SPLINE_POINTS = 32;
const screenWidth = 800;
const screenHeight = 450;

// Cubic Bezier spline control points
// NOTE: Every segment has two control points
const ControlPoint = struct {
    start: rl.Vector2,
    end: rl.Vector2,
};

// Spline types
const SplineType = enum(i32) {
    linear = 0, // Linear
    basis = 1, // B-Spline
    catmullrom = 2, // Catmull-Rom
    bezier = 3, // Cubic Bezier
};

//------------------------------------------------------------------------------------
// Program main entry point
//------------------------------------------------------------------------------------
pub fn main() anyerror!void {
    // Initialization
    //--------------------------------------------------------------------------------------

    rl.setConfigFlags(.{ .msaa_4x_hint = true });
    rl.initWindow(screenWidth, screenHeight, "raylib [shapes] example - splines drawing");
    defer rl.closeWindow(); // Close window and OpenGL context

    var points: [MAX_SPLINE_POINTS]rl.Vector2 = undefined;
    points[0] = rl.Vector2{ .x = 50.0, .y = 400.0 };
    points[1] = rl.Vector2{ .x = 160.0, .y = 220.0 };
    points[2] = rl.Vector2{ .x = 340.0, .y = 380.0 };
    points[3] = rl.Vector2{ .x = 520.0, .y = 60.0 };
    points[4] = rl.Vector2{ .x = 710.0, .y = 260.0 };
    for (5..MAX_SPLINE_POINTS) |i| {
        points[i] = rl.Vector2{ .x = 0, .y = 0 };
    }

    // Array required for spline bezier-cubic,
    // including control points interleaved with start-end segment points
    var pointsInterleaved: [3 * (MAX_SPLINE_POINTS - 1) + 1]rl.Vector2 = undefined;
    for (&pointsInterleaved) |*point| {
        point.* = rl.Vector2{ .x = 0, .y = 0 };
    }

    var pointCount: usize = 5;
    var selectedPoint: ?*rl.Vector2 = null;
    var focusedPoint: ?*rl.Vector2 = null;
    var selectedControlPoint: ?*rl.Vector2 = null;
    var focusedControlPoint: ?*rl.Vector2 = null;

    // Cubic Bezier control points initialization
    var control: [MAX_SPLINE_POINTS - 1]ControlPoint = undefined;
    for (&control) |*cp| {
        cp.* = .{ .end = .{ .x = 0, .y = 0 }, .start = .{ .x = 0, .y = 0 } };
    }
    for (0..pointCount) |i| {
        control[i].start = .{ .x = points[i].x + 50, .y = points[i].y };
        control[i].end = .{ .x = points[i + 1].x - 50, .y = points[i + 1].y };
    }

    // Spline config variables
    var splineThickness: f32 = 8.0;
    var splineTypeActive = SplineType.linear;
    var splineTypeEditMode = false;
    var splineHelpersActive = true;

    rl.setTargetFPS(60); // Set our game to run at 60 frames-per-second
    //--------------------------------------------------------------------------------------

    // Main game loop
    while (!rl.windowShouldClose()) // Detect window close button or ESC key
    {
        // Update
        //----------------------------------------------------------------------------------
        // Spline points creation logic (at the end of spline)
        if (rl.isMouseButtonPressed(.right) and (pointCount < MAX_SPLINE_POINTS)) {
            points[pointCount] = rl.getMousePosition();
            const i = pointCount - 1;
            control[i].start = rl.Vector2{ .x = points[i].x + 50, .y = points[i].y };
            control[i].end = rl.Vector2{ .x = points[i + 1].x - 50, .y = points[i + 1].y };
            pointCount += 1;
        }

        // Spline point focus and selection logic
        if (selectedPoint == null and ((splineTypeActive != SplineType.bezier) or selectedControlPoint == null)) {
            focusedPoint = null;
            for (0..pointCount) |i| {
                if (rl.checkCollisionPointCircle(rl.getMousePosition(), points[i], 8.0)) {
                    focusedPoint = &points[i];
                    break;
                }
            }
            if (rl.isMouseButtonPressed(.left)) selectedPoint = focusedPoint;
        }

        // Spline point movement logic
        if (selectedPoint) |point| {
            point.* = rl.getMousePosition();
            if (rl.isMouseButtonReleased(.left)) selectedPoint = null;
        }

        // Cubic Bezier spline control points logic
        if ((splineTypeActive == SplineType.bezier) and focusedPoint == null) {
            // Spline control point focus and selection logic
            if (selectedControlPoint == null) {
                focusedControlPoint = null;
                for (0..pointCount) |i| {
                    if (rl.checkCollisionPointCircle(rl.getMousePosition(), control[i].start, 6.0)) {
                        focusedControlPoint = &control[i].start;
                        break;
                    } else if (rl.checkCollisionPointCircle(rl.getMousePosition(), control[i].end, 6.0)) {
                        focusedControlPoint = &control[i].end;
                        break;
                    }
                }
                if (rl.isMouseButtonPressed(.left)) selectedControlPoint = focusedControlPoint;
            }

            // Spline control point movement logic
            if (selectedControlPoint) |cp| {
                cp.* = rl.getMousePosition();
                if (rl.isMouseButtonReleased(.left)) selectedControlPoint = null;
            }
        }

        // Spline selection logic
        splineTypeActive = switch (rl.getKeyPressed()) {
            .one => SplineType.linear,
            .two => SplineType.basis,
            .three => SplineType.catmullrom,
            .four => SplineType.basis,
            else => splineTypeActive,
        };

        // Clear selection when changing to a spline without control points
        if (rl.isKeyPressed(.one) or rl.isKeyPressed(.two) or rl.isKeyPressed(.three)) selectedControlPoint = null;

        //----------------------------------------------------------------------------------

        // Draw
        //----------------------------------------------------------------------------------
        rl.beginDrawing();
        defer rl.endDrawing();

        rl.clearBackground(.ray_white);

        switch (splineTypeActive) {
            SplineType.linear => rl.drawSplineLinear(points[0..pointCount], splineThickness, .red),
            SplineType.basis => rl.drawSplineBasis(points[0..pointCount], splineThickness, .red),
            SplineType.catmullrom => rl.drawSplineCatmullRom(points[0..pointCount], splineThickness, .red),
            SplineType.bezier => {
                // NOTE: Cubic-bezier spline requires the 2 control points of each segnment to be
                // provided interleaved with the start and end point of every segment
                for (0..pointCount - 1) |i| {
                    pointsInterleaved[3 * i] = points[i];
                    pointsInterleaved[3 * i + 1] = control[i].start;
                    pointsInterleaved[3 * i + 2] = control[i].end;
                }

                pointsInterleaved[3 * (pointCount - 1)] = points[pointCount - 1];

                // Draw spline: cubic-bezier (with control points)
                rl.drawSplineBezierCubic(pointsInterleaved[0 .. 3 * pointCount], splineThickness, .red);

                // Draw spline control points
                for (0..pointCount - 1) |i| {
                    // Every cubic bezier point have two control points
                    rl.drawCircleV(control[i].start, 6, .gold);
                    rl.drawCircleV(control[i].end, 6, .gold);

                    if (focusedControlPoint == &control[i].start) rl.drawCircleV(control[i].start, 8, .green) else if (focusedControlPoint == &control[i].end) rl.drawCircleV(control[i].end, 8, .green);
                    rl.drawLineEx(points[i], control[i].start, 1.0, .light_gray);
                    rl.drawLineEx(points[i + 1], control[i].end, 1.0, .light_gray);

                    // Draw spline control lines
                    rl.drawLineV(points[i], control[i].start, .gray);
                    rl.drawLineV(control[i].end, points[i + 1], .gray);
                }
            },
        }

        if (splineHelpersActive) {
            // Draw spline point helpers
            for (0..pointCount) |i| {
                const radius: f32 = if (focusedPoint == &points[i]) 12 else 8;
                const color: rl.Color = if (focusedPoint == &points[i]) .blue else .dark_blue;
                rl.drawCircleLinesV(points[i], radius, color);
                if ((splineTypeActive != SplineType.linear) and
                    (splineTypeActive != SplineType.bezier) and
                    (i < pointCount - 1)) rl.drawLineV(points[i], points[i + 1], .gray);

                rl.drawText(rl.textFormat("[%.0f, %.0f]", .{ points[i].x, points[i].y }), @intFromFloat(points[i].x), @intFromFloat(points[i].y + 10), 10, .black);
            }
        }

        // Check all possible UI states that require controls lock
        if (splineTypeEditMode or selectedPoint != null or selectedControlPoint != null) rgui.lock();

        // Draw spline config
        _ = rgui.label(.{ .x = 12, .y = 62, .width = 140, .height = 24 }, rl.textFormat("Spline thickness: %i", .{@as(i64, @intFromFloat(splineThickness))}));

        _ = rgui.sliderBar(.{ .x = 12, .y = 60 + 24, .width = 140, .height = 16 }, "", "", &splineThickness, 1.0, 40.0);

        _ = rgui.checkBox(.{ .x = 12, .y = 110, .width = 20, .height = 20 }, "Show point helpers", &splineHelpersActive);

        if (splineTypeEditMode) rgui.unlock();

        _ = rgui.label(.{ .x = 12, .y = 10, .width = 140, .height = 24 }, "Spline type:");
        var active: i32 = @intFromEnum(splineTypeActive);
        if (rgui.dropdownBox(.{
            .x = 12,
            .y = 8 + 24,
            .width = 140,
            .height = 28,
        }, "LINEAR;BSPLINE;CATMULLROM;BEZIER", &active, splineTypeEditMode) > 0) splineTypeEditMode = !splineTypeEditMode;
        splineTypeActive = @enumFromInt(active);

        rgui.unlock();
    }
}
