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

mainWindow.write("test")

var tutorial1 = [[0,0,0,0,0],[0,1,1,1,0],[0,1,1,1,0],[0,1,1,1,0],[0,0,0,0,0]]

func mapBuild(plan: [[Int]]) {
    mainWindow.turnOn(cyanOnBlue)
    let locationX = 5
    var locationY = 5
    cursor.position = Point(x:locationX, y:locationY)
    for rows in plan {
        for cell in rows {
            if cell == 0 {
                mainWindow.write("█")
            } else if cell == 1 {
                mainWindow.write(" ")
            }
        }
        locationY += 1
        cursor.position = Point(x:locationX, y:locationY)
    }
    mainWindow.refresh()
    mainWindow.turnOff(cyanOnBlue)
}

mapBuild(plan:tutorial1)
mainWindow.refresh()

screen.wait()
