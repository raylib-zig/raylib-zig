// A raylib port of https://github.com/raysan5/raylib/blob/master/examples/core/core_3d_camera_free.c

const rl = @import("raylib");

//------------------------------------------------------------------------------------
// Program main entry point
//------------------------------------------------------------------------------------
pub fn main() anyerror!void {
    // Initialization
    //--------------------------------------------------------------------------------
    const screenWidth = 800;
    const screenHeight = 450;

    rl.initWindow(screenWidth, screenHeight, "raylib [core] example - 3d camera free");
    defer rl.closeWindow(); // Close window and OpenGL context

    // Define the camera to look into our 3d world
    var camera = rl.Camera{
        .position = .init(10, 10, 10),
        .target = .init(0, 0, 0),
        .up = .init(0, 1, 0),
        .fovy = 45,
        .projection = .perspective,
    };

    const cubePosition = rl.Vector3.init(0, 0, 0);

    rl.disableCursor(); // Limit cursor to relative movement inside the window
    rl.setTargetFPS(60); // Set our game to run at 60 frames-per-second
    //--------------------------------------------------------------------------------

    // Main game loop
    while (!rl.windowShouldClose()) { // Detect window close button or ESC key
        // Update
        //-----------------------------------------------------------------------------
        camera.update(.free);

        if (rl.isKeyPressed(.z)) {
            camera.target = .init(0, 0, 0);
        }
        //-----------------------------------------------------------------------------

        // Draw
        //-----------------------------------------------------------------------------
        rl.beginDrawing();
        defer rl.endDrawing();

        rl.clearBackground(.ray_white);

        {
            camera.begin();
            defer camera.end();

            rl.drawCube(cubePosition, 2, 2, 2, .red);
            rl.drawCubeWires(cubePosition, 2, 2, 2, .maroon);

            rl.drawGrid(10, 1);
        }

        rl.drawRectangle(10, 10, 320, 93, .fade(.sky_blue, 0.5));
        rl.drawRectangleLines(10, 10, 320, 93, .blue);

        rl.drawText("Free camera default controls:", 20, 20, 10, .black);
        rl.drawText("- Mouse Wheel to Zoom in-out", 40, 40, 10, .dark_gray);
        rl.drawText("- Mouse Wheel Pressed to Pan", 40, 60, 10, .dark_gray);
        rl.drawText("- Z to zoom to (0, 0, 0)", 40, 80, 10, .dark_gray);
        //-----------------------------------------------------------------------------
    }
}
