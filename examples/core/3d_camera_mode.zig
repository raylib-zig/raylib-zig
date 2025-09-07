// raylib-zig (c) 0xdeadbad 2025

const rl = @import("raylib");

const Camera = rl.Camera;
const CameraProjection = rl.CameraProjection;
const Vector3 = rl.Vector3;

pub fn main() anyerror!void {
    const screenWidth = 800;
    const screenHeight = 450;

    rl.initWindow(screenWidth, screenHeight, "raylib [core] example - 3d camera mode");
    defer rl.closeWindow();

    const camera = Camera{
        .position = .{ .x = 0.0, .y = 10.0, .z = 10.0 },
        .target = .{ .x = 0.0, .y = 0.0, .z = 0.0 },
        .up = .{ .x = 0.0, .y = 1.0, .z = 0.0 },
        .fovy = 45.0,
        .projection = CameraProjection.perspective,
    };

    const cubePosition = Vector3{ .x = 0.0, .y = 0.0, .z = 0.0 };

    rl.setTargetFPS(60);

    while (!rl.windowShouldClose()) {
        rl.beginDrawing();
        {
            defer rl.endDrawing();
            rl.clearBackground(.ray_white);
            rl.beginMode3D(camera);
            {
                defer rl.endMode3D();
                rl.drawCube(cubePosition, 2.0, 2.0, 2.0, .red);
                rl.drawCubeWires(cubePosition, 2.0, 2.0, 2.0, .maroon);
                rl.drawGrid(10, 1.0);
            }
            rl.drawText("Welcome to the third dimension!", 10, 40, 20, .dark_gray);
            rl.drawFPS(10, 10);
        }
    }
}
