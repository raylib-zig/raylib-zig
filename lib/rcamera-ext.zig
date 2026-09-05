// raylib-zig (c) Nikolas Wipper 2024

const rl = @import("raylib.zig");
const rcamera = @import("rcamera.zig");

pub extern "c" fn GetCameraForward(camera: [*c]rl.Camera)  Vector3;
pub extern "c" fn GetCameraUp(camera: [*c]rl.Camera)  Vector3;
pub extern "c" fn GetCameraRight(camera: [*c]rl.Camera)  Vector3;
pub extern "c" fn CameraMoveForward(camera: [*c]rl.Camera, distance: f32, moveInWorldPlane: bool)  void;
pub extern "c" fn CameraMoveUp(camera: [*c]rl.Camera, distance: f32)  void;
pub extern "c" fn CameraMoveRight(camera: [*c]rl.Camera, distance: f32, moveInWorldPlane: bool)  void;
pub extern "c" fn CameraMoveToTarget(camera: [*c]rl.Camera, delta: f32)  void;
pub extern "c" fn CameraYaw(camera: [*c]rl.Camera, angle: f32, rotateAroundTarget: bool)  void;
pub extern "c" fn CameraPitch(camera: [*c]rl.Camera, angle: f32, lockView: bool, rotateAroundTarget: bool, rotateUp: bool)  void;
pub extern "c" fn CameraRoll(camera: [*c]rl.Camera, angle: f32)  void;
pub extern "c" fn GetCameraViewMatrix(camera: [*c]rl.Camera)  Matrix;
pub extern "c" fn GetCameraProjectionMatrix(camera: [*c]rl.Camera, aspect: f32)  Matrix;
