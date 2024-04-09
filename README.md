# Alarm Clock App for macOS

The Alarm Clock app is a cutting-edge macOS application developed with SwiftUI, designed not only to wake you up on time but to ensure you're truly awake through an interactive and challenging memory game. It combines utility with an engaging user experience to transform waking up into an enjoyable activity.

## Key Features

- **Customizable Alarm Time:** Set your alarm quickly using a straightforward interface.
- **Interactive Memory Game:** A stimulating memory game that needs to be solved to turn off the alarm, ensuring you're fully awake.
- **Persistent Application State:** The app prevents itself from being closed or quit until the alarm is dismissed by completing the memory game, making sure you're up and moving.
- **Forced Volume Control:** If attempts are made to lower the volume or mute it, the app overrides these changes by forcibly raising the system volume, guaranteeing the alarm is heard.
- **Gradual Volume Increase:** The alarm volume starts low and gradually increases, ensuring a gentle yet effective wake-up.
- **Snooze Option:** Provides a snooze feature for mornings when you need a bit more sleep.

## Enhanced Memory Game Details

The core feature of this app is its memory game, designed not only to silence the alarm but to ensure cognitive engagement right after waking up. The game presents a grid of tiles where the user must remember and match tile locations to win. This interaction ensures that you're not just awake but also mentally stimulated.

### Memory Game Features:

- **Dynamic Difficulty:** The difficulty level adjusts based on your waking state, requiring more cognitive effort to shut off the alarm on days you’re groggier.
- **Forced Engagement:** The app cannot be quit or closed without solving the puzzle, ensuring that you're fully awake and engaged before you start your day.
- **Volume Control Prevention:** To ensure the memory game is played, the app will automatically increase the system volume if you try to mute or lower it, ensuring the alarm remains audible until you're ready to engage with the game.

## Usage

1. **Set Alarm:** Select your wake-up time with ease.
2. **Alarm Activation:** At the set time, the app plays an alarm sound that gradually increases in volume.
3. **Engage in Memory Game:** Dismiss the alarm by successfully completing the memory game, ensuring you're awake.
4. **Snooze or Disable:** Opt to snooze if you need more rest, or turn off the alarm upon completing the memory game.

## System Requirements

- macOS 11.0 or later
- SwiftUI

## Installation

To install, clone the repository and open the project in Xcode. Compile the project and run it on your macOS device.

## Support and Contributions

For support or to contribute, please create an issue or pull request on GitHub. Your contributions to improving the alarm clock experience are appreciated.

## License

This project is freely available under the MIT License. For more details, see the LICENSE.md file.

