if ($args.Count -ne 1) {
  $PROJECT_NAME = 'Project'
} else {
  $PROJECT_NAME = $args[0]
}

New-Item -Name $PROJECT_NAME -ItemType Directory -ErrorAction Stop
Set-Location -Path $PROJECT_NAME -ErrorAction Stop

Write-Output "Generating project files..."

zig init
Remove-Item "build.zig", "src\root.zig"

$BUILD_DOT_ZIG = @"
const std = @import("std");
const rlz = @import("raylib_zig");

pub fn build(b: *std.Build) !void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});
    
    const raylib_dep = b.dependency("raylib_zig", .{
        .target = target,
        .optimize = optimize,
    });

    const raylib = raylib_dep.module("raylib");
    const raylib_artifact = raylib_dep.artifact("raylib");

    //web exports are completely separate
    if (target.query.os_tag == .emscripten) {
        const exe_lib = try rlz.emcc.compileForEmscripten(b, "$PROJECT_NAME", "src/main.zig", target, optimize);

        exe_lib.linkLibrary(raylib_artifact);
        exe_lib.root_module.addImport("raylib", raylib);

        // Note that raylib itself is not actually added to the exe_lib output file, so it also needs to be linked with emscripten.
        const link_step = try rlz.emcc.linkWithEmscripten(b, &[_]*std.Build.Step.Compile{ exe_lib, raylib_artifact });
        //this lets your program access files like "resources/my-image.png":
        link_step.addArg("--emrun");
        link_step.addArg("--embed-file");
        link_step.addArg("resources/");

        b.getInstallStep().dependOn(&link_step.step);
        const run_step = try rlz.emcc.emscriptenRunStep(b);
        run_step.step.dependOn(&link_step.step);
        const run_option = b.step("run", "Run $PROJECT_NAME");
        run_option.dependOn(&run_step.step);
        return;
    }

    const exe = b.addExecutable(.{ .name = "$PROJECT_NAME", .root_source_file = b.path("src/main.zig"), .optimize = optimize, .target = target });

    exe.linkLibrary(raylib_artifact);
    exe.root_module.addImport("raylib", raylib);

    const run_cmd = b.addRunArtifact(exe);
    const run_step = b.step("run", "Run $PROJECT_NAME");
    run_step.dependOn(&run_cmd.step);

    b.installArtifact(exe);
}
"@

New-Item -Name "build.zig" -ItemType "file" -Value $BUILD_DOT_ZIG -Force

zig fetch --save git+https://github.com/Not-Nik/raylib-zig#devel

New-Item -Name "resources" -ItemType "directory"
New-Item -Name "resources/placeholder.txt" -ItemType "file" -Value "" -Force

Copy-Item -Path "../examples/core/basic_window.zig" -Destination "src/main.zig"
