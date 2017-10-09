import Squirrel
import Foundation

func error(_ message: String, status: Int32 = 1) -> Never {
    print("Usage:\n\tWebPage <port>")
    print(message)
    exit(status)
}

guard CommandLine.argc == 2 else {
    error("Expect only one argument.")
}

let args = CommandLine.arguments

guard let port = UInt16(args.last!) else {
    error("Could not convert given argument to number")
}

let server = Server(port: port)

server.route(get: "/") { () -> Any in
    return "Hello World!"
}

try server.run()
