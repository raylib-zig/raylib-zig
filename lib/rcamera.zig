const rl = @import("raylib.zig");
const std = @import("std");

pub const cdef = @import("rcamera-ext.zig");
const Camera = rl.Camera;
const Vector3 = rl.Vector3;
const Matrix = rl.Matrix;

pub fn getCameraForward(camera: *Camera)  Vector3 {
    return cdef.GetCameraForward(@as([*c]Camera, @ptrCast(camera)));
}

pub fn getCameraUp(camera: *Camera)  Vector3 {
    return cdef.GetCameraUp(@as([*c]Camera, @ptrCast(camera)));
}

pub fn getCameraRight(camera: *Camera)  Vector3 {
    return cdef.GetCameraRight(@as([*c]Camera, @ptrCast(camera)));
}

pub fn cameraMoveForward(camera: *Camera, distance: f32, moveInWorldPlane: bool)  void {
    return cdef.CameraMoveForward(@as([*c]Camera, @ptrCast(camera)), distance, moveInWorldPlane);
}

pub fn cameraMoveUp(camera: *Camera, distance: f32)  void {
    return cdef.CameraMoveUp(@as([*c]Camera, @ptrCast(camera)), distance);
}

pub fn cameraMoveRight(camera: *Camera, distance: f32, moveInWorldPlane: bool)  void {
    return cdef.CameraMoveRight(@as([*c]Camera, @ptrCast(camera)), distance, moveInWorldPlane);
}

pub fn cameraMoveToTarget(camera: *Camera, delta: f32)  void {
    return cdef.CameraMoveToTarget(@as([*c]Camera, @ptrCast(camera)), delta);
}

pub fn cameraYaw(camera: *Camera, angle: f32, rotateAroundTarget: bool)  void {
    return cdef.CameraYaw(@as([*c]Camera, @ptrCast(camera)), angle, rotateAroundTarget);
}

pub fn cameraPitch(camera: *Camera, angle: f32, lockView: bool, rotateAroundTarget: bool, rotateUp: bool)  void {
    return cdef.CameraPitch(@as([*c]Camera, @ptrCast(camera)), angle, lockView, rotateAroundTarget, rotateUp);
}

pub fn cameraRoll(camera: *Camera, angle: f32)  void {
    return cdef.CameraRoll(@as([*c]Camera, @ptrCast(camera)), angle);
}

pub fn getCameraViewMatrix(camera: *Camera)  Matrix {
    return cdef.GetCameraViewMatrix(@as([*c]Camera, @ptrCast(camera)));
}

pub fn getCameraProjectionMatrix(camera: *Camera, aspect: f32)  Matrix {
    return cdef.GetCameraProjectionMatrix(@as([*c]Camera, @ptrCast(camera)), aspect);
}
