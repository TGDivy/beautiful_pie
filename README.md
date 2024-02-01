# The Clock Pie Diagram

I had started doing this project when I found myself reaching out to pen and paper to visualize my day in a pie chart type manner.

Moreover, I wanted to learn Flutter, and this seemed like a good project to start with.

However, since I have spent time building the pie chart functionality, I realised that it is actually quite different from a pie chart. More so that it is like a clock.

## Scope

- [ ] Schema for the events to be visualized.
- [ ] Start with a clock like diagram.
  - [ ] Show case division of time.
  - [ ] Show case labels for the time.
  - [ ] Show case events.
  - [ ] When events are overlapping, add another ring.
- [ ] When the user drags from the center, it will show an arc that follows the finger, and snaps to the end of the clock, when released it will create a new event.
  - [ ] It will show a ghost of the new event, and the size of the new event will be a selected size.
  - [ ] If the arc is not long enough, it will not create a new event.
  - [ ] If the arc is close to another event, it will snap to the event.
- [ ] When the user drags from the divider of an event, it will increase the size of the event it is dragging from.
  - [ ] If the direction it is dragging is towards another event, it will decrease the size of the event it is dragging to, if they are adjacent.
  - [ ] If the direction it is dragging is away from another event, it will increase the size of the event it is dragging to if they are adjacent.
  - [ ] If no event is adjacent, it will increase the size of the event it is dragging, filling the space between the event and the next event.
- [ ] The user can tap on an event to select it.
  - [ ] When selected, tap and drag the event will allow the user to move the event around the clock.
  - [ ] When selected, tap and release on the event again will deselect it.
- [ ] It always shows the time of the event that is selected, being created, or being dragged (and the time of the event it is being dragged to).

## Data Structure

The data structure will be a simple list of `Event` objects. Each `Event` will have the following properties (inspired by [Google Calendar](https://calendar.google.com/calendar/r)):
- `title` - The title of the event.
- `time` - The time of the event.
- `duration` - The duration of the event.
- `color` - The color of the event.
- `location` - The location of the event.
- `description` - The description of the event.
- `type` - The type of the event (e.g. work, personal, etc.).



## Beautiful Pie (Initial Plan, now deprecated)

This is a simple app that shows a pie chart with a beautiful animation. The goal is to provide intutive controls and beautiful animations to test the limits of Flutter, and my own coding skills.

## Scope

It is important to set the scope of this project as it will allow me to both stay on track, and mark it as complete when it is done.

### What it will do

- [x] Renders the pie chart with the appropriate data.
  - [x] Each section is rendered individually.
  - [x] Customization for each section
    - [x] Color
    - [x] Border
    - [x] Size (radius)
    - [x] Label
    - [x] Offset from center (To make it look as if the slice is being selected / differentiated.)
    - [ ] A custom widget that can be specified for the section.
- [x] Animates the pie chart
  - [x] Each section animates individually.
  - [x] Customization for each section
    - [x] Animation duration
    - [x] Animation curve
    - [ ] Animation direction (clockwise / counter-clockwise)
- [ ] Controls the pie chart
  - [x] On tap of a section, it will select that section, and differentiate it from the rest.
  - [ ] When selected, tap and drag the section will allow the user to move the section around the pie chart.
    - [ ] It will show a ghost/ preview of the new pie chart, and the size of the new section will be the same as the original.
  - [x] When selected, tap and release on the section again will deselect it.
  - [ ] Tap and drag from the center will show a line that follows the finger, and snap to the end of pie chart, when released it will create a new section.
    - [ ] It will show a ghost of the new section, and the size of the new section will be a standard size.
  - [ ] Tap and drag from the divider of a section will increase the size of the section it is dragging from, and decrease the size of the section it is dragging to.

### Data Structure

The data structure will be a simple list of `PieSection` objects. Each `PieSection` will have the following properties:

- `percentage` - The percentage of the pie chart that the section will take up.
- `color` - The color of the section.
- `border` - The border of the section.
- `label` - The label of the section.
- `offset` - The offset of the section from the center of the pie chart.
- `widget` - The widget that will be rendered in the section.

