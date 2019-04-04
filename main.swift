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

let red = Color.standard(.red)
let yellow = Color.standard(.yellow)
let redOnYellow = colors.newPair(foreground:red, background:yellow)

var currentMap = maps.tutorial1
var backup = maps.tutorial1
var backupCoordinates = Point(x:0,y:0)
var mapNumber = 1
var mapPosition = Point(x:2,y:2)
var cursorPosition = Point(x:4,y:4)

class Maze {
/*
    enum Cell {
        case Space, Wall
    }
*/
    var data: [[Int]] = []

    // Generate a random maze.
    init(width: Int, height: Int) {
        for _ in 0 ..< height {
            data.append([Int](repeating: 0, count: width))
        }
        for i in 0 ..< width {
           data[0][i] = 1
            data[height - 1][i] = 1
        }
        for i in 0 ..< height {
            data[i][0] = 1
            data[i][width - 1] = 1
        }
        data[2][2] = 1
        self.carve(x: 2, y: 2)
        data[1][2] = 1
        data[height - 2][width - 3] = 2
    }

    // Carve starting at x, y.
    func carve(x: Int, y: Int) {
        let upx = [1, -1, 0, 0]
        let upy = [0, 0, 1, -1]
        var dir = Int.random(in:0...3)
        var count = 0
        while count < 4 {
            let x1 = x + upx[dir]
            let y1 = y + upy[dir]
            let x2 = x1 + upx[dir]
            let y2 = y1 + upy[dir]
            if data[y1][x1] == 0 && data[y2][x2] == 0 {
                data[y1][x1] = 1
                data[y2][x2] = 1
                carve(x: x2, y: y2)
            } else {
                dir = (dir + 1) % 4
                count += 1
            }
        }
    }

    // Show the maze.
    /*
     func show() {
     for row in data {
     for cell in row {
     if cell == 1 {
     print("  ", separator: "", terminator: "")
     } else if cell == 0 {
     print("██", separator: "", terminator: "")
     }
     }
     print("")
     }
     }
     */

}//class maze
//generates random maze

let maze1 = Maze(width: 45, height: 25)



/*for rows in maps.loopTest {
    for cell in rows {
        for i in stride(from:0,to:10,by:1) {
            if Int.random(in:0...1) == 0 {            
                maps.loopTest.append([0])
            } else {
                maps.loopTest.append([1])
            }
        }
    }
    }*/

cursor.position = Point(x:5,y:5) //initialize position
func mapBuild(plan: [[Int]]) {
    cursorPosition = cursor.position
    mainWindow.clear()
    let locationX = 3
    var locationY = 3
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

func colorSwitch(old:ColorPair, new:ColorPair) {
    mainWindow.turnOff(old)
    mainWindow.turnOn(new)
    mapBuild(plan:currentMap)
    mainWindow.refresh()
}

func mapSelect(number: Int)-> [[Int]] {
    switch (number) {
    case 1: mapPosition = Point(x:2,y:2)
            cursor.position = Point(x:5,y:5)
            return maps.tutorial1
    case 2: mapPosition = Point(x:2,y:1)
            cursor.position = Point(x:5,y:4)
            return maze1.data
    case 3: mapPosition = Point(x:5,y:1)
            cursor.position = Point(x:8,y:4)
            return maps.lava1
    default:
        mapPosition = Point(x:2,y:2)
        cursor.position = Point(x:5,y:5)
        return maps.tutorial1
    }
}

mapBuild(plan:mapSelect(number:mapNumber))

var standard = true
var wallbreaker = false
var lavafloor = false

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
                     if key.character == "2" && currentMap[mapPosition.y][mapPosition.x] != 0 {
                         wallbreaker = true
                         standard = false
                     }
                     if key.character == "3" && currentMap[mapPosition.y][mapPosition.x] != 0 {
                         lavafloor = true
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
                     if key.character == "1" && currentMap[mapPosition.y][mapPosition.x] != 0 {
                         standard = true
                         wallbreaker = false
                     }
                     if key.character == "3" && currentMap[mapPosition.y][mapPosition.x] != 0 {
                         lavafloor = true
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
    while lavafloor {
        colorSwitch(old:cyanOnBlue,new:redOnYellow)
        mapBuild(plan:currentMap)
        maps.backup = currentMap
        backupCoordinates = cursor.position
        let key = keyboard.getKey(window:mainWindow)
        switch (key.keyType) {
        case .arrowUp:
            if currentMap[mapPosition.y-1][mapPosition.x] == 1 {
                currentMap[mapPosition.y][mapPosition.x] = 0
                cursor.position = Point(x:cursor.position.x, y:cursor.position.y-1)
                mapPosition = Point(x:mapPosition.x, y:mapPosition.y-1)
                mainWindow.refresh()
            }
            else if currentMap[mapPosition.y-1][mapPosition.x] == 0 {
                mapBuild(plan:maps.backup)//should be correct (but it isnt)
                cursor.position = backupCoordinates
            }
        case .arrowDown:
            if currentMap[mapPosition.y+1][mapPosition.x] == 1 {
                currentMap[mapPosition.y][mapPosition.x] = 0
                cursor.position = Point(x:cursor.position.x, y:cursor.position.y+1)
                mapPosition = Point(x:mapPosition.x, y:mapPosition.y+1)
                mainWindow.refresh()
            }
            else if currentMap[mapPosition.y+1][mapPosition.x] == 0 {
                mapBuild(plan:backup)
                cursor.position = backupCoordinates
            }
        case .arrowLeft:
            if currentMap[mapPosition.y][mapPosition.x-1] == 1 {
                currentMap[mapPosition.y][mapPosition.x] = 0
                cursor.position = Point(x:cursor.position.x-1, y:cursor.position.y)
                mapPosition = Point(x:mapPosition.x-1, y:mapPosition.y)
                mainWindow.refresh()
            }
            else if currentMap[mapPosition.y-1][mapPosition.x] == 0 {
                mapBuild(plan:backup)
                cursor.position = backupCoordinates
            }
        case .arrowRight:
            if currentMap[mapPosition.y][mapPosition.x+1] == 1 {
                currentMap[mapPosition.y][mapPosition.x] = 0
                cursor.position = Point(x:cursor.position.x+1, y:cursor.position.y)
                mapPosition = Point(x:mapPosition.x+1, y:mapPosition.y)
                mainWindow.refresh()
            }
            else if currentMap[mapPosition.y-1][mapPosition.x] == 0 {
                mapBuild(plan:backup)
                cursor.position = backupCoordinates
            }
        default: do {
                     if key.character == "1" && currentMap[mapPosition.y][mapPosition.x] != 0 {
                         colorSwitch(old:redOnYellow,new:cyanOnBlue)
                         standard = true
                         lavafloor = false
                     }
                     if key.character == "2" && currentMap[mapPosition.y][mapPosition.x] != 0 {
                         colorSwitch(old:redOnYellow,new:cyanOnBlue)
                         wallbreaker = true
                         lavafloor = false
                     }
                 }
        }//switchcase
    }//while lavafloor
}//big true

