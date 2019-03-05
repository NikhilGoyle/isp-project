import Foundation
import Curses

let screen = Screen.shared
let keyboard = Keyboard.shared

class Handler : CursesHandlerProtocol {
    func interruptHandler() {
        screen.shutDown()
        print("GAME OVER")
        exit(0)
    }

    func windowChangedHandler() {
    }
}

let handler = Handler()

screen.startUp(handler:handler)
let colors = Colors.shared
precondition(colors.areSupported, "This terminal doesn't support colors")
colors.startUp()

let mainWindow = screen.window
let cursor = mainWindow.cursor

let blue = Color.standard(.blue)
let cyan = Color.standard(.cyan)
let cyanOnBlue = colors.newPair(foreground:cyan, background:blue)
mainWindow.turnOn(cyanOnBlue)

func colorSwitch(old:ColorPair, new:ColorPair) {
    mainWindow.turnOff(old)
    mainWindow.turnOn(new)
    }

var currentMap = maps.tutorial1
var mapNumber = 1
var mapPosition = Point(x:2,y:2)
var cursorPosition = Point(x:4,y:4)

func mapBuild(plan: [[Int]]) {
    mainWindow.clear()
    let locationX = 2
    var locationY = 2
    cursor.position = Point(x:locationX, y:locationY)
    for rows in plan {
        for cell in rows {
            if cell == 0 {
                mainWindow.write("█")
            } else if cell == 1 {
                mainWindow.write(" ")
            } else if cell == 2 {
                mainWindow.write("༜")
            }
        }
        locationY += 1
        cursor.position = Point(x:locationX, y:locationY)
    }
    cursor.position = cursorPosition
    mainWindow.refresh()
}

func mapSelect(number: Int)-> [[Int]] {
    switch (number) {
    case 1: mapPosition = Point(x:2,y:2)
            cursorPosition = Point(x:4,y:4)
            return maps.tutorial1
    case 2: mapPosition = Point(x:2,y:2)
            cursorPosition = Point(x:4,y:4)
            return maps.tutorial2
    default:
        mapPosition = Point(x:2,y:2)
        cursor.position = Point(x:4,y:4)
        return maps.tutorial1
    }
}

mapBuild(plan:mapSelect(number:mapNumber))

var standard = true
var wallbreaker = false

