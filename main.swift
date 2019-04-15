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

struct Items {
    var wallbreaker = false
    var lavafloor = false
    var backpack = false
    var resurrect = false
    var con = false
    var flag = false
    var ration = false
    var conflagration = false
}

class Player {
    static var name = "Player"
    static var health = 10
    static var attackMelee = 3
    static var potions = 0
    static var items = Items()
}

class Enemy {
    var name = "Enemy"
    var health = 5
    var attackMelee = 1
    var drops = Items()
}

class Maze {
    var data: [[Int]] = []

    // Generate a block with a start and end
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
        self.room(xSize:width,ySize:height)
        self.enemies(xSize:width,ySize:height)
        self.drops(xSize:width,ySize:height)
        data[1][2] = 1
        data[height - 2][width - 3] = 2

        //test
        for i in 0 ..< width {
            data[0][i] = 0
            data[height-1][i] = 0
        }
        for i in 0 ..< height {
            data[i][0] = 0
            data[i][width-1] = 0
        }
    }

    func room(xSize:Int,ySize:Int) {
        let square1xstart = Int.random(in:2...xSize/4)
        let square1xend = Int.random(in:xSize*3/8...xSize-xSize/4)
        let square1ystart = Int.random(in:2...ySize/4)
        let square1yend = Int.random(in:ySize*3/8...ySize-ySize/4)
        let square2xstart = Int.random(in:xSize/4...xSize-xSize*3/8)
        let square2xend = Int.random(in:xSize-xSize/4...xSize-2)
        let square2ystart = Int.random(in:ySize/4...ySize-ySize*3/8)
        let square2yend = Int.random(in:ySize-ySize/4...ySize-2)

        for row in square1ystart...square1yend {
            for cell in square1xstart...square1xend {
                data[row][cell] = 1
            }
        }
        for row in square2ystart...square2yend {
            for cell in square2xstart...square2xend {
                data[row][cell] = 1
            }
        }
    }//func room

    func enemies(xSize: Int, ySize: Int) {
        var averageEnemies = xSize*ySize/500
        var random1 : Int
        var random2 : Int
        repeat {
            random1 = Int.random(in:0..<ySize)
            random2 = Int.random(in:0..<xSize)
            if data[random1][random2] == 1 {
                data[random1][random2] = 3
                averageEnemies -= 1
            }
        } while averageEnemies > 0 
    }//func enemies

    func drops(xSize: Int, ySize: Int) {
        if Int.random(in:1...2) == 1 {
            var random1 : Int
            var random2 : Int
            var dropPlaced = false
            
            repeat {
                if Int.random(in:1...2) == 1 {
                    random1 = Int.random(in:1...4)
                } else {
                    random1 = Int.random(in:ySize-4...ySize-1)
                }
                
                if Int.random(in:1...2) == 1{
                    random2 = Int.random(in:1...4)
                } else {
                    random2 = Int.random(in:xSize-4...xSize-1)
                }
                
                if data[random1][random2] == 1 {
                    data[random1][random2] = 4
                    dropPlaced = true
                }
            } while dropPlaced == false
            
        }//50% chance
    } //drops function
    
    // Carve out maze inside
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
}//class maze
//generates random maze

let maze1 = Maze(width: 50, height: 30)
let maze2 = Maze(width: 50, height: 30)
let maze3 = Maze(width: 50, height: 30)
let maze4 = Maze(width: 50, height: 30)
let maze5 = Maze(width: 50, height: 30)
let maze6 = Maze(width: 50, height: 30)
let maze7 = Maze(width: 50, height: 30)
let maze8 = Maze(width: 50, height: 30)
let maze9 = Maze(width: 50, height: 30)
let maze10 = Maze(width: 50, height: 30)
let maze11 = Maze(width: 50, height: 30)
let maze12 = Maze(width: 50, height: 30)
let maze13 = Maze(width: 50, height: 30)
let maze14 = Maze(width: 50, height: 30)
let maze15 = Maze(width: 50, height: 30)
let maze16 = Maze(width: 50, height: 30)
let maze17 = Maze(width: 50, height: 30)
let maze18 = Maze(width: 50, height: 30)
let maze19 = Maze(width: 50, height: 30)
let maze20 = Maze(width: 50, height: 30)
let maze21 = Maze(width: 50, height: 30)
let maze22 = Maze(width: 50, height: 30)
let maze23 = Maze(width: 50, height: 30)
let maze24 = Maze(width: 50, height: 30)
let maze25 = Maze(width: 50, height: 30)



