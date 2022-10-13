import PySimpleGUI as gui
import datetime as dt
import json
import os

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
            gui.Combo(values=[hour for hour in range(0, 60)], key='-S-MINUTE-', default_value=30, readonly=True),
            gui.Combo(values=['am', 'pm'], key='-S-DAYTIME-', default_value='am', readonly=True)
        ],
        [gui.Text('End Time', justification='center')],
        [
            gui.Combo(values=[hour for hour in range(1, 13)], key='-E-HOUR-', default_value=12, readonly=True), 
            gui.Text(':'), 
            gui.Combo(values=[hour for hour in range(0, 60)], key='-E-MINUTE-', default_value=30, readonly=True),
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
        [gui.Combo(week_list, default_value=week_list[0], readonly=True, key='-VIEW-WEEK-'), gui.Button('Fetch', key='-FETCH-'), gui.Button('Summary', key='-SUMMARY-')],
        [gui.Text('Total Hours: '), gui.Text('0', key='-TOTAL-HOURS-'), gui.Text('Min Hours Reached: '), gui.Text('FALSE', key='-IS-REACHED-')],
        [
            gui.Table(
                values=[], 
                headings=['Activity', 'Start-Time', 'End-Time', 'Description', 'Day'],
                justification='center',
                key='-ACTIVITY-TABLE-',  
            )
        ]
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

    window = gui.Window(title='Capstone Time Tracker', layout=window_components, margins=(100, 25))

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
            # Getting tracker information from json file and then caclulating total time taken
            activity_data = get_activity_data(window['-VIEW-WEEK-'].get())

            window['-ACTIVITY-TABLE-'].update(activity_data[0])
            window['-TOTAL-HOURS-'].update(str(calculate_time(activity_data[1])))

            if float(window['-TOTAL-HOURS-'].get()) >= 20:
                window['-IS-REACHED-'].update('TRUE')
            else:
                window['-IS-REACHED-'].update('FALSE')
        
        if event == '-SUMMARY-':
            data = get_summary_data(window['-VIEW-WEEK-'].get())
            summary_output = f'Coding: {data["Coding"]} hrs\nResearch: {data["Research"]} hrs\nDesign: {data["Design"]} hrs\nBug Fixing: {data["Bug Fixing"]} hrs\nOther: {data["Other"]} hrs'
            gui.Popup(summary_output, title='Hours Break Down', keep_on_top=True)
            

        # If the user close window 'X' it will shut the gui down
        if event == gui.WIN_CLOSED:
            break

    window.close()

def get_activity_data(week):

    with open('tracker.json', 'r') as file:
        tracker_info = json.loads(file.read())
        table_data = []
        time_information = []

        for key in dict(tracker_info[week]).keys():
            for data_info in tracker_info[week][key]['activities']:
                table_data.append([data_info['activity'], data_info['start_time'], data_info['end_time'], data_info['description'], key])
                time_information.append([data_info['start_time'],data_info['end_time']])

    return (table_data, time_information)

def get_summary_data(week):
    with open('tracker.json', 'r') as file:
        tracker_info = json.loads(file.read())
        summary_data = {
            'Coding': 0, 'Research' : 0, 'Design' : 0, 'Bug Fixing' : 0, 'Other' : 0
        }

        for key in dict(tracker_info[week]).keys():
            for data_info in tracker_info[week][key]['activities']:
                summary_data[data_info['activity']] = summary_data[data_info['activity']] + calculate_time([[data_info['start_time'],data_info['end_time']]])
                
    return summary_data

def calculate_time(time_list):

    total_time_worked = 0

    for time_tuple in time_list:
        # Need to update the time if the user puts in pm. That way we get more accurate timing on worked hours
        start_time_check = time_tuple[0].split(' ')
        end_time_check = time_tuple[1].split(' ')
        if start_time_check[1] == 'pm':
            change_hour = start_time_check[0].split(':')
            new_end_time = str(int(change_hour[0]) + 12)

            time_tuple[0] = f'{new_end_time}:{change_hour[1]}'

        if end_time_check[1] == 'pm':
            change_hour = end_time_check[0].split(':')
            new_end_time = str(int(change_hour[0]) + 12)

            time_tuple[1] = f'{new_end_time}:{change_hour[1]}'

        # Getting start time and end time
        start_time = dt.datetime.strptime(time_tuple[0].split(' ')[0], "%H:%M")
        end_time = dt.datetime.strptime(time_tuple[1].split(' ')[0], "%H:%M")

        # Getting total elapsed time in hours
        total_time_worked += (end_time - start_time).total_seconds() / (60 * 60)

    return total_time_worked

def create_activity(week, day, activity, start_time, end_time, description):
    # Making new activity object
    new_activity = {
        "activity" : activity,
        "start_time" : start_time,
        "end_time" : end_time,
        "description" : description
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