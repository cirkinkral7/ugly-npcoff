# ugly-npcoff

A lightweight **FiveM** client resource that reduces ambient traffic, scenario pedestrians, random emergency spawns, and **AI dispatch** (police, ambulance, fire, etc.) on your server. It is intended for roleplay or event servers where you want a calmer world without constant NPC vehicles and automatic emergency responses.

> **Note:** The authoritative copy of this resource lives under  
> `resources/[ugly]/ugly-npcoff/`.  
> This `cache/files/` folder is produced by the FiveM server when the resource is built; **cache can be deleted** when you update the server or clear cache. Keep this README next to the real resource folder if you want it to persist.

---

## What it does

### Client (`client.lua`)

Runs every frame in a loop and applies native density and world settings:

| Setting | Effect |
|--------|--------|
| `SetVehicleDensityMultiplierThisFrame(0.0)` | No ambient driving traffic. |
| `SetRandomVehicleDensityMultiplierThisFrame(0.0)` | No random spawning vehicles in traffic. |
| `SetParkedVehicleDensityMultiplierThisFrame(0.0)` | No parked cars spawning as ambient props in the same way. |
| `SetScenarioPedDensityMultiplierThisFrame(0.0, 0.0)` | Scenario / ambient “scene” pedestrians are suppressed. |
| `SetPedDensityMultiplierThisFrame(3.0)` | **Walking** pedestrian density multiplier is set high (not zero). If you want fewer walkers too, lower this value in `client.lua`. |
| `SetGarbageTrucks(false)` | Disables garbage truck spawns. |
| `SetRandomBoats(false)` | Disables random boats. |
| `SetCreateRandomCops` (variants) | Stops random cop ped creation. |
| `EnableDispatchService(i, false)` for `i = 1..15` | Disables dispatch services (no automatic police/ambulance/fire units responding to world events). |

These natives must be called **every frame** (or very frequently); the script uses `Citizen.Wait(0)` for that reason.

### Server (`server.lua`)

- Starts with **QBCore**: `exports['qb-core']:GetCoreObject()`.
- On resource start, prints a short confirmation line to the **server console** (Turkish message in the current build).

The server side does **not** run game density logic; all gameplay effect is **client-side**.

---

## Requirements

- **FiveM** server (artifact with standard GTA V / `cerulean` support).
- **QBCore** (`qb-core`) must be started **before** this resource, because `server.lua` loads the core object on start.

There is no database or extra asset dependency.

---

## Installation (step by step)

### 1. Resource location

Place the folder so the structure is:

```text
resources/
  [ugly]/
    ugly-npcoff/
      fxmanifest.lua
      client.lua
      server.lua
      storage/
        eslint_rc.js
```

If your server already uses `ensure [ugly]`, any resource inside `[ugly]` is started with that folder.

### 2. `fxmanifest.lua`

The manifest should reference:

- `client_script 'client.lua'`
- `server_script 'server.lua'`
- `shared_scripts` including `storage/eslint_rc.js` (as in your current pack)

Do not rename `client.lua` / `server.lua` unless you update the manifest accordingly.

### 3. `server.cfg` load order

1. Ensure **QBCore** is started first, for example:

   ```cfg
   ensure qb-core
   ```

2. Then start the ugly pack or this resource:

   ```cfg
   ensure [ugly]
   ```

   Or, if you only want this script without the whole bracket folder:

   ```cfg
   ensure ugly-npcoff
   ```

**Important:** `ugly-npcoff` must start **after** `qb-core`, otherwise `server.lua` can error when resolving `exports['qb-core']`.

### 4. Restart

- Restart the server, or run in the server console:

  ```text
  ensure ugly-npcoff
  ```

- Join the server and confirm: less traffic, no dispatch spam, and check the server console for the startup print from `server.lua`.

---

## Configuration tips

- **Fewer walking NPCs:** In `client.lua`, change `SetPedDensityMultiplierThisFrame(3.0)` to `0.0` or a small value like `0.3` and restart the resource.
- **Re-enable dispatch for specific services:** You would need to stop calling `EnableDispatchService` for those indices or set them to `true` selectively (see GTA/FiveM native docs for dispatch index meanings).

---

## Troubleshooting

| Problem | Likely cause |
|--------|----------------|
| Server error on start about `qb-core` | `qb-core` not started or wrong export name; fix load order or rename export if your framework differs. |
| No effect in-game | Resource not started, or another script overrides the same natives every frame after this one (resolve load order). |
| README missing after update | It was only under `cache/files/`; copy `readme.md` into `resources/[ugly]/ugly-npcoff/` for a permanent copy. |

---

## Credits

Per `fxmanifest.lua`: **ugly NPC ve Trafik Engelleyici** — authors listed as Gemini & Cursor.

---

## License

If the original pack shipped with a license file, follow that file. This README is documentation only and does not replace any license terms from the resource author.