print("Please enter your name: ", terminator:"")
let player = Player()
Player.name = readLine()!

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
var lavacount = 0



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
            } else if cell == 3 {
                mainWindow.write("X")
            } else if cell == 4 {
                mainWindow.write("O")
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
cursor.pushPosition(newPosition:Point(x:0,y:0))
mainWindow.write("Welcome, \(Player.name)! Use w,a,s,d to move around. Move to the portal to proceed")//combine all text into strings so there isnt any overlapping
cursor.popPosition()

var standard = true
var wallbreaker = false
var lavafloor = false
var inventory = false

while true {
    while standard {
        cursor.pushPosition(newPosition:Point(x:0,y:0))
        //mainWindow.write("                                                                         ")
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
                         colorSwitch(old:cyanOnBlue,new:redOnYellow)
                         lavafloor = true
                         standard = false
                     }
                     if key.character == "i" {
                         inventory = true
                         standard = false
                     }
                 }//do
        }//switchcase
    }//standard
    while inventory {
        func inventoryLabel(position:Point, label: String) {
            cursor.pushPosition(newPosition:position)
            mainWindow.write(label)
            cursor.popPosition()
        }
        cursor.pushPosition(newPosition:Point(x:0,y:0))
        mainWindow.write("""
                            ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
                            ┃                                                   ┃
                            ┃                                                   ┃
                            ┃                                                   ┃
                            ┃                                                   ┃
                            ┃                                                   ┃
                            ┃                                                   ┃
                            ┃                                                   ┃
                            ┃                                                   ┃
                            ┃                                                   ┃
                            ┃                                                   ┃
                            ┃                                                   ┃
                            ┃                                                   ┃
                            ┃                                                   ┃
                            ┃                                                   ┃
                            ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛
                           """)
        
        inventoryLabel(position:Point(x:3,y:1), label:"\(Player.name)")
        inventoryLabel(position:Point(x:3, y:3), label: "Health: \(Player.health)")
        inventoryLabel(position:Point(x:3,y:5), label:"Potions: \(Player.potions)")
        inventoryLabel(position:Point(x:3,y:7), label: "Level:\(mapNumber)")
        
        let key = keyboard.getKey(window:mainWindow)
        switch (key.keyType) {
        default: do {
                     if key.character == "i" {
                         cursor.popPosition()
                         mapBuild(plan:mapSelect(number:mapNumber))
                         standard = true
                         inventory = false
                     }
                 }
        }//switchcase
    }//while inventory
    
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
        cursor.pushPosition(newPosition:Point(x:0,y:0))
        mainWindow.write("The floor is lava!")
        cursor.popPosition()
        mapBuild(plan:maps.lavaArray[lavacount])
        mainWindow.refresh()
        let key = keyboard.getKey(window:mainWindow)
        switch (key.keyType) {
        case .arrowUp:
            if maps.lavaArray[lavacount][mapPosition.y-1][mapPosition.x] == 1 {
                maps.lavaArray[lavacount][mapPosition.y][mapPosition.x] = 0
                cursor.position = Point(x:cursor.position.x, y:cursor.position.y-1)
                mapPosition = Point(x:mapPosition.x, y:mapPosition.y-1)
                mainWindow.refresh()
            }
            else if maps.lavaArray[lavacount][mapPosition.y-1][mapPosition.x] == 0 {
                maps.lavaArray[lavacount] = maps.lavabackup
                mapBuild(plan:mapSelect(number:mapNumber))
            }
            else if maps.lavaArray[lavacount][mapPosition.y-1][mapPosition.x] == 2 {
                for row in maps.lavaArray[lavacount] {
                    for cell in row {
                        if cell == 0 {
                            maps.lavaArray[lavacount] = maps.lavabackup
                            mapBuild(plan:mapSelect(number:mapNumber))
                            break
                        }
                    }
                }
                lavacount += 1
                maps.lavabackup = maps.lavaArray[lavacount]
                mapNumber += 1
                mapBuild(plan:mapSelect(number:mapNumber))
                currentMap = mapSelect(number:mapNumber)
                break
            }
        case .arrowDown:
            if maps.lavaArray[lavacount][mapPosition.y+1][mapPosition.x] == 1 {
                maps.lavaArray[lavacount][mapPosition.y][mapPosition.x] = 0
                cursor.position = Point(x:cursor.position.x, y:cursor.position.y+1)
                mapPosition = Point(x:mapPosition.x, y:mapPosition.y+1)
                mainWindow.refresh()
            }
            else if maps.lavaArray[lavacount][mapPosition.y+1][mapPosition.x] == 0 {
                maps.lavaArray[lavacount] = maps.lavabackup
                mapBuild(plan:mapSelect(number:mapNumber))
            }
            else if maps.lavaArray[lavacount][mapPosition.y+1][mapPosition.x] == 2 {
                maps.lavaArray[lavacount][mapPosition.y][mapPosition.x] = 0
                for rows in maps.lavaArray[lavacount] {
                    for cell in rows {
                        if cell == 0 {
                            maps.lavaArray[lavacount] = maps.lavabackup
                            mapBuild(plan:mapSelect(number:mapNumber))
                        }
                    }
                }
                lavacount += 1
                maps.lavabackup = maps.lavaArray[lavacount]
                mapNumber += 1
                mapBuild(plan:mapSelect(number:mapNumber))
                currentMap = mapSelect(number:mapNumber)
                break
            }
        case .arrowLeft:
            if maps.lavaArray[lavacount][mapPosition.y][mapPosition.x-1] == 1 {
                maps.lavaArray[lavacount][mapPosition.y][mapPosition.x] = 0
                cursor.position = Point(x:cursor.position.x-1, y:cursor.position.y)
                mapPosition = Point(x:mapPosition.x-1, y:mapPosition.y)
                mainWindow.refresh()
            }
            else if maps.lavaArray[lavacount][mapPosition.y][mapPosition.x-1] == 0 {
                maps.lavaArray[lavacount] = maps.lavabackup
                mapBuild(plan:mapSelect(number:mapNumber))
            }
            else if maps.lavaArray[lavacount][mapPosition.y][mapPosition.x-1] == 2 {
                maps.lavaArray[lavacount][mapPosition.y][mapPosition.x] = 0
                for rows in maps.lavaArray[lavacount] {
                    for cell in rows {
                        if cell == 0 {
                            maps.lavaArray[lavacount] = maps.lavabackup
                            mapBuild(plan:mapSelect(number:mapNumber))
                        }
                    }
                }
                lavacount += 1
                maps.lavabackup = maps.lavaArray[lavacount]
                mapNumber += 1
                mapBuild(plan:mapSelect(number:mapNumber))
                currentMap = mapSelect(number:mapNumber)
                break
            }
        case .arrowRight:
            if maps.lavaArray[lavacount][mapPosition.y][mapPosition.x+1] == 1 {
                maps.lavaArray[lavacount][mapPosition.y][mapPosition.x] = 0
                cursor.position = Point(x:cursor.position.x+1, y:cursor.position.y)
                mapPosition = Point(x:mapPosition.x+1, y:mapPosition.y)
                mainWindow.refresh()
            }
            else if maps.lavaArray[lavacount][mapPosition.y][mapPosition.x+1] == 0 {
                maps.lavaArray[lavacount] = maps.lavabackup
                mapBuild(plan:mapSelect(number:mapNumber))
            }
            else if maps.lavaArray[lavacount][mapPosition.y][mapPosition.x+1] == 2 {
                maps.lavaArray[lavacount][mapPosition.y][mapPosition.x] = 0
                for rows in maps.lavaArray[lavacount] {
                    for cell in rows {
                        if cell == 0 {
                            maps.lavaArray[lavacount] = maps.lavabackup
                            mapBuild(plan:mapSelect(number:mapNumber))
                        }
                    }
                }
                lavacount += 1
                maps.lavabackup = maps.lavaArray[lavacount]
                mapNumber += 1
                mapBuild(plan:mapSelect(number:mapNumber))
                currentMap = mapSelect(number:mapNumber)
                break
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

