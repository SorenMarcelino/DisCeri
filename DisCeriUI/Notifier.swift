//
//  Notifier.swift
//  DisCeri
//
//  Created by Soren Marcelino on 29/04/2023.
//

import Foundation
import Ice
import IceStorm

func usage() {
    print("Usage: [--batch] [--datagram|--twoway|--ordered|--oneway] [--retryCount count] [--id id] [topic]")
}

class ClockI: Request {
    func newFile(time: String, current: Ice.Current) {
        print("New File !")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 6) {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: showAlertNotificationKey), object: nil)
        }
    }

    func renameFile(id: String, oldName: String, fileName: String, current: Ice.Current) {
        print("Renamed File !")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 6) {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: showAlertNotificationKey), object: nil)
        }
    }
}

enum Option: String {
    case none = ""
    case datagram = "--datagram"
    case twoway = "--twoway"
    case ordered = "--ordered"
    case oneway = "--oneway"
}

func run() -> Int32 {
    do {
        var args = [String](CommandLine.arguments.dropFirst())
        signal(SIGTERM, SIG_IGN)
        signal(SIGINT, SIG_IGN)
        args.append("--Ice.Default.Host=192.168.1.154")
        args.append("--TopicManager.Proxy=DemoIceStorm/TopicManager:default -h 192.168.1.154 -p 10002")
        args.append("--Clock.Subscriber.Endpoints=tcp:udp")

        var properties: InitializationData
        properties = InitializationData()
        let property = createProperties()
        property.setProperty(key: "TopicManager.Proxy", value: "DemoIceStorm/TopicManager:default -h 192.168.1.154 -p 10002")
        property.setProperty(key: "Ice.Default.Host", value: "192.168.1.154")
        property.setProperty(key: "Clock.Subscriber.Endpoints", value: "tcp:udp")
        properties.properties = property
        
        let communicator = try Ice.initialize(args: args, configFile: properties)
        defer {
            communicator.destroy()
        }
        print("Salut 2")
        
        let sigintSource = DispatchSource.makeSignalSource(signal: SIGINT,
                                                           queue: DispatchQueue.global())
        let sigtermSource = DispatchSource.makeSignalSource(signal: SIGTERM,
                                                            queue: DispatchQueue.global())
        sigintSource.setEventHandler { communicator.shutdown() }
        sigtermSource.setEventHandler { communicator.shutdown() }
        sigintSource.resume()
        sigtermSource.resume()

        args = try communicator.getProperties().parseCommandLineOptions(prefix: "Clock", options: args)
        print("Salut 3")

        var topicName = "time"
        var option: Option = .none
        var batch = false
        var id: String?
        var retryCount: String?

//        for var i in 0 ..< args.count {
//            print("Salut 3.5")
//            let oldoption = option
//            if let o = Option(rawValue: args[i]) {
//                option = o
//            } else if args[i] == "--batch" {
//                batch = true
//            } else if args[i] == "--id" {
//                i += 1
//                if i >= args.count {
//                    usage()
//                    return 1
//                }
//                id = args[i]
//            } else if args[i] == "--retryCount" {
//                i += 1
//                if i >= args.count {
//                    usage()
//                    return 1
//                }
//                retryCount = args[i]
//            } else if args[i].starts(with: "--") {
//                usage()
//                return 1
//            } else {
//                topicName = args[i]
//                i += 1
//                break
//            }
//
//            if oldoption != option, oldoption != .none {
//                usage()
//                return 1
//            }
//        }

        if retryCount != nil {
            if option == .none {
                option = .twoway
            } else if option != .twoway, option != .ordered {
                usage()
                return 1
            }
        }
        print("Salut 4")

        print(communicator.getProperties())
        //guard let base = try communicator.stringToProxy("DemoIceStorm/TopicManager:default -h 192.168.1.154 -p 10002") else {
        guard let base = try communicator.propertyToProxy("TopicManager.Proxy") else {
            print("Salut 4.5")
            return 1
        }
        guard let manager = try checkedCast(prx: base, type: IceStorm.TopicManagerPrx.self) else {
            print("invalid proxy")
            return 1
        }
        print("Salut 5")

        //
        // Retrieve the topic.
        //
        let topic: IceStorm.TopicPrx!
        do {
            topic = try manager.retrieve(topicName)
        } catch is IceStorm.NoSuchTopic {
            do {
                topic = try manager.create(topicName)
            } catch is IceStorm.TopicExists {
                print("temporary error. try again.")
                return 1
            }
        }
        
        print("Salut 6")

        let adapter = try communicator.createObjectAdapterWithEndpoints(name: "Clock.Subscriber", endpoints: "tcp -h 192.168.1.147 -p 10002")
        print("Salut 7")

        //
        // Add a servant for the Ice object. If --id is used the
        // identity comes from the command line, otherwise a UUID is
        // used.
        //
        // id is not directly altered since it is used below to
        // detect whether subscribeAndGetPublisher can raise
        // AlreadySubscribed.
        //
        let subId = Ice.Identity(name: id ?? UUID().uuidString, category: "")

        var subscriber = try adapter.add(servant: RequestDisp(ClockI()), id: subId)
        print("Salut 8")

        //
        // Activate the object adapter before subscribing.
        //
        try adapter.activate()
        print("Salut 9")

        var qos: [String: String] = [:]

        if let retryCount = retryCount {
            qos["retryCount"] = retryCount
        }

        //
        // Set up the proxy.
        //
//        switch option {
//        case .datagram:
//            subscriber = batch ? subscriber.ice_batchDatagram() : subscriber.ice_datagram()
//        case .ordered:
//            // Do nothing to the subscriber proxy. Its already twoway.
//            qos["reliability"] = "ordered"
//        case .oneway,
//             .none:
//            subscriber = batch ? subscriber.ice_batchOneway() : subscriber.ice_oneway()
//        case .twoway:
//            // Do nothing to the subscriber proxy. Its already twoway.
//            break
//        }
        
        subscriber = batch ? subscriber.ice_batchOneway() : subscriber.ice_oneway()

        do {
            _ = try topic.subscribeAndGetPublisher(theQoS: qos, subscriber: subscriber)
        } catch is IceStorm.AlreadySubscribed {
            // Must never happen when subscribing with an UUID
            precondition(id != nil)
            print("reactivating persistent subscriber")
        }
        print("Salut 10")
        communicator.waitForShutdown()
        try topic.unsubscribe(subscriber)

        return 0
    } catch {
        print("Error: \(error)\n")
        return 1
    }
}

