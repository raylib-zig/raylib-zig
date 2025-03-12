// port of raylib example https://github.com/raysan5/raylib/blob/master/examples/core/core_2d_camera_mouse_zoom.c

const rl = @import("raylib");

pub fn main() anyerror!void {
    // Initialization
    //--------------------------------------------------------------------------------------
    const screenWidth = 800;
    const screenHeight = 450;

    rl.initWindow(screenWidth, screenHeight, "raylib-zig [core] example - 2d camera mouse zoom");
    defer rl.closeWindow(); // Close window and OpenGL context

    var camera = rl.Camera2D{
        .target = .{ .x = 0, .y = 0 },
        .offset = .{ .x = 0, .y = 0 },
        .zoom = 1.0,
        .rotation = 0,
    };

    var zoomMode: i32 = 0; // 0-Mouse Wheel, 1-Mouse Move

    rl.setTargetFPS(60); // Set our game to run at 60 frames-per-second
    //--------------------------------------------------------------------------------------

    // Main game loop
    while (!rl.windowShouldClose()) { // Detect window close button or ESC key
        // Update
        //----------------------------------------------------------------------------------
        if (rl.isKeyPressed(.one)) {
            zoomMode = 0;
        } else if (rl.isKeyPressed(.two)) {
            zoomMode = 1;
        }

        // Translate based on mouse right click
        if (rl.isMouseButtonDown(.right)) {
            var delta = rl.getMouseDelta();
            delta = rl.math.vector2Scale(delta, -1.0 / camera.zoom);
            camera.target = rl.math.vector2Add(camera.target, delta);
        }

        if (zoomMode == 0) {
            // Zoom based on mouse wheel
            const wheel = rl.getMouseWheelMove();
            if (wheel != 0) {
                // Get the world point that is under the mouse
                const mouseWorldPos = rl.getScreenToWorld2D(rl.getMousePosition(), camera);

                // Set the offset to where the mouse is
                camera.offset = rl.getMousePosition();

                // Set the target to match, so that the camera maps the world space point
                // under the cursor to the screen space point under the cursor at any zoom
                camera.target = mouseWorldPos;

                // Zoom increment
                var scaleFactor = 1.0 + (0.25 * @abs(wheel));
                if (wheel < 0) {
                    scaleFactor = 1.0 / scaleFactor;
                }
                camera.zoom = rl.math.clamp(camera.zoom * scaleFactor, 0.125, 64.0);
            }
        } else {
            // Zoom based on left click
            if (rl.isMouseButtonPressed(.left)) {
                // Get the world point that is under the mouse
                const mouseWorldPos = rl.getScreenToWorld2D(rl.getMousePosition(), camera);

                // Set the offset to where the mouse is
                camera.offset = rl.getMousePosition();

                // Set the target to match, so that the camera maps the world space point
                // under the cursor to the screen space point under the cursor at any zoom
                camera.target = mouseWorldPos;
            }
            if (rl.isMouseButtonDown(.left)) {
                // Zoom increment
                const deltaX = rl.getMouseDelta().x;
                var scaleFactor = 1.0 + (0.01 * @abs(deltaX));
                if (deltaX < 0) {
                    scaleFactor = 1.0 / scaleFactor;
                }
                camera.zoom = rl.math.clamp(camera.zoom * scaleFactor, 0.125, 64.0);
            }
        }
        //----------------------------------------------------------------------------------

        // Draw
        //----------------------------------------------------------------------------------
        rl.beginDrawing();
        defer rl.endDrawing();

        rl.clearBackground(.ray_white);

        {
            camera.begin();
            defer camera.end();

            rl.gl.rlPushMatrix();
            rl.gl.rlTranslatef(0, 25 * 50, 0);
            rl.gl.rlRotatef(90, 1, 0, 0);
            rl.drawGrid(100, 50);
            rl.gl.rlPopMatrix();

            rl.drawCircle(screenWidth / 2, screenHeight / 2, 50, .maroon);
        }

        rl.drawText("[1][2] Select mouse zoom mode (Wheel or Move)", 20, 20, 20, .dark_gray);
        if (zoomMode == 0) {
            rl.drawText("Mouse right button drag to move, mouse wheel to zoom", 20, 50, 20, .dark_gray);
        } else {
            rl.drawText("Mouse right button drag to move, mouse press and move to zoom", 20, 50, 20, .dark_gray);
        }

        //----------------------------------------------------------------------------------
    }
}
