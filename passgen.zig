const std = @import("std");

pub fn main() !void {
    const characters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#$%^&*()-_=+\"'";
    const pass_length: usize = 12;
    var password: [pass_length]u8 = undefined;

    for (0..pass_length) |item| {
        const rand = std.crypto.random;
        password[item] = characters[rand.intRangeAtMost(u8, 0, characters.len)];
    }

    std.debug.print("Generated password: {s}\n", .{password});
}
