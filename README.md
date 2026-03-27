# TotemTimers 3.5

A polished TotemTimers-style addon for Turtle WoW.

## Description

TotemTimers is a World of Warcraft addon designed specifically for Turtle WoW that gives shamans a lightweight totem bar with timers, quick casting, flyout selection, and per-character layout settings.

## Features

- Always-visible totem bar for the elements you actually know
- Hover flyouts that show the other available totems for that element
- Left-click main button to cast the selected/default totem
- Click a flyout spell to cast it and set it as that element's default
- Right-click the main button to clear that element's active timer
- Timer text and cooldown-fill overlay for active totems
- Urgency colors and glow effects as a totem nears expiration
- Twist helper text when a tracked totem is close to expiring
- Drag-and-drop positioning while unlocked
- Compact and vertical layout modes
- Per-character saved settings
- No external libraries required

## Controls

- **Left-click** - Cast the selected/default totem for that element
- **Hover** - Show the flyout of learned totems for that element
- **Click flyout spell** - Cast it and make it the new default
- **Right-click** - Clear that element's active timer
- **Drag while unlocked** - Move the bar anywhere on screen

## Commands

| Command | Description |
|---------|-------------|
| `/tt lock` | Toggle lock/unlock so the bar can be moved |
| `/tt compact` | Toggle compact button sizing |
| `/tt vertical` | Toggle vertical bar layout |
| `/tt reset` | Reset the bar position to default |
| `/tt test` | Start a test timer |

## How It Works

- Each visible element button represents your current selected totem for that school
- If a totem is active, the button shows its icon, timer text, and progress overlay
- If no totem is active, the button remains visible with your selected/default spell
- Elements with no learned totems are hidden automatically
- Hovering a button opens a flyout above it with learned alternatives

## Installation

1. Clone or download this repository
2. Place the `TotemTimers` folder in your World of Warcraft `AddOns` directory:
   - `World of Warcraft\Interface\AddOns\`
3. Make sure the folder name is exactly `TotemTimers`
4. Restart World of Warcraft or reload the UI (`/reload`)

## Usage

Once installed and enabled:
1. The addon will automatically load when you log onto a shaman
2. Use the bar buttons to cast your selected totems quickly
3. Hover each element button to pick a different default totem
4. Drag the bar while unlocked to reposition it
5. Use slash commands to adjust layout and reset placement

## Files

- `TotemTimers_Core.lua` - Core event handling, spell tracking, and timer state
- `TotemTimers_UI.lua` - Button creation, flyout menus, and timer visuals
- `TotemTimers_Init.lua` - UI initialization
- `TotemTimers_Config.lua` - Slash command handling
- `TotemTimers_Layout.lua` - Anchor handling and layout logic
- `TotemTimers_Advanced.lua` - GCD overlay and advanced visual effects
- `TotemTimers.toc` - Addon table of contents configuration file

## Requirements

- Turtle WoW private server
- World of Warcraft client (1.12.x - compatible with Turtle WoW)
- Shaman character

## Notes

- Built for `Interface 11200`
- Uses Turtle/Vanilla-compatible spell event handling
- Does not rely on modern retail APIs
- Designed to stay lightweight without external libraries

## Credits

- Original TotemTimers authors
- Turtle WoW community
- Modern Turtle-compatible rewrite and polish by Greg Deichler

## License

This project is open source and available under the MIT License. See [LICENSE](LICENSE).
