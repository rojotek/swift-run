#!/usr/bin/swift
import Foundation
struct Command {
    var file: String
    var cmd: String
    var args: [String]
}

let commands = [
    Command(file: "Procfile.rob", cmd: "foreman", args:["foreman", "start", "-f", "Procfile.\(NSUserName())"]),
    Command(file: "Procfile", cmd: "foreman", args:["foreman", "start"]),
    Command(file: "bin/rails", cmd: "bin/rails", args:["rails", "s"]),
    Command(file: "ember-cli-build.js", cmd: "ember", args:["ember", "serve"]),
    Command(file: ".", cmd: "/bin/ls", args: ["ls", "-l"]) // . will always exist in a files system so this gives a safe terminator.
]

func lookupCommand() -> Command {
    let fileManager = FileManager()
    let command = commands.first(where: { fileManager.fileExists(atPath: $0.file) })
    return command!
}

func exec(cmd: Command) {
    print("Running: \(cmd.args.joined(separator: " ")) ")
    // Array of UnsafeMutablePointer<Int8>
    let cargs = cmd.args.map { strdup($0) } + [nil]
    execvp(cmd.cmd, cargs)
}

let command = lookupCommand()
exec(cmd: command)
print("failed to exec command")
