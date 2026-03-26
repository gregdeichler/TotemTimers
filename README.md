# TotemTimers 3.5

A polished TotemTimers-style addon for **Turtle WoW / Vanilla 1.12**.

It keeps the classic shaman workflow intact while using a lightweight, Turtle-friendly implementation built around spell detection and per-character settings.

---

## Features

- Always-visible totem bar for the elements you actually know
- Hover flyouts that show the other available totems for that element
- Left-click main button to cast your selected/default totem
- Click a flyout spell to cast it and set it as that element's default
- Right-click main button to clear that element's active timer
- Accurate timer text and cooldown-fill overlay
- Urgency colors and glow effects as a totem nears expiration
- Totem twist helper text when a tracked totem is about to expire
- Drag-and-drop positioning while unlocked
- Compact and vertical layout modes
- Per-character saved settings
- No external libraries required

---

## How It Works

Each visible element button represents your current selected totem for that school.

- If a totem is active, the button shows its icon, timer, and progress overlay
- If no totem is active, the button still remains visible with your selected/default spell
- Elements with no learned totems are hidden automatically
- Hovering a button opens a vertical flyout above it with your learned alternatives

---

## Controls

- `Left-click`: Cast the selected/default totem for that element
- `Hover`: Show the vertical flyout of learned totems for that element
- `Click flyout spell`: Cast it and make it the new default for that element
- `Right-click`: Clear that element's active timer
- `Drag while unlocked`: Move the bar anywhere on screen

---

## Commands

```text
/tt lock       - Toggle lock/unlock so the bar can be moved
/tt compact    - Toggle compact button sizing
/tt vertical   - Toggle vertical bar layout
/tt reset      - Reset the bar position to default
/tt test       - Start a test timer
```

---

## Installation

1. Place this folder in:

```text
Interface/AddOns/TotemTimers/
```

2. Make sure the folder name is exactly `TotemTimers`
3. Reload the UI or restart the client

---

## Turtle WoW Notes

- Built for `Interface 11200`
- Uses Turtle/Vanilla-compatible spell event handling
- Does not depend on combat log parsing for timer tracking
- Works best for shamans who want a clean modernized totem bar without extra libraries

---

## Design Goals

- Fast and lightweight
- Stable on Turtle WoW
- Easy to read in combat
- Easy to extend without external dependencies

---

## Credits

- Original TotemTimers authors
- Turtle WoW community
- Modern Turtle-compatible rewrite and polish by contributors

---

## License

MIT License. See [LICENSE](LICENSE).
