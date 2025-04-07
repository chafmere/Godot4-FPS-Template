### This is an FPS Template for Godot 4.

![alt text](media/FPS_Banner.FREEE.png)

The purpose of this template is to make prototyping a First Person Shooter a lot faster since the gameplay and weapons can be designed and art added later. 

Each weapon takes string references to each animation. Design a large array of weapons with place holder animations, and then when the Rig is ready, swap it in and replace the animation references.

Weapons are created via a resource called [`Weapon_Resource`](Player_Controller/scripts/Weapon_State_Machine/weapon_resource.gd). Add all animations and stats for each weapon. Then the weapon manager -- a `Node` [Weapon_State_Machine.gd](Player_Controller/scripts/Weapon_State_Machine/Weapon_State_Machine.gd) -- will load all the resources and use its small state machine to control which weapon is active.

![alt text](media/Weapon%20Resources.png)

![alt text](media/Weapon%20Statemachine.png)
The template utilizes components very heavily. All can be swapped and changed without affecting the other elements.
- The weapons themselves are components added to the state machine.
- The projectiles, whether hit scan or projectile are a separate component that are added to each weapon.
- Also the spray profiles for each weapon are components. 

[![Patreon](https://img.shields.io/badge/Patreon-Support%20this%20Project-%23f1465a?style=for-the-badge)](https://patreon.com/ChaffGames) [![Discord](https://img.shields.io/discord/865048184160911421?style=for-the-badge&logo=Discord&label=Discord)](https://discord.gg/Exzd8QmKrU) [itch.io](https://chafmere.itch.io/godot-4-fps-controller)

Need help understanding?

Check out the [Documentation](https://docs.chaffgames.com/docs/fpstemplate/table_of_contents/)

Here are some of the main features:

- Resource Based: [docs](https://docs.chaffgames.com/docs/fpstemplate/creating_a_new_weapon/#create-a-resource)

- State Machine to manage current weapon: [source](Player_Controller/scripts/Weapon_State_Machine/Weapon_State_Machine.gd)
  - '1' through '9' in demo scene
  - reload - 'r' in demo scene 

- Movement Options: [source](Player_Controller/scripts/Player_Character/player_character.gd) 
![Movement Options](media/player%20movement.png)
  - lean - 'q' and 'e' in demo scene
  - crouch - 'c' in demo scene
  - drop - 'g' in demo scene
  - sprint - 'shift + move' in demo scene
  - coyote timer -- to reduce frustration around cliff edges, allowing 'jump' in the tenth of a second the player's foot leaves an edge
  - walk - 'ctrl + move' in demo scene

- Several Preset Weapon Types: [directory](Player_Controller/scripts/Weapon_State_Machine/Weapon_Resources)
![Currently 4 Weapons](media/weapon%20range.png)


