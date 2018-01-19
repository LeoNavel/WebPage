import Squirrel
import NutView
import Foundation
import SquirrelConfig
import Cache

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

struct NotFoundHandler: ErrorHandlerProtocol {
    func getResponse(for error: Error) -> Response? {
        guard let error = error as? HTTPError, case .notFound = error.status else {
            return nil
        }
        return try? Response(presentable: View(name: "404")) 
    }
}

ErrorHandler.sharedInstance.addErrorHandler(handler: NotFoundHandler())

NutConfig.NutViewCache.setNutViewCache(config: Config(cacheDirectory: squirrelConfig.cache.string))


let server = Server(port: port)

server.route(get: "/") { () -> Any in
    return View(name: "Index")
}

try server.run()
