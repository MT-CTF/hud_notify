# HUD Notify [hud_notify]

HUD Notify is a mod that can be used display messages using HUD elements (instead of chat) for better noticeability. Due to the higher potential for abuse, the use of this command is restricted to moderators and above.

### Dependencies: None

### Usage

- `/notify <player_name> <msg>`
  - Send a notification (`msg`) to `name`.
- `/notify_all <msg>`
  - Send a global notification `msg`.

### Example

- `/notify LegendaryGriefer Stop griefing or face a ban!`
- `/notify_all Attention! The server will be shutting down for maintenance in 15 minutes.`

### Mod Settings

- `hud_notify.hud_duration`
  - Stores a numeric value (10 by default) which represents the duration of the message visibility in seconds.
- `hud_notify.hide_sender`
  - Boolean value which is evaluated to show or hide message header containing the sender's name.

### Screenshot

![screenshot](https://raw.githubusercontent.com/ClobberXD/hud_notify/master/screenshot.png)

### TODO

- Add automatic line-break if `msg` too long.