while true {
    while standard {
        cursor.pushPosition(newPosition:Point(x:0,y:0))
        mainWindow.write("                                                                         ")
        cursor.popPosition()
        mainWindow.refresh()
        let key = keyboard.getKey(window:mainWindow)
        switch (key.keyType) {
        case .arrowUp:
            if currentMap[mapPosition.y-1][mapPosition.x] == 2 {
                mapNumber += 1
                mapBuild(plan:mapSelect(number:mapNumber))
                currentMap = mapSelect(number:mapNumber)
                break
            }
            if currentMap[mapPosition.y-1][mapPosition.x] != 0 {
                cursor.position = Point(x:cursor.position.x, y:cursor.position.y-1)
                mapPosition = Point(x:mapPosition.x, y:mapPosition.y-1)
                mainWindow.refresh()
            }
        case .arrowDown:
            if currentMap[mapPosition.y+1][mapPosition.x] == 2 {
                mapNumber += 1
                mapBuild(plan:mapSelect(number:mapNumber))
                currentMap = mapSelect(number:mapNumber)
                break
            }
            if currentMap[mapPosition.y+1][mapPosition.x] != 0 {
                cursor.position = Point(x:cursor.position.x, y:cursor.position.y+1)
                mapPosition = Point(x:mapPosition.x, y:mapPosition.y+1)
                mainWindow.refresh()
            }
        case .arrowLeft:
            if currentMap[mapPosition.y][mapPosition.x-1] == 2 {
                mapNumber += 1
                mapBuild(plan:mapSelect(number:mapNumber))
                currentMap = mapSelect(number:mapNumber)
                break
            }
            if currentMap[mapPosition.y][mapPosition.x-1] != 0 {
                cursor.position = Point(x:cursor.position.x-1, y:cursor.position.y)
                mapPosition = Point(x:mapPosition.x-1, y:mapPosition.y)
                mainWindow.refresh()
            }
        case .arrowRight:
            if currentMap[mapPosition.y][mapPosition.x+1] == 2 {
                mapNumber += 1
                mapBuild(plan:mapSelect(number:mapNumber))
                currentMap = mapSelect(number:mapNumber)
                break
            } 
            if currentMap[mapPosition.y][mapPosition.x+1] != 0 {
                cursor.position = Point(x:cursor.position.x+1, y:cursor.position.y)
                mapPosition = Point(x:mapPosition.x+1, y:mapPosition.y)
                mainWindow.refresh()
            }
        default: do {
                     if key.character == "e" && currentMap[mapPosition.y][mapPosition.x] != 0 {
                         wallbreaker = true
                         standard = false
                     }
                 }//do
        }//switchcase
    }//standard
    
    while wallbreaker {
        cursor.pushPosition(newPosition:Point(x:0,y:0))
        mainWindow.write("Use the keys (w), (a), (s), and (d) to remove or create walls around you.")//add this to a variable so i can have an instructions bar
        cursor.popPosition()
        mainWindow.refresh()
        let key = keyboard.getKey(window:mainWindow)
        switch (key.keyType) {
        case .arrowUp:
            if currentMap[mapPosition.y-1][mapPosition.x] != 0 {
                cursor.position = Point(x:cursor.position.x, y:cursor.position.y-1)
                mapPosition = Point(x:mapPosition.x, y:mapPosition.y-1)
                mainWindow.refresh()
            }
        case .arrowDown:
            if currentMap[mapPosition.y+1][mapPosition.x] != 0 {
                cursor.position = Point(x:cursor.position.x, y:cursor.position.y+1)
                mapPosition = Point(x:mapPosition.x, y:mapPosition.y+1)
                mainWindow.refresh()
            }
        case .arrowLeft:
            if currentMap[mapPosition.y][mapPosition.x-1] != 0 {
                cursor.position = Point(x:cursor.position.x-1, y:cursor.position.y)
                mapPosition = Point(x:mapPosition.x-1, y:mapPosition.y)
                mainWindow.refresh()
            }
        case .arrowRight:
            if currentMap[mapPosition.y][mapPosition.x+1] != 0 {
                cursor.position = Point(x:cursor.position.x+1, y:cursor.position.y)
                mapPosition = Point(x:mapPosition.x+1, y:mapPosition.y)
                mainWindow.refresh()
            }
        default: do {
                     if key.character == "e" && currentMap[mapPosition.y][mapPosition.x] != 0 {
                         standard = true
                         wallbreaker = false
                     }
                     if key.character == "w" {
                         cursor.pushPosition(newPosition:Point(x:cursor.position.x,y:cursor.position.y-1))
                         if currentMap[mapPosition.y-1][mapPosition.x] == 1 {
                             mainWindow.write("█")
                             currentMap[mapPosition.y-1][mapPosition.x] = 0
                         }
                         else if currentMap[mapPosition.y-1][mapPosition.x] == 0 {
                             mainWindow.write(" ")
                             currentMap[mapPosition.y-1][mapPosition.x] = 1
                         }
                         cursor.popPosition()
                     }//w
                     if key.character == "a" {
                         cursor.pushPosition(newPosition:Point(x:cursor.position.x-1,y:cursor.position.y))
                         if currentMap[mapPosition.y][mapPosition.x-1] == 1 {
                             mainWindow.write("█")
                             currentMap[mapPosition.y][mapPosition.x-1] = 0
                         }
                         else if currentMap[mapPosition.y][mapPosition.x-1] == 0 {
                             mainWindow.write(" ")
                             currentMap[mapPosition.y][mapPosition.x-1] = 1
                         }
                         cursor.popPosition()
                     }//a
                     if key.character == "s" {
                         cursor.pushPosition(newPosition:Point(x:cursor.position.x,y:cursor.position.y+1))
                         if currentMap[mapPosition.y+1][mapPosition.x] == 1 {
                             mainWindow.write("█")
                             currentMap[mapPosition.y+1][mapPosition.x] = 0
                         }
                         else if currentMap[mapPosition.y+1][mapPosition.x] == 0 {
                             mainWindow.write(" ")
                             currentMap[mapPosition.y+1][mapPosition.x] = 1
                         }
                         cursor.popPosition()
                     }//s
                     if key.character == "d" {
                         cursor.pushPosition(newPosition:Point(x:cursor.position.x+1,y:cursor.position.y))
                         if currentMap[mapPosition.y][mapPosition.x+1] == 1 {
                             mainWindow.write("█")
                             currentMap[mapPosition.y][mapPosition.x+1] = 0
                         }
                         else if currentMap[mapPosition.y][mapPosition.x+1] == 0 {
                             mainWindow.write(" ")
                             currentMap[mapPosition.y][mapPosition.x+1] = 1
                         }
                         cursor.popPosition()
                     }//d
                 }//default
        }//switchcase
    }//wallbreaker
}//big true

