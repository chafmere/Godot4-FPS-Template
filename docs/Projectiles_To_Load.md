A Pojectile to load is not a physical projectile. 

It can be a rigid body if you want it to be. But what it actually is, is an object that is loaded when you press the fire button and is responsilble for ray casting and detecting a hit. It can be either a hit scan weapon or it can be a "rigid body projectile".

A Projectile_To_Load should be placed on every weapon resource that exists in your game. It is a required object for the manager to function.

![It is found under weapon behaviour](images/weapon_behavior.png)

Let's look at the flow of the code to understand a bit better how the projectiles are designed to work.

![The Shoot Function](images/shoot_code.png)

The first few lines are all focused around checking what the player is doing, like reloading or already firing, The next thing it does is play the animation, reduce ammo and update the hud.

After that it will calculate the spread [via the spray profile](Spray_Profile.md). and the ver last thing it does it call the Load Projectile function.

In essence the shoot function within the manager does not do any damage checking, firing or ray casting. All it does is check if you can shoot, and if you can, play and an animation and ask for a spray value before handing off to the projectile.

The Weapon Manager then instantiates the Projectile and calls the function Set_Projectile passing in the damage, spread and range.

Okay So now let's look at the Projectil To Load itself.

The Projectile Class is an object that can ray cast and determine if the object it hit can be damaged.

There are a few options available to us when setting up. 
![alt text](<images/Projectile Options.png>)

* Projectile Type
    * Can Be Either A Hit Scan or Rigid Body Projectile. If Rigid body is select a Rigid body must be provided.
* Display Debug Decal
    * Will Spawn a red dot on the point where the bullet hit. This is good for early stages and regular decals have not been set up yet.

* Projectile Velocity
    * The Speed at which a rigid body is sent from the weapon
* Expirey Time
    * The Amount of time befoe the rigid body will de spawn if it has not hit anything.
* Rigid Body Projectile
    * The Rigid Body to spawn if the projectile is a rigid body projectile.

There is not a lot to set up here. If a simple Hitscan weapon is needed a projectile object saved in a scene with nothing else and added to a weapon manager *should* just work. 

The main reason for the component if to give the user the ability to inherit from this class and override the _Set_Projectile function to do other kinds of weapons. For example a shot gun that does 12 ray casts at once.

The Set Projectile Function sets the damage to it's own internal variable and the calls Fire_Projectile which take care of the ray cast detection.

![alt text](images/set_projectile.png)

To make a shot gun you can over ride this function and call 9-12 ray casts for every "Pelle" you fire

![alt text](images/shot_gun.png)

Of course when doing this don't change the number of parameters taken by the function. Otherwise the godot will through an error. Eg the Spread sent to us is not really needed since the shot gun is going to create it's own pattern. 