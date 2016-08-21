import Foundation

func processFile () {

    print("Trying to open the file: \(filelocation) ... ", terminator:"")

    let fileContent = try? NSString(contentsOfFile: filelocation, encoding: String.Encoding.utf8.rawValue)

    if fileContent == nil {
        print("\(Colors.Red("Something went wrong while trying to open that file!"))")
        exit(1)
    } else {

        print("\(Colors.Green("File opened successfuly!"))")

        printfulldebug("\n\(ANSI.Cyan)######BEGINNING OF FILE CONTENT######\(ANSI.Reset)")
        printfulldebug(fileContent!)
        printfulldebug("\(ANSI.Cyan)######END OF FILE CONTENT######\(ANSI.Reset)\n")

        let delimiter = "."
        let linesList = fileContent!.components(separatedBy: delimiter)

        // Each line of the linesList has a source and destination airport and flight info
        for line in linesList {

            printfulldebug("\(ANSI.Cyan)~~~~~~~~~~~~~~~~BEGINNING OF LINE~~~~~~~~~~~~~~~~\(ANSI.Reset)")

            printfulldebug("\(ANSI.Yellow)$$$$$$--FULL LINE--$$$$$$$\(ANSI.Reset)")
            printfulldebug(line)
            printfulldebug("\(ANSI.Yellow)$$$$$$--END OF IT--$$$$$$$\(ANSI.Reset)")


            // CLEAN THE STRING
            let newline1 = line.replacingOccurrences(of: "timetable(", with: "")
            let newline2 = newline1.replacingOccurrences(of: "\n", with: "")
            let newline3 = newline2.replacingOccurrences(of: "\t", with: "")
            let newline4 = newline3.replacingOccurrences(of: " ", with: "")


            if let comma_range = newline4.range(of: ","),
                let left_bracket = newline4.range(of: "[") {

                let flightSource = newline4[newline4.startIndex..<comma_range.lowerBound]
                let secondPart = newline4[comma_range.lowerBound..<left_bracket.lowerBound]
                let thirdPart = newline4[left_bracket.lowerBound..<newline4.endIndex]

                printfulldebug("Source: |\(flightSource)|")

                let airport_tmp = Airport(city: flightSource)

                if !airportList.contains(airport_tmp) {
                    airportList.insert(airport_tmp)
                }


                let flightDestination = secondPart[secondPart.characters.index(secondPart.startIndex, offsetBy: 1)..<secondPart.characters.index(secondPart.endIndex, offsetBy: -1)]

                printfulldebug("Destination: |\(flightDestination)|")

                let thirdPartv2 = thirdPart[thirdPart.characters.index(thirdPart.startIndex, offsetBy: 1)..<thirdPart.characters.index(thirdPart.endIndex, offsetBy: -2)]


                let thirdPartv3 = thirdPartv2.replacingOccurrences(of: "],",with: "];")
                let thirdPartFinal = thirdPartv3.replacingOccurrences(of: "alldays,",with: "alldays;")

                printfulldebug("Third: |\(thirdPartFinal)|")

                let delimiter = ";"
                let listOfInfos = thirdPartFinal.components(separatedBy: delimiter)

                for wholeInfo in listOfInfos {

                    printfulldebug("\(ANSI.Magenta)--------:START:-------\(ANSI.Reset)")

                    let delimiter = "/"
                    let infos = wholeInfo.components(separatedBy: delimiter)

                    let tmp_timeLeaving = infos[0]
                    let tmp_timeArrival = infos[1]
                    let tmp_code = infos[2]
                    let _tmp_days = infos[3]

                    var tmp_days = [String:Bool]()

                    tmp_days["mo"] = false
                    tmp_days["tu"] = false
                    tmp_days["we"] = false
                    tmp_days["th"] = false
                    tmp_days["fr"] = false
                    tmp_days["sa"] = false
                    tmp_days["su"] = false

                    if _tmp_days == "alldays" {
                        tmp_days["mo"] = true
                        tmp_days["tu"] = true
                        tmp_days["we"] = true
                        tmp_days["th"] = true
                        tmp_days["fr"] = true
                        tmp_days["sa"] = true
                        tmp_days["su"] = true
                    } else {

                        let more_tmp_days = _tmp_days.replacingOccurrences(of: "[", with: "")
                        let more_more_tmp_days = more_tmp_days.replacingOccurrences(of: "]", with: "")


                        let delimiter = ","
                        let days_info = more_more_tmp_days.components(separatedBy: delimiter)


                        for lol in days_info {
                            tmp_days[lol]=true
                        }

                    }

                    let flight = FlightInfo(code: tmp_code, destination: flightDestination, timeLeaving: tmp_timeLeaving, timeArrival: tmp_timeArrival, days: tmp_days)

                    let tmp_airport_hack = Airport(city: flightSource)
                    let indexAirport = airportList.index(of: tmp_airport_hack)
                    airportList[indexAirport!].flights.append(flight)

                    for info in infos {
                        printfulldebug("\(info)")

                    }

                    printfulldebug("\(ANSI.Magenta)--------:OVER:--------\(ANSI.Reset)")


                }

            }

            printfulldebug("\(ANSI.Cyan)~~~~~~~~~~~~~~~~END OF LINE~~~~~~~~~~~~~~~~~~~~~~\(ANSI.Reset)")
        }

        printdebug("")
        printdebug(Colors.Green("/----------------------------------------------------------------------\\"))
        printdebug(Colors.Green("|-------EVERYTHING HAS BEEN PROCESSED!! HERE IS THE FINAL RESULT-------|"))
        printdebug(Colors.Green("\\----------------------------------------------------------------------/"))

        printdebug("The Database has \(airportList.count) Airports, and here they are: ")
        printdebug("")

        for (index, airpoirt) in airportList.enumerated() {
            printdebug("Airport number \(index+1): \(airpoirt.city) has \(airpoirt.flights.count) flights ")
            printdebug("----------------------------------------------------------------")
            printdebug(airpoirt.flights)
            printdebug("----------------------------------------------------------------")
            printdebug("")
        }


    }

}