/*class Notifier {
    init(){
        do {
            var initData = Ice.InitializationData()
            initData.properties = try Ice.createProperties()
            initData.properties?.setProperty(key: "Ice.Warn.Connections", value: "0")
            let communicator = try Ice.initialize(initData)
            defer {
                communicator.destroy()
            }

            try run(communicator: communicator)
        } catch {
            print("Error: (error)")
        }
    }
   
func run(communicator: Communicator) {
    // Remplacez cette ligne par l'adresse de votre serveur IceStorm
    let topicManagerProxy = "IceStorm/TopicManager:default -h 192.168.1.154 -p 9996"

    guard let manager = try? checkedCast(prx: communicator.propertyToProxy("TopicManager.Proxy"), type: TopicManagerPrx.self) else {
        print("Invalid proxy")
        return
    }

    let topicName = "time"

        let topic: TopicPrx
        do {
            topic = try manager.retrieve(topicName)!
        } catch {
            do {
                topic = try manager.create(topicName)!
            } catch {
                print("Error: temporary error. try again")
                return
            }
        }

        let adapter = try! communicator.createObjectAdapter("Clock.Subscriber")
        let subscriber = ClockI()
        let identity = UUID()
        let subscriberPrx = try! uncheckedCast(prx: adapter.add(servant: subscriber as! Disp, id: Ice.stringToIdentity(identity.uuidString)), type: RequestPrx.self)

        do {
            try adapter.activate()
        } catch {
            return
        }

        /*do {
            try topic.subscribeAndGetPublisher(qos: [:], subscriber: RequestPrx.self)
        } catch is AlreadySubscribed {
            print("Error: reactivating persistent subscriber")
        }*/

        communicator.waitForShutdown()

        do {
            try topic.unsubscribe(subscriberPrx)
        } catch {
            return
        }
    }

    
}*/
