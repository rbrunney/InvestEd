import PySimpleGUI as gui
import os
import json
import time

def main():

    gui.theme("Python")

    ## Making First Column Layout for Adding Hours 

    # Fields for giving activity title
    add_column_1 = [
        [gui.Text('Activity', justification='right')],
        [gui.Combo(values=['Coding', 'Research', 'Design', 'Bug Fixing', 'Other'],  key='-ACTIVITYBOX-', readonly=True)]
    ]

    # Fields for Start and End Time

    add_column_2 = [
        [gui.Text('Start Time', justification='center')],
        [
            gui.Combo(values=[hour for hour in range(1, 13)], key='-S-HOUR-', default_value=12, readonly=True), 
            gui.Text(':'), 
            gui.Combo(values=[hour for hour in range(1, 60)], key='-S-MINUTE-', default_value=30, readonly=True),
            gui.Combo(values=['am', 'pm'], key='-S-DAYTIME-', default_value='am', readonly=True)
        ],
        [gui.Text('End Time', justification='center')],
        [
            gui.Combo(values=[hour for hour in range(1, 13)], key='-E-HOUR-', default_value=12, readonly=True), 
            gui.Text(':'), 
            gui.Combo(values=[hour for hour in range(1, 60)], key='-E-MINUTE-', default_value=30, readonly=True),
            gui.Combo(values=['am', 'pm'], key='-E-DAYTIME-', default_value='am', readonly=True)
        ],
    ]

    week_list = [f'Week {week}' for week in range(1, 11)]
    add_hours_layout = [
        [gui.Column(layout=add_column_1), gui.Column(add_column_2)],
        [gui.Text('Description')],
        [gui.Multiline(key='-MULTILINE-')],
        [gui.Combo(week_list, default_value=week_list[0], readonly=True, key='-WEEK-')],
        [gui.Button('Add Hours', key='-ADD-')]
    ]

    view_hours_layout = [[gui.Text('Hello from view')]]

    window_components = [
        [
            gui.TabGroup(
                [[
                    gui.Tab('Add Hours', layout=add_hours_layout),
                    gui.Tab('View Hours', layout=view_hours_layout)
                ]],
                tab_location='top'
            )
        ]
    ]

    window = gui.Window(title='Capstone Time Tracker', layout=window_components, margins=(300, 150))

    while True:
        event, values = window.read()

        if event == '-ADD-':
            # Creating activity for information
            create_activity(
                window['-WEEK-'].get(),
                window['-ACTIVITYBOX-'].get(),
                str(window['-S-HOUR-'].get()) + ":" + str(window['-S-MINUTE-'].get()) + ' ' + window['-S-DAYTIME-'].get(),
                str(window['-E-HOUR-'].get()) + ":" + str(window['-E-MINUTE-'].get()) + ' ' + window['-E-DAYTIME-'].get(),
                window['-MULTILINE-'].get()
            )

        # If the user close window 'X' it will shut the gui down
        if event == gui.WIN_CLOSED:
            break

    window.close()

def create_activity(week, activity, start_time, end_time, description):
    # Making new activity object
    new_activity = {
        "activity" : activity,
        "start_time" : start_time,
        "end_time" : end_time,
        "description" : description,
        "total_hours" : 0
    }

    # Checking to see if tracker.json exists if not create the file
    if not os.path.exists('./tracker.json'):
        with open('tracker.json', 'w') as file:
            file.write(json.dumps({
                'Week 1' : {"activities" : []},
                'Week 2' : {"activities" : []},
                'Week 3' : {"activities" : []},
                'Week 4' : {"activities" : []},
                'Week 5' : {"activities" : []},
                'Week 6' : {"activities" : []},
                'Week 7' : {"activities" : []},
                'Week 8' : {"activities" : []},
                'Week 9' : {"activities" : []},
                'Week 10' : {"activities" : []}
            }, indent=4))

    # Reading and Overwriteing with new information
    with open('tracker.json', 'r') as file:
        json_load = json.loads(file.read())
        
        with open('tracker.json', 'w') as file:
            json_load[week]['activities'].append(new_activity)
            file.write(json.dumps(json_load, indent=4)) 

if __name__ == "__main__":
    main()