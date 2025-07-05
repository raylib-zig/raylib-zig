// raylib [shaders] example - Basic PBR
//
// Example complexity rating: [★★★★] 4/4
//
// Example originally created with raylib 5.0, last time updated with raylib 5.1-dev
//
// Example contributed by Afan OLOVCIC (@_DevDad) and reviewed by Ramon Santamaria (@raysan5)
//
// Example licensed under an unmodified zlib/libpng license, which is an OSI-certified,
// BSD-like license that allows static linking with closed source software
//
// Copyright (c) 2023-2025 Afan OLOVCIC (@_DevDad)
//
// Model: "Old Rusty Car" (https://skfb.ly/LxRy) by Renafox,
// licensed under Creative Commons Attribution-NonCommercial
// (http://creativecommons.org/licenses/by-nc/4.0/)

const rl = @import("raylib");

/// Casts ShaderLocationIndex to a u32
fn uSli(sli: rl.ShaderLocationIndex) u32 {
    return @intCast(@intFromEnum(sli));
}

/// Casts MaterialMapIndex to a u32
fn uMmi(mmi: rl.MaterialMapIndex) u32 {
    return @intCast(@intFromEnum(mmi));
}

/// Max dynamic lights supported by shader
const max_lights = 4;
/// Current number of dynamic lights that have been created
var light_count: u32 = 0;

//------------------------------------------------------------------------------
// Types and Structures Definition
//------------------------------------------------------------------------------

/// Light data
const Light = extern struct {
    type: Type = .directional,
    enabled: bool = false,
    _enabled_pad1: u8 = 0,
    _enabled_pad2: @Type(.{.int = .{
        .signedness = .unsigned,
        .bits = @bitSizeOf(c_uint) - 16,
    }}) = 0,
    position: rl.Vector3 = .init(0, 0, 0),
    target: rl.Vector3 = .init(0, 0, 0),
    color: [4]f32 = .{ 0, 0, 0, 0 },
    intensity: f32 = 0,

    // Shader light parameters locations
    loc: extern struct {
        type: i32 = 0,
        enabled: i32 = 0,
        position: i32 = 0,
        target: i32 = 0,
        color: i32 = 0,
        intensity: i32 = 0,
    } = .{},

    /// Light type
    const Type = enum(c_uint) {
        directional = 0,
        point,
        spot,
    };

    /// Create light with provided data
    ///
    /// NOTE: It updates `light_count` and is limited to `max_lights`
    fn init(
        t: Type,
        position: rl.Vector3,
        target: rl.Vector3,
        color: rl.Color,
        intensity: f32,
        shader: rl.Shader,
    ) Light {
        if (light_count >= max_lights) {
            return .{};
        }
        const light: Light = .{
            .type = t,
            .enabled = true,
            .position = position,
            .target = target,
            .color = .{
                @as(f32, @floatFromInt(color.r)) / 255.0,
                @as(f32, @floatFromInt(color.g)) / 255.0,
                @as(f32, @floatFromInt(color.b)) / 255.0,
                @as(f32, @floatFromInt(color.a)) / 255.0,
            },
            .intensity = intensity,

            // NOTE: Shader parameters names for lights must match the requested ones
            .loc = .{
                .type = rl.getShaderLocation(shader, rl.textFormat("lights[%i].type", .{ light_count })),
                .enabled = rl.getShaderLocation(shader, rl.textFormat("lights[%i].enabled", .{ light_count })),
                .position = rl.getShaderLocation(shader, rl.textFormat("lights[%i].position", .{ light_count })),
                .target = rl.getShaderLocation(shader, rl.textFormat("lights[%i].target", .{ light_count })),
                .color = rl.getShaderLocation(shader, rl.textFormat("lights[%i].color", .{ light_count })),
                .intensity = rl.getShaderLocation(shader, rl.textFormat("lights[%i].intensity", .{ light_count })),
            },
        };
        light.update(shader);
        light_count += 1;

        return light;
    }

    /// Send light properties to shader
    ///
    /// NOTE: Light shader locations should be available
    fn update(self: Light, shader: rl.Shader) void {
        rl.setShaderValue(shader, self.loc.type, &self.type, .int);
        rl.setShaderValue(shader, self.loc.enabled, &self.enabled, .int);

        // Send to shader light position values
        const position: [3]f32 = .{ self.position.x, self.position.y, self.position.z };
        rl.setShaderValue(shader, self.loc.position, &position, .vec3);

        // Send to shader light target position values
        const target: [3]f32 = .{ self.target.x, self.target.y, self.target.z };
        rl.setShaderValue(shader, self.loc.target, &target, .vec3);
        rl.setShaderValue(shader, self.loc.color, &self.color, .vec4);
        rl.setShaderValue(shader, self.loc.intensity, &self.intensity, .float);
    }
};

//----------------------------------------------------------------------------------
// Main Entry Point
//----------------------------------------------------------------------------------
pub fn main() anyerror!void {
    // Initialization
    //--------------------------------------------------------------------------------------
    const screen_width = 800;
    const screen_height = 450;

    rl.setConfigFlags(.{ .msaa_4x_hint = true });
    rl.initWindow(screen_width, screen_height, "raylib [shaders] example - basic pbr");
    defer rl.closeWindow();      // Close window and OpenGL context

    // Define the camera to look into our 3d world
    var camera: rl.Camera = .{
        .position = .init(2, 2, 6),    // Camera position
        .target = .init(0, 0.5, 0),    // Camera looking at point
        .up = .init(0, 1, 0),          // Camera up vector (rotation towards target)
        .fovy = 45,                    // Camera field-of-view Y
        .projection = .perspective,    // Camera projection type
    };

    // Load PBR shader and setup all required locations
    const shader: rl.Shader = try rl.loadShader(
        "resources/shaders/glsl330/pbr.vs",
        "resources/shaders/glsl330/pbr.fs",
    );
    defer rl.unloadShader(shader);

    shader.locs[uSli(.map_albedo)] = rl.getShaderLocation(shader, "albedoMap");
    // WARNING: Metalness, roughness, and ambient occlusion are all packed into a MRA texture
    // They are passed as to the SHADER_LOC_MAP_METALNESS location for convenience,
    // shader already takes care of it accordingly
    shader.locs[uSli(.map_metalness)] = rl.getShaderLocation(shader, "mraMap");
    shader.locs[uSli(.map_normal)] = rl.getShaderLocation(shader, "normalMap");
    // WARNING: Similar to the MRA map, the emissive map packs different information
    // into a single texture: it stores height and emission data
    // It is binded to SHADER_LOC_MAP_EMISSION location an properly processed on shader
    shader.locs[uSli(.map_emission)] = rl.getShaderLocation(shader, "emissiveMap");
    shader.locs[uSli(.color_diffuse)] = rl.getShaderLocation(shader, "albedoColor");

    // Setup additional required shader locations, including lights data
    shader.locs[uSli(.vector_view)] = rl.getShaderLocation(shader, "viewPos");
    const loc_light_count: i32 = rl.getShaderLocation(shader, "numOfLights");
    const max_light_count: i32 = max_lights;
    rl.setShaderValue(shader, loc_light_count, &max_light_count, .int);

    // Setup ambient color and intensity parameters
    const ambient_intensity: f32 = 0.02;
    const ambient_color: rl.Vector3 = blk: {
        const c: rl.Color = .init(26, 32, 135, 255);
        break :blk .init(
            @as(f32, @floatFromInt(c.r)) / 255.0,
            @as(f32, @floatFromInt(c.g)) / 255.0,
            @as(f32, @floatFromInt(c.b)) / 255.0,
        );
    };
    rl.setShaderValue(shader, rl.getShaderLocation(shader, "ambientColor"), &ambient_color, .vec3);
    rl.setShaderValue(shader, rl.getShaderLocation(shader, "ambient"), &ambient_intensity, .float);

    // Get location for shader parameters that can be modified in real time
    const loc_metallic_value = rl.getShaderLocation(shader, "metallicValue");
    const loc_roughness_value = rl.getShaderLocation(shader, "roughnessValue");
    const loc_emissive_intensity = rl.getShaderLocation(shader, "emissivePower");
    const loc_emissive_color = rl.getShaderLocation(shader, "emissiveColor");
    const loc_texture_tiling = rl.getShaderLocation(shader, "tiling");

    // Load old car model using PBR maps and shader
    // WARNING: We know this model consists of a single model.meshes[0] and
    // that model.materials[0] is by default assigned to that mesh
    // There could be more complex models consisting of multiple meshes and
    // multiple materials defined for those meshes... but always 1 mesh = 1 material
    const car: rl.Model = try .init("resources/models/old_car_new.glb");
    defer {
        car.materials[0].shader = .{ .id = 0, .locs = null };
        rl.unloadMaterial(car.materials[0]);
        car.materials[0].maps = null;
        car.unload();
    }

    // Assign already setup PBR shader to model.materials[0], used by models.meshes[0]
    car.materials[0].shader = shader;

    // Setup materials[0].maps default parameters
    car.materials[0].maps[uMmi(.albedo)].color = .white;
    car.materials[0].maps[uMmi(.metalness)].value = 1.0;
    car.materials[0].maps[uMmi(.roughness)].value = 0.0;
    car.materials[0].maps[uMmi(.occlusion)].value = 1.0;
    car.materials[0].maps[uMmi(.emission)].color = .init(255, 162, 0, 255);

    // Setup materials[0].maps default textures
    car.materials[0].maps[uMmi(.albedo)].texture = try .init("resources/textures/old_car_d.png");
    car.materials[0].maps[uMmi(.metalness)].texture = try .init("resources/textures/old_car_mra.png");
    car.materials[0].maps[uMmi(.normal)].texture = try .init("resources/textures/old_car_n.png");
    car.materials[0].maps[uMmi(.emission)].texture = try .init("resources/textures/old_car_e.png");

    // Load floor model mesh and assign material parameters
    // NOTE: A basic plane shape can be generated instead of being loaded from a model file
    const floor: rl.Model = try .init("resources/models/plane.glb");
    defer {
        floor.materials[0].shader = .{ .id = 0, .locs = null };
        rl.unloadMaterial(floor.materials[0]);
        floor.materials[0].maps = null;
        floor.unload();
    }
    //Mesh floorMesh = GenMeshPlane(10, 10, 10, 10);
    //GenMeshTangents(&floorMesh);      // TODO: Review tangents generation
    //Model floor = LoadModelFromMesh(floorMesh);

    // Assign material shader for our floor model, same PBR shader
    floor.materials[0].shader = shader;

    floor.materials[0].maps[uMmi(.albedo)].color = .white;
    floor.materials[0].maps[uMmi(.metalness)].value = 0.8;
    floor.materials[0].maps[uMmi(.roughness)].value = 0.1;
    floor.materials[0].maps[uMmi(.occlusion)].value = 1.0;
    floor.materials[0].maps[uMmi(.emission)].color = .black;

    floor.materials[0].maps[uMmi(.albedo)].texture = try .init("resources/textures/road_a.png");
    floor.materials[0].maps[uMmi(.metalness)].texture = try .init("resources/textures/road_mra.png");
    floor.materials[0].maps[uMmi(.normal)].texture = try .init("resources/textures/road_n.png");

    // Models texture tiling parameter can be stored in the Material struct if required (CURRENTLY NOT USED)
    // NOTE: Material.params[4] are available for generic parameters storage (float)
    const car_texture_tiling: rl.Vector2 = .init(0.5, 0.5);
    const floor_texture_tiling: rl.Vector2 = .init(0.5, 0.5);

    // Create some lights
    var lights: [max_lights]Light = .{
        .init(.point, .init(-1, 1, -2), .init(0, 0, 0), .yellow, 4, shader),
        .init(.point, .init(2, 1, 1), .init(0, 0, 0), .green, 3.3, shader),
        .init(.point, .init(-2, 1, 1), .init(0, 0, 0), .red, 8.3, shader),
        .init(.point, .init(1, 1, -2), .init(0, 0, 0), .blue, 2, shader),
    };

    // Setup material texture maps usage in shader
    // NOTE: By default, the texture maps are always used
    const usage: i32 = 1;
    rl.setShaderValue(shader, rl.getShaderLocation(shader, "useTexAlbedo"), &usage, .int);
    rl.setShaderValue(shader, rl.getShaderLocation(shader, "useTexNormal"), &usage, .int);
    rl.setShaderValue(shader, rl.getShaderLocation(shader, "useTexMRA"), &usage, .int);
    rl.setShaderValue(shader, rl.getShaderLocation(shader, "useTexEmissive"), &usage, .int);

    rl.setTargetFPS(60);                   // Set our game to run at 60 frames-per-second
    //---------------------------------------------------------------------------------------

    // Main game loop
    while (!rl.windowShouldClose())    // Detect window close button or ESC key
    {
        // Update
        //----------------------------------------------------------------------------------
        camera.update(.orbital);

        // Update the shader with the camera view vector (points towards { 0.0f, 0.0f, 0.0f })
        const camera_pos: [3]f32 = .{ camera.position.x, camera.position.y, camera.position.z };
        rl.setShaderValue(shader, shader.locs[uSli(.vector_view)], &camera_pos, .vec3);

        // Check key inputs to enable/disable lights
        if (rl.isKeyPressed(.one)) {
            lights[2].enabled = !lights[2].enabled;
        }
        if (rl.isKeyPressed(.two)) {
            lights[1].enabled = !lights[1].enabled;
        }
        if (rl.isKeyPressed(.three)) {
            lights[3].enabled = !lights[3].enabled;
        }
        if (rl.isKeyPressed(.four)) {
            lights[0].enabled = !lights[0].enabled;
        }

        // Update light values on shader (actually, only enable/disable them)
        for (&lights) |*l| {
            l.update(shader);
        }
        //----------------------------------------------------------------------------------

        // Draw
        //----------------------------------------------------------------------------------
        rl.beginDrawing();
        defer rl.endDrawing();

        rl.clearBackground(.black);
        {
            rl.beginMode3D(camera);
            defer rl.endMode3D();

            // Set floor model texture tiling and emissive color parameters on shader
            rl.setShaderValue(shader, loc_texture_tiling, &floor_texture_tiling, .vec2);
            const floor_emissive_color: rl.Vector4 = rl.colorNormalize(floor.materials[0].maps[uMmi(.emission)].color);
            rl.setShaderValue(shader, loc_emissive_color, &floor_emissive_color, .vec4);

            // Set floor metallic and roughness values
            rl.setShaderValue(shader, loc_metallic_value, &floor.materials[0].maps[uMmi(.metalness)].value, .float);
            rl.setShaderValue(shader, loc_roughness_value, &floor.materials[0].maps[uMmi(.roughness)].value, .float);

            floor.draw(.init(0, 0, 0), 5, .white);   // Draw floor model

            // Set old car model texture tiling, emissive color and emissive intensity parameters on shader
            rl.setShaderValue(shader, loc_texture_tiling, &car_texture_tiling, .vec2);
            const car_emissive_color: rl.Vector4 = rl.colorNormalize(car.materials[0].maps[uMmi(.emission)].color);
            rl.setShaderValue(shader, loc_emissive_color, &car_emissive_color, .vec4);
            const emissive_intensity: f32 = 0.01;
            rl.setShaderValue(shader, loc_emissive_intensity, &emissive_intensity, .float);

            // Set old car metallic and roughness values
            rl.setShaderValue(shader, loc_metallic_value, &car.materials[0].maps[uMmi(.metalness)].value, .float);
            rl.setShaderValue(shader, loc_roughness_value, &car.materials[0].maps[uMmi(.roughness)].value, .float);

            car.draw(.init(0, 0, 0), 0.25, .white);   // Draw car model

            // Draw spheres to show the lights positions
            for (&lights) |*l| {
                const light_color: rl.Color = .init(
                    @intFromFloat(l.color[0] * 255),
                    @intFromFloat(l.color[1] * 255),
                    @intFromFloat(l.color[2] * 255),
                    @intFromFloat(l.color[3] * 255),
                );

                if (l.enabled) {
                    rl.drawSphereEx(l.position, 0.2, 8, 8, light_color);
                } else {
                    rl.drawSphereWires(l.position, 0.2, 8, 8, rl.colorAlpha(light_color, 0.3));
                }
            }
        }
        rl.drawText("Toggle lights: [1][2][3][4]", 10, 40, 20, .light_gray);

        rl.drawText("(c) Old Rusty Car model by Renafox (https://skfb.ly/LxRy)",
            screen_width - 320, screen_height - 20, 10, .light_gray);

        rl.drawFPS(10, 10);
    }
}
