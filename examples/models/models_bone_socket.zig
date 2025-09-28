const std = @import("std");
const rl = @import("raylib");

const BONE_SOCKETS = 3;
const BONE_SOCKET_HAT = 0;
const BONE_SOCKET_HAND_R = 1;
const BONE_SOCKET_HAND_L = 2;

pub fn main() anyerror!void {
    const screenWidth: i32 = 800;
    const screenHeight: i32 = 450;

    rl.initWindow(screenWidth, screenHeight, "raylib [models] example - bone socket");
    defer rl.closeWindow();

    // Define the camera to look into our 3d world
    var camera: rl.Camera3D = .{
        .position = .{ .x = 5.0, .y = 5.0, .z = 5.0 },
        .target = .{ .x = 0.0, .y = 2.0, .z = 0.0 },
        .up = .{ .x = 0.0, .y = 1.0, .z = 0.0 },
        .fovy = 45.0,
        .projection = .perspective,
    };

    // Load gltf model
    var characterModel: rl.Model = try rl.loadModel("examples/models/resources/models/gltf/greenman.glb"); // Load character model
    defer characterModel.unload();
    const equipModel: [BONE_SOCKETS]rl.Model = .{
        try rl.loadModel("examples/models/resources/models/gltf/greenman_hat.glb"), // Index for the hat model is the same as BONE_SOCKET_HAT
        try rl.loadModel("examples/models/resources/models/gltf/greenman_sword.glb"), // Index for the sword model is the same as BONE_SOCKET_HAND_R
        try rl.loadModel("examples/models/resources/models/gltf/greenman_shield.glb"), // Index for the shield model is the same as BONE_SOCKET_HAND_L
    };
    defer for (equipModel) |model| {
        model.unload();
    };

    var showEquip: [3]bool = .{ true, true, true }; // Toggle on/off equip

    // Load gltf model animations
    var animIndex: usize = 0;
    var animCurrentFrame: i32 = 0;
    const modelAnimations = try rl.loadModelAnimations("examples/models/resources/models/gltf/greenman.glb");
    const animsCount = modelAnimations.len;
    defer rl.unloadModelAnimations(modelAnimations);

    // indices of bones for sockets
    var boneSocketIndex: [BONE_SOCKETS]usize = undefined;

    // search bones for sockets
    for (0..@as(usize, @intCast(characterModel.boneCount))) |i| {
        const boneName: [:0]const u8 = @ptrCast(&characterModel.bones[i].name);
        if (rl.textIsEqual(boneName, "socket_hat")) {
            boneSocketIndex[BONE_SOCKET_HAT] = i;
            continue;
        }

        if (rl.textIsEqual(boneName, "socket_hand_R")) {
            boneSocketIndex[BONE_SOCKET_HAND_R] = i;
            continue;
        }

        if (rl.textIsEqual(boneName, "socket_hand_L")) {
            boneSocketIndex[BONE_SOCKET_HAND_L] = i;
            continue;
        }
    }

    const position: rl.Vector3 = .zero(); // Set model position
    var angle: f32 = 0.0; // Set angle for rotate character

    rl.disableCursor(); // Limit cursor to relative movement inside the window

    rl.setTargetFPS(60); // Set our game to run at 60 frames-per-second

    while (!rl.windowShouldClose()) {
        // Update
        //----------------------------------------------------------------------------------
        rl.updateCamera(&camera, .third_person);

        // Rotate character
        if (rl.isKeyDown(.f)) {
            angle += 1.0;
            angle = @mod(angle, 360.0);
        } else if (rl.isKeyDown(.h)) {
            angle -= 1.0;
            angle = @mod(angle, 360.0);
        }

        // Select current animation
        if (rl.isKeyPressed(.t)) animIndex = (animIndex + 1) % animsCount else if (rl.isKeyPressed(.g)) animIndex = (animIndex + animsCount - 1) % animsCount;

        // Toggle shown of equip
        if (rl.isKeyPressed(.one)) showEquip[BONE_SOCKET_HAT] = !showEquip[BONE_SOCKET_HAT];
        if (rl.isKeyPressed(.two)) showEquip[BONE_SOCKET_HAND_R] = !showEquip[BONE_SOCKET_HAND_R];
        if (rl.isKeyPressed(.three)) showEquip[BONE_SOCKET_HAND_L] = !showEquip[BONE_SOCKET_HAND_L];

        // Update model animation
        const anim = modelAnimations[animIndex];
        animCurrentFrame = @mod(animCurrentFrame + 1, anim.frameCount);
        rl.updateModelAnimation(characterModel, anim, animCurrentFrame);
        //----------------------------------------------------------------------------------

        // Draw
        //----------------------------------------------------------------------------------
        {
            rl.beginDrawing();
            defer rl.endDrawing();

            rl.clearBackground(.ray_white);
            {
                rl.beginMode3D(camera);
                defer rl.endMode3D();
                // Draw character
                const characterRotate: rl.Quaternion = rl.math.quaternionFromAxisAngle(.{ .x = 0.0, .y = 1.0, .z = 0.0 }, angle * std.math.rad_per_deg);
                characterModel.transform = rl.math.matrixMultiply(rl.math.quaternionToMatrix(characterRotate), rl.math.matrixTranslate(position.x, position.y, position.z));
                rl.updateModelAnimation(characterModel, anim, animCurrentFrame);
                rl.drawMesh(characterModel.meshes[0], characterModel.materials[1], characterModel.transform);

                // Draw equipments (hat, sword, shield)
                for (0..BONE_SOCKETS) |i| {
                    if (!showEquip[i]) continue;

                    const transform = &anim.framePoses[@intCast(animCurrentFrame)][boneSocketIndex[i]];
                    const inRotation = characterModel.bindPose[boneSocketIndex[i]].rotation;
                    const outRotation = transform.rotation;

                    // Calculate socket rotation (angle between bone in initial pose and same bone in current animation frame)
                    const rotate = rl.math.quaternionMultiply(outRotation, rl.math.quaternionInvert(inRotation));
                    var matrixTransform = rl.math.quaternionToMatrix(rotate);
                    // Translate socket to its position in the current animation
                    matrixTransform = rl.math.matrixMultiply(matrixTransform, rl.math.matrixTranslate(transform.translation.x, transform.translation.y, transform.translation.z));
                    // Transform the socket using the transform of the character (angle and translate)
                    matrixTransform = rl.math.matrixMultiply(matrixTransform, characterModel.transform);

                    // Draw mesh at socket position with socket angle rotation
                    rl.drawMesh(equipModel[i].meshes[0], equipModel[i].materials[1], matrixTransform);
                }

                rl.drawGrid(10, 1.0);
            }

            rl.drawText("Use the T/G to switch animation", 10, 10, 20, .gray);
            rl.drawText("Use the F/H to rotate character left/right", 10, 35, 20, .gray);
            rl.drawText("Use the 1,2,3 to toggle shown of hat, sword and shield", 10, 60, 20, .gray);
            //----------------------------------------------------------------------------------
        }
    }
}
