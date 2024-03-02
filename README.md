This is an FPS Template for Godot 4. 

The weapons are created via a resource called Weapon_Resource that allows you to add all the animations and stats to the weapon. The weapon manager will then load all the resources and use the small state machine to control which weapon is active.

The purpose of this template is to make prototyping a First Person Shooter a lot faster since the gameplay and weapons can be design an art added later. This is because each weapon takes string references to each animation, you could design a large array of weapons with place holder animations and then when the Rig is ready, swap it in and replace the animation references.

The template utilize component very heavily. The weapons themselves are components added to the state machine. The projectiles, whether hit scan or projectile are a separate component that are added to each weapon. And the spray profiles for each weapon. All can be swapped and changed without effecting the other elements.
