#!/usr/bin/swift
import Foundation
struct Command {
    var cmd: String
    var args: [String]
}
func lookupCommand() -> Command {
    let fileManager = FileManager()
    if fileManager.fileExists(atPath: "Procfile.rob") {
        print("loading foreman with Procfile.rob")
        return Command(cmd: "foreman", args:["foreman", "start", "-f", "Procfile.rob"])
    } else if fileManager.fileExists(atPath: "Procfile") {
        print("loading foreman with standard Procfile")
        return Command(cmd: "foreman", args:["foreman", "start"])
    } else if fileManager.fileExists(atPath: "bin/rails") {
        print("rails s it up")
        return Command(cmd: "bin/rails", args:["rails", "s"])
    } else if fileManager.fileExists(atPath: "ember-cli-build.js") {
        print("ember ftw")
        return Command(cmd: "ember", args:["ember", "serve"])
    } else {
        print("Default ls files in folder")
        return Command(cmd: "/bin/ls", args: ["ls", "-l"])
    }
}
func exec(cmd: String, args: [String]) {
    // Array of UnsafeMutablePointer<Int8>
    let cargs = args.map { strdup($0) } + [nil]
    execvp(cmd, cargs)
}
// let args = ["ls", "-l", "/Library"]
// exec(cmd: "/bin/ls", args: args)
let command = lookupCommand()
exec(cmd: command.cmd, args: command.args)
print("failed to exec command")
