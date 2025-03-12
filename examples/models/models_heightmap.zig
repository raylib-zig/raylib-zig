const rl = @import("raylib");

pub fn main() anyerror!void {
    const screenWidth: i32 = 800;
    const screenHeight: i32 = 450;

    rl.initWindow(screenWidth, screenHeight, "raylib [models] example - heightmap loading and drawing");
    const cameraPosition: rl.Vector3 = .{ .x = 18, .y = 21, .z = 18 };
    const cameraTarget: rl.Vector3 = .{ .x = 0, .y = 0, .z = 0 };
    const cameraUp: rl.Vector3 = .{ .x = 0, .y = 1, .z = 0 };
    const cameraProjection = rl.CameraProjection.perspective;
    var camera = rl.Camera{ .fovy = 45.0, .position = cameraPosition, .up = cameraUp, .projection = cameraProjection, .target = cameraTarget };

    const image: rl.Image = try rl.loadImage("examples/models/resources/heightmap.png");

    const texture: rl.Texture2D = try rl.loadTextureFromImage(image);

    const meshSize = rl.Vector3{ .x = 16, .y = 8, .z = 16 };
    const mesh = rl.genMeshHeightmap(image, meshSize);

    var model = try rl.loadModelFromMesh(mesh);
    model.materials[0].maps[@intFromEnum(rl.MATERIAL_MAP_DIFFUSE)].texture = texture;

    const mapPosition = rl.Vector3{ .x = -8.0, .y = 0.0, .z = -8.0 };

    rl.unloadImage(image);

    rl.setTargetFPS(60);

    while (!rl.windowShouldClose()) {
        rl.updateCamera(&camera, .orbital);
        rl.beginDrawing();

        rl.clearBackground(.ray_white);
        rl.beginMode3D(camera);
        rl.drawModel(model, mapPosition, 1, .red);
        rl.drawGrid(20, 1.0);
        rl.endMode3D();
        rl.drawTexture(texture, screenWidth - texture.width - 20, 20, .white);
        rl.drawRectangleLines(screenWidth - texture.width - 20, 20, texture.width, texture.height, .green);
        rl.drawFPS(10, 10);

        rl.endDrawing();
    }
    rl.unloadTexture(texture);
    rl.unloadModel(model);

    rl.closeWindow();
}
