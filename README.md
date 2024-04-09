# Puzzle Alarm App for macOS

The Puzzle Alarm app, crafted with SwiftUI for macOS, is more than just an alarm. It incorporates a memory game to ensure that you're fully awake before you can turn off the alarm. This approach adds a layer of engagement to your morning routine, aiming to make waking up a bit more interesting.

## Key Features

- **Customizable Alarm Time:** Set your alarm effortlessly with a user-friendly interface.
- **Interactive Memory Game:** To turn off the alarm, solve a memory game that guarantees you're alert.
- **Persistent Application State:** The app requires the memory game to be completed before it can be closed or quit, ensuring you're ready to start your day.
- **Forced Volume Control:** If the volume is lowered or muted, the app intervenes by raising the system volume to ensure the alarm is heard.
- **Gradual Volume Increase:** Begins with a softer volume that gently rises, designed to wake you up without a start.
- **Snooze Option:** A snooze feature for those mornings when you need just a bit more sleep.

## Memory Game Details

At the heart of this app is its memory game, crafted to make sure you're not just awake but mentally engaged. The game presents a challenge that must be completed to silence the alarm, adding a fun twist to your morning routine.

### Memory Game Features:

- **Engagement Required:** The app remains active until the puzzle is solved, promoting mental alertness from the moment you wake up.
- **Volume Control Prevention:** The app counters any attempt to mute or lower its volume, ensuring the alarm continues until you're ready to tackle the day.
- **Interactive Puzzle:** Completing the memory game puzzle is necessary to turn off the alarm, making sure you’re fully awake.

## Usage

1. **Set Alarm:** Choose your wake-up time easily.
2. **Alarm Activation:** At the set time, the app plays an alarm sound that increases in volume gradually.
3. **Memory Game Engagement:** Solve the memory game to prove you're awake and turn off the alarm.
4. **Snooze or Disable:** You can snooze for more sleep or disable the alarm after completing the game.

## System Requirements

- macOS 11.0 or later
- SwiftUI

## Installation

Clone the repository and open the project in Xcode to install. Build and run it on your macOS device.

## Support and Contributions

For support or contributions, feel free to open an issue or pull request on GitHub. Your input helps make waking up a better experience.

## License

This project is available under the MIT License. See the LICENSE.md file for more details.
