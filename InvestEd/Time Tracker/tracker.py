import PySimpleGUI as gui

def main():
    gui.theme("Dark Amber")

    window_components = [
        [gui.Text('Add Time')],
    ]

    window = gui.Window(title='Capstone Time Tracker', layout=window_components, margins=(400, 200))

    while True:
        event, values = window.read()

        if event == gui.WIN_CLOSED:
            break

    window.close()

if __name__ == "__main__":
    main()