# Beautiful Pie

This is a simple app that shows a pie chart with a beautiful animation. The goal is to provide intutive controls and beautiful animations to test the limits of Flutter, and my own coding skills.

## Scope

It is important to set the scope of this project as it will allow me to both stay on track, and mark it as complete when it is done.

### What it will do

- [ ] Renders the pie chart with the appropriate data.
  - [ ] Each section is rendered individually.
  - [ ] Customization for each section
    - [ ] Color
    - [ ] Border
    - [ ] Size (radius)
    - [ ] Label
    - [ ] Offset from center (To make it look as if the slice is being selected / differentiated.)
    - [ ] A custom widget that can be specified for the section.
- [ ] Animates the pie chart
  - [ ] Each section animates individually.
  - [ ] Customization for each section
    - [ ] Animation duration
    - [ ] Animation curve
    - [ ] Animation direction (clockwise / counter-clockwise)
- [ ] Controls the pie chart
  - [ ] On tap of a section, it will select that section, and differentiate it from the rest.
  - [ ] When selected, tap and drag the section will allow the user to move the section around the pie chart.
    - [ ] It will show a ghost/ preview of the new pie chart, and the size of the new section will be the same as the original.
  - [ ] When selected, tap and release on the section again will deselect it.
  - [ ] Tap and drag from the center will show a line that follows the finger, and snap to the end of pie chart, when released it will create a new section.
    - [ ] It will show a ghost of the new section, and the size of the new section will be a standard size.
  - [ ] Tap and drag from the divider of a section will increase the size of the section it is dragging from, and decrease the size of the section it is dragging to.