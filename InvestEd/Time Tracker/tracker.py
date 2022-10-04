import PySimpleGUI as gui
import os
import json

def main():

    gui.theme("Python")

    ## ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    ## Making First Tab Layout for Adding Hours 

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
    day_list = ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday']
    add_hours_layout = [
        [gui.Column(layout=add_column_1), gui.Column(add_column_2)],
        [gui.Text('Description')],
        [gui.Multiline(key='-MULTILINE-')],
        [gui.Combo(week_list, default_value=week_list[0], readonly=True, key='-WEEK-'), gui.Combo(day_list, default_value=day_list[0], readonly=True, key='-DAY-')],
        [gui.Button('Add Hours', key='-ADD-')]
    ]

    ## ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    ## Making Second Tab Layout for Viewing Hours 

    view_hours_layout = [
        [gui.Combo(week_list, default_value=week_list[0], readonly=True, key='-VIEW-WEEK-'), gui.Button('Fetch', key='-FETCH-')],
        [gui.Text('Total Hours: '), gui.Text('0', key='-TOTAL-HOURS-'), gui.Text('Min Hours Reached: '), gui.Text('FALSE', key='-IS-REACHED-')],
        [gui.Table(
            values=[['Activity', 'Start-Time', 'End-Time', 'Description', 'Day']], 
            headings=['Activity', 'Start-Time', 'End-Time', 'Description', 'Day'],
            justification='center'
            )]
    ]

    window_components = [
        [
            gui.TabGroup(
                [[
                    gui.Tab('Add Hours', layout=add_hours_layout, element_justification='center'),
                    gui.Tab('View Hours', layout=view_hours_layout, element_justification='center')
                ]],
                tab_location='top'
            )
        ]
    ]


    ## ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    ## Making window and running gui

    window = gui.Window(title='Capstone Time Tracker', layout=window_components, margins=(150, 50))

    while True:
        event, values = window.read()

        if event == '-ADD-':
            # Creating activity for information
            create_activity(
                window['-WEEK-'].get(),
                window['-DAY-'].get(),
                window['-ACTIVITYBOX-'].get(),
                str(window['-S-HOUR-'].get()) + ":" + str(window['-S-MINUTE-'].get()) + ' ' + window['-S-DAYTIME-'].get(),
                str(window['-E-HOUR-'].get()) + ":" + str(window['-E-MINUTE-'].get()) + ' ' + window['-E-DAYTIME-'].get(),
                window['-MULTILINE-'].get()
            )

        if event == '-FETCH-':
            print(window['-VIEW-WEEK-'].get())

            window['-TOTAL-HOURS-'].update('20')

            if float(window['-TOTAL-HOURS-'].get()) >= 20:
                window['-IS-REACHED-'].update('TRUE')
            

        # If the user close window 'X' it will shut the gui down
        if event == gui.WIN_CLOSED:
            break

    window.close()

def create_activity(week, day, activity, start_time, end_time, description):
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
                'Week 1' : {},
                'Week 2' : {},
                'Week 3' : {},
                'Week 4' : {},
                'Week 5' : {},
                'Week 6' : {},
                'Week 7' : {},
                'Week 8' : {},
                'Week 9' : {},
                'Week 10' : {}
            }, indent=4))

    # Reading and Overwriteing with new information
    with open('tracker.json', 'r') as file:
        json_load = json.loads(file.read())

        with open('tracker.json', 'w') as file:

            try:
                json_load[week][day]['activities'].append(new_activity)
            except:
                json_load[week][day] = {'activities' : []}
                json_load[week][day]['activities'].append(new_activity)

            file.write(json.dumps(json_load, indent=4)) 

if __name__ == "__main__":
    main()