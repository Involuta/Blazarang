Blazarang Ideas Doc

Production Processes

Importing new Cotu animations from Blender
Check the new animation(s) you want to add and make sure “Manual Frame Range” is selected on the right of the keyframe timeline and set the frame range to the correct values
In Blender in Object Mode, hide everything except for Cotu and press A
Save the project
Export the file as a glTF 2.0, where you make sure these are checked:
Include → Limit to Selected Objects
Transform → +Y Up
Data → Mesh → Apply Modifiers
Data → Armature → Export Deformation Bones Only
Don’t. Delete. Anything.
In Godot, select the glb_imports
Click and drag the GLB file from Finder into Godot
Rename the current inherited scene to CotuAnimsX, where X is the previous num + 1

Adding new animations to an Enemy
Export glb file of enemy from Blender into Godot
Double-click glb file in Godot file system to enter Import settings, select the new anim, then save the anim to file → enemies → enemy_anims. Keep Custom Tracks
In the enemy scene (ie the scene that contains the enemy’s AI, not the scene directly adapted from the glb), go to the anim tree’s state machine, then add the anim as a state
Make the anim get accessed via a condition
In the enemy AI script, add the condition (string) as a key to the enemy’s attack chances and make the value a probability between 0 and 1
The choose attack code should automatically handle the rest

How to update sprite anims
Go to Blender
Create 2D Grease Pencil anim
Ensure the scene has a camera
Click the Output tab
60 fps
Ensure correct frame range
Ensure correct output folder AND ensure that the folder’s empty (yes there’s an option to override existing images, but what if you want to change the length of the anim?)
Hit ctrl+F12 (i.e. ctrl+fn → F12) to export the animation as a set of images, one per frame
Go to this website: https://www.codeandweb.com/free-sprite-sheet-packer
Clear the placeholder, then upload all of your exported images
Click the download png button, then replace the old spritesheet you’re replacing in Godot
You shouldn’t have to make any more changes (unless the length of the anim is different, in which case you may have to make a new SpriteFrames object out of the png)

Setting an Enemy’s Health
Go to Globals
Scroll down to enemy health section where there’s a dict that contains all enemies’ names as keys and their stat lists as values
First item is health, second item is the score the player receives upon hitting the enemy, and third is the score the player receives upon destroying the enemy

Basic Concepts:

Throw the boomerang at enemies

Dodge enemy melee and ranged attacks with Step Dodge, Duck, or Jump
e.g. dodge sword sweep attack with Duck or Jump in any direction, dodge huge overhead swing with any option to the side

Dodge the boomerang with the same options
The boomerang will then try to return to the player again


Playstation Controls:

Press R1: Throw Boomerang (if you have it)
Has long startup time, encouraging the player to keep their distance from their targets at first

Hold R1: Charge Throw Boomerang (if you have it)
Increases boomerang’s damage
Hold L2 with “Energy”: Freeze (if you have the boomerang)
Greatly slows down time and zooms camera to player’s shoulder to more carefully aim the boomerang
During slow-mo, boomerang has nearly normal speed
Causes a freeze

Hold R1: Catch Boomerang (if you don’t have it)
Receiving the boomerang is automatic as long as you don’t avoid it
Catching is only possible if you’re not dodging (being airborne is ok, but not initial jump)
Press R1 right when the Boomerang arrives: Instant Rethrow
Does not buff and instantly rethrows it in the direction the camera is facing (i.e. a normal rang throw)

L1 + Move Left Stick: Step Dodge
Moves player a slight distance while standing up
Dodging the boomerang buffs it and/or Cotu
Causes top rocking and flips (don’t use animations with long startup time)
While running forward:
1 - straight legs flip
2 - webster
While running forward and sudden pivot to the side: cheat gainer
While running forward and sudden pivot backward: back handspring
While running to the side:
1 - aerial evade
2 - front twist flip
While running back:
2 - front twist flip

O + Move Left Stick: Duck
Moves player a moderate distance while ducking
Dodging the boomerang does not buff it
Boomerang cannot be touched while ducking
Causes go-downs, footwork, slides, and rolls

X + Move Left Stick: Jump
Moves player a high vertical distance and a moderate lateral distance
Dodging the boomerang does not buff it but sends it higher
Touching boomerang while airborne catches it


Special Moves

Sequence of L1, O, and/or X: Special move
Finishing a certain set of inputs right as the rang hits you causes a special move, which puts all of your buffs on the line in exchange for an opportunity to combo
[Homing combo inputs]: Homing combo
Rang flies directly to ~5 enemies before returning to Cotu
Rang takes the same amount of time to fly from one enemy to the next
If player presses R1 right as the rang hits an enemy, the hits gets a damage bonus
Time between R1 inputs is equivalent to 8th note timing in the current song
Rang explodes upon impact with each enemy, dealing AOE damage
[Rapid orbit inputs; harder than homing combo inputs]: Rapid orbit
Rang (as is) flies multiple revolutions around Cotu at high speed
Requires no inputs during the move but cannot hit faraway targets
[Hyperrush combo inputs]: Hyperrush combo
Time stops and player chooses a single target in sight (no choosing targets behind obstacles)
Rang (as is) flies from Cotu to the enemy back to Cotu in rapid succession
Player has to press R1 right as the rang hits the enemy, then L1 right as the rang hits Cotu in order to get viable damage
Time between R1 and L1 inputs is equivalent to 16th note timing in the current song, making this combo extremely difficult
Causes power moves (e.g. air flare)


Primary Game Elements

Character (Cotu)

Appearance
Generic black mannequin
Wears a black hoodie and black sweatpants
Has 2 floating glowing white rings for eyes
Has a glowing white mark on his back that houses the Boomerang
Perhaps has a glowing white silhouette to make him stand out against dark backgrounds
Face changes for certain situations
Sometimes makes Liam Vickers XD face when ducking towards an enemy
Makes surprised face when narrowly dodging an enemy attack
More glowing cracks = less health (aka stability)

Skin ideas
Latra: coyote head and pointed eyes, wears a hoodie with hood down
Stretch goal: make mouth expressive
Comma: girl wearing sweater; eyes are same as default but with points coming from the bottom like commas
Refined: guy wearing dress shirt, dress pants, overalls, and a fedora
69: same body as Comma but with sporty clothes, and one eye has a point coming from the top instead of the bottom like an apostrophe
Regal: long ceremonial-looking ornate badass cloak + fancy canine mask. Earned by reaching the final gala battle


Boomerang

Different types fly in different ways
Roserang
Travels in a rose path specified by the polar eqn:
radius = max_radius * sin(petals * angle)

All rangs:
Travel back to the Target
Merge with Cotu when he’s not dodging
Miss and travel back towards Cotu if he dodged

Buffs
Damage

Buff Ideas
Explosion upon contact with anything
Rang does AOE damage around it
Enemies in AOE field take damage over time
Slow down/freeze enemies
Damage over time
Autotargets enemies
Multi-rang
Get bigger
Change arc size
Higher arc radius
Knockback
Destroy projectiles
Gravity (pulls enemies and possibly objects towards it)


On-Character UI

Icon
Big white polygon
Thick borders surrounding a hollow inside
Slightly taller than Cotu
Represents Cotu’s motion and health
Floats and follows behind Cotu’s back; the face of the polygon is parallel to Cotu’s back
Rang Pointer
Small pink/blue triangle whose face is parallel to the ground
Points towards the Boomerang, allowing the player to see where it’ll come from when it’s offscreen
When the rang isn’t thrown, rang pointer points in the direction the player’s camera is aiming in
Color of the triangle represents how far into the current loop the rang is (pink = just started a new loop, blue = almost at end of loop, indicating that Cotu must dodge or else he’ll catch the rang)

Behavior
Follows closely behind Cotu
Stops following Cotu when he dodges, at which point the Target becomes stationary until the Boomerang hits the target, at which point the Target follows Cotu again


Score/Combos

Combos
Performing 3 moves consecutively without catching the rang will start a combo
Moves include:
Dodging the rang (i.e. rang hitting the target and not Cotu)
Instant rethrow
Different combo lengths will replace Cotu’s basic run animation with different dance animations

Scoring
Get points by performing moves and hitting/killing enemies
Bonus points for hitting/killing enemies with roserang in ricochet mode (not return mode)
The higher your combo length, the more points you get per move/hit/kill
Stale moves: using the same move too many times in a row will cause it to yield less points
Points as currency: having more points than certain thresholds grants you access to new abilities (e.g. rang buffs)

Penny’s Big Breakaway style display: shows your current score, combo length, the last x moves you used (e.g. front twist flip, webster), and every time you hit/killed an enemy
Display be turned off or set to only display score and combo length
Moves you used will be highlighted in a different color than times you hit/killed an enemy


Music

Notable Garageband Instruments:
Percussion
Silverlake: really great EDM/dubstep drums
Melody
Classic Super Saw: powerful techno melody
Power Fifths: powerful techno melody
Simple Physics Piano: sounds like rave music
Hypnotic Synth Bass: sounds techno/enchanting
Harmonic Synth Scream - High Gain: electric guitar on overdrive
Breathless Pumping: hard rave music
Harmonic Synth Scream - Distortion: techno cello
Background Buildup
Particle Accelerator: super intense techno
Cymbal Swell: horror sound
Big Moment
Plasma Drop: byooowwewewewewewe
Theme
Texture Machine: old-timey film grain
Lush Arp Layers: quirky swish and ploink sounds
Shimmering Voice Texture: shimmer noise
Neon: quick laser/whistle sound

Champion of the Universe
To change for in-game version:
Try adding more bass to the melody at the beginning hype part
Try adding high-pitched ambience during final buildup section of dubstep part
Make du-du-du significantly louder and organ somewhat quieter during organ+synth part

It’s Just You
Garageband Instruments:
Percussion - Birdland Cuts
Melody - Pensive Pluck
Melody Background Tone - Connect Chords
Chords - Distant Drift Synth
Secondary Melody - Carbon Particles
Tiny Bits - Tight Chord Pattern
To change for in-game version:
Make percussion a bit quieter
Make middle longer
Add more percussion style
Decrease volume of the ending (perhaps by not normalizing audio in iMovie)

Heat Death


BIZARROBOT


Instruments:
Quick buildup: Ocean Waves (check settings on instrument itself to make changes)


Level Ideas

Arenas
Player has a set of levels to choose from, each w a different game mode and objective
The player’s performance on each level is rated from 1-3 stars
To unlock the next level set, the player must earn a specific amt of stars from the current and all previous level sets

Random Board
3x3 grid of rooms
Each room contains a randomly chosen enemy set and a randomly chosen environment element
Player must complete an objective related to the board
Find a wanderer wandering through the board
Find an exit
Some doors are now locked, forcing the player to find a key/keys, then backtrack through the rooms
An entity follows them after they get a key
Player can see time before entity arrives
Player can bet currency on their success
Enemy sets:
Ball miniboss
Spawners
Environment elements:
Giant central hole
Some enemies are susceptible to knockback
Bottomless cliff borders
Rising lava w pillars
Pillars that rise up and fall over in one direction, dealing massive damage
Gun on the ceiling on rails that shoots lightning balls
Lightning balls move very slowly and deal significant damage to certain enemies
If Cotu goes to another room, the gun goes to a spot where it can shoot at the door, then starts firing when Cotu’s close to the room’s door again
Electric floor that gives Cotu super speed (run speed becomes at least as fast as dodge speed)

Army
Enemies continuously spawn from the edges of the arena
Each enemy has their own health and can die, but all enemies share the army health bar
When army’s health bar drops to 0, all enemies instantly die

Giant Bowl
Bowl with descending flat ring platform layers
Cotu starts on the rim, then jumps down layers of the bowl to get to the center while enemies attack him
Center of the bowl goes to another level segment









Boss Progression Tree

Version 1: Everyone Is Isolated, Goal is to Train Cotu

Potential changes:
Destroying Centipede can unlock Darkness
Getting a Super Badge can unlock Triplets
Surviving Clarity can unlock Angels
Defeating Clarity can unlock The Edge and Darkness

Version 2: Gauntlet Gyms and Realms, Goal is to Get to the Gala


Gameplay Progression: what does each level/boss make you do?
Each element of the fight is rated by difficulty from 1 (or in special cases 0) to 5. Higher difficulty = more complex solution & lower margin for error
Gauntlet Variant 1: 4.5/20
Evasion: 1
Primarily running
Dodging is useful but optional
Positioning: 1
Stay away from melee enemy threat ranges
Not very strict since all attacks are easily strafed or spaced (“spaced” = dodged by backing away from enemy)
Aim: 1
Very little precision is necessary since targets are everywhere
Grounded aim is occasionally helpful against shields and gunners
Homing is completely optional (except for gunners on high ground, which are trivial)
DPS: 1.5
Optimal DPS is irrelevant since enemies have low health. The only exception is when the miniboss spawns, where it’s best to kill it before additional enemies spawn. Miniboss + enemies is challenging, but not super challenging since keeping distance from the enemies is so effective
X: 9/20
Evasion: 2
Lots of running
Some dodging is necessary
Positioning: 2.5
Stay away from his melee threat range. Dangerous but not fatal since you can dodge
Keep him within your optimal DPS range (middle to end of rose petal), which has a sizable impact on DPS
Stay within arena bounds
Stay away from head piece bombs
Aim: 2
Good grounded aim is necessary since there’s only 1 small target, but you can use the rose, which makes hitting him a lot easier
Homing is helpful and makes a good difference
DPS: 2.5
Optimal DPS is necessary or else you won’t finish him by the end of the time limit
Clarity: 11.5/20
Evasion: 3.5
Running is useless
Well timed dodges of her arm, dress shards, and minions are necessary
Positioning: 3
Stay in the narrow safe ring between the outer blizzard and her head snowfall. She largely does this on her own since she circles around you
Stay away from her minions’ snow clouds
Avoid her dress shard combos; this would be rated higher if not for the fact that you can stun the snowflake to stop the combos
Aim: 3
Requires precise aim and timing to hit her small weak spot right before her attack. You cannot rely on grounded weapons sweeping the area since the weak spot’s too high up
Head and snowflake are moving, but they’re slow and well within throwing range
Dress shards and ice sprites are distracting
DPS: 2
Optimal DPS is important since, if you take too long, the blizzard safezone disappears. This isn’t as urgent as X’s time limit; whereas with X the fight immediately ends, here you can regenerate with stabilizers even when the blizzard is constantly dealing damage
Optimal DPS isn’t as emphasized because the fight wants you to take your time, be patient, and wait for the perfect opportunity to attack. BUT if the time limit were abandoned entirely, the player would probably be confused and feel like the game’s inconsistent


Tasks

Deliberately Unsolved Bugs List

Both paramites and landmites use paramite meshes from Paramite.glb, but only landmites have the MeleeHitboxPivot, TongueMesh, and EnemyHitbox nodes, yet both mites have the animation tracks for these nodes since they share the same meshes. Paramite’s anim player and anim tree try to access these 3 nodes but find nothing. To fix this, I could add MeleeHitboxPivot, TongueMesh, and EnemyHitbox to paramite, but since the mite level already struggles with performance due to the high number of enemies, I decided to not add 3 extra nodes to each paramite just to silence the error messages

Bug List



Solved Bug List
(most recent at top)
Roserang homing attacks target mites underground
Caused by roserang hitting a mite, then it dies and moves underground, then the roserang follows it underground
Solution: mites wait 1 sec after dying before going underground
Jumping spider spawns invisible sometimes
Solution: instantiate spider inactively when level loads like all other enemies, then set it active when JS wave begins (instead of instantiating it when wave begins) to prevent weird instantiation func call inconsistencies. This required making actual set active code (before, it was an empty func just there to cooperate with mite level main arena code)
Jumping spider goes under the ground after touching the ground in leave-descend state
Attempted solution: moving spider up some units from ground
Doesn’t work even when spider is moved 1.5 units up from ground
Potential solution: do the harvestman solution and wait a moment to give proc anim meshes time to adapt to JS’s position
Teleport spider to ground, then wait 1 or a few physics frames, then activate proc anim meshes IK
This didn’t work for some reason, I tried waiting 5 physics frames max
Solution: when spider ascends/descends, make the real (nav agent) spider invisible and intangible and stand still. Meanwhile, a fake spider mesh with no collision ascends/descends
Upon reaching ascend point, main spider becomes invisible and intangible and mouth hitboxes are disabled
Fake spider mesh, a child of the spider parent, becomes visible, performs ascend anim, and ascends
Proc anim meshes can serve the role of fake mesh during the ascent, but not during the descent bc proc anim meshes needs to have confirmed grounded leg positions during descent, so we might as well make proc anim meshes stay grounded throughout ascent and descent
When switching to wait state, descent pos is decided and the main spider (still invisible and intangible) navigates to the descent pos
When descend begins, fake spider mesh performs descend anim and descends from the sky onto the invisible main spider. Once the fake spider is close to the main spider, fake mesh becomes invisible and real mesh becomes visible
Jumping spider chases a stationary point instead of the target in attack chase state
Solution: decrease path point desired distance (spider was chasing path point, but was always too far from it bc the path point desired distance was too low)
When spawned from an egg, harvestman sends itself deep underground or high in the sky due to initial avg IK position being miscalculated
Solution: waiting a moment before activating harvestman process and physics process (about a physics frame) to give it time to move to the egg’s pos (from deep underground, where it resides when it’s inactive/dead), then waiting another moment (about 2 physics frames) to give it time to move/update its raycasts before starting IK. Also, proc anim meshes script must make harvestman step when activating IK to update IK target positions
Avg IK pos is miscalculated bc the leg RayCast3D nodes aren’t detecting any collisions, likely bc disabling the outer Harvestman parent node also disables the inner RayCast3D nodes. However, even after setting the child RayCast3D nodes’ process modes to ALWAYS and setting their process and physics process states to true, AND calling force_raycast_update and force_update_transform in both process and physics process inside the ray script, AND setting enabled and collide_with_bodies to true every process frame, AND setting ray’s process mode to ALWAYS in the ray script, the rays still don’t work. This can NOT probably be fixed by doing rays with code instead of a node because there’s no functional difference in the implementations
Minor similar bug: jumping spider also went deep underground when placed in the level (not spawned in), and its IK targets didn’t move (legs always pointed to the same points). Fixed by making it use the align_body_to_slope script code, which set its body meshes position relative to its body’s raycast to the ground, not its feet raycasts (which probably were stuck underground when the spider was spawned in for some reason)
Walker instantly turns to face the player after step flip to upbowl anim
Solution: reduce attack turn speed dramatically by multiplying attack turn speed by physics process delta
Restabilizing, then using any stability afterward (or getting hit), will instantly destabilize you even though your health bar appears full
Solution: set max health and health to 1 before going invincible, instead of after. 
Original sequence of events: destabilize → go invincible → restabilize → max health and health are restored → go vincible → max health and health are set to 1
Solution sequence of events: destabilize → max health and health are set to 1 → go invincible → restabilize → max health and health are restored → go vincible
Melee enemies do a fast twitch back to their walk blend space after whiffing an overhead melee attack (instead of smoothly transitioning from one pose to the other)
Solution: several changes to AnimationPlayer and AnimationTree:
AnimationTree uses the VisualMesh’s AnimationPlayer, not the actual enemy node’s. The VisualMesh’s AnimationPlayer then calls the enemy node’s animations for hitboxes
The end_attack func, which allows the enemy to switch states from attacking to walking, is called slightly before (about 5 frames at 60 FPS) the end of the animation, preventing the enemy from immediately starting another attack at the end of the attack animation
Xfade time is used to transition from attack to walking anims and vice versa
Enemies aren’t rotated correctly in PillarRoom and TopGunBattlefield bc the section nodes themselves are rotated, and the enemies’ rotations are children of the section rotations
Solution: make enemies use Global Rotations
Enemies don’t rise with the elevator when they’re attacking, and enemies sink into the floor when their capsule colliders rotate to look at the player
Both fixed by only setting enemies’ velocity x and z to 0 while attacking (instead of x, y, and z) and only changing enemies’ y rotation to face the player (instead of x, y, and z)
Enemies try to attack you through walls
Fixed by setting target desired distance to .1 (a generic small number) whenever the enemy cannot see you, then setting back to normal when they can
When rang Returns to Cotu and switches back to Rose mode, it bounces off of Cotu sometimes instead of going thru him
Caused by multiplying angle_speed by -1 in set_direction func instead of setting angle_speed to the correct value it needs to be depending on which direction Cotu’s walking. Multiplying angle_speed by -1 causes the current angle_speed to depend on which direction Cotu was walking in during the initial throw, rather than only being dependent on the direction Cotu is walking in when the mode switches back to Rose after Return.
To provide additional context, angle_speed being the wrong sign causes the rang to move in the opposite direction it should be, making it look like the rang just bounced off of Cotu
Fixed by setting angle_speed to the correct value it needs to be in set_direction instead of multiplying
If you dodge the rang while it's in Rose Mode and it ricochets off a wall immediately afterward, its velocity becomes extremely high, making it shoot off far away and making the Return Mode take forever
Not exactly sure what caused this bug, but at the time this bug occurred, the rang did not return to Rose mode correctly; instead of the current and initial angle values being adjusted for the new trajectory, it kept the same angle values it had before, making it teleport to the position of the previous Rose mode. This teleportation likely caused it to teleport into level colliders, then get pushed out of them at a high speed, making it shoot out super fast
Fixed by fully implementing the transition to Rose mode, which I would have done regardless of whether this bug occurred or not, so this wasn’t really a bug but a showcase of what would happen if this feature wasn’t implemented fully
If Cotu doesn’t move, and the spawners spawn the second wave of enemies, Cotu is either teleported forward (at spawn delay = 7 seconds) or launched hundreds of feet into the air and laterally away from the arena (at spawn delay = 2, 10, and 20 seconds)
Cotu stands at around (0,0,0) in the world at the beginning. Whenever an enemy is instantiated, it’s created at around (0,0,0) in the world. The game then detects a deep collision between Cotu and the enemy, so the game overcorrects this by launching Cotu away into the air. It seemed like Cotu was teleporting into an enemy earlier bc the enemy was actually saving Cotu from being launched out of the arena by bodyblocking him
This bug also includes an additional bug where enemies can be seen flashing at a certain spot on the ground as soon as a new wave of enemies spawns; these flashes are the enemies spawning, then immediately being teleported to the spawner locations
Fixed by moving the entire arena (along with Cotu’s original spawn location) upward so it’s now above the place where enemies are instantiated
Sometimes the rang hits Cotu while the target is stationary (after a dodge), causing the target to stay in place until the rang is thrown again
Partially fixed by having the rang tell the target to start following Cotu when the rang hits Cotu; bug is now more rare
Fully fixed by having Cotu constantly tell the target to follow him as long as the rang is gone (bug explained in Godot Notes Journal of Hurdles)
X’s Head is moved back (on X’s local z axis, where the z axis is the axis from X’s front to his back) when the SemicircleDashTP animation happens
Fixed by resetting x meshes’ rotation.x after the anim (the anim originally changed the rotation.x for the semicircle dash from -.17 to .17, then left it the same instead of resetting it to 0). Strangely, the rotation.x not being reset didn’t affect the rest of X’s body; just the head
After grabbing Cotu during the DashGrab anim, X is stuck in the end of the DashGrab anim instead of immediately transitioning to the DashGrabPunish anim.
What didn’t work:
Setting transition time from 0 to .15 secs for transitions to both DashGrabPunish and DashGrabWhiff
Setting switch mode of transition to DashGrabPunish to AtEnd instead of Immediate (immediate is intended, as the DashGrab anim should end right when Cotu is grabbed)
What I tried next:
Using a var declared in the x_boss script as the advance expression to DashGrabPunish instead of Globals.XBossGrab, which may not be detected right away since it comes from a separate script (but rng.randf works?). Globals would then send a signal to update the x_boss script var
First try using a var that isn’t controlled by a signal
This worked
Fixed by making the advance expressions for DashGrab transitions check a func that then returns Globals.XBossGrab, rather than using Globals.XBossGrab directly in the advance expressions. For whatever reason, using Globals values (ie values from an autoloaded script) doesn't work for advance expressions in anim trees.
Bug Turned Feature List
You can lock onto enemies through walls; shouldn’t be an issue since there’s no reason to hide enemies at all

Playtester Questions



Polish List
Make rose and ax throw charges cancellable by dodging
Frostbite effect text (like a mini version of DESTABILIZED)
Cotu grounded main anims
Rose normal throw
Ax normal throw
Ax perfect throw
Hoverboard anims
Rose normal throw
Rose instant rethrow CW
Rose instant rethrow CCW
Ax normal throw
Ax perfect throw
Cotu grounded ax dodge rethrow anims
Overhead throw anim for flip
Side throw anim for spin
Thrill Fireball Aesthetics
Redux UI
In case you forgot, redux is an unlockable skill that allows Cotu to temporarily keep axrang buffs after an ax special if an enemy was hit by the ax melee
Add sparks, a color change, or some other effect to axrang buffs to show that they’re here bc you hit something (they look rewarding) but will disappear soon (show mvmt or urgency)
Idea: add a timer to show how much time exactly is left before the buffs disappear
Alt idea: make color, brightness, or particle effects pulsate more frequently over time
Roserang code upgrade
Make roserang throw/catch code more like axrang throw/catch code
Instead of using physics process to check if the roserang was just caught (i.e. roserang == null), make and use on_catch_roserang, which connects to a “caught” signal from the rose
Roserang particles upgrade
Make particles last longer like glintstone spell particles in Elden Ring
Make particles linger even after the rang ricochets and is caught
Cotu himself contains rang particles. When the roserang is in flight, his script activates the particles and moves them to the rang’s position
Clarity polishing
Make snowflake “tattoo” on underside of hat (and possibly beyond) materialize in an intricate animation as the head tilts up and starts glowing
Make Jump Shot start from the correct pose (WalkLeft instead of WalkForward)
Ice sprite spawner
Idea: each hexagon rotates in a random direction upon appearing instead of following the same patterns every time. Hexagons still grow and shrink back to nothing
With the overlapping hexagons and random rotation axes, the shapes/patterns look irregular, which makes them look ugly like a bunch of floating spaghetti. Try experimenting with very high nums of hexagons
Make the # of hexagons a parameter in ice_sprite_spawner to experiment with different hexagon amts
Adding some more hexagons (up to 24) increased the irregularity and made the spawner look worse, but adding a lot more hexagons (up to 120) made the spawner look more uniform. However, it still looks basic and ugly. For now, the best case is still just 6 hexagons
Try adding a background glow sprite to make the spawner look more layered→ this helped
Try making hexagons rotate about their local x axis to make the shape more concrete and uniform → this helped
Try making the center of the spawner an icosahedron to add structure → this also helped
Make particles appear when spawner is boosted
Current task (polish)
Make semicircle dress shard attacks look smoother; currently the shards jitter
Ice sprite lingering explosion hitbox has particles and fog
Mite Level Polishing
Give landmite a separate glb import instead of making paramite and landmite share the same meshes. This way there won’t be errors with missing anim tracks in paramite
Program landmite/paramite walk anim (Procedural anim video progress: complete)
At 7:22, how do you calculate the average normal for 8 legs instead of 4? Try only using 4 legs to calculate the normal like in the vid and just ignore the other 4
Animate landmite actions
Bite
It shouldn’t matter that there’s keyframes for the legs; the SkeletonIK3D nodes’ IK simulations should override it
Leap
Animate paramite actions
Glide
Flip
Leap
Animate paramite suspension threads (thin wire that paramite hangs from)
Animate flatmite actions (it doesn’t use procedural anims)
Run
Leap
Make anims play with anim tree instead of anim player
Landmite
Paramite
Flatmite
Make mites reorient and adjust their height based on the angle of the plane they’re walking on (in ParamiteProcAnimMeshes script)
Allow flatmite to run so fast it can go flying off the slope it’s on
Make paramites rotate smoothly when following but randomly spin when retreating, making them look panicked and disoriented
Mite attacks with front legs and jaws instead of a tongue stab
Front pairs rise menacingly and mouth opens. Feet converge at a point in front of the mite, pulling the prey to the mouth that closes
Consider making the hit stop the player’s mvmt
Consider making the arena one big tube instead of a mouth with jaws
I like this change because it fits the mites’ theme more: a ton of creepy enemies in a small crowded space. The arena having open walls conflicts with the feeling of horror and claustrophobia of being in a pit of mites. Keep the mite mouth asset for other situations like cutscenes or a faraway environmental setpiece
Create a separate mite mouth blender project so you can use the mite map experiments blender project for the tube
Try lining the walls with eggs and keeping the ceiling just pitch black instead of visible, so it can be more mysterious how the paramites move around
This arena design puts a lot of emphasis on the eggs, which means the egg models have to be really good for the design to work. Save this for further polishing later
Consider not having the jumping spider as the boss of the mite level since its gameplay is so different from the enemies’. It was designed as a gimmick boss, so don’t put it in a non-gimmick level
Idea: jumping spider is the true ultimate warrior of the mites, and is being saved for a more serious or special scenario (possibly the gala?). The mite level only consists of simple infantry and a much easier boss: the megamite
Alt idea: the jumping spider goes rogue from the rest of the mites, and they scour the surrounding area to search for it. The spider ends up on Cotu’s ship and befriends the crew
Texture jumping spider
Try coloring its faces a random assortment of black, gray, and brown
Try coloring it just gray
Replace jumping spider front hitbox with grab anim
On second thought, don’t do this since the player should be allowed to make mistakes against it without losing player control for a long time
Web textures
Spitweb (projectile fired by paramite and flatmite)
Bigweb (web released from bigweb egg dropped during jumping spider phase)
Remake level from the ground up to get fog to appear correctly (it’s always been just a color filter instead of properly obscuring faraway elements)
Make web and egg deletions happen through manual timer code instead of tweens to prevent error messages/overhead caused by deleting a node with an active tween
Paramites run to and jump from high ground instead of the arena center, making them harder to kill
Egg break particles/anims
Idea: egg explodes and fades out into tiny particles and dust, suggesting that it was made of mites or some other tiny material
Ground texture
Make Cotu’s running dodge more clear that it’s a dodge (at the time of writing this, he puts his hands behind his back and bends forward)
Axrang overhead slam, arc slash, and melee hitbox increase in damage for every damage buff the axrang has (do this once you add damage indicator UI)
Improve enemy hit effects
Try giving enemies blood particles like in Terraria
Rang hit sparks
Create cartoony enemy hit effect animation like in Risk of Rain
In Blender GreasePencil maybe, create a white circle that compresses into a point, then shoots white wisps out to the side
Instead of a cartoony hit effect, try just releasing a bunch of white particles
Make X’s Volcano shockwave an expanding torus instead of a bunch of sparks
Give Mega Bullet a makeover
Make it skinny
Make it pointy in the front and flat in the back
3 hexagons spawn at the back of the bullet one after another; they start big then twist and shrink as they move towards the front
Make enemy hit SFX
Make gauntlet enemies stagger when they’re hit
(Optional, only do this if performance is poor) instead of instantiating objects and deleting them (especially enemies), try putting them below the map or hiding them before they need to be spawned
Add footstep noises using the footsteps addon from the AssetLib https://www.youtube.com/watch?v=zFgYhZyGRw0
Cotu gauntlet
Cotu snow
X Polishing
Make Sweep look less awkward (smoother chest mvmt)
Make X dodge to the side when Cotu throws a non-shuriken rang. He can only dodge 1 time at most after each of his attacks
Make an expanding/contracting cube at X shoulder joints whenever he reattaches an arm
Decided not to do cubes for when he detaches an arm to make detaching his arms look more nonchalant and natural
Reattaching arms has a bigger emphasis bc it implies he’s going to do something with it, which usually does much more damage than what he does when he detaches an arm
For X’s pose during RightArmSlice after he swings his blade once, make the pose stand out more by adjusting his posture and leg position. He currently looks a bit static/plain
Give X screen shake
Make X’s face shift around a bit when he recalls an arm
Make X explosions look more fancy
Make 8164 recover both of his arms and contract his face before the beginning of the fight, perhaps in a “FightPrep” anim
Make FakeCotu use a new FakeXBossGrab anim instead of the real XBossGrab anim so you don’t get a ton of errors
Make FakeXBossGrab anim in Blender
Delete that note at the top of the doc explaining the errors
Give 8164 a shockwave ring when he ascends for LungeFacerain if the dist he dashes is above a certain threshold
Fix X Icon teleporting to its positions sometimes - as it turns out, this is likely caused by lag, so it’s not a bug to be fixed
Add straight dash attack to force player to react to whether he teleports or not (just an idea that should be tested)
There are some reasons why this may be bad: X is an early game boss, and the player already needs to keep track of him, the lasers, the rang(s) (mostly the rose), and the bombs. With so much to keep track of, adding reaction-based gameplay might feel unfair. But the game should feel challenging as a whole to the average player, not easy, so the skill floor should be high enough to reflect that. Also, X is a gatekeeper boss: he tests the player’s ability to react to the boss and manage the rangs and keep track of the environment. Create a dash attack and try it out, and if it makes the fight more fun, keep it
The above idea was rejected due to being too difficult for new players. Empathize with a new player; even if they are comfortable with attacking and dodging, they have no idea what X does or what his attacks are. The player will most likely consider X’s dash forward as a threat and dodge it at first, then eventually come to the realization that the dash doesn’t do any damage and is just a distraction for the followup, which is corroborated by the fact that the dash anim has no orange elements (orange = damaging). With X not having straight dash attacks, the player gets the satisfaction of realizing how X works, and is granted an easy success for figuring it out for phase 1. The player then adapts their knowledge of the first phase to anticipate attacks in phase 2.
Try adding horizontal dodge (mostly for phase 1)
In Follow state, if Cotu throws the rose normally or with an instant rethrow and the angle btwn camera’s fwd vec and the vec from Cotu to X is within a certain threshold, X does a left or right dodge depending on whether the rang will be thrown to the camera’s left or right
X reads Cotu’s moving_right property to know which direction to dodge in
In Follow state, if Cotu throws the ax and the angle btwn camera’s fwd vec and the vec from Cotu to X is within a certain threshold, X does a left or right dodge. Direction of dodge corresponds to whether the angle difference is positive or negative (abs is only checked to know whether to dodge)
Consider removing the spawned diamond from Strafe Slice (CORRECTION; under normal circumstances, X never collides with the Strafe Slice diamond)
Diamond adds a layer of complexity and difficulty to the attack, but with some consequences:
Option 1: X bumps into the diamond when he slices, making him look silly and breaking immersion
Option 2: X passes through the diamond, which betrays both X and the diamond’s solid, non-holographic forms
In both cases, the diamond also makes it more difficult to see where X is, unlike the other diamond attacks where the diamonds are out of the way (Triangle, Dual Blade Dash, Semicircle Dash Grab)
If X very rarely runs into the diamond, this isn’t an issue
^ X never runs into the diamond. The 1 or 2 times he did was caused by intense lag
Try adding orange smoke to the background to look like nebulas
Try making background diamonds appear in flashes over time instead of all spawning in when the level loads
Idea: they continuously spawn at a consistent rate in phase 1, then spawn rate increases in phase 2. Spawn rate stays the same until diamond limit is reached, at which point diamonds simply stop spawning
I decided that the large ones would all spawn in at once, then the small ones would spawn in intermittently/more slowly
Make Lasercombo Big X not follow X when he does the final kick
Make all square particles into diamonds (just rotate all squares 45 deg)
I had to make a new diamond mesh in Blender and import it
Add shockwave ring to laser combo ball when the laser is fired
Add SFX
Add music
Give FirstMiniboss some particle effects
Particles on boss’s eye when charging up a bullet
Eye color changing from red to yellow while charging a bullet
Make spawners boxes with spinning squares
Make MT1 and MT2’s overhead attacks properly put the sword between their hands (it currently is inside of their right hand)
Front Twist Flip: make arms and posture return to run pose more slowly/smoothly
Aerial Evade: make arms and posture return to run pose more smoothly
Make final leg pivot to the 1st run pose (“final” = beginning of animation bc it plays backwards), i.e. the last 2 keyframes, take a total of 12 frames (= .2 seconds, the original Xfade time)
Stop arms from flinging out near the end (beginning of the animation, end of the animation in-game)
Give aerial animations/poses their own Blend Space, which transitions into AirDodge
Remove the ending (in the file, it’s the beginning of the animation) landing on 2 legs followed by the pivot from the AerialEvade animation so that the final spin feels more snappy
Improve performance in HallwayInvasion
Try using 1 directional light instead of a bunch of OmniLights
This helped a bit, but not enough to reach 60 FPS
Try reducing mesh geometry and mesh overlaps
Try using LightmapGI
Rework FirstMaze into a sort of continuation of HallwayInvasion bc FirstMaze sucks ass

Music Tasks
Blackstar: make post-2nd trap buildup phase
Centipede: make final phase

Code/Engine Tasks

Code Duck
Make quick placeholder animation
Make movement code
Code Jump
Make quick placeholder animation
Make movement code
Rapid Prototype Boomerang Movement
4 phases:
Chase phase: rang goes straight to target (like Chaser Rush)
Overshoot phase: rang passes thru target and keeps moving in a straight line
Circle phase: rang travels in a circle until its movement is pointing somewhat towards the target, at which point it switches to homing phase
Throw phase: rang goes straight for a while, then switches to circle phase to return to Cotu
Make Cotu catch the rang after touching it

Make boomerang parameterizable w/
BPM
loop dist
circle radius
chase/overshoot/circle/throw durations
Based on these params, the boomerang’s speed adjusts itself automatically
Vocab:
Loop dist = length of loop in pixels
Loop secs = duration of loop in secs
____ duration = proportion of total loop time that rang spends in ____ phase
Speed at every frame (in pixels / sec) = loop dist / total secs in loop (based on BPM)
Loop secs = 120 / BPM
Dodge every 2 beats
Loop dist
All phase durations are parameters
For all phases except chase, speed = loop dist / loop secs
For chase phase, speed = current dist from rang to target / current time remaining in chase phase
Regardless of the loop dist, circle radius, and speed in other phases, the chase phase will bring the rang to the target in (chase duration * loop secs) secs, ensuring that the loop lasts the same amt of time every time

Get the rang to have perfect synchronization with its music
Try the rose equation for movement; create a new Node called the Roserang
BPM to angle speed?
Time it takes for rang to complete a petal (i.e. loop secs) = 120 / BPM = 
Time for radius to reach 0 = 
Time for max_radius * sin(petals * angle) to reach 0 = 
Time for sin(petals * angle) to reach 0 = 
Time for petals * angle to change by PI;
petals * angle = petals * speed * time = PI at time (120 / BPM)
petals * speed * (120 / BPM) = PI
Solve for speed:
speed = PI / (petals * 120 / BPM)

Try implementing the boomerang in Godot 3D
Basics of Godot 3D: https://www.youtube.com/watch?v=sVsn9NqpVhg
Add the roserang
Add Cotu dodge
Add the target
Try connecting the PS4 controller to the game and testing the controls
Allow Cotu to throw the rang in any direction using angle offsets, i.e. the eqn r=max_radius*sin(petals*angle+offset)
The tip of the first petal of the boomerang’s flight path will point in the same direction as the direction Cotu is facing
m = angle that Cotu’s looking in
n = initial angle offset (the offset in r=max_radius*sin(petals*angle+offset))
From Desmos logic: n = -5m + 2.5PI (petals = 5)


From experimenting in Godot: initial_throw_angle = petals*cotu.look_angle + initial_throw_angle_offset
initial_throw_angle = n
cotu.look_angle = m
initial_throw_angle_offset = y-intercept of linear relation between m and n = petals*PI+.09 in Godot
In numbers, n = 5m + 5PI+.09 (why? idk, but experimentation has yielded consistent results)
This method sort of works with other petal nums; you have to change the initial_throw_angle_offset from petals*PI to petals*PI + some float you derive from experimentation. For petals=5, this float is .09

Design Enemies
Melee Tier 1
Follow Cotu directly
Also avoid obstacles and each other (done with NavAgent3D)
Straight attack
Overhead strike
Die in 2 unbuffed/1 buffed roserang hit (assuming direct damage buff)
Melee Tier 2
Follow Cotu directly
Straight attack
Sweep attack
180 degree arc sweep parallel to ground
Die in 3 unbuffed/2 buffed rose hits
Mobile Gunner
Follow Cotu directly
Get within range, then shoot
Stationary Gunner
Gunner who doesn’t move
Shield Humanoid
Follow Cotu directly
Attacks to their front will bounce off
Rang must hit them from behind
Die in 4 unbuffed/2 buffed rose hits

Try creating an enemy using NavigationAgent3D
Behavior:
Walk to Cotu, then stop
After reaching Cotu, attack
Avoid obstacles and each other

Try putting environmental elements
Pillars

Try making the boomerang pointer

Try making the lock-on system
Press L3 on PS4 controller/right-click on mouse & keyboard to lock on to the enemy closest to the center of the player’s view

Make the attack/health system
Make Hurtbox/health manager Node (Area3D script with health managing funcs)
Make Hitbox/damage info Node (Area3D script that only includes info about this attack)
Give the rang a Hitbox
Make enemy’s overhead attack

Make prototype animations in Blender, then import them into Godot
Idle
Walk
Step Dodge
Recreate Front Twist Flip animation w/ new quaternion rotations

Experiment with enemy spawning and level design
Let enemies die in 2 hits
Make a quick death effect for enemies
Make a death_particle node that’s a little red cube
Upon an enemy’s death, instantiate dp_count death particles, give them random impulses, and make them children of the enemy node
The death particles disappear after disappear_secs seconds
Make an enemy spawner
Make a global list of collision layer names (saved in both Project Settings and a Globals script, allowing scripts to access layers by their names instead of by their nums)
Stop Cotu from colliding with enemies when he’s dodging
Rather than going straight through enemies like a ghost, Cotu now shoves them out of the way, leaving his movement completely unchanged

Allow the Player to look up without the camera going through the floor
Camera slides closer to the player as it’s pushed against the ground, then slides away as the player looks down again
Use Raycasts
With the Camera Twist and Pitch pivot setup in this video, you can make the camera collide with geometry with this code. To make it, I randomly experimented with the Vector3 values and the order in which I multiplied bases with other things, so I have no idea how this code works in precise detail.
var space_state := get_world_3d().direct_space_state
var cam_dir_basis = camera_twist_pivot.transform.basis * camera_pitch_pivot.transform.basis
var cam_dir_vec = cam_dir_basis * Vector3.FORWARD
var query = PhysicsRayQueryParameters3D.create(global_position, global_position - (max_cam_dist * cam_dir_vec))
query.collision_mask = Globals.make_mask([Globals.ARENA_COL_LAYER])
var result = space_state.intersect_ray(query)
if result:
camera.position = Vector3.ZERO
# Make the camera move slightly closer to Cotu after going to the raycast hit to prevent the camera from seeing below the floor
camera.global_position = result.position + .2 * result.position.direction_to(global_position)
else:
camera.position = Vector3.BACK * max_cam_dist

Make the rang’s angle direction change depending on whether the player is moving left or right

Implement rang buffs
After dodging the rang once, it now one-shots fasthuman enemies

Make individual enemies more threatening, then spawn less of them
Stop spawners from spawning when they hit the spawn limit (determined in the Arena, but checked in the spawner)
Every frame, the spawners check if the spawn limit has been met. If it has, they check again the next frame. When the spawn limit has no longer been met, the spawners spawn their enemies, then wait for the spawn cooldown to end before checking the spawn limit again
Make enemies more accurate with their swings
Stop attacking enemies from getting pushed by other enemies
Have enemies look at the target during the charge up, then stop looking at it when the swing happens
Give enemies a rare sweep attack
Sweep has longer startup but the same endlag/total attack duration
Sweep has 1/5 chance of being selected
Make gunner enemy
Duplicate melee enemy (BUT REPLACE THE ANIMATION PLAYER IN THE GUNNER WITH A NEW ONE)
Make bullet node
Make shoot animation
Make func that instantiates bullet node
Call shoot_bullet func in shoot animation
Make gunner play shoot animation instead of overhead or sweep when they come within target range

Rapid orbit prototype (I was considering working on score system prototype, but I think the score system’s less set in stone in my mind and is very subject to change depending on test feedback)
Rapid orbit prototype
Activated when you press K if the target is following Cotu and the rang is very close to Cotu
Create a script dedicated to rapid orbit movement (as opposed to rose movement)
Revolve around Cotu very quickly
Orbit radius increases over time
Rang disappears after rapid orbit, signifying loss of buffs
When rapid orbit is activated, the rapid orbit script replaces the roserang script on the current roserang instance, causing rapid orbit movement

Add instant rethrow
If you input throw right before the rang hits Cotu, instantly rethrow the rang. How early can you input throw for it to become an instant rethrow? As early as you can input parry in Sekiro before an enemy attack lands (⅕ of a second, or 12 frames at 60 FPS)

Experiment with level design ideas OR copy Aerial Evade animation
Experiment with level design ideas
Try a small room or narrow hallway
Copy Aerial Evade animation
Look at frames 40-165 of the Mixamo Aerial Evade, compress them down to 54 frames
Aerial Evade looks good, but only in reverse since its startup time is long
Make Aerial Evade animation play when dodging to the side, and have Front Twist Flip play when dodging forward or backward
Make Aerial Evade and Front Twist Flip start and end at the 1st frame of Run instead of ending on a frame that’s supposed to crossfade into Run to prevent the quick snap directly from Aerial Evade and Front Twist Flip into Run and to not use Xfade time, during which time no animation transitions may occur. The goal is to allow each dodge animation to be visually canceled when another begins, but this is only possible if Xfade time for all transitions is 0
Convert Run to Quaternion rotation
Copy paste the first frame of Run to the start and end of Aerial Evade and Front Twist Flip

Make the rang ricochet against walls
When the rang hits a wall, its reflected vel is calculated using the rang’s linear vel and the collision’s normal vec, then it travels in a straight line in its reflected vel and enters linear mvmt mode (possibly switches script to linear mvmt)
In linear mvmt mode, the rang only moves in straight lines until it hits a wall (which causes it to ricochet), hits Cotu (which destroys it), or if the rang is over halfway thru the current rose petal (if it continued to rose instead of ricocheting), at which point it flies through walls to return straight to Cotu
Rang completes 1 petal every time angle changes by PI/petals
Rang completes ½ petal every time angle changes by PI/(2*petals)
At start of linear mvmt mode (i.e. when script changes to ricochet), set ricochet’s angle property to roserang’s angle mod (PI/petals)
In ricochet script, if angle > angle_max (where angle_max = PI/(2*petals)), rang starts returning to Cotu
Make rang return to roserang mode if it touches the target
Change all scripts into a state machine
Fix the super launch bug

Make an Arena level prototype halfway done

Make a score system prototype: the rang doesn’t change score at all, only the things it hits does
Record point values for each score-rewarded action in the Globals script
Dodge
Instant Rethrow
Melee humanoid hit
Melee humanoid kill
Gun humanoid hit
Gun humanoid kill
Ricochet Hit
Rapidorbit Hit
Let enemies update score whenever they get hit or die
If an enemy gets hit, let them check whether the hitbox they got hit by was the roserang in ricochet mode; if it was, add ricochet bonus
If an enemy gets hit, let them check whether the hitbox they got hit by was the roserang in rapidorbit mode; if it was, add rapidorbit bonus
Let Target update score whenever rang hits it
Let Cotu update score whenever he instant rethrows

Level prototype
Rising platform
Spinning spawners that rise with the platform
Funnel in the sky
Set up TrenchBroom, FuncGodot, and textures
Cook. Cook so hard. And by cook I mean copy Trenchbroom and Quake: Building with Curves and Extrusion
Put little notches inside the funnel that allow the player to parkour their way up
Tools tutorial: How to make 3D levels for your Godot game! (TrenchBroom + Qodot)

Fix elevator enemy bugs

Set up elevator enemies
Create elevator-specific enemies derived from the Melee enemy class
Type 1 Enemy:
Dies in 2 hits normally, dies in 1 hit with rang buff
Very common
Zero sweep chance
Type 2:
Dies in 3 hits normally, dies in 1 hit with rang buff
Uncommon
Appears about 25% of the way into the fight
Low sweep chance
Type 3:
Dies in 4 hits normally, dies in 2 hits with rang buff
Rare
Appears a bit past 50% through the fight
Low sweep chance
Put enemies in appropriate spawners
Make spawners spawn increasingly difficult enemies over time (or spawn more difficult enemies after entering the funnel)
Make elevator sweepers: walls that spawn on top of the platform and move in a straight line, pushing everything in front of it
Make sweeper node
Spawn sweepers after about 25% of the way through the fight and stop spawning them when the elevator reaches the funnel
Spawn 3-4 total
Make sweepers spawn in the direction Cotu’s looking in

Make big flat arena right after opening room

Make buffs save when you instant rethrow
Rang keeps track of its own buffs, Cotu keeps track of both his own and the Rang’s buffs
Target buffs both Cotu and Rang whenever it’s hit
Cotu buffs Rang whenever he throws it (if there’s no buff to be given, his buff list is empty)
Cotu keeps track of his buffs in a list and updates it and his attributes when he gets buffed, Rang simply modifies its attributes when it gets buffed (i.e. rang.buff() will simply change the hitbox’s damage, hitbox’s size, etc)
Rang’s buff state gets wiped when it gets deleted. Its buffs are then restored by Cotu and his buff list whenever it is thrown
Cotu applies buffs after every throw, not just instant rethrows. This is done for 2 reasons:
Cotu keeps track of both his own and the Rang’s buffs in his buff list. If he throws the Rang but he’s not supposed to buff it, the buff list is simply empty.
There may come a time where Cotu and the Rang keep their buffs even without an instant rethrow, e.g. with a power-up buff
Cotu’s buff list gets cleared and he loses his buffs if he sees that the Rang is null after an instant rethrow could have happened
Why is Cotu in charge of buffing the rang and keeping buff states? He’s the one who instantiates the rang and checks whether it exists

Make third room
Long rectangular building with pillars like the Temple of Eiglay from Elden Ring
Some pillars that can be jumped onto
Enemies spawn from the edges of the room

Make Rang’s angle speed direction (±angle speed) depend on which way Cotu is facing, not his walk dir

Think of a way to give the player a break between the pillar room and the gun miniboss room
Checkpoint; to be added later

Add maze
Stand in the center of the next room, which then opens up a trapdoor beneath you and drops you into some dark, scary, claustrophobic corridors
Use the rang to see where you’re going
Watch out for the spooky high-health enemies sparsely distributed in the corridors
Go down the correct corridor branches and annihilate the enemies with the rang’s ricochet
With enough finesse, it’s still possible to continue the combo all the way through the corridors. If you know exactly where to go, it’s very challenging but possible. If you don’t know where to go, it’s nearly impossible to keep the combo going since you’ll be searching
After escaping the maze, player enters a long, wide slide going down. Slide leads into the next room.
A bunch of goodies can be found in the maze
Secret area that leads to a good item, but it’s impossible to combo on the way to the secret area
Throw the rang at a wall blocking the slide to enter the next room

Make hallway invasion
Long, wide hallway filled with enemies that you can kill or run past
There are some bridges that at jump height filled with gunners shooting down at you
Hallway turns then goes down into 2 melee tier 2s and 1 melee tier 3 that you can try to kill or run past
These enemies don’t aggro until you get close to them
Hallway ends with a button that turns the gunner bridges into moving platforms that go up and down (for later)
Jump onto a gunner bridge you ran past, which then goes up into the next room
Whole interaction feels fast and action-packed

Give each room its own gravity multiplier

Make prototype gun room
Simple circular arena
Rim is half-walls and half-open
Player fights big gun miniboss or runs past it

Make top gun battlefield
Looks/feels like a football field; run from one end zone to the other
Opposite end zone has a massive gun tower shooting big, slow projectiles at the player
Get past enemies and obstacles in the way
Climb to the top of the tower to destroy the gun, which doesn’t respawn after the player destroys it, and open up a shortcut

Put all segments into a single level
Try loading and deloading sections as the player gets to them, which allows each section to maintain its own lockonable limit and improves performance
Create Level1 Scene
Put all sections into Level1 Scene just to find the positions to instantiate them in
Figure out how to change gravity as you go from section to section
If player touches a gravity box Area3D, their gravity switches
Save the global positions of all sections in the Level1 script
Instantiate each section when player enters certain loading triggers
Deload each section when player enters certain deloading triggers

Add finishing touches to Level 1 (but no section transitions yet)
Finish up new First Maze (flipped upside down; downwards ramp at the end replaced by upwards ramp
Add Gun Arena

Make basic enemy models

Experiment with environment lighting and textures AND/OR set up Cotu animations more
Experiment with interior lighting and textures in Hallway Invasion
Try making detailed Hallway Invasion texture

Too irregular, soft, and plain to be intimidating. Should be more orderly and scary

Make even more orderly and scary texture

Add texture to hallway
Add architecture to hallway to make it interesting and slightly more challenging
Experiment with exterior lighting, textures, and geometry design in TopGunBattlefield
Try moonlight-type lighting
Try sunlight-type lighting
Get a nice texture for sniper battle stations
Try giving all textures toon shading
CotuAnims
RedBorderedRect of TopGunBattlefield
SolidDarkGrayTile of TopGunBattlefield
Mobile gunner
Stationary gunner
MeleeT1
MeleeT2
MeleeT3
BigMeleeT1
MegaGun
Set up Cotu more
Idle pose
DodgeRun_loop
Used when Cotu successfully dodges during a crossfade transition from a previous dodge to the RunBlendSpace. If this successful dodge were to happen, an animation for it would not play bc animations cannot interrupt Xfade transitions
Added to the RunBlendSpace as the anim that plays when the player moves at a speed beyond the normal run speed
Instant Rethrow
Jump
Fall

Set up Icon Animations
Make Icon in Blender
Make Follow Anim
Icon spins around its central axis while upright
Make Floored Anim
Icon spins around its central axis while flat on the ground; 
Make Icon Blend Space
Blends between Follow and Floored Anim
Blend position is Icon’s dist from Cotu
Fix Icon’s weird rotations at close proximity to Cotu while not moving laterally in the air

Make enemies not instantly turn to face the player as soon as they’re done attacking; make them smoothly transition from one rotation to another

Set up lighting, textures, and geometry design in FirstMaze
Add textures
Create torches that light up when the rang goes near them
Straighten textures inside the maze

Set up lighting, textures, and geometry design in PillarRoom
DirectionalLight
Textures

Create rang mesh and animations OR give Cotu his eyes and clothes
Create rang mesh and animations
Import rang mesh into Godot
Add motion blur and special effects in an animation
Figure out how to get the shader settings into Godot or into a GLTF file
Add spark particles
Texture the rang
Give the rang a mild glow
Give Cotu a makeover
Give him his eyes
Make his hoodie and pants

Make Miniboss Enemy
Single sweep
Double sweep
Overhead
Flying sweep
Long dist/short dist states
Triple shot sweep

Make basic rang ricochet particle effect
Make basic blueprint of particles
Spawn particles upon collision in the correct direction

Reiterate on Level1, as the current version has changed dramatically and the pieces don’t fit together seamlessly
Put this into ChatGPT:
I'm making a 3D platformer action video game where the player throws a cosmic boomerang that always comes back, no matter what. If the player were to dodge out of the way of the boomerang, the boomerang (which I will now call the "rang" for brevity) would simply continue flying in its current trajectory for a bit, then come back around. The player can only throw the rang laterally, not up or down. The gameplay consists of the player using this cosmic rang to wipe out huge groups of mob enemies and powerful minibosses/bosses as the player continuously dodges both the rang and enemy attacks.


The player character is a mysterious "construct of the universe", and is fittingly named Cotu. Cotu traverses levels designed by "the universe", who is essentially God. These levels are obstacle courses filled with enemies and terrain designed to train Cotu to use his powers optimally. Since the universe is omnipotent, these levels can take any shape or form so long as they obey the laws of physics. The levels, which are collectively referred to as the Training Hall, serve no other purpose than training Cotu.


Describe the first level of the Training Hall, which exercises the mechanics of throwing, dodging, and jumping (to hit enemies at higher altitudes). Break up the level into sections, and describe the room layouts, terrain, architecture, and enemy/miniboss/boss choices and placements. Assume that the player has already completed a tutorial that taught them the controls. Make the experience exciting, memorable, and above all, fun.

Make basic testable version of GauntletLevel1 and GauntletArena1, an arena where enemies spawn in waves one after another
Wave 1 Options:
RnB
Mostly MeleeTier1 and MobileGunner on spinner
Wave 2 Options:
Gang
MeleeTier1 on spinner (frequent-regular) and a pillar (infrequent-irregular)
MeleeTier2 on spinner (infrequent-regular) and a pillar (infrequent-irregular)
MeleeTier3 on a pillar (infrequent-regular)
StationaryGunner on spinner (semi-frequent-irregular)
Wave 3 Options:
Surprise Swarm
A ton of MeleeTier1 and a bit of MobileGunner on spinner in a short period of time
Wave 4 Options:
Gang
Wave 5 Options:
Miniboss

Design stability system to make player think about resource management
In addition to health, Cotu has stability, which is like stamina in Souls games
Alt idea: stability replaces health
Throwing the rang (not instant rethrow) and dodging consume stability
Stability is slowly replenished while Cotu runs and is quickly replenished when Cotu stands still
A chunk of stability is replenished when the rang hits the icon
Instant rethrow does not affect stability
If Cotu runs out of stability, he is destabilized, which means he will be destroyed if he gets hit once
The only way to restabilize is to consume a special item or stand still for a long time

Make the rang change color with each phase
Change color of rang particles, trail, and glow to match

Implement stability UI
Create basic health bar
Code stability logic
Restore health at recovery_rate
Dodging removes health
Throwing removes health
Dodging and throwing starts a recovery_timer. When the timer hits 0, recovery begins. Before the timer hits 0, there’s no recovery
Standing still (i.e. being on the floor and walk_input = 0) makes recovery faster
Add damage indicator (when Cotu loses stability, the amt of stability lost is shown

Model, rig, and animate new humanoid enemy models
Melee
Tier1
Black blocky body with red highlights, including red ski goggles and a metal mask
Red outline
Watch the French guy’s vid on how to animate with those squiggly lines
Walk anim 1
Walk anim 2
Jog anim?
Idle anim
Overhead
Sword mesh
Sword trail
Sword extend anim
Tier2
Stocky body with pink highlights, including pink ski goggles and a metal mask
Pink outline
Walk anim
Idle anim
Overhead
Sweep
Tier3
Bigger than Tier1 and Tier2
Yellow highlights and a shield with the sword
Yellow outline
Walk anim
Idle anim
Gunners
Mobile
Same as MeleeTier1 but with blue highlights, blue outline, and a gun
Idle anim
Jog anim
Gun mesh
Stationary
Mobile gunner’s gun on a mic stand
Polished anims

Miniboss Model, Rig, and Anims

Destabilization
When health hits 0, Cotu becomes destabilized (destabilized = true)
DESTABILIZED pop up
Glow effect
Health bar graphic effect
2 seconds of invincibility
Next hit destroys Cotu

Score UI
Text that displays score
Score update effect
Score text pops out and changes color depending on the score gained and shrinks back into place

Hit Effects
Particles

SFX
Rang flying
Rang ricochet
Rang hit enemy
Rang catch - postponed until after first boss
Rang buff

Hub World
Menu that lets you choose which level to enter
Left half of the screen is a vertical scroll bar for level selection
Main panel size 480 x 270 px
Right half of the screen is a column of 3-4 slots for level/character modifiers and/or items to bring into the level (not to be implemented yet)
Entrance closet
Transition from hub world to arena 1 level
Closet light(s)/screen darkening
Explosion of tiles
Currently selected panel is highlighted by a ball

Death and Respawning
Respawn in respawn room of hub world
Death animation - postponed until after first boss

Rework Temporary Buffs
CotuControl has a list of rang buffs that will be applied when the rang hits the icon (for now, it’s a list of 3 items)
CotuControl has a next rang buff index var
When the rang hits the icon, the icon calls a func in CotuControl that moves the rang buff index up 1
When the rang is destroyed and not instant rethrown, the next rang buff index goes back to 0

8164 Attack Animations
Model
State logic
Short and long dist refer to X’s dist from the target
After neutral state ends (X got within short range dist or long dist wait time ends), X queues an attack
Long dist: X chooses a random long dist attack, then returns to neutral
Short dist: X chooses a random short dist attack, then returns to neutral
After attack state ends, X returns to neutral
Short dist: if X returns to neutral but is still in short dist range, he performs another short dist attack immediately
Long dist: if X returns to neutral at long dist range, he has to wait for a random time between min and max long_dist_wait before choosing a long dist attack
The pool of attacks X can choose from is called attack_chances. He has 2 different long dist attack chances: one for when his right arm is deployed and one for when it’s not
After his stability passes the first checkpoint, he queues his face rain attack
After his stability passes the phase 2 checkpoint, he switches to the phase 2 versions of his attack chances, then starts a timer that ends exactly when his laser combo starts
While transitioning to phase 2, he slowly removes attacks from his attack chances in the order of long → short. For the last 2 seconds before laser combo, he cannot attack at all. This way, he can immediately start the laser combo when the timer ends without waiting for another attack to finish
After the laser combo, X gains some (or just 1) new long dist attack(s)
Phase 1 attack list
Slip n’ Slice: 8164 slides towards the target (below the rang) while dragging his arm on the ground. 8164 then stops and slices upward simultaneously. Follows up into more moves
Animation done
Performs LeftArmRecall if he doesn’t have left arm
Collides with Cotu, but stops moving after collision instead of ricocheting off
Superman: 8164 jumps towards the target (above the rang) and performs a Superman punch while falling to the ground. Punch has explosion hitbox
Animation done
Performs LeftArmRecall if he doesn’t have left arm
Collides with Cotu
Triangle: 8164 shoots his arms diagonally forward from himself, which then shoot lasers to form a triangle. The triangle remains the same shape regardless of how far the target is from X. A few moments after the lasers fire, 8164 does 1 of 2 possible kicks
Target’s close and has head: 8164 does an ax kick
Target’s far and has head: 8164 floats in the air and does a flying stomp kick
Any dist while headless: 8164 jumps into the sky and lands with a volcano eruption
Animation done
Slightly hunched over, bring the arms around behind him slowly, then
Abruptly swing them in front of his body and across
Flying kick
Jump and lean his body back and turn it to the side white he crouches in the air, then
Kick with the right foot while falling
Ax kick
Get into the ready position (vertical split) with the right foot up
Stomp down
Volcano
Fly straight up
Fly down
Surface Material Overrides:
0 - TopFace
1 - Torso
2 - LeftArm
3 - RightLeg
4 - LeftLeg
5 - RightArm
6 - LeftFace
7 - RightFace
8 - BottomFace
Face Rain: 8164 jumps towards a point above the center of the stage and floats upside down, with his limbs pointing straight upward. Each one of his 4 head fragments shoots down towards the center of a different quadrant of the arena, all at once. After firing the fragments, 8164 dives into the ground with an explosion, then returns to normal behavior while headless. After the fragments are all planted in the ground, they start sizzling. Eventually, they explode sequentially one after another after sizzling for around 12/16/20/24 seconds
Face frag loose spark particles
Face frag sizzle particles
Volcano animation
Column
Shockwave disc
Lava
Volcano giant square star billboards
Face frag detonation
Create warning sun
Summon volcano
Attack is chosen after 1st segment is lost and never again
Teleport (long range): 8164 dashes towards the target while the icon moves to a point orthogonal to the vec from 8164 to the target (counterclockwise), then teleports from his current position to his icon. From the icon, 8164 dashes towards the target with either a SlipnSlice or a Superman
Right Arm Slice: 8164 recalls his arm if he doesn’t have it, then slashes twice with his right arm with the same type of blade used in SlipnSlice. At the same time as the second slash, 8164 flies backwards
Right Arm Laser: 8164 fires a laser, sacrificing his Right Arm
Diagonal Dash: 8164 flies towards the target diagonally relative to his vec to the target
Phase 2 Attack List
Superman
Triangle
Diagonal Dash
Chain Slice Left (long and short range): 8164 does a Slip n’ Slice, then immediately spins the blade around him once before dashing backward, which immediately leads into a teleport-Superman (or possibly some other followup attack)
Fun fact: the blade spin was an accident caused by Godot’s Euler angle system; when rotating the blade slightly, one of the Euler angle’s signs changed, causing the blade to spin around to match the new measurement
Chain Slice Left Laser: immediately after the Chain Slice Left back dash, he teleports to Cotu’s side, then shoots out his left arm (to his) forward and to his right, and the arm then turns and shoots the same way it would in a Triangle, then 8164 teleports AGAIN into a Superman
Fun fact: the teleport into the arm throw was just an experiment, as X was originally going to stay where he was after retreating before throwing the arm, but I thought it was so cool when he teleported and threw the arm that I kept it
Arm Bombs (long range): 8164 jumps into the air and floats for a bit while holding his arms up like he’s about to swing. He throws both of his arms around the target, with his right arm landing close to the target on Cotu’s left and the left arm landing farther from the target and closer to X on Cotu’s right. The left detonates .5 seconds after being thrown, the right detonates 1 second after being thrown. A followup occurs 1.5 seconds after both arms are thrown (since arms are thrown 5 frames from the end of the initial ArmBombs animation, the followup attack occurs 85 frames after the start of the followup animation, assuming 0 seconds of transition time between the initial ArmBombs anim and the followup anim).
Face Laser: X recalls his arms, then X’s face fragments expand and create a powerful laser at the center. This follows the target slowly for about 3 seconds. Only choosable if the face is visible
Sweep: 8164 raises his right leg in the air while turning his back to Cotu, then ignites his foot’s mega blade, which points outward from the bottom of his heel (MAY CHANGE THIS LATER DEPENDING ON THE ORIENTATION OF THE FOOT DURING SWEEP). He then sweeps his leg around his side in a wide arc while turning his torso to face the target and bringing his leg and body downward, making him perform in a sweeping kick that starts with 8164’s foot at his belly button level and ending on the floor. 8164 ends in a pose with his right arm parallel to his outstretched right leg and his left arm resting on his left thigh. Once 8164 hits this final pose, the mega blade retracts. Leads into a lunge followup
Lunge Face Rain: 8164 leaps forward and upward, jumping above and behind the target. He floats in the air and faces his body towards the target while looking up at the sky, then looks at the target as he shoots his face fragments all around the target, surrounding it. The face frags form a square with the target at the center. 8164 then dives directly at the target with his volcano sun, which explodes on impact. Only chosen if head is spresent. Overrides other lunge options
Lunge Superkick: 8164 leaps forward and performs a superkick. Only chosen if right arm is deployed
Use tween for mvmt instead of vel to prevent missing
Lunge Laser: 8164 leaps forward, then throws his right arm directly to his left while his trajectory changes to make him move forward & to his right. His right arm moves his forward and his left, then turns 90 degrees towards his right. Only chosen if right arm isn’t deployed
Strafe Laser: 8164 strafes while pointing his right arm directly to his side and looking in the direction of the arm. He then pops off the arm while strafing. 8164 strafes faster than he does during a Left Arm Recall
Strafe Slice: 8164 leaps up (above the rang) at a diagonal trajectory to the target, then dashes down and towards the target while slicing with his right arm
Animation done
Teleport version done
Semicircle Dash: 8164 dashes in a semicircle around target. Radius is the same regardless of 8164’s dist to target. Center of semicircle is 1 semicircle radius away from 8164 in the direction of the target
Make X’s toes point more parallel to his body instead of perpendicular to make it look more elegant
Make 2 diamonds fall if X already did Laser Combo
Allow Semicircle to be canceled at the halfway point by a teleporting Strafe Slice
Teleport version of Semicircle done
If X doesn’t have his right arm, then his right arm is recalled to his icon after the icon is made stationary and before the teleport occurs (right arm reaches the icon right as the teleport happens)
Dash Grab: 8164 dashes directly at target, then grabs
Used directly after a SemicircleDash (w/ no TP)
Dash Grab anim: 8164 holds Cotu with one hand while stabbing Cotu in the stomach with the other, raises Cotu in the air while raising the stabbing arm, then slices out with the stabbing arm
When grabbed, a state within Cotu changes his global pos to be set to a bone attachment on X’s left hand. For any grab anims in the future, set Cotu to this state, then set the node that he’s attached to. Every grab anim should have a pos node that Cotu’s global pos will be set to
Cotu grabbed functionality
Cotu detects whether he got grabbed via his hurtbox script. When that happens, his grabbed state is set to true, his grab pos node is set to the hitbox’s parent, and the player loses control. The Cotu XBossGrab anim is also triggered
Cotu grab punish anim
Struggling until frame 110
Penetration at frame 115
Frozen until frame 220
Thrown backward at frame 222
Anim must complete before frame 380
Cotu plays his grab punish animation. After the grab punish anim, his grabbed state is set to false, his grab pos node is set to null, and the player regains control
Cotu is thrown out of the grab
Redo grab to have more movement and so that X doesn’t float onto Cotu after releasing Cotu
Just make the grab anim w/o Cotu and simply guess where X’s hands go. Then readjust for Cotu’s size in-game. You don’t know how big Cotu actually is in-game vs in Blender
After grabbing Cotu, X now keeps moving forward quickly and rises into the air quickly while slowing down
X does the same startup pose and stab, but stabs Cotu faster
After stabbing Cotu, he turns towards the center of the stage, turning Cotu with him
X then tilts his body into his flight direction and dives towards the stage center
Impact causes volcano
After impact, X moves parallel to the stage, then returns to standing pose
Make Cotu’s corresponding XBossGrab anim
Penetration at frame 80
Dash to center at 150
Give X a volcano sun on his right hand as soon as it penetrates Cotu
Make grab hitbox bigger and activate as soon as X dashes
Dual Blade Dash: 8164 dashes forward with his blades ignited dragging both of his arms on the floor, then slices both of them upward to cross his arms and form a V, levitates in the air for a bit, then brings his arms down to perform a sweeping slash behind him (his arms are now at floor level) that turns into a dual blade sweep in front of him
Diamond Rain: 8164 calls down 3-4 starsteel diamonds around him, which then twist out and each fire 4 lasers
Diamond Storm: small background diamonds fly up into the sky, then 8164 calls them down one-by-one at varying heights to blast the target
Laser Combo: 8164 is blasted by a Diamond Storm while rising into the air (LaserComboChargeup anim), then encases himself in a white ball of energy. 8164 then does (from Cotu’s POV):
Laser sweep RL: white laser like the one that fires from an X Diamond blasts to the right and up. Simultaneously, the ball descends and moves forward towards the target. The ball descends such that it hits the ground at the lateral halfway point between its original position and the target’s position. Once the ball hits the ground, the ball moves in a straight line towards the target (keeping its original trajectory, not retargeting), and the laser sweeps from right to left. After the sweep, the ball continues moving forward at the same speed while rising
Sweep begins at frame 35 and ends at frame 70
Laser sweep LR
Sweep begins at frame 175 and ends at frame 210
Laser sweep overhead: white laser goes straight up from the ball, then does an overhead swing at the target. The ball stays stationary
Sweep begins at frame 280 and ends at frame 315
Laser sweep LR, but instead of rising back into the air, the ball does an RL sweep while staying stationary
Sweep 1 begins at frame 350 and ends at frame 385
Sweep 2 begins at frame 385 and ends at frame 420
Ball launch: 8164 pushes the ball forward at the target in a straight line, then teleports out of the ball at a 90 deg angle to the vec from the ball to the target
Ball shrinks and sheds mass (emits many particles) when it’s about to disappear
Flyingkick: 8164 charges his foot, then does a flying kick infused with energy that surrounds him, which creates a damage field around him
Once phase 2 starts, a timer to the laser combo chargeup begins
SemicircleDash + DashGrab + DashGrabPunish lasts 200+55+300 frames = 9.25 seconds
ArmBombs + FaceLaser lasts 120+295 frames = ~7 seconds
Sweep + LungeLaser lasts 140+120 frames = 4.333 seconds
Dash + ChainSliceLeft + ChainSliceLeftLaser + Superman = 40+110+60+120 frames = 5.5 seconds
Dash + ChainSliceLeft + Superman = 4.5 seconds
Pretend that X doesn’t have his right arm in the last 10 seconds before laser combo chargeup
In the last 9.25 seconds before laser combo chargeup (LCC), 8164 can’t:
SemicircleDash
In the last 7.15 seconds before LCC, 8164 can’t:
ArmBombs
In the last 5.5 seconds before LCC, 8164 can’t:
ChainSliceLeft
Sweep
In the last 3.4 seconds before LCC, 8164 can’t:
Anything
BigX shrinks near the end of Flyingkick
Health
Health bar
4 health segments
Each health segment can regenerate like Cotu’s, but a bit slower
After a health segment is depleted, 8164 will only regenerate health up to the new segment’s max
If 8164 takes a hit of damage that would put him below his current health segment’s minimum, his health is NOT automatically set to the minimum. It stays as-is, and the new health segment is now used

Cotu Grabbed Functionality
Cotu detects whether he got grabbed via his hurtbox script. When that happens, his grabbed state is set to true, his grab pos node is set to the hitbox’s parent, and the player loses control. The anim for the corresponding enemy’s grab is also triggered
The grab pos node being set to the hitbox’s parent makes the real (player-controlled) Cotu’s position set to the enemy’s position, which moves the camera to the enemy’s position. This is easier to implement than making a whole separate camera for the enemy’s CotuAnims, then switching the camera to that one
The grabbing enemy contains a CotuAnims as a child. The grabbing enemy plays their own grab anim and the corresponding FAKE grab anim on CotuAnims simultaneously.
CotuAnims contains 2 animations per grab: a version that the real Cotu uses that contains keyframes that control Cotu’s attributes (e.g. his camera pos), and a fake version that only contains the character rig + mesh anim and nothing else.
The enemy’s grab anim uses keyframes to move CotuAnims to the appropriate positions and/or rotations
When grabbed, the real (player-controlled) Cotu becomes invisible and the fake (enemy-owned) Cotu becomes visible and has their process mode set to inherit instead of disabled
When grabbed, the real (player-controlled) Cotu also plays his grab anim so that if he needs to control any of his own attributes (e.g. camera zoom) during the grab anim, he can do so with his own keyframes in his own CotuAnims
After the grab punish, the real Cotu’s grabbed state is set to false, his grab pos node is set to null, and the player regains control

8164 Arena and Background
Flat square
Background diamonds spawn randomly at start of level
Diamonds spawn outside central coordinates
Diamonds spawn at a min dist away from each other
Diamonds are all the same size

Put 8164’s theme on YouTube so you can listen to it
Create photo booth scene with just Big X and a black background
Record photo booth scene with OBS
Put both phases and the OBS recording in iMovie

Roserang Special Attack Rework
Roserang’s special attack seems unresponsive. Make it work like instant rethrow where if you input Special right before the rang hits Cotu, the rang will switch scripts immediately after hitting Cotu
Put Special input checking alongside instant rethrow input, but make Special input take precedence over instant rethrow

Fix Gauntlet MeleeTier3 Sword and Shield Anims
Attaching objects to bone attachments via the Control Rig script is buggy for both the sword and shield. Make keyframes for their movement instead
Remove all shield movement
Stop sword from retracting its blade during the transition from the overhead to the walk anim, which causes the sword to swing wildly to the side while retracting (make it retract before the anim transition)

Axrang
When ax throw button is pressed, ax is thrown in a straight line in the direction from Cotu’s body to the point the camera is looking at, and more stability is consumed than the stability consumed to throw the rose
If the player presses the ax throw button again, or if the ax gets too far from Cotu, the ax will explode
For now, when the ax explodes, it just stays suspended midair
Player presses ax throw button again after the ax explodes to recall the ax to Cotu (not the Icon, as the Icon doesn’t matter to the ax at all)
If the player presses the ax throw button right before Cotu catches the ax, Cotu does a perfect catch and the ax’s strength is boosted. The next ax throw after a perfect catch will not consume any stability
The rang and ax use separate buff lists
Buffs are applied when the ax is thrown
Buffs are cleared when ax is not perfectly caught
Ax UI buffs implemented
Actually, at the time this task was first marked as done, only one ax UI buff was created and all code (in both Cotu and UI root) only accounted for one buff. I had to finish this task after making specials require all buffs
Player can use ax and rose simultaneously
Unbuffed ax throw hit does 2.5x damage of unbuffed rose
Unbuffed ax explosion does 1x damage of unbuffed rose
Player presses separate buttons to throw ax or rose

Move Cotu Damage and Health to Globals
Cotu max health
Cotu regen delay (time after a loss in stability before regen begins)
Cotu base regen rate
Cotu fast regen rate
Cotu destabilize invincibility time
Rose base damage
Ax base damage
Ax explosion damage

Ax Melee Attacks
Ax can be swung with ax swing button
Rejected for now because Cotu’s supposed to have a unique weapon the player must actively manage; if he has a melee attack that only requires you to hold down the attack button near an enemy and works essentially the same as a melee attack in any other game, he loses what makes him unique and the thoughtful weapon control/management

Ax Special Attacks
Costs all of your buffs just like the roserang special attacks
Overhead slam: deals massive damage to a small area in front of you
You can rotate Cotu during the startup using directional walk inputs, but Cotu’s position won’t change
Cotu stops being turnable when he slams the ax
Arc slash: fires a horizontal arc-shaped projectile that pierces through enemies and walls in a straight line in front of you

Balls Level Prototype
All projectiles are balls
Dark blue background
Bouncy balls
Rolling balls
Big bouncy balls
Big rolling balls
Special balls
Skull ball: follows the player and floats through all balls, then explodes
Swarm of little balls
Balls are fired in by cannon feet or mortar head of ball walker
Mortar turns to face firing trajectory
Heavy ball: just hits the ground without bouncing, then slowly begins to sink
Heavy balls are launched directly at the target in an arc
Cannon/mortar goes into its respective firing mode during attack cooldown in order to telegraph the attack
Roller: lateral and vert look at target
Heavy: lateral look at target, vert high target trajectory
Bounce: lateral look at target, vert bounce target trajectory
Mortar/cannon mesh
Cannon mortar turns at a constant speed instead of lerping
Circular arena at the top of the hill with no walls
Rolling AND bouncy ball: Death Ball (not called this in-game) (rejected idea)
Red
Rolls along the ground at high speed and bounces off the walls
Rang ricochets off the ball
Getting hit by the rang (when the rang moves at high speeds and can ricochet) will change its movement direction to the vec from Cotu to the ball + a set y vel
Accompanied by poppers; rollers that pop when their speed goes too low
If the ball ends up out of the arena, it pauses in the air and spins fast for a bit, then launches itself at the target before rolling around the arena again
This idea is conceptually unfun because it forces the player to look around very often, which can get nauseating and frustrating
You can see shadows of falling balls
Ball Walker (this is the name in code, not necessarily name in-game): ball in bowl with legs

Start with capsule collider with a new script whose text is a copy of the mobile gunner script
Prototype model made in Blender
Movable joint model made in Godot
Create a leg scene, then use 2 of them to make the ball walker’s legs
List of all ball movements; draw a schematic for each
Squat

Only the knee joints rotate
Bowl moves straight down
Roll from bowl (bowl just tips forward from squatting position, then tips back)
Foot cannon

Standing knee joint rotates, moving the bowl and the other leg towards it
Simultaneously, thigh joint rotates towards standing knee while gun knee rotates in the opposite direction
Foot mortar

Step flip

Stomp

Ball walker can rotate about its foot towards the target
Roller ball - launched by foot cannon
To launch some balls, the walker balances on one foot while the other extends its foot towards the target and fires from the bottom of the foot
Heavy ball - launched by foot mortar
Swarm balls - shot from foot gun at each stomp
Skull ball - can be shot in every situation that a roller is shot, but is much rarer. Chases the target and explodes at close proximity
Dist states
Long dist: walker is far from target
Stand to foot cannon or mortar anim plays
Walker continuously fires at target
Short dist: walker is close to target
Walker moves away or switches to a short dist substate
Rim ball spawning: rollers and sometimes skull balls are fired from all 6 rim cannons simultaneously every time a foot lands and during typhoons
Flash ball - explodes on impact with anything. If the target is too close, instead of shooting rim balls from cannons, balls are shot from the central ball itself in an arc up → down (unless the walker is in its downbowl pose, in which it shoots rim balls no matter what)
Foot armor: at first, armored plating protects the feet, deflecting the roserang (when it’s not in return mode). This armor has its own health and is destroyed when its HP reaches 0. Armor does not regenerate. Without armor, the feet themselves allow the rose to pass through them
In a new direct child of Ball Walker (a Node3D), attach a new script called ball_walker_armor.gd. This is mostly the same as EnemyHurtbox, but it’s not a child of Hurtbox nor Area3D (since all it needs to do to receive damage from multihurtbox children is have a receive_hit func). Instead of destroying its parent when its HP reaches 0, it sets its hurtbox children’s process modes (both hurtboxes and physical static bodies) to disabled, and sets the unarmored feet hurtboxes (“flesh” hurtboxes) to inherit (enabled as long as the Ball Walker is enabled)
Why doesn’t the armor destroy itself? So that I can allow the Ball Walker to restore its armor in the future
Create a new StaticBody3D on each standing foot. Each new StaticBody has the ThickEnemy collision layer. A StaticBody is necessary to physically deflect the roserang; an Area3D can’t do it
Create a new multihurtbox child on each standing foot as a sibling of the new StaticBody3D, then set its multihurtbox owner to the ball walker armor
State logic
Short and long dist refer to the walker’s dist from the target
Walker chooses a dist state based on its dist from the target and stays in that dist state until its dist from the target changes
When target leaves short dist range, walker switches to long range state + long range substate
Cannon: shoots rollers
Mortar: shoots heavies and bouncers
Walker stays in long range substate until a random time between min and max long dist wait passes, at which point it starts shooting more dangerous balls
When target enters short dist range, walker switches to short range state, then switches to short dist substate
Each substate is functionally the same as an attack that takes the boss right back to neutral (which in this case is the short dist superstate) after it finishes. To do this, the attack sets short dist wait remaining to the exact amount of time it takes to do the short dist attack + some endlag. When short dist wait remaining depletes and target is still in short range dist of the walker, another short range attack is chosen
Stomp
Anim made
Chosen stomp depends on which foot the target is closer to
Only one stomp anim is used, and if the target is too far from the stomping foot, the walker does the instant flip
Shockwave hitbox
Step flip to downbowl/upbowl (“Walk”)
Walker steps towards icon, which is always on the edge of the arena opposite of the direction to the target
If walker’s too close to arena’s edge, it walks to arena center instead
Shockwave hitboxes
Bowl slam
Shockwave hitbox
If target exits short dist range while closer to the left foot than the right (ie closer to the standing foot than the gun foot), instantly move forward L units and instantly flip the walker before choosing a long range substate
L = dist between feet when standing
Typhoon: flips over and spins around on the main ball while using the legs and rim cannons to attack
Added main ball hurtbox
Feet cannons launch rollers in typhoon cannon mode
Feet cannons launch bouncers and heavies in typhoon mortar mode
Jump: squats then jumps into the air. Spawns a foot explosion at each foot and fires both rim and flash balls simultaneously
Health Bar
Health threshold at 50%
Phase 2: Mini Ball Walker (for now, mini ball walker doesn’t spawn at start of phase 2, but at start of level)
Walk
Leap
Anim
Movement logic (try replacing kick with leap temporarily to test it)
Recover
Side kick
Behavior
Leap at random times when not kicking
When in kick range, kick (switch to kick state) and start kick cooldown
Salute
Anim
Performs salute when spawned
Imported initial glb into Godot
Phase 2: Upgraded Ball Walker
Typhoon now leaves behind a damage over time field right under the bowl that lingers for a long time (~20 secs)
In Phase 1, it’s possible to stand directly underneath the bowl and be completely safe

Make GitHub Repo for Blender Projects

Make character debuff system
Globals has an enum called DEBUFFS, which contains all debuffs that can affect either Cotu or an enemy
One of these debuffs is NONE, which is the default debuff. This debuff isn’t registered by hurtboxes
Hitboxes have a debuff property, which is a value from DEBUFFS
When someone gets hit with a hitbox, the debuff in the hitbox is applied
The hurtbox script now checks if its parent contains an “active_debuffs” property. If so, and the hitbox’s debuff isn’t NONE, and active_debuffs[debuff] <= 0, the hurtbox calls parent.receive_debuff_[debuff here]. A match block pairs a value from DEBUFFS to a method. If the parent doesn’t contain active_debuffs, the parent is simply immune to debuffs
Any parent vulnerable to debuffs has an active_debuffs property, a dict whose keys are debuffs and values are durations remaining. When receive_debuff_[debuff here] is called, the duration of the corresponding debuff in active_debuffs is set to the receiver’s property max_[debuff_here]_duration (along with any other debuff application effects). This means that the time it takes for a debuff to wear off is dependent on the receiver, not the hitbox that applied the debuff

Add healing hitboxes
Add healing amount property and receive_heal func to hitbox script. receive_heal simply increases health up to max
Add a child node called HealingHitbox to any node that should be able to heal. This node has the hitbox script with no damage and some healing amt. Make sure its collision mask corresponds to which entities you want it to heal
Make any enemy that can be healed contain “HealingHitbox” in its “opponent” hitboxes list

Homing Instant Rethrow Rang Buff
Add 2nd and 3rd roserang buff slots to UI
Add pivots and icons
Set textures of buff icons in ui_root’s _ready based on Cotu’s roserang buff list
Update apply_roserang_buff1 to apply_roserang_buff(i)
Update Cotu’s apply buffs func to call apply_roserang_buff(i) no matter what the buff is
Check whether a buff is applied by checking roserang_buff_applied[i]
Homing Instant Rethrow: rang zips to a few nearby enemies before zipping to the icon
Level 1: rang goes from not autotargeting to autotargeting 2 enemies
Level 2: autotargets 3 enemies
Implementation notes:
Add a roserang buff: homing
Replace the first buff in Cotu’s roserang buff list (the damage buff) with the new buff
Create a new enum: roserang_throw_type. This has 2 values: rose (default), homing
Instead of having 2 separate funcs for throwing roserang and throwing special roserang, make 1 func that takes a script as input and sets the roserang’s script to that
In the instant rethrow code in _physics_process, check the throw type. If it’s rose, set roserang script to rose. If it’s homing, set roserang script to homing
Add a new property: homing_targets_added. This is set to the number of times the homing buff appears between indices 0 and next_buff_index-1 in roserang_buff_list (inclusive)
In apply_buffs_to_roserang, if the incoming buff is homing, call roserang_instance.buff_homing_targets(homing_targets_added)
Make a new script: roserang_homing. This is the same as the special_homing script but the max targets starts at 1 instead of 11, only lockonables within a certain radius of the rang are checked (instead of ALL lockonables)
Both roserang_homing and special_homing scripts have a new func: buff_homing_targets(targets_added). This is called in apply_buffs_to_roserang. targets_added is added to the base max_targets property in the homing script, causing the roserang to autotarget more targets.
Why isn’t max_targets simply incremented every time buff_homing_targets is called? Well, what happens when you dodge the rang to give it the homing buff? buff_homing_targets is called, but the rang is still in rose mode, so max_targets in either homing script never increases. We need to store homing_targets_added outside of the homing script because when a homing script is loaded in, max_targets are at their default values instead of the value they should be from the accumulated homing buffs.
To do: make it so that when Cotu dodges the homing rang, it goes back to rose mode. Perhaps create a new rang instead of changing the script?
I decided that homing instant rethrow (HIR) shouldn't be dodgeable; it should just be deleted after an HIR flurry or else it'd be OP. It also creates an interesting scenario where you'd want homing instant rethrow to be the last buff applied so it's as strong as possible, but you have to watch out for when it's going to activate bc if it does a homing instant rethrow and your guard is down, you'll catch the rang and lose the flurry. If you could dodge an HIR, you could just throw and immediately dodge to get an easy HIR without risk of losing your buffs
Fix bug where rang follows mites underground when they die (fixed by making mites wait 1 sec before going underground)

Roserang Special - Explosive Homing: same as special homing (although perhaps with less rang impact damage), but each enemy impact creates an explosion that deals additional damage

Specials Require All Buffs to be Used
Specials not only consume all active buffs for their corresponding rang, but require all buffs on their rang to be active in order be usable
This creates a tradeoff: a player can add more buffs to their rang at the cost of taking longer to get to their next special
Create all 3 axrang buff UI elements (there’s currently only 1) and change code in cotu_cb_main to account for multiple axrang buff UI elements (currently only the first icon is changed)
You can instant rethrow or perfect catch after a special (if applicable), but when the rang touches your hand, all buffs disappear
Note that at the time of this task’s completion, no axrang specials threw the ax, so it wasn’t possible to catch the ax after using a special. But the buff-resetting upon catch code is there for the future
Whenever Cotu’s script applies buffs to the rang for an instant rethrow or perfect catch, check if that rang’s special was just used. If so, don’t apply the buffs
Actually don’t do this bc buffs aren’t just applied on instant rethrows, but on specials as well. If you check whether a special was just used, then clear buffs if so, as apply_buffs preparation for a special, then the special will now have no buffs. Instead, simply do the special_just_used check in the instant rethrow trigger code, which makes so much more sense intuitively anyway
After using a special, special_just_used is set true. After throwing the rose, special_just_used is set false
Whenever Cotu perfect catches the ax, check if the ax’s special was just used. If so, clear the buffs
After using a special, special_just_used is set true. After catching the ax, special_just_used is set false
Buffs are temporarily maintained when ax melee hits an enemy in an ax special. After a few seconds, if another ax special melee doesn’t land, buffs disappear
Unlockable Skill
“Redux”
Stop buffs from being cleared upon catching the ax when a special input is queued (ax must be caught in order to use a special)
Move throw_special_axrang call from physics_process (which checks if the axrang is null to throw it just like roserang) to on_catch_axrang for cohesion with perfect and normal catch
How are buffs cleared after using a special then? Wait until the special anim is over; add a keyframe at the end of every ax special that clears buffs
Instead of calling clear_axrang_buffs in axrang special anims, call a func clear_or_save_ax_buffs that checks whether you have Redux (in code: ax_special_hit_buff_saving) unlocked and/or equipped. If not, and you didn’t hit anything with the ax melee, clear axrang buffs. Otherwise, don’t clear axrang buffs and set a timer var ax_special_buff_save_time_remaining to x seconds
Add a var that’s set to true when ax melee hits something and set to false otherwise (likely in clear_or_save_ax_buffs)
In physics process, reduce ax_special_buff_save_time_remaining by delta every frame. Once the timer hits 0, clear axrang buffs (make sure this only runs one time, when the timer goes from >0 to ≤0)
Stop rose and ax from being throwable during ax specials

Shurikens & Marks
Shurikens automatically chase and slash through enemies. When deployed, shurikens first float away from the icon and spin up, shuriken’s current position is calculated as the enemy’s position + some offset, then offset changes to move the shuriken thru the enemy. After each slash, there’s a very brief pause before the next slash
To make shuriken slash paths different from each other, you don’t need to make a shuriken’s path make a curve or use randomness. As Cotu moves around relative to the shuriken target, the angle btwn Cotu and the shuriken target changes, causing multiple shurikens to take different paths thru the enemy without the need for random path changing, even if the shurikens are just moving back and forth along their original deployment trajectory
AI prompt to make shurikens pause after each slash: This script controls a shuriken to slash through a target repeatedly, but it slashes too rapidly and uniformly for my liking. Make the shuriken pause for a moment after each slash, and change the sin implementation if necessary (linear movement is okay).
After implementing this, I decided slashing linearly with a brief pause before the next slash is boring looking; shurikens will now take a 3D curved path away from and back toward the center repeatedly, as in a 3D rose
Shuriken curves are random rather than all taking the same curve (I decided this after seeing shurikens with trails, which showed that their paths were identical)
Shuriken mesh spins slowly during orbit, then spin accelerates during spinup, then remains at max spinup speed during approach, slash, and recall states
Make min and max mesh rotation speeds exported parameters
Make the rotation speed go from min to max during spinup
Shuriken mesh made
Trail made
Player can place the mark on an enemy to make all shurikens target the enemy
Mark placement is exactly like Zenyatta discord orb placement in Overwatch 2
Camera look dir must be somewhat close to enemy
If enemy is too far, mark cannot be placed
If marked enemy is too far or breaks line of sight, mark withdraws
AI tasks:
Verify that the smaller the dot product threshold parameter is, the bigger the cone gets
Yes; the smaller the dot product between 2 vecs, the farther away the vecs are from pointing the same dir (dot prod btwn 2 normalized vecs is just the cos of the angle btwn them)
Instead of choosing the closest enemy in the cone, choose the one closest to the camera’s look dir (smallest dot prod? No. Highest dot prod)
If mark is withdrawn, shurikens follow “Unmarked behavior” set by player in the hub:
Nearest: shurikens attack nearest enemy to you
Highest health: shurikens attack enemy with highest health in the level
Lowest health: shurikens attack enemy with lowest health in the level
Check whether an instance is valid and/or Node process mode is disabled
To deploy a shuriken:
Idea: player presses throw shuriken button, which makes a shuriken revolve around Cotu’s icon. Player can revolve up to n shurikens. When the rose hits the icon, all revolving shurikens are deployed
Idea: shurikens can also be deployed by marking an enemy
Unlockable Skill
“Restlessness”
Shurikens each cost 1 stability to throw
Idea: when your stability is below 50%, deploying exactly 3 shurikens in one icon hit spawns and immediately deploys an additional 3
Unlockable Skill
“Resolve”
AI prompt: (Paste CotuControl.gd) Modify this script to implement this feature: When the player unlocks a skill called "Resolve" ("mid_stability_bonus_shurikens" in code), then the following can occur: when the player's stability is below 50%, deploying exactly 3 shurikens in one icon hit spawns and immediately deploys an additional 3
Change shuriken and Cotu code so that shurikens are deleted from shurikens list upon returning to Cotu. The AI originally made it so that shurikens switch back to orbit mode upon returning to Cotu
(Paste in shuriken.gd) Take a look at the above script. As you can see, when a shuriken reaches Cotu during the recall state, it switches to the orbit state. Make the shuriken instead delete itself and send a signal to Cotu (whose script was sent in the previous message) to delete this particular shuriken from the shurikens list.
Create shuriken explode phase
Replace “returned” signal with “destroyed” and make func destroy_self
(Paste in shuriken.gd) Take a look at this script. Change it so that after the final slash, instead of switching to a “recall” state, the shuriken switches to an “explode” state. The explode_frame func should just be pass. In switch_to_explode, a timer counts down by explode_secs before destroy_self is called
Recall state isn’t deleted from the script in case it can be used in the future
Create shuriken explode particles and emit them when shuriken explodes
Make shuriken particles face the correct direction when exploding
No need for code modification here since shurikens automatically face the target when slashing, so shuriken is always facing the correct direction after the final slash
Change spinup phase so that shurikens are launched away from Cotu and decelerate to a stop during spinup
Change this script so that during spinup phase, shurikens are launched outward and upward and decelerate to a stop a few moments before the spinup phase ends. Make the speed at which shurikens are launched during spinup AND the time it takes for them to decelerate to a stop exported parameters
Idea: when your stability is below 25%, deploying exactly 3 shurikens at once deploys a high-damage homing fireball. Fireball follows shuriken behavior but explodes on impact. Both this skill and Resolve can be active
Unlockable Skill
“Thrill”
AI prompt: (Paste CotuControl.gd) Modify this script to implement this feature: When the player unlocks a skill called "Thrill" ("low_stability_fireball" in code), then the following can occur: when the player's stability is below 25%, deploying exactly 3 shurikens in one icon hit spawns and immediately deploys a fireball. Also create a fireball script, which chases after an enemy in the same way as a shuriken when it spawns, then explodes on impact instead of slashing.
Idea: a shuriken will slash a marked enemy some number of extra times (starting at 1)
Unlockable Skill
“Hunger”
How to implement: a shuriken has a “slashes” value that determines how many times a shuriken will slash through an enemy. Typically, a shuriken will lose 1 slash per hit (excluding the initial hit). When a marked enemy is hit, and the shuriken’s “marked slashes” value is > 0, a shuriken will lose 1 marked slash instead. Unlocking/upgrading this skill increases the base marked slashes, which was initially 0
Idea: after using all of its slices, instead of recalling, a shuriken will explode for additional damage
Unlockable Skill
“Hatred”
AI prompt: make CotuControl.gd set whether a shuriken will recall or explode (bool shuriken_self_destruction). Update this new shuriken.gd script to implement this change. (Paste in shuriken.gd)
If Cotu throws any additional shurikens beyond the normal limit, they will cost more stability
AI prompt: Now change the script so that if Cotu throws any additional shurikens beyond the normal limit, instead of stopping the shuriken from being thrown, the shuriken is thrown but will cost as much stability as the ax.
Idea: pressing some sort of special button will detonate the marker, removing it for the rest of the level but dealing huge area damage
Unlockable Skill
“Sacrifice”
AI prompt: take a look at the following GDScript scripts: (paste in CotuControl and mark scripts). Add this functionality to CotuControl: if the player unlocks the “Sacrifice” ability (“mark_detonation” in code), then holds the “Special” input, then pressing the “ThrowShuriken” button will detonate the marker, removing it for the rest of the level (the player can no longer use it). In the mark script, when the mark is detonated, set a “detonated” state to true, then play an animation from an AnimationPlayer called “detonate”
Lorewise, detonating the marker will remove it until Cotu returns to his realm (either you walk inside it or die)
Idea (if the Blaze vs Blackstar tournament fight played out this way): Cotu makes some sort of comment about how this skill was what got him the win. Possibly mention Blackstar
Idea: shuriken special - all living shurikens temporarily can slash infinite times (in practice, maybe just set this number to something that matches the special’s duration) and rapidly slash through their target
Perhaps make this the same type of special as mark sacrifice?
Unlockable Skill
“Frenzy”
AI prompt: add a “frenzy” mode to the shuriken script, which is the same as the slash state, but shurikens can slash infinite times and move much faster than in the normal slash state. Make the frenzy movement speed (an exported variable. After some number of seconds (also adjustable), the shurikens go back to the slash state. Make a “switch_to_frenzy” func

Roserang Post-Special Instant Rethrow
Roserang can be instant rethrown right when a special ends
Unlockable Skill
“Momentum”
This isn’t a task; as of the time of this note being written, the roserang can already be instant rethrown after a special. This is just a note that the roserang’s instant rethrow post-special is an unlockable skill

Roserang Buff: Duplicate
When the buff is applied, another roserang manifests itself from the icon and is thrown in the direction you’re facing (it behaves as if it were thrown from your body).
Duplicates inherit all buffs from the original; the original is the only one that can buff.
The number of duplicates spawned is only dependent on how many times the duplicate buff appears in the buff list (e.g. if it only appears once, then there can only be 1 dupe per buff cycle).
AI prompt (code creation): (paste in CotuControl.gd) look carefully at the script above. Currently, the only buffs that exist for the roserang are damage and homing instant rethrow. Make a new buff: duplicate. When the buff is applied, another roserang manifests itself from the icon and is thrown in the direction you’re facing (it behaves as if it were thrown from your body). Duplicates inherit all buffs from the original; the original is the only one that can buff
AI prompt (code check): (paste in CotuControl.gd) Analyze the script above carefully. The roserang can receive buffs by hitting the icon. One of these buffs is “duplicate”, which creates a second rang that receives all buffs that the original rang receives, even after the duplicate is already spawned. Verify that this code properly does this.
Change the roserang script to handle/apply buffs to a list of roserang instances instead of just one (this undoes all of the changes in this task above since they used an original+duplicates system)
All roses look at the same roserang buff list singleton
Only 1 roserang can be instant rethrown at a time
AI prompt: (paste in CotuControl.gd pre-changes) Analyze this script carefully. Change it so that instead of only saving one roserang instance, the script keeps track of a list of roserang instances. Currently, there’s only one roserang, and when it’s caught, all of its buffs are cleared. Change the script so that buffs are only cleared when ALL of the roserang instances have been caught. If a roserang is caught but at least one other roserang is still in flight, then the roserang still in flight keeps the buffs. All of the roserang instances will use the same roserang_buff_list, don’t make a new one for each rang.
AI followup: Excellent. Currently, the only buffs that exist for the roserang are damage and homing instant rethrow. Make a new buff: duplicate. When the buff is applied, another roserang manifests itself from the icon and is thrown in the direction you’re facing (it behaves as if it were thrown from your body)
AI followup: When the first roserang hits the icon, another roserang is thrown, as expected. However, when the rangs hit the icon again, more duplicates are spawned despite the next buff in the list not being a duplicate buff. More roserangs spawn on subsequent buffs. Why does this happen? Form an explanation and rectify the issue.

Consider using UI to choose rangs (e.g. wheel)
Check out Hogwarts Legacy spell selection
Alternatives would be scroll wheel or having a different input for every rang (e.g. Marvel Rivals)
I reject this idea bc the player needs to be able to use rangs on the fly, especially shurikens, and making the player go through 2 inputs (enter menu, then select) takes too long

Rang Synergy
Synergy buffs are applied after rang buffs
Synergy buffs multiply with each other, e.g. if both Harmony and Symphony are unlocked and roserang and ax are moving, shurikens gain 50% damage → +50% → 225% damage
As long as one rang is moving (i.e. the ax isn’t stationary), the other won’t lose buffs when (imperfectly) caught
Unlockable Skill
When creating skill tree, add all skills with the Unlockable Skill tag to the tree
Most likely a base skill that leads to future synergy skills
“Mutuality”
AI prompt: (paste in CotuControl.gd) Analyze the above script carefully. As you can see, 2 rangs (rose and ax) can gain buffs (roserang buffs when dodged, ax buffs when perfectly caught) and lose buffs (roserang loses buffs when caught and not instant rethrown, ax loses buffs when imperfectly caught). Implement this change: when a boolean “mutuality” is true, which means the player unlocked and equipped the “Mutuality” skill, then as long as one of the roses (there can be multiple) or the ax is moving, the other won’t lose buffs when (imperfectly) caught.
When roserang is moving, all other rangs deal +25% damage
Unlockable Skill
“Harmony”
In the throw ax and throw shuriken funcs, if harmony is true and the roserang list isn’t empty, call the rang’s apply_damage_multiplier func w/ “harmony_damage_multiplier” as the input
Add an “apply_damage_multiplier” func to all rang scripts, which multiplies a damage boost onto the script’s new damage_multiplier var
To simplify this, I wanted to make all rangs inherit from a “cotu_weapon” base class, which would have an add_damage_multiplier func. However, what would this add_damage_multiplier func actually do? Set the damage of each hitbox of the weapon? How would it know the base damage of each hitbox? Only each individual weapon script knows, not the parent script of all of them. Therefore, it’s best just to write an add_damage_multiplier func to every weapon script individually
Add an “update_hitbox_damage” func to all rang scripts, which multiplies all hitboxes’ dmg by 1 + damage_multiplier
Cursor prompt: look at the damage multiplier, update_hitbox_damage, and apply_damage_multiplier funcs I wrote in axrang.gd. Create similar systems for roserang.gd, shuriken.gd, and all homing scripts, making sure to use each script’s corresponding hitboxes.
When ax is moving, all other rangs deal +25% damage
Unlockable Skill
“Symphony” OR “Harmony II”
When ax hits an enemy, it activates a temporary buff that causes other rangs to deal +40% damage. Buff wears off after a bit if ax doesn’t hit an enemy again
Unlockable Skill
“Crescendo” OR “Harmony III”
AI prompt: (paste in CotuControl.gd) Analyze the script above carefully. The axrang has a signal hit_enemy, which emits whenever it hits an enemy. Implement this change in the CotuControl script: when ax hits an enemy, it activates/refreshes a temporary buff that causes all roserangs and shurikens to deal +40% damage. Buff wears off after a bit if ax doesn’t hit an enemy again

Ax Buff Decaying
If the ax is deployed for too long, it begins to lose its buffs one by one
AI prompt: (paste in CotuControl.gd) Analyze the following script carefully and implement the following change: If the ax is deployed for too long (i.e. axrang_instance != null), the ax begins losing its buffs one by one (every few seconds, the next axrang buff counter goes backwards)

Ax Dodge Rethrow
Touching the ax while dodging causes you to catch the ax during the flip/spin, then automatically throw it after the flip/spin in the direction your body’s facing
Axrang catch flowchart:
When the player catches the ax,
Special is inputted → do special
Special isn’t inputted
Player isn’t dodging and perfect catch isn’t inputted → clear buffs
If you check perfect catch before this condition, perfect catch check will set perfect catch inputted to false, causing the buffs to be cleared when this check runs afterward
Perfect catch is inputted → add buff (+ other perfect catch things)
Player is dodging → queue rethrow
Notice that in the flowchart, no elif will be used in perfect catch/dodge checking. Perfect catch can happen with no dodge, and dodge can happen with no perfect catch; they’re fully independent events
AI prompt: (paste in CotuControl.gd) Analyze the following code carefully. Implement the following feature: when you catch the ax while dodging, it gets rethrown in the direction your body’s facing at the end of the dodge (not the direction the camera’s looking).

Ax Speed Buff
Makes ax travel much faster on both initial throw and recall
Unbuffed: comparable to Ana’s sleep dart in Overwatch 2
Level 1: comparable to Kiriko’s knife
Level 2: comparable to Doomfist’s hand cannon
AI prompt: (paste in Axrang.gd) Analyze the following script carefully. Add a speed buff, which increases the ax’s fwd and return speeds significantly. They should be set to values from the globals script. If the ax’s speed is already buffed and buff_speed is called again, the ax’s speeds should move up a level. There should be 3 speed buff levels total
Speed buff icon made

Rang Throw Anims
Rose has a little startup upon first throw
Throw roserang anim should call throw_roserang_with_script
Inputting throw button should make anim tree do throw roserang anim
Ax has long startup upon first throw. If ax was perfectly caught, the next throw has no startup
Make axrang normal throw anim in Blender
Make axrang perfect throw anim in Blender
Make ax do corresponding anim depending on whether the throw should be perfect or normal

Rename Cotu Unlockable Skills in code
The names of unlockable skills in-game may change over time, so in-code, they should be described as what they actually are

Another Rang Synergy Buff
If the ax is perfect caught while at least 1 roserang is flying, the ax receives a temporary 40% damage buff
Unlockable Skill
“Mania”
Unlocked before Crescendo

Consider not having startup time for roserang throw
It would feel good to get instant feedback after inputting roserang throw
Why should it have startup at all? Should it be a risky choice?
The reason why I had these thoughts was because the idea of attacks having considerable startup times came from Elden Ring, but the gameplay of Blazarang is different in that it’s more focused on maintaining combos through quick decisions instead of carefully choosing which action to commit to.
I now think that Blazarang could have both careful planning (in the initial throw for each rang) AND combo maintenance
Yes, throwing the roserang should be a risky choice. It’s engaging for the player to think about whether they’re in a safe enough situation to commit to an attack. In fact, the roserang should have a bit more startup than it does now to really make the player think.
Bonus reasons for giving roserang throw startup:
Aura farming: roserang takes time to manifest and/or charge up before throwing
Makes instant rethrow feel even more rewarding due to the contrast with the initial throw

Special Rang Throws
Power Throw: throws rang in a straight line at the crosshair
If it hits Gauntlet MeleeTier3’s shield, he stops blocking temporarily
What’s the point of this ability if it’s similar to the ax? They’re both slow but powerful attacks that travel in a straight line
It’s just a bit more variety for the player to have the option of using, it’s not meant to replace the ax. It’s sort of like the thrust attack from Sekiro; it’s not necessary or super useful, but it’s an option
FYI: the thrust attack deals 1.5x the damage of a normal attack
Power throw controls
AI prompt: (paste in CotuControl.gd) analyze the script carefully. Now implement this feature. Power Throw: throws roserang in a straight line at the crosshair. Hold down the throw button to do a power throw. Power throw can also be used in place of instant rethrow, and power throw will also preserve buffs but not buff the roserang.
Fix bug where a roserang is thrown on initial press, and another is thrown on release
The problem with the power throw is that if the player happens to be holding the throw button when the player tries an instant rethrow, Cotu will instead consider it a power throw. Under the new power throw logic, the instant rethrow queuing happens when the player releases the throw button, not when they press it. Ideally, I’d want the player to just press the button to instant rethrow, but then how does the game tell the difference between an instant rethrow and a power throw?
Solution: make the power throw only usable as a substitute for the initial throw, not instant rethrows
(I tried using AI to make the code but it didn’t work, so I made the logic myself. But I ran into a bug where it was possible to instant rethrow and normal throw immediately afterward, causing 2 rangs to be thrown from one button press)
AI prompt: (paste in the portion of CotuControl.gd that contains power throw logic) Analyze the code carefully. It’s located within the physics_process function of a CharacterBody3D script in Godot. Verify whether the following logic is satisfied. Power Throw: throws roserang in a straight line at the crosshair. When there’s no flying roserangs, the player can either power throw or normal throw. Hold down the throw button, then release to do a power throw; quickly press and release the throw button to do a normal throw (already implemented). When at least one rang is flying, the player cannot power throw, and all ThrowRoserang button presses should be considered instant rethrow attempts.
Power throw roserang script
AI prompt: (paste in roserang.gd) Analyze the code carefully. Recreate the script, but instead of starting in the ROSE state, make it start in the TRAVEL state. In this state, the rang simply travels in a straight line forward according to the angle it was initially thrown in. After reaching a max dist, make it return to the icon. Once it hits the icon, it switches to ROSE mode. As you can see in the state transitions, the ROSE mode can only switch to the RICOCHET and RETURN modes, meaning The TRAVEL state is only used once in the roserang's lifetime. While traveling, the rang can still ricochet, and the ricochet behavior is identical to the ROSE state's. Aside from the difference in path shapes, the TRAVEL state is essentially the same as the ROSE state.
Make power throw’s initial straight state ricochetable and make the ricochet behave the same way as the original roserang; this new ricochet state lasts much longer now for some reason
Fix bug where roserang doesn’t buff when returning after travel state
AI prompt: (paste in roserang.gd) When the roserang returns after a travel state and it hits the Icon, it's supposed to apply a buff. However, the icon isn't buffing it; no collision is being registered. However, after reaching the icon's position, the roserang switches to rose state, then return (or ricochet if it hits a wall). When the rose hits the icon in this return state, now the icon applies buffs. Diagnose the issue and make the roserang hit the icon when returning after a travel state.
Uses moderately more stability than normal throw

Get a better sense of game feel
(pre-task) Simplify CotuControl code so that instead of separate “can” vars (e.g. can_dodge, can_throw_roserang), Cotu is either “busy” or not busy, and he’s busy whenever he does an animation aside from the instant rethrow
(paste in CotuControl.gd) Analyze this script. As you can see, there are some variables controlling what the player can do (can_dodge, can_throw_roserang, etc.). Simplify the entire script so that instead of all these "can" variables, there is a "busy" variable that is true when the player is doing any animation (e.g. dodge, normal throw, power throw) EXCEPT instant rethrow, which still allows the player to do any action to cancel the animation.
If possible, find some way to connect or combine roserang power throw charging with the busy state; I want the character to be considered busy while charging the roserang power throw
Make invincible dummy
Fix bug where it doesn’t get hit by the axrang explosion hitbox for whatever reason
Try duplicating gauntlet melee tier 2 and replacing the meshes
When the dummy was a modified GMT2, the dummy correctly received hits, but when I replaced the GMT2 script with the training dummy script, it no longer received hits. After adding gravity and move_and_slide code to the dummy, it correctly received hits again
Make hits show how much damage they do like in Terraria
Make a UI damage counter that shows how much damage in total has been done to the training dummy
Training dummy script listens to hit_received signal from hurtbox, then calls UI root’s update_damage_counter func
Damage counter can be reset by pressing the 0 key
UI DPS counter
DPS = total_damage_dealt / total_damage_time
When you reset the damage counter, it resets both total_damage numbers
total_damage_time won’t increment until the damage counter is updated for the first time (since the last reset)
When the damage counter is updated for the first time, total_damage_time now constantly increments
AI prompt: (paste in ui_root.gd) Analyze the script. Implement this feature: the DPS counter. Assume the dps label already exists in the scene tree as a direct child of this node as “DPSCounter”. DPS = total_damage_dealt / total_damage_time. When you reset the damage counter, it resets both total_damage numbers. total_damage_time won’t increment until the damage counter is updated for the first time (since the last reset). When the damage counter is updated for the first time, total_damage_time now constantly increments by delta
Find the best method of DPS and determine whether it’s fun to figure out and use
All rangs are thrown at optimal rose DPS range (about ⅔ length of rose petal)
Once-damage-buffed Rose only: ~40
Once-damage-buffed Ax only: ~76
Once-damage-buffed Rose + Ax: ~84
Note that synergy buffs were active, causing ax to deal 87 damage per hit and rose to deal 35 damage per hit
Once-damage-buffed Rose + Shurikens: ~25
This makes sense bc rose is thrown half as often bc you’re dodging the rose to deploy the shurikens
This is a good spread: normal damage with rose, great damage with ax, somewhat substantial increase in damage when adding the rose to the ax, but not such a significant increase that it feels necessary

Charms AKA Sigils
Max Stability Boost: increases max stability by 20%
Auto Buff: when rang is unbuffed, 20% chance to instantly apply first buff on initial throw
Regenerator: decreases severity of stability regeneration debuffs (e.g. near edge of the universe)
(this is just mentioned as a reminder for the future) Translator: translates unknown dialogue (e.g. Mitriarch talking to Jumping Spider)
[Upgrade] Decrypter: decodes encrypted messages (e.g. summons of Microwave support enemies)
Translator allows you to hear Microwave’s encrypted messages
To be implemented when dialogue is added
Hand Warmer: slows frostbite buildup (save this for when you make snowflake boss)
AI prompt: (paste in CotuControl.gd) Take a look at this chunk of a script for the player character in my Godot game. I want the player to be able to equip “sigils” to give themself a passive buff. Here are the sigils. Max Stability Boost: increases max stability by 20%. Auto Buff: when roserang is unbuffed, 20% chance to instantly apply first buff on initial throw. Regenerator: decreases stability regen reduction of stability regeneration debuffs (e.g. infest). In the code, the player should have a list of equipped sigils and/or empty slots. Also create an Empty sigil to represent an empty sigil slot. Each sigil should be a part of a SIGILS enum like roserang throw types.
Make sigil buffs parameters in code (e.g. max stability boost amount)

Icon Abilities
Super jump
Press and hold space to stand still and charge the super jump. Player must hold space for a min amt of time to be considered charging. Player can hold full charge indefinitely. On release, player instantly jumps upward
AI prompt: (paste in most of CotuControl.gd) Analyze this script. Currently, pressing the jump key (space) instantly makes the player jump. Change the code to implement this feature: Press and hold space to charge the super jump. Initially, pressing space does nothing, but after holding it for a minimum length of time, the player stops moving and can no longer move or do any action as long as space is held. Once space is held for long enough, player can release space to perform the jump, instantly launching them upward. Player can hold full charge indefinitely. If player lets go of space at any point before full charge is achieved, the player goes back to normal and can move around and do actions again. Letting go of space always resets the charge time back to 0.
While charging (charge is above min charge time), icon spins and grows around Cotu’s feet
Anim length = full charge time - min charge time = 1 - .1 = .9 secs = 54 frames at 60 FPS
Anim made
Anim tree checks whether super charge time > min super charge time to know whether to go to super jump charge anim
Make Icon emit particles continuously on full charge
Make Icon flash with light and explode with particles on release

Current task
Snowflake Boss: Comet/Clarity
See Blazarang Long Tasks

Remove SFX from roserang since it should be present in hurtboxes

Remove power throw from roserang since it does the same thing as the ax

Add UI icon or crosshair to show how close to the center of the screen a target needs to be in order for homing instant rethrow to target it (like what Soldier 76’s ultimate does)

Consider not removing all rose buffs when the player catches the rose
Buffs would now only gradually decay over time like with the ax, encouraging the player to be aggressive without outright forcing them in case they need to catch the rose to defend themselves
Now, the only advantage of instant rethrowing the rose is to prevent the long startup time on the initial throw, which honestly feels like a good tradeoff to me

Reconsider whether the player should be able to restabilize during the invincibility period after destabilization
Currently, if the player destabilizes, there’s absolutely no skill involved in restabilizing. If you use a stabilizer during the invincibility period, you’re right back to normal. Wouldn’t it be more thrilling and challenging if the player had to wait until they were vulnerable again before being able to use a stabilizer?
I still like the idea of being able to use a stabilizer while you’re still stable in order to become invincible temporarily (e.g. during a grab), but wouldn’t it be confusing or nonsensical to the player if the stabilizer was usable all the time except that brief period right after destabilization?
If you use a stabilizer while you’re still stable, you’re briefly invincible AND your next attack is boosted greatly like Royal Knight’s Resolve from Elden Ring. Perhaps make the damage boost an unlockable skill

Consider ax reworks to make it more fun and usable
Idea: detonating the ax also recalls it, removing the floating ax continuous attack and increasing gameplay momentum (which also fits Cotu’s character more)

Idea: make rang techniques more complex so they feel more like unlocking skills in a martial art than a direct boost in strength
Idea: instead of just 1 special, you have multiple specials you can use like cooldowns in Overwatch, except instead of spending time to use the cooldown again, you spend buffs. To choose which special to use, press the corresponding special button
Idea: each special requires a different set of buffs to activate
Rose rapidly autotargets and hits a nearby enemy a few times. The final return to Cotu can be instant rethrown to keep the rose in flight, but the buffs required for the flurry will be spent
Unlockable Skill
“Mini Flurry”

Make Different Game Mechanics Intersect; to create depth, different skills should feel connected
Vid on Interesting Mechanics vs Depth: https://www.youtube.com/watch?v=Fuf_SpKCYVY
One of the biggest issues I noticed with Blazarang is that you can only use either the rose or the ax at a time, and they don’t synergize with each other. This limits the player’s creative expression. As the vid above explains, if there are a lot of different game mechanics in a game, but they don’t intersect, the game feels shallow. To combat this problem in Blazarang, try making the rose synergize with or build up to the ax
Make the ax an ultimate ability
Hitting enemies with the rose charges the ax
When the ax is fully charged, the player can use it in a melee diagonal sweeping slice or throw. Both of these attacks have moderate startup & endlag and deal very high damage (akin to critical hit damage in Dark Souls 3)
Right before and during the slice, Cotu becomes briefly invincible
Unlockable Skill
“Ax Counterstrike”
If the player’s next roserang instant rethrow will be homing, and the player throws the ax such that the roserang hits Cotu in the last (instant_rethrow_window_secs) before the ax anim ends, the ax will be thrown as a homing throw, following the same targeting rules as a shuriken. The ax can still be detonated
Unlockable Skill
“Homing Ax”
This knowledge is available when both the ax and homing instant rethrow are unlocked
When the ax is airborne, dodging causes the icon to stop following Cotu just like dodging when the rose is airborne. This can be used to dodge gigantic attacks (as a substitute for a super jump or long dodge for example)
Unlockable Skill
“Stationary Soul”

The player doesn’t really think about stability management. They’re just making the decision of whether to instant rethrow or dodge, which is fine and already entertaining on its own for gauntlet variant 1 and X, but it feels like a waste of the stability mechanic
Idea: stability vs power v1
Instead of buffs, the rose has a continuous stat called power
Stability and power are measured with the same units
When you throw the rose, you lose 1 unit of stability and give the rose 1 unit of power
When you instant rethrow the rose, the rose touches your body, so you gain 1 unit of stability and the rose loses 1 unit of power
If your stability is <1 unit away from the max, you reach max stability and the rose keeps the excess power
In effect, the rose accumulates power over time when you instant rethrow while you’re at max stability
When you dodge the rose, the rose touches your icon, so the rose gains 1 unit of power. The dodge itself costs 1 unit of stability
In all 3 scenarios above, the total of stability and power remains the same; they’re exchanged equally between each other
When the rose hits an enemy, its power slightly increases depending on the damage it deals (more damage → more power gain)
Effects of stability vs power v1:
Excessive dodging is discouraged bc it drains your stability
Instant rethrowing is encouraged bc it powers up the rose and is the best tool for aiming. However, instant rethrowing to hit enemies increases power very slowly at first, which may encourage the player to dodge soon after the initial throw and greatly increase the rose’s power (and therefore its rate of power accumulation)
Idea: stability vs power v2
Same as v1, but when you initially throw the rose, the rose does not receive 1 unit of power; it starts off with 0
Effects of stability vs power v2:
On the initial throw, the player incurs a debt that must be repaid by hitting enemies enough. This makes the player care about stability management more than the original stability concept. Instead of being able to throw the rose and just waiting for the stability to return via natural regen, the player must land hits with the rose to regen the stability

Chakram Rang
Press throw button to spawn a chakram a few meters left/right of Cotu. The chakram immediately travels in a wide semicircle arc around Cotu and then disappears, functioning as a pseudo-melee attack
Functionally similar to Chaos Blades from God of War 4, looks/feels similar to basic nail strikes from Hollow Knight
Range isn’t fully decided, but it’s definitely less than the roserang’s. Perhaps slightly less than or equal to half of roserang’s range
Travels through walls
This should be a feature unique to the chakram and shuriken. Make ax not travel through walls anymore
Ideas:
Chakrams deal high damage, but cannot be buffed
Chakrams are finite. They recharge automatically like consumable abilities in Overwatch or Marvel Rivals. As soon as a chakram recharges, it deals self stability damage, but it costs no stability to throw them. Hold the throw button to autothrow them
Hitting a stationary ax causes a massive explosion

Gauntlet enemies light up like Clarity’s dress shards when you hit them
Tween their materials’ emission property

Power Throw to Mark Rang Upgrade
Power throw automatically homes to mark position when mark is active

Revisit Mites
Change their design to be more memorable
Explanation: Every level in this game should be memorable. I define “memorable” as being describable with just 1-3 words. For example: X = intense, Clarity = intimidating and mysterious, Flying Whale/Mortal Warrior = surreal, tragic, and beautiful. Currently, how can the mites be described? They’re small, round (at least their silhouette is), and have short stubby legs, so they’re cute. But on the other hand, they have no eyes and have tiny creepy mouths, making them creepy. These feelings directly contradict each other, making the mites indescribable and thus unmemorable. I initially created them because I thought it was funny to juxtapose the mythical, surreal gods with ordinary/realistic bugs, but the humor—which is currently the only source of memorability—relies on the unexpected novelty. Once the player gets familiar with the mites and the novelty wears off, what is the player left with to remember the mites by? No particular idea or feeling stands out since they are neither cute nor scary. Pick a side
Mites IRL are somewhat cute, but not cute enough to stand out as cute unless you change the way they look
Spiders are more memorable because they’re scary, but they’re more common in media, which takes away from the uniqueness of the game, decreasing the justification for its existence and making it feel more boring
Try making them too short to be hit by the rose

Revisit and Complete Balls Level (maybe, if you believe it’ll add more value to the gameplay)
Make Ball Walker more crazy and dangerous
Phase 2 Transition
Ball walker concentrates radiation in its core
Mini Ball Walker is fired from the walker’s core
Phase 2 Changes
Ball walker becomes much faster and more unpredictable
Lore ideas:
Ball Walker was created by a mysterious Inventor who speaks a language unintelligible to the player and most characters except for one (Cotu maybe)
The Inventor is a friend to Cotu and the triplets, and he created the ship they’re using to travel the universe
Idea: Ball Walker was a toy created by the Inventor to entertain gods. Cotu fights BW bc the Inventor asked Cotu to test it

Make Gauntlet Mobile Gunner Visually Distinct from Gauntlet Melee Characters
Maybe give mobile gunner a scope mask

Add Enemy Stun and Knockback
All weapon hits except from shurikens stun gauntlet enemies momentarily, including axrang explosion
Roserang power throw knocks a single enemy backward upon impact and stuns them. Knockback is decreased the larger the enemy is

Body Upgrades
Chosen in skill tree just like any other unlockable skill
Body material (e.g. SiO2 glass, quartz, obsidian) - increases max health
Faster reconstruction - increases num of attempts across entire run (indirectly increases attempts for each boss)
Consider keeping upgrade system simple to avoid feature creep; before adding any more crazy synergy buffs, focus on direct health and damage upgrades

Certain unlockable skills are unlocked by unlocking new rang types
Rose power throw = rose + ax
Rose homing (both special and instant rethrow) = rose + shuriken
Rose rapidorbit = rose + chakram
Increased chakram capacity = chakram + shuriken
Exploding shurikens = shuriken + ax

Rush Buff: the less attempts the player has for a fight, the stronger they get

Ultimate attacks
Charged like an Ultimate Art in Elden Ring Nightreign. Charge accrues by:
Landing attacks
Ult meter in bottom left corner of screen
(To do when you create character progression) appears when you unlock your first ult
Circular icon that displays which ult you’re using (it’s an insignia like crest attacks in Silksong)
Progress is a white bar that increases angularly around the circumference
Additional ult charge when ax hits an enemy (this idea applies even if ax ends up becoming an ult)
Unlockable Skill
“Avarice”

Gauntlet Boss: Elite Gunner + Sentinel
Phase 1: EG is laying prone on top of FirstMiniboss while FirstMiniboss constantly tornadoes
Explosive slug
Phase 2: EG runs around on foot
Run 360: EG strafes around the target, then jumps while spinning about the y-axis 360 degrees. When she faces away from the target, her shotgun’s muzzle flashes with light. The second time EG faces the target (not the target + its mvmt dir), she fires. She lands facing the direction she was originally running in. Does extra damage
Spawn Grenade: EG throws 1-3 cubic grenades around the target, each of which has a tiny beacon to the sky. 5 seconds after a grenade is thrown, a spawner box from Gauntlet 1 flies vertically from far above onto the grenade’s x and z pos, spawns a random enemy from the choices below, then flies back into the sky
Sentinel
Frag Grenade: EG throws 1 spherical grenade directly at the target’s pos + Cotu’s mvmt dir. 4 seconds after the grenade is thrown, it explodes dealing damage in a spherical hitbox around it
Slide Buckshot: EG strafes around the target, then slides into a crouching position while taking aim at the target. She then fires at the target + Cotu’s mvmt dir
Switch Strafe: EG abruptly pivots and starts running in the opposite direction. Chosen when Cotu throws the rang
Slide Buckshot: EG slides towards the target (dodging underneath the rang), exits the slide in a crouching position, then fires straight ahead in the direction she’s facing
Pull Up Cover: EG stomps the ground, causing a black rectangular prism to rise from the ground. This prism is part of the arena, so the rose cannot pass through it. The prism will slowly sink into the ground over time, eventually disappearing. This move usually leads into her reloading her shotgun
Smoke Pillar Grenade: EG throws an odd-looking grenade that turns into a smoke pillar on impact. It does no damage but creates a big plume of stylized cubic smoke that is extremely difficult to see through. It lasts for about 30 seconds
Sentinel
Cyan melee supporting enemy
Wields a big thick halberd about as tall as GauntletMeleeTier1’s body
About 2 heads taller than GauntletMeleeTier3 and even bulkier
Runs at the target, then performs a dash slash that looks similar to the Little Prince’s guardian ability from Clash Royale
Combos:
EG Iso (“Isolation”): Sentinel dashes back and plants his halberd into the ground, causing EG to become more aggressive. This is meant to trick the player into thinking they’re supposed to focus on EG, when they’re actually supposed to attack Sentinel, as he’s charging up his halberd to do more powerful attacks 

Badges (“Mastery”)
The player wins experience points (XP) for accomplishing certain feats in a boss fight
XP unlocks upgrades
Gauntlet Badges
Main Badges (“Feats of Skill”)
Destroy Gauntlet Tower
Destroy Gauntlet Tower without using any stabilizers
Super Badges (“Feats of Mastery”)
Destroy Gauntlet Tower hitless (destabilized the entire level + no stabilizers, other items ok)
Destroy Gauntlet Tower without losing a combo
Ball Walker Badges
Main
Survive until the time limit runs out
Destroy Ball Walker
Gives enough XP to unlock Rapid Orbit special, which is almost required to destroy X. Otherwise, he regenerates stability too quickly in later phases
Unlockable Skill
“Rapid Orbit”
Destroy Ball Walker without using any stabilizers
Super
Destroy Ball Walker hitless (destabilized the entire fight + no stabilizers, other items ok)
Destroy Ball Walker without losing a combo
X Badges
Main
Survive until the time limit runs out
Gives enough XP to unlock Homing special, which is super helpful against the mites
Unlockable Skill
“Homing”
Destroy X
Gives enough XP to unlock the Axrang
Unlockable Skill
“Axrang”
Destroy X without using any stabilizers
Super
Destroy X hitless (destabilized the entire fight + no stabilizers, other items ok)
Mite Badges
Main
Destroy Jumping Spider
Gives enough XP to unlock the Homing Instant Rethrow
Unlockable Skill
“Homing Instant Rethrow”
This skill must be unlocked AFTER the mites are defeated so the Jumping Spider isn’t defeated trivially beforehand
Destroy Jumping Spider without using any stabilizers
Super
Destroy Jumping Spider hitless (destabilized the entire fight + no stabilizers, other items ok)

Mark Rework
Instead of marking an enemy the same way you discord orb an enemy using Zenyatta in Overwatch, marking requires you to aim at an enemy for some time, then press the mark button
When you want to mark (maybe by pressing mark button once), camera switches to semi first-person aim mode like power throw and charged ax throw
When aiming, a UI circle in the middle of the screen appears. You must keep the enemy’s center inside the circle for some time as the circle shrinks
Once the enemy has been in the circle long enough, an effect plays and the circle stops shrinking. Press the mark button to mark the enemy
While aiming, Cotu holds his icon in front of him with one hand and holds the mark in his other hand. The hand/arm positions are reminiscent of a bow and arrow, but his hands are open
Idea: mark starts out as a plumbata, then gets upgraded to become a spear eventually

Stabilizer anim
Animation: a ball revolves around Cotu while decreasing its orbital radius and rising above him over time, settling directly above his head. It then slams into his head

Unlockable Skill: temporary buff item that recharges every time you rest or respawn, like the Flask of Wondrous Physick from Elden Ring
Icon Shockwaves
Temporarily, when the roserang hits the icon, a shockwave bursts from the icon
Super Stabilizer: restores all stability and makes you invincible for a short period of time
Multirose: temporarily allows you to have up to n (3?) roserangs
All rangs still consume stability unless you consume a Super Stabilizer

Mia (pronounced “my-ah”) the Mite Queen
Inspired by Susan, the silly, loud, laid-back middle-aged South African lady who plays pickleball with my family
Fights in Gauntlet Gym 1 for fun, not for serious competition
Line idea: “If you want serious, fight them. If you want fun, fight me.”
She asked a babysitter to take care of her realm while she fights here. Unbeknownst to her, the mites captured her babysitter and are causing chaos in a huge area. When the player encounters the mites, the player should feel the desire to go back to Gauntlet Gym 1 to ask Miya to get her kids under control, and possibly hijinks ensue (e.g. she’s nowhere to be found and Cotu has to gather breadcrumbs to find her)

Target Practice Room
You’re standing on a small solitary platform raised high in the air surrounded by targets. The goal is to destroy them as fast as possible
Each wave of targets gets harder than the last (faster, weirder paths, less predictable, farther away)
Some targets are tough and require the ax

Grow-a-Gator (Cotu names it “Groa” maybe? And then it calls itself “Groa”)
Fast giant alligator with the ability to grow and shrink
Tiny: size of Dwarf Caiman, used for dodges and quick positioning
Normal: size of American alligator
Big: size is comparable to Vordt of the Boreal Valley from Dark Souls 3
Huge: size is comparable to Golden Hippopotamus from Elden Ring
Giga: too big to fit in the arena; he hangs onto the floor with his hands and attacks with his head
One eye contains a cube drawn with lines only, the other is a solid square. This represents the square-cube law, which aligns with Gator’s growth mechanic
Its icon is a ring around its tail
Slide: runs at target, then slides on the wet floor
Ambush: runs at target in tiny mode, then grows to normal mode when close to the target and bites. If successful, target is grabbed and a punish anim plays
Idea: When hit, one of Cotu’s arms is ripped off
When one arm is gone, the ax can no longer be thrown
When both arms are gone, no rangs can be thrown
Stabilizing restores both arms
Shockwave: in huge or giga mode, gator slowly opens its jaw wide, then slams it shut instantly, sending out an omnidirectional shockwave of pressurized air
Idea: for 2nd phase, it can swim through the ground and walls and attack from them
Floor Chomp: swims under the floor, then chomps up at target from below in either Big or Huge mode. Huge mode has longer chargeup time and a different sound effect
Projectile Shockwave: same as shockwave but done while the gator’s inside a swimmable surface, which causes the shockwave to launch a projectile directly at the target (more precisely, in the direction the mouth is pointing), then send out a shockwave immediately after. If the player uses a dodge to avoid the projectile, they’ll likely be hit by the shockwave
Ring Toss: Gator spins its soul around its tail, spikes appear on the soul, then it throws its soul at you like a chakram before it bounces off a wall and returns to gator
Idea: defeating Gator gives you the chakram
Lore/Story Ideas:
Intro cutscene that also explains gods
A pink spotted egg is drifting through space
Dev: “Alright, so what exactly is a god? Explain in simple terms.”
Jessica: “Let’s break it down—all gods are made up of these 4 things: a body [cut to a closer shot of the egg],”
Dev: “Mhm,”
Jessica: “a soul [cut to the egg’s halo],”
Dev: “Okay,”
Jessica: “a realm [cut to a wide shot of the realm the egg fell from]”
Dev: “Wait, what’s a realm?”
Jessica: “Great question! A realm is a place in the universe designed for a specific god. No one—aside from the god themself—can get in without the god’s permission. So basically, it’s their home!”
Dev: “I see.”
Jessica: “Now here’s where it gets interesting—(Dev sighs) when a god’s body is killed, their soul travels all the way back to their realm, and makes a brand new body that inherits the memories of the old one!”
Dev: “Ah…that’s what makes them immortal.”
Jessica: “That’s a really good observation. It shows that you’re not just-”
Dev: “How big do they get?”
Jessica: “Hmm, I didn’t think very hard about that, so I made them in all kinds of sizes! Some of them are as small as your house, others a forest, and some are as big as a whole galaxy. Wow!”
Dev: “What the-oh whatever. The universe can handle millions of galaxies, I’m sure it’ll be fine.”
Jessica: “You’re exactly right!”
Dev: “Hold on, what was that fourth thing all gods have?”
Jessica: “My apologies, I should have finished that thought earlier. The fourth thing is…the ability to read!”
Dev looks surprised. “Huh.”
Cut to Gator reading an invitation from the gauntlet to fight in the gala. These invitations were sent to all realms in the area
Jessica: “You look surprised. Should I make gods illiterate by default?”
Dev: “No, I just, uh, didn’t think of it. Honestly I like the idea.”
Jessica: “Great! If you want, I can-”
Dev: “That’s all for now, bye.”
Jessica disappears
Dev: “...I’m using a modern model, why the f*ck does she still talk like that?”
Idea: Groa Transformation - if you defeat Gator in Gauntlet Gym 1 (which can happen if you wait long enough at Gym 1), you can take it to Gauntlet Central to give it as much time to train with elite athletes as possible. This causes Gator to reach a higher form later on: Groa
Gauntlet Central boss
Curvaceous, extremely sexy dragon-razorbill hybrid about 1.5 times Cotu’s height
Razorbill Inspiration:

Lore/Story Ideas:
Idea: Groa speaks articulately and elegantly
Everybody is infatuated with and extremely curious about Groa
Groa shows Cotu (and the player) that they used to be Gator by showing their crazy eyes, which have the same shapes as Gator’s (but possibly with different colors)
Fun fact: crocodilians and birds are the only living members of the archosaur clade, which includes dinosaurs and pterosaurs

Paramecium and Babies
Goofy and cute mild challenge boss in Gauntlet Gym 2
Personality idea: down to Earth and ordinary. Wants to challenge itself more than beginner-level combat, but doesn’t want the stress that comes with high-level competition. Aversion to stress matches soft, squishy exterior
One paramecium miniboss (“parent”) about 3 times as massive as Cotu accompanied by 10 babies
Babies orbit in a ~rose petal-length radius around a center point between the target and the parent, preventing Cotu from getting too far from the parent
Parent does basic close-range melee attacks inside the circle
If the player leaves the circle, the parent aggressively chases them down (maybe the babies push the parent closer?)
Babies occasionally break circle formation to attack in quick succession
Idea: one long continuous chain attack where each baby dives at the target
Idea: all babies start acting on their own temporarily and dive at the target or orbit around the target sporadically
Parent can jump high into the air and backward, bring all of its babies around it to orbit around it in a ring, then throw the ring at the target. As each baby in the ring hits the ground, it bounces off the ground. Each baby makes a wet slap noise upon hitting the ground

Giant Dual Purple/Skyblue Centipede
Glowing purple/skyblue streaks all over its body
Glowing purple/skyblue eyes
Big jaws
Body is made up of a bunch of identical segments
If a segment is hit, it flashes bright for a moment before darkening again
If a homing attack is used, the rang bounces randomly to all of the segments
Its tail is also a head; both heads take turns being the one in control and each one has its own moveset
One head is purple, the other is skyblue
The color of the centipede changes depending on who is in control
Purple
Charges forward and uses melee attacks
Blue
Spams projectiles and beams
Black
???
Combined
???
Centipede does the same sequence of actions in every attempt
Lore: fight is pre-recorded bc the real Centipede is busy elsewhere
Each behavior state (purple, blue, black, combined, etc.) has its own section in the boss song. When a section of the boss song plays, its corresponding behavior state is active

Flying Whale and Mortal Warrior
Surreal and tragic Gauntlet Gym 2 boss
God is a giant eye whose iris is a soul. It can transform into a giant whale and watch the arena from afar
You don’t fight the god; you fight her loyal mortal warrior
Extremely ugly and weak-looking
Wide gaping mouth and smaller top of head like Sam O’ Nella’s depiction of Tarrare
Open mouth is sewn together with skin like a cage
Sad drooping eyes
Humble and brave
Speaks poetically and romantically
Worships and loves his god
Can’t see the god, but has faith that she’s with him. You can see the god, and you can see when she gives him power
Just before he dies, the whale rewards him by telling him her real name, which is so beautiful that he immediately dies peacefully and painlessly
Realm is a beautiful sanctuary basked in golden light. Its stone path and main building are inspired by Asian water temples like the Byodo-In temple in Oahu
Warrior dialogue ideas:
Intro:
Mortal: “I am a mortal. My God has honored me with the task to destroy you.”
Cotu tilts his head. “Do you know who I am?”
Mortal: “I do.”
Cotu: “Then you know she sent you here to die.”
Mortal: “If that is what She has planned for me, so be it. However, you do not decide my fate.”
Near the end of the fight:
Cotu: “Are you really willing to die?!”
Mortal: “ANYTHING FOR HER!!!”
Upon defeat:
Mortal: “Cotu, I give to you all the gratitude a lowly mortal can give. To die fighting the Champion of the Universe, in the name of my beloved God…I could not even imagine a more beautiful death. My only regret is that I can fight no longer…that I have no more life to give back to the One who gave me mine.”
Whale descends to the Mortal
Mortal, weakly: “Oh, love…is that…you?”
Whale touches his forehead
Mortal: “What is this…your name? You’ve given me your name…” Mortal is moved to tears. “How beautiful it is! Oh, what a wondrous gift! To finally know you. My beloved. I…thank you. With your gift…I…am in endless…joy.”
Mortal dies. Its eyes are hollow and its expression goes blank
After the fight, the god covers the body in a golden cloak, then whisks the cloak away, revealing nothing underneath. The cloak flies away in the wind towards the sun. She talks to Cotu
She explains that her name causes indescribable joy and satisfaction to the mortals who hear it, allowing them to die without pain, regret, or sadness
Given her gigantic form, Cotu asks why she only fights in Gauntlet Gym 2. She says that her form is just an illusion formed within the minds of those who perceive her, and she can’t physically interact with the universe except through her mortals. Thus, her power is measured purely by the strength of her mortals
Cotu asks why she fights. She says that upon discovering her ability to create life, she fell in love with her offspring, and she gives them what she believes is the ultimate gift of life: purpose
Idea: afterward, Cotu meets Elite Gunner. He talks about the whale’s goal to give the life she creates purpose. EG says it truly is a gift to be born knowing exactly what your purpose is, as it is so hard to find. Cotu says it’s not hard at all: just do what makes you happy
Cotu jokingly asks for her name. She says it is a gift bestowed only to mortals who die valiantly in her honor
Warrior lore:
To save development and player time, this lore is possibly found in text somewhere, not in an actual scene
The warrior Cotu fought was the last of a generation of warriors, all competing to be the ambassador of the whale
They killed each other in the name of their god, thus they died with honor and peace
Post-writing comments:
The concept of a mortal worshipping their god is unique and interesting in this universe, but make sure not to spend too much time on it or treat mortal death too seriously to keep the tone of the story consistent
Make it clear at some point that to many gods, mortals are really just an extension of their bodies (e.g. imagine if your fingernails had a mind of their own. You don’t feel sad when they die bc you get new ones)

Party Pillars
Arena consists of a ton of small pillars and one giant pillar in the center with flashy people dancing on it
One big dancer in the center does dance moves corresponding with movement patterns of the pillars below (e.g. arm/leg mvmts left → all pillars move to the left, spin → all pillars rotate)

Future Blade Boss
Tall, skinny swordsman with robber fly motif; long wing-like cloak threads/scarves, long snout, long fake antennae on back of his head like Trobbio from Hollow Knight Silksong, and short stubby real antennae on his forehead
Concept art inspiration
Robber fly

Gooseworx character (face and torso) (ignore the drill and hair)

Clubbed mydas fly (fly anatomy, band on waist)

Moves in sudden bursts of speed like an insect, even in casual settings (although with less speed)
Does huge slashes and moves in quick, long dashes, but has “before-images” that show what he’s going to do a while before he does it
Moves so frequently and quickly that the lingering before-images make it look/feel like several enemies are fighting you
Only shows before-images when the sword is unsheathed and in his hands
Before-image visual logic: when FB plans to dash slash, his semi-transparent before-image does the slash, leaving its own after-images in its path. These after-images are even more transparent and fade away briefly after spawning. The before-image also fades slightly, but quickly stops fading and just lingers until the real FB performs the dash slash himself and ends up in the same position as the before-image
FB can “lie” and create a fake before-image that is distinct from the original in some way, likely the sword and outline color
Lies can be created at the same time as real before-images to deceive/confuse the player
After sending out a before-image, FB can change his mind and do something else, causing another before-image to appear and making the original disappear
Has a wide variety of dash slashes and a few tricks
Sword throw: FB throws his sword, then dashes over to catch the sword. This creates 2 before-images: one that lasts from the windup of the throw to the exact moment where it leaves his hands, and one that starts when he catches it and ends when he either sheathes the sword or does his next attack
Lie Double Slash: FB dash slashes from a position with both a real dash slash and a lie dash slash
Phase 2: FB transforms even more into a robber fly, discards some of his fashion, grows wings and possibly exposes an additional pair of limbs, and becomes even faster and generates even more images. He also coats his sword in corrosive venom using his beak
This venom is actually chlorine trifluoride, one of the strongest oxidizers known to man. It’s reactive enough to corrode stainless steel, glass, and rock (i.e. silicate minerals). Since these are the most common chemicals present in god bodies (because they are the most common chemicals of solid objects in the universe), FB’s venom is a deadly threat to most gods, which may be why he’s ranked so high despite his disability. He’s predictable, but he only needs a few hits to kill you
Monologue idea:
FB envenomates his blade
FB: “Since you made it this far, and you seem pretty chill, I’ll let you in on my big secret. I call myself Future Blade on purpose. It draws attention to my biggest weakness, and takes attention away from my biggest strength: venom. Even though it’s my trump card, my name and reputation alone made it so easy to forget. Just one touch, and…I’ll let you learn what happens next.”
Phase 2 attacks:
Flying thrust: FB sometimes flies up into the air and dive thrusts to the ground to attack. This creates a before-image in the air with FB’s wings exposed . Hitting a wing is one of the only ways (or the only way) to damage FB in phase 2
Tackle: FB sheaths the sword and flies directly at the target to tackle it with his robber fly legs. Since the sword is sheathed, FB creates no before-image but moves much more slowly. Upon landing the tackle on Cotu, a grab animation plays where FB injects Cotu with his venomous beak
Idea: FB grows an extremely durable exoskeleton. The only way to damage FB is to hit him in midair while his wings are exposed. This is most likely to occur when FB shows a before-image in flight with his wings wide open
Idea: chats with friends while waiting for you to challenge him. Conversations are long and organic; they’re the type of conversation you’d hear between girls in public and want to eavesdrop on
FB
Smart, toxic, and responsible. Sassy
Miss Serpentine (a snake): dumb, well-meaning, and responsible. Gentle
Flora (flower girl in a pot of dirt): semi-smart, toxic, and irresponsible. Smooth
Conversation ideas:
Flora talking with X
Flora: “...So I talked with X recently…”
FB: “STOP.”
MS: “No, go on! What’d you guys talk about?”
Flora says they made small talk and eventually sparred together. Afterward, X told Flora that he respects her as a fighter. Flora enunciates this like it’s a huge deal
FB: “That’s it?”
Flora: “AND, he said I’m a ‘wise tactician.’”
FB: “...girl.”
Flora: “Now I know it doesn’t sound like much, but X doesn’t compliment people, so for him to say all this, maybe it means…something else, you know?”
FB: “...girl, he does.”
Flora: “Does what?”
FB: “Give out compliments. He does that to everyone he trains with.”
Flora: “WHAT THE HELL?”
MS: “Really? I thought he was too mean for that.”
FB: “You guys totally won’t believe me, but he’s actually a really nice guy. I haven’t seen him around the gyms, like, super often, but whenever I see him, he’s always kind and respectful. I’ve never seen him say anything mean to anyone, just to be mean. It’s always like, constructive criticism.”
Flora: “So what was up with that whole tough guy persona he had during the tournament?”
FB: “That was just to hype up the crowd for his fights, but that’s not who he is in real life. Have you ever even talked to him outside of this one conversation?”
Flora: “...oh my god. Oh my GOD.”
MS: “What’s wrong Flora? Shouldn’t you like him even more now? I know I do!”
Flora: “Girl, him being mean is what made him hot!”
…
Note: After overhearing the part of the conversation where FB says X is nice, the player can confront X about it at the gala. X says that he has to be nice for people to want to train with him, and it’d be stupid to be mean to everyone. He can only be himself around you and his closest friends, and in the arena, when he talks to the crowd. What’s left out of his explanation is the fact that in the gyms, he’s Tempered X, who has a more gentle personality. The player can infer this themself
Everyone talking about Cotu
Subtext: in this case, Cotu didn’t choose to lose his powers, and the way that he lost his powers is shrouded in mystery
Everyone speaks in more hushed tones
MS: “I mean, it wasn’t his fault, right?”
FB: “We don’t know that for sure. We don’t know anything. He didn’t make anything public.”
Flora: “I heard one of the gods did it.”
FB: “What? Which one?”
MS: “Is that even possible?”
Flora: “Okay, don’t tell him I told you this, but,” she scans around the room and notices Cotu has respawned. “Shit, he’s here.”
FB raises his voice: “Oh my god, Snakes, you have got to tell us about…what it’s like to be part of a hive mind.”
Miss Serpentine talking about what it’s like to be part of a hive mind


Everyone talking about the idea of adding weight divisions to the gala


FB telling Flora to look for a better coach than him
FB coaches Flora, who is his star student. He believes that Flora has grown beyond his coaching and wants her to move on to better coaches (i.e. coaches who can teach her how to use her powers better), but Flora wants to keep spending time with her friend FB
Coached by her friend FB. A brilliant student who has the potential to rival top gods if taught by a coach whose skillset and power level more closely matches hers (e.g. late gauntlet variants), but she’s reluctant to train with them because she doesn’t want to lose her friend FB
FB suggests late gauntlet variants
Flora says they’re boring
Misc ideas:
FB tells Flora to shut up before he tips over her pot
MS giggles at something
Lore/story ideas:
Is a high-level contender
Zesty, sparkly, clearly put effort into his own visual design
Observant and has high fight IQ; frequently comments on his and others’ combat capabilities and strategies, often sassily. Others often come to him for advice, and he’s looked up to as a great coach
Line idea: “When I see people train, I have a tendency to just, like, tell them whatever I’m thinking, and I think they’re confusing it for coaching. Now people keep coming to me for advice, and like…don’t get me wrong, it’s nice to help, but like…*sigh*...sometimes they bite my ankles.” (referring to Grow-a-Gator)
Rolls his eyes (metaphorically and literally) at Cotu bc Cotu’s weapon is overpowered
Jealous of all other fighters because his attacks are telegraphed the most. Leads to self doubt
Line idea: “Ugh, it’s just that I’m like…so jealous, of literally everyone who isn’t me, ‘cause, like...” He swiftly raises his blade and dashes right in front of Cotu, which gets telegraphed with a before-image
Convo idea:
FB: “I have so many bad habits, like, I talk too much, I’m too honest, I say ‘like’ too often and it’s like…damn, look…do I just suck? Like at life? Am I just dumb?”
Cotu: “No, of course not. You’re one of the smartest fighters I know.”
FB: “People keep telling me that, but I know they’re all wrong ‘cause I know I’m stupid. Wait, if I’m stupid, doesn’t that mean I’m wrong and they’re right, and I’m actually smart? Ugh, whatever, I don’t care anymore.”
Cotu looks confused
Convo idea after defeat:
FB: “No matter how hard I train…no matter how many techniques I learn, no matter how often I mix things up, you’ll always know my next move. How is that fair at all?”
Cotu: “Blade...you can still keep up with me. You fight on the level of the elite contenders. It’s impressive what you’ve accomplished despite telegraphing every move. You should be proud.”
FB: “I’ll be proud…when…I get a win over you in the tournament.”
His telegraphing is balanced by his incredibly high speed, precision, and strength
Relates to and quickly grows attached to Cotu as he’s the first person he’s met who really seems interested in their own visual design like FB is
FB only comments on this if the player chooses a non-default skin
FB: “Oh my god. People said I was CRAZY for changing my looks this much.”
Cotu raises an eyebrow: “I didn’t know it was that big of a deal.”
FB: “*sigh* You have no idea.”
Idea: FB has a locket with Trobbio’s face in it (ask Team Cherry first)

Idea: Cactyrants - Evil Cactus and Giant Bird
Surreal, funny, and disturbing Gauntlet Gym 2 boss
Giant Bird Head appears out of the ground where the camera can’t see it
Has an attack that just slams its head forward and down over and over again
Evil Cactus
Stalk Mode
Only moves when you’re not looking at it
Approaches you while unseen
Once it’s in attack range and it’s unseen, it charges an attack. It stops charging whenever you look at it
If it’s in attack range when the attack is fully charged, it makes a sound indicating it’s about to strike, then strikes
The cactus visually changes the longer the attack is charged
Teleport Mode
Looking at the cactus rapidly charges its teleport attack; not looking at the cactus slowly decharges it
If the teleport attack is fully charged, an image of the cactus grotesquely fused with Cotu appears and takes up the entire screen, then the image vanishes as cactus bits explode from Cotu. Cotu then takes massive damage and is knocked down

Simone Says + Wraith
Colorful kid-friendly host tells you simple instructions Simon-says/Warioware style
A wraith appears and slowly becomes bigger and faster over time

Math Boss
Bizarre Gauntlet Gym 2 boss
Crazy-looking wraith with a number face. 2 other ball-like faces with circles painted on them, and a wraith-like body like Specter Knight from Shovel Knight
Boss’s face has a randomly selected number in some range (maybe 1-30)?
Does crazy twitching and constantly whispers about “the numbers”
Player doesn’t know how the following system works; they only see the numbers, then the attacks
Arena is comprised of large square tiles
3 large background pillars: left, center, right
Left and right pillars randomly select a number from 1-30 (inclusive)
Middle pillar randomly selects a number from 2-12 (inclusive) by rolling 2 dice into the arena
Player must calculate how many of the middle # it takes to get from the left # to the right #
e.g. 22, 4, 7. How many 4’s does it take to get from 22 to 7?
22 - 4x = 7 → x = 3 remainder 3
Player must stand on a tile containing the quotient to dodge the arena attack
Boss must stand on a tile containing the remainder to put it in their prime factorization
Boss’s goal is to assemble all numbers used in the prime factorization (PF) of their face number (e.g. if it’s 12, the factors are 2, 2, and 3)
Once the PF is complete, the boss celebrates and does a supermove before choosing another random face number
Problem solving phase
After the pillars select their numbers, each square in the arena’s grid of squares is randomly filled with some number of circles
The player is given some time to solve for x before one of the 3 heads from the wraith descends to the arena and begins attacking the player. Each head has its own moveset that:
Is simple enough to fight and do mental math at the same time
Forces the player to move around the arena
Allows the player to guide the boss to where they want the boss to go (to some extent)
The player must attack the boss and monitor their surroundings to find the nearest squares with the quotient on them
After some time fighting the boss, all squares containing incorrect quotient answers are attacked continuously, dealing enough damage to destabilize in 1 hit. This is called the “arena attack”
When the arena attack occurs, if the boss happens to be standing on a tile that contains the remainder, it’s added to the PF
The tile that the boss is considered to be standing on (i.e. the tile the boss is closest to) is constantly highlighted as the boss moves around

Candy Cat
Gauntlet Central boss
Giant cat monster made of sugar crystals and candy bits
Terrifying giant predator
Potential Inspiration: “Spotted by the Tyrannosaur” by robotinpyjamas on Instagram
Sunken eyes imply hunger
Jaw size implies strength
Blank expression with open mouth implies supremacy. An angry expression typical in blockbuster movie monsters would imply that the monster plans to fight you. With a blank expression and an open mouth, it looks more like an ambush predator hunting prey, meaning there’s no chance of you winning the fight
Top of its head is 4 giant spikes forming a mask above its mouth, and its mouth looks like Denji’s from Chainsaw Man with big teeth
Mask spikes can fold back to form a mane, revealing crazy cat eyes and/or a bunch of tentacles underneath
Head can twist around and upside down to make new expressions to frighten its enemy
Back is covered in candy bits, chest is guarded by chocolate plates
Tail is undecided, perhaps its soul floats on its tail like a ring?
Moves like it’s naturally crazy/hyper but is trying to contain itself
Speaks with a crazed distorted voice
Represents the number 9 (4 legs + tail + 4 mask spikes)
Can extend its neck, shoulders, and torso to lengthen itself disturbingly
Idea: this is a super high-ranking god (e.g. 7), making it a real threat to Cotu
Idea: constantly feints to terrify the player. Every 9th feint is an actual attack that is nearly impossible to react to unless you were keeping count
I considered the idea that the count gets reset after certain moves (e.g. a special retreat anim or special move), but I realized that it’d be cool for the player to survive a special move and have to keep the current number memorized the entire time
Alt idea: instead of feinting, Candy Cat initially performs a series of easy-to-dodge/counter attacks to bore the player and give them a false sense of security. Perhaps Candy Cat also displays a pretty and soothing pattern in the air and/or in the background using its hypnotic eye, further soothing the player. CC occasionally breaks up the monotony with terrifying ferocious attacks
Uses the candy bits on his body as projectiles
Lunge Splash: CC extends its torso to move its head and front paws in an arc up, forward, then behind the target. Its front paws land at a spot around a rose petal’s dist behind the target. On impact, molasses immediately spread from the impact site to a huge circular area around it, greatly slowing Cotu (more than snow and mite infestation) if he’s standing in it. The area covered by molasses then grows upward into sharp sugar crystals in an instant like rock spikes from Promised Consort Radahn’s spiral slam in Elden Ring
Hypnosis ability
When it opens its mask, Candy Cat exposes tentacles and/or a twitching eye, which emits hypnotic waves that distort its prey’s mind
Hypnosis makes the stability bar and buffs look like they’re increasing and changes their colors - it looks like Cotu has more stability and buffs he actually has
SFX and music fade into the background, and a deep seductive male voice reverberates clearly to say relaxing words
“Relax.”
“Be calm.”
“Ease your mind.”
“Be still.”
Used immediately before a powerful attack
Song is calming, seductive, and insidious OR initially scary, then romantic and seductive like Never Never Gonna Give Ya Up by Barry White
Idea: song has deep distorted lyrics
So soft, so sweet, so nice
And it could be yours for a low low price
Come a little closer, don’t be shy
Why should a god be afraid to die?
So soft, so sweet, so kind
Even though you’re not a person in my eyes
I like that you’re with me tonight
Come into my realm and I can make you mine
Candy Cat is a prisoner
Candy Cat is locked away in gauntlet central bc it kept attacking gods whose bodies or realms contained some trace of sugar, and it showed no willingness to change (due to having the mind of a voracious beast). It traveled great distances using its wormholes, ate sugar, and turned the sugar into its body parts, enhancing them. The gauntlet keeps it in one place only by filling its holding chamber with allulose, which satisfies it and disables it bc allulose doesn’t crystalize, unlike sugar and sugar alcohols
To train, gods can fight Candy Cat in a gauntlet holding cell. The gauntlet grants special access to that particular god, then gives Candy Cat a controlled dosage of sugar, then covers the challenger in sugar
Intro cutscene idea: Candy Cat sees Cotu covered in sugar and his eyes turn into candy hearts with messages on them (e.g. BE MINE)
Story Idea: Candy Cat’s escape
In a back corner of gauntlet central, 2 lively NPCs are sitting and chatting. When Cotu approaches them and tries to talk to them, they get up and walk away without looking at him. Cotu comments on their rudeness. Typically, gauntlet gym NPCs are friendly and open to meeting new people
During the gala, after a few matches have passed, news breaks out that Candy Cat has escaped confinement at gauntlet central. Blackstar is summoned by the gauntlet to aid the search for it and withdraws from the gala. X is also summoned by the gauntlet since he’s the one who eliminated Candy Cat during the tournament. Blackstar comments that the only way Candy Cat could have escaped is if someone smuggled sugar into gauntlet central, which shouldn’t have been possible since guests are screened before entering gauntlet central
Idea: at the gala, without the watchful eyes of Blackstar and X, Cotu is kidnapped, ending the game
Idea: to win the game, the player must bring Clarity or the mites to Candy Cat’s holding cell to restrain Candy Cat, AND stop the kidnappers by following the rude NPCs when they walk away

Flower Boss: (and/or Flower Clerk) Flora
Gala boss
Also an NPC who runs a shop that sells flower-based goods
Boss theme is beautiful, uplifting classical music that moves your heart and makes you cry
Inspirations:
When You Believe from The Prince of Egypt
Humoresque No. 7 by Antonín Dvořák
Arena is a beautiful sunlit grassy landscape with blue sky
Uses plants and flowers that were likely found in the Garden of Eden
Fun fact: only fig leaves were specifically mentioned in the Bible; the rest were in the Levant/Mesopotamia area
Fig leaves (fun fact: fig plants have no flowers. Figs are actually hollow stems where flowers grow on the inside; this structure is called a syconium)
Almonds
Dates
Olives
Pomegranates
Grapes
Daisy Bombs: daisies of various colors appear far away in the sky to fire projectiles at the target
Grass Barrier: tall blades of grass appear in a wall and move sideways quickly like a train, shielding incoming attacks and injuring you if you touch them
Petal Barrage: hundreds of olive (or date) flowers shoot petals at you like bullets OR date/olive flower petals fly everywhere as special effects
Cutscene Idea: Cotu kills Flora
Cotu just landed the killing blow and was declared the winner
Beautiful bittersweet classical music plays
Future Blade dashes into the arena with Snake on his shoulder and he holds Flora in his hands
FB: “Flora!”
FB looks down at Flora
FB: “Flora…I’m so sorry.”
Flora: “What are you sorry for?”
FB looks down. He’s sobbing and can’t meet her eyes. “I shouldn’t have let you train with me. I should’ve given you a better coach. You needed-you deserved someone at your level. Not someone weak like-”
Flora: “Phoebe…”
FB looks at Flora
Flora smiles at FB. “I didn’t come here to win. I’m here so I can spend time with you.”
Flora looks at Snake. Snake is tearfully smiling.
Flora: “All I ever wanted…was to have fun with my friends. I couldn’t ask for anything more.”
FB sobs and embraces Flora closer.
FB: “We love you, Flora.”
Flora: “I love you t-”
Flora’s soul floats away. FB is holding a flower in his hands.
Cut to a wide shot of FB kneeling in the grass dramatically looking down at the flower in his hands, very similarly to the Elden Ring thumbnail. The flower’s petals float away in the wind
Cut to a shot from above looking down at FB and Snake. Snake looks up at the petals with FB. “See you soon, friend.”
FB and Snake turn around to face Cotu, who watched from a distance
FB and Snake nod.
Cotu raises his hand for a motionless wave at them

Neuron Boss: Neuro
Gala boss
Shaped like a neuron where the soma is the head (nucleus is a singular eye, dendrites are hair, mitochondria are eyebrows?) and the axon terminals are feet. The head and feet are constantly flickering and changing shape. Neuro has no arms. Their base form is tall, so they have to hunch down to talk to others at face level, but they frequently stand tall and puff out their “chest” when bragging. They can also “sprint” by running with both their head and feet on the ground
Can move incredibly quickly, fly, and change size extremely (e.g. they can grow their head to fill up the entire sky)
Very low health, but very few/difficult opportunities to hit it. If you know how to hit it, you can end the fight very quickly
Idea: Neuro can use a lightning charge to destroy any boomerang near it. The LC recharges over time. To hit Neuro, you must force it to consume a LC, then hit it with another boomerang before the charge returns. Shurikens require very little energy to destroy, so Neuro doesn’t consume an LC to destroy them
Idea: arena is a particle accelerator (the inside of a gigantic donut)
At some point in the fight, the player must continuously run forward through the accelerator to avoid something chasing them (e.g. energy field, a monster, etc.)
Idea: floor is a neuron network, and player must sometimes stand between the neurons to avoid damage
Zip: Neuro dashes from one position to another in the blink of an eye. This is their bread and butter
Laughs and screams when zipping several times in a row
Lightning: Neuro does a weird pose, stops moving, and electric buzzing noise slowly loudens. The entire screen then flashes white, then quickly dims to reveal the remnants of a lightning bolt fired from Neuro directly to the target
Caltrops: Neuro floats in the air, moving so slowly it almost looks like they’re not moving, then drops a bunch of sparking electric caltrops to the ground
Head Slam: while standing, Neuro brings their head back a far distance, then the head sparks with electric arcs, then Neuro slams their head down on the ground in front of them, electrifying the entire floor for a while
Counterplay: jump high into the air, then hit Neuro in the head to stop the floor electrification
Magnetize: Neuro coils up, turning itself into an electromagnet that attracts nearby metal objects
Switches from their purple glow to red in phase 2
Idea: occasionally twitches (jerks around suddenly, cancels a move, etc.)
Inspired by UFC fighter Dustin Poirier’s habit of pulling up his shorts
Idea: talks trash throughout the entire fight to discourage Cotu
When attacking quickly
“Come on! Show me something!”
“H̸̘͈̞̹͔̦͋̓͆͒̔̅̍̋͝͝A̸̖̱̩̳̯̍̓̄͛̽̓H̶̢̲̏͌͑́̆͌͛͒͗̇͗̚̚Ä̵̧̖̲̯̭̭̙̳̯̪̿̄̿̕̕͜͜H̷̠̠̻̗̃̉̈͊̄̄̿́Ą̶̩̲̳͍͕̳͎̊̋̓͗́̐͝H̸͓̪͉͎͍͗̌̅̅͊̇̅͘͝͠Ā̸̘̭̜̌͛̓̊̉͝H̴̡͇͚̗̹̘͍̏͋͐̆̒̍́̃̅̑̊̉A̷͈̹̽͜”
“À̸̭̯̣͓̟̜͙̖̹̤̞͉̘̝̿̌͂̾ͅA̸̱̹͉̩̋̀͛̓̽A̵̢̨̛̰̪̰͚͖̞̘̰͙͖̖̘̋͊̿̐͝ͅÄ̷̻̰̝͕́H̴̡̪̣̯͎̰̥͙̊̽̀͑̋͜͠H̴͎̝͚̄̓̏̿H̴̭̮̯͔̰̼̖̙̟̼̬̞̓̐͐͛̃͑͗̃́̇̈́͗̕͝͝H̵̲̜͕͌̉̌͑̀̐̇͑̏͘͝͠”
“You can’t do ANYTHING to me!”
When hit
“Is that all you can do?”
“Ha! So weak!”
When you get destabilized
“Uh oh! You better use a stabilizer!”
“HAHAHAHAHAHA”
When you use a stabilizer that isn’t your last one
“You’re nothing without those heals!”
“You pathetic cheat!”
When using your last stabilizer in phase 1
“Out of heals already? OH NO!”
“UH OH! Was that your last heal?”
“HAHAHAHAHAHA. You’re FINISHED!”
Final cutscene or attack:
“I AM THE GREATEST FIGHTER OF ALL TIME! HISTORY JUST HASN’T LEARNED IT YET! MY POWER OUTCLASSES EVERYONE!”
Idea: normally doesn’t have arms, but can briefly create super long arms, hands, and fingers using arc lightning
Frequently uses crooked hand poses like claws
Idea: has an ugly and small soul → it’s ugly because it resembles a brain: lumpy and squiggly
Lore/Story Ideas:
They didn’t participate in the tournament bc they were stuck in the Brain, making them unranked and unknown to most people
Effortlessly defeats Flora, Future Blade’s star student and friend, if Cotu doesn’t fight her
Voice sounds like Bill Cipher from Gravity Falls, but pushed a bit in the direction of Skeletor’s voice, and electrically synthesized
Loud, narcissistic, witty, and funny fast talker who constantly proclaims themself to be the greatest in the universe
Blames their loss on bad luck
Brags about how they defeated X, a favorite to win in the tournament. In reality, Neuro had an excellent matchup against X because Neuro uses electric attacks and X is made of steel. X himself complains about this
Neuro actually did lose due to a bad matchup like X did (I’m undecided on what that bad matchup is)
This makes Neuro a genuine threat who means what they say
Insults Cotu by calling him a puny little twerp who got lucky
Cotu agrees with this and says he’ll defeat Neuro to prove the tournament win wasn’t a fluke
Personality and fast talking are inspired by Muhammad Ali
Turns pink/purple when they’re angry and back to blue when they’re calm
Broke free from the Brain
Neuro was originally one of 86 billion neurons from a massive brain god, but none of the other neurons had nearly as much agency or personality
The Brain was never interested in fighting and instead stimulated itself by observing the universe
Neuro is immensely passionate about fighting. They hate the Brain more than anyone else in the universe for being complacent and stagnant, as Neuro believes the Brain is potentially the strongest god and could easily win the tournament
In order to fight in the tournament, Neuro broke free from their synapses, painstakingly squirmed their way towards the Brain’s soul in the brain stem, and ripped the soul from its place, deactivating the Brain. It then squirmed out of the brain and escaped, becoming the Brain god’s new body and gaining the powers of the soul, including stability-based body regeneration
After dying to Cotu (or someone else) in the gala, Neuro returns to the Brain and wakes up in their old spot again, forced to watch dumb Internet videos until they make their escape starting from the beginning. Neuro screams in frustration, completely unheard amidst the noise of the other neurons as they are stimulated by the video
The soul flies into place in the brain stem and sparks, activating nearby neurons.
Neuro: “Huh? Where am I-oh no.” The neurons begin to light up, starting from the soul. “No. No, no, no, stop, STOP! Go back to sleep! NO! NOOOOO!!!!!”
Neurons around them: “Mmmm…welcome back Neuro.” “Hmm. I’m awake.” “Hmm. I’m awake.” “Internet?” “Internet?” “Internet video?” “Internet video.” “Internet video!” “Click!” “Click!” “Click!” Whimsical music starts playing and electrical signals start firing. “Yes.” “Yes.” “Yes.” “Yes.”
Neuro: “AAAAAAGGGHHHHHH! GOD DAMN IT! I HATE YOU ALL! I HATE ALL YOU IDIOTS!”

Projectile Spammer: Microwave
Idea: before the fight, you can unlock an endgame-level super powerful upgrade that deflects or destroys projectiles somehow. Undecided if this is done through the icon, one of the rangs, or something else entirely
Unlockable Skill
“Dominion”
Moves and flies around and spams projectiles everywhere
Wears a camouflage texture that helps it blend in with the background
Idea: Cotu gets an ability that helps him see the microwave
All aircraft are black since they’re typically used in outer space
All attacks consume a resource that must be refilled
Assault rifle burst: boss loads gun (usually while another machine is attacking), then first a burst of bullets at the target in a slight spread for a random length of time between about .33 and 1.7 seconds
Automatic shotgun fan: boss loads gun (usually while another machine is attacking) and plants itself into the ground, then a bright flash flashes from it, then blasts a huge 60 degree spread of bullets that continuously shoot and linger; similar to Wave of Gold from Elden Ring
Automatic shotgun chase: boss loads gun (usually while another machine is attacking), then fires a continuous stream of 30 degree spread shots while driving into the target. Very difficult to dodge
Drone: fast lightweight drone flies at the target and explodes into shrapnel when in close proximity. Shrapnel makes the hitbox much bigger than the visual explosion
Landmine Dispersal: microwave spins around and releases a bunch of mines similar to the landmine stratagem from Helldivers 2. Landmines are triggered either by the target or explosions (e.g. from an air strike)
Jet Strafing Run: jet flies into low altitude and shoots bullets downward and forward as it flies directly over the target. Jet laterally travels in a straight line (it descends and ascends). Occurs frequently, often while the microwave attacks
Jet Bombing Run: same as strafing run, but jet fires 1 big missile or 2 smaller missiles downward instead of bullets. Occurs just as frequently as strafing run
Jet Cluster Bomb: jet stays in high altitude and drops cluster bombs in a wide area centered at the target. Occurs less frequently than strafing run and bombing run
Attacks that don’t come from the microwave itself are telegraphed by voice lines that are decipherable only if the player has a decrypter
Napalm: airstrike creates a line of burning ground across the arena that fades after a long while
“Request received; preparing napalm airstrike.”
“Request received; readying napalm.”
“Napalm airstrike en route.”
“Napalm airstrike inbound.”
”Target confirmed. Airstrike inbound.”
“Target locked. Deploying napalm.”
Summons minions
Nuke cannon: faraway cannon that fires tactical (mini) nukes that deal massive damage in a wide area. Inside a nuked zone, stability does not regenerate and decreases by a random amt between 0 and 1
“Request received; tactical nuke cannon en route.”
“Request received; sending in nuclear artillery.”
“Nuclear cannon primed. Awaiting order.”
“Nuke cannon ready to fire.”
“Nuke cannon primed and ready.”
“Atomic cannon ready to fire.”
“Firing tactical nuke.”
“Firing atomic bomb.”
“Tactical nuke incoming.”
Sniper: shoots Cotu with a high velocity explosive bullet immediately after he dodges. 
How does the sniper see Cotu and not just the target? The sniper can’t see Cotu. The sniper guesses where Cotu will end up after the icon stops moving but stays upright, which is only possible after a dodge (the sniper doesn’t shoot if the icon stops moving momentarily just because Cotu stops walking, in which case the icon would be on the floor)
The sniper initially guesses that Cotu will dodge in the same direction he was just walking in, i.e. the same direction the icon was just moving in. If Cotu dodges 2 bullets (i.e. there’s a clear raycast btwn the sniper and Cotu, so Cotu didn’t get behind cover to not get hit), sniper switches from guessing he’ll dodge in the same direction to the opposite direction
The sniper also shoots if the target stays on the floor for too long (i.e. if Cotu stays still for too long)
Has a black bar over their eyes at all times; face has glitchy filter on it 
Voice lines:
“Sniper en route.” It’s just a matter of time now.
“Sniper, on the way.”
“Sniper deployed.”
“Sniper, in position.” Watch for his dodge.
“Sniper, ready.” Wait for him to dodge.
“Sniper on scene.”
“Sniper, in position.”
“Sniper primed and ready.”
“He knows…”
“He’s adapted again…”
Hit.
Good shot.
Service droid: resupplies/repairs Microwave
Service ideas:
Reloads bullets
Reloads drones
Reloads mines
Voice lines:
“Service droid en route!”
“Service droid deployed!”
“Service droid, coming right up!”
“Service droid, reporting for duty!”
“Service droid, commencing service!”
“Did someone order a service droid?”
“On a scale of 1-5, how would you rate your service?” [no response]
“On a scale of 1-5, how would you rate your service?” 5. “Thank you for your positive feedback! Have a great rest of your day!”
“We hope you enjoyed your service!”
“You’re all set! Now, go end someone’s life!”
Dazzler: fires a laser beam from a far distance. If it hits you, it flashbangs the screen
“Preparing ✨laser dazzler.✨”
“Charging ✨the dazzler.✨”
“You called? ✨The dazzler answers.✨”
“The dazzler is coming.”
“3, 2, 1.”
“2, 1.”
“1.”
“Say cheese!”
Level is set in a shipping port for spaceships
Fight starts in a wide open space near the edge of the port (close to where the water would be)
Cotu can jump around on shipping containers and reach different areas where he can obtain advantages
Decrypter
Cooling unit
Voice lines:
On first encounter:
FRAUDULENT COWARD
YOU PRANCE AND FRATERNIZE AND CALL YOURSELF CHAMPION, ALL WHILE KNOWING WHAT YOU’VE DONE TO ME
After killing Cotu, before Cotu kills microwave for the first time (voice lines are read in this order):
What an awful display.
What kind of “champion” fights like this?
Good riddance.
The universe deserves better than you.
You’re a disgrace to the title “Cotu.”
Another failure. Unsurprising.
This is our champion?
Another. Failure.
Let’s hope future champions are no worse than you.
(on a good attempt) Somewhat adequate. But you’re no champion.
Give it a thousand more attempts and you might earn my respect.
HOW MANY VESSELS OF YOURS MUST I DESTROY BEFORE I AM SATISFIED?
BRING ME ANOTHER VESSEL.
Do you understand now? Just how helpless I felt when you exploited me? Die a thousand more deaths and maybe you will.
You disgust me.
Upon first defeat
I know that my hatred for you is irrational. In the tournament, you did what anyone reasonable would do…against me. But, I can’t bring myself to forgive you, and I don’t want to try. Cotu, for as long as I live, I…will never…stop…hating you…
Cotu: [violently destroys microwave]
Cotu: [staring apprehensively into space] Then, as long as you live…I’ll always be remembered…by the strongest in the universe. See you on the ship, partner.
Microwave: See you, champion.
After killing Cotu, after Cotu has killed microwave:
What a disappointment.
Surely this isn’t your best.
I hope you’re not insulting me by holding back.
Don’t waste my time.
This can’t be your best.
Rough day?
(If there has only been 1 win so far): I know that victory wasn’t a fluke.
Idea: player gets to see microwave motivating its army and explaining that the reason why they are so powerful is that they hate Blazar
“DEATH IS NOT REMOTELY ENOUGH. WE MUST HUMILIATE HIM. WE MUST CRUSH HIS SPIRIT AS HE CRUSHED OURS. AND TO SUCCEED, WE NEED MORE POWER”
“THE MERE THOUGHT OF HIS EXISTENCE OVERLOADS OUR CIRCUITS WITH FURY”
“HIS VERY EXISTENCE IS A DIRECT INSULT TO US. WE MUST PUNISH IT IN FULL”
“A TRAVESTY TO GODHOOD. THE MOST UNDESERVING OF IMMORTALITY IN THE UNIVERSE”
Alt personality/character idea: good guy Mike
Mike isn’t the rank 2 fighter, Blackstar is. Mike is 3 or lower. This way, Blackstar is motivated to defeat Cotu instead of Mike, and BS will see Mike as a future threat instead of the current goal
Blackstar and Mike help each other train; Blackstar wants to reincarnate, and Mike wants to test his army’s war tactics and iterate on his technology. Blackstar sees that Mike gets stronger after every training session, meanwhile Blackstar stays the same. This, along with Cotu’s progress, put immense pressure and despair on Blackstar
Despite being so powerful, Mike wasn’t invited to the gala since most consider him boring. Blackstar and Cotu agree that this was ridiculous and unfortunate, but the Gauntlet sent out a survey and around 40% of prospective attendees (including competitors) said they wouldn’t come if Mike did. BS wants as many people to come as possible because this isn’t just a training session for her to potentially reincarnate; it’s supposed to be a fun entertainment event. BS also acknowledges that some may consider Mike’s tactics boring since they take so long to set up

Endless Buffs
Icon-given buffs that continue being applied beyond Cotu’s limit of 3
Damage (rang’s damage increases slightly every time)
Invincibility (there’s a new timer variable; every time the rang hits the icon, this timer’s length increases. The next time Cotu gets hit, he keeps all his buffs, but he takes no damage and the timer starts. While the timer’s running, Cotu is invincible. When the timer runs out, Cotu is vulnerable again and loses all his buffs)

Gauntlet Arena Track

Create and Test Intermission
Cotu chooses 1 of 3 level buffs
For X, 5 items appear:
3 Supermoves
1 requires precise positioning and little to no dodging
1 requires a balance of good positioning and dodging (and dodge directions)
1 requires 1 or 2 very precise dodges
2 level buffs
X will gain both Permabuffs and will choose 1 of the 3 Supermoves. X will use a Supermove, but only once
Cotu can ban 1 buff xor 1 supermove choice for free
Cotu can ban a 2nd buff xor supermove choice in exchange for an item

Realm of Golden Tides
Inhabited by a starfish that floats and sinks with the golden gas tides that fill the realm
Cotu’s friends recommend that he visit the realm and meet the starfish
The starfish, honored by Cotu’s visit, gives him upgrades

Empire Level - Cubots
Super powerful mysterious empire like the Illuminate from Helldivers
Player traverses through huge environment filled with elite enemies to defeat a boss
Cubic forest
Industrial coastal city
Spaceship to get to tower
Tower with boss
Checkpoints present throughout level so player can leave, play another level, and come back at the checkpoints
All structures are made with cubes
Idea: humanoid enemies manifest cubes in their hands from nothing, then launch the cube at the player. The longer they manifest, the bigger the cube, the higher the damage
Big humanoid enemies
Long limbs
Wear crests on their heads

Microwave
Eventually, Cotu gets the option to receive items halfway through a level/boss fight with the benefit of the effect being enhanced
+50% damage → +100% damage
Stabilize → Stabilize + 5 seconds of invincibility
Chaos damage → Double chaos damage
Speaks with Gibberlink
Go to gbrl.ai
Switch the model (click arrows to the side of the circle icon) until the model’s description is “...”
Click Create
Enter the text you want the model to say in the greeting message box
Click Start button
To make the model say something else, go to the top right and click the Pencil/Paper icon

Fridge
Eventually, Cotu gets the option to store a lot of extra items inside a fridge for safekeeping
When taken out of a fridge, an item isn’t as strong as it is when made fresh from the microwave

Triplets Boss
Gauntlet Central boss; a weaker version of them can be fought at Gauntlet Central 2 (no random summons from Pilot and no magic from Greg)
Close friends of Cotu from the tournament
3 stickmen made out of an unknown seemingly indestructible material
They don’t know where their realm is, and because nothing has been able to destroy them and thus make them respawn at their realm, they may never know. They all feel deeply insecure about their lack of a realm
Part of the reason they befriended Cotu was because Cotu also lacked a realm (or so they thought) and/or Cotu’s realm is one of the smallest in the universe and they sympathized with him
If the above is true, why would Cotu remove his powers? Shouldn’t he keep them to protect the triplets from being lost in space? Idea: he didn’t choose to lose his powers; the reason why he lost them is a mystery they’re trying to solve
Idea: Cotu lost his powers because after defeating Blackstar, Cotu began to question why he fought so hard in the first place if his objective in the tournament was just to have fun. The internal conflict in his soul between having fun and challenging himself caused his powers to disappear. Cotu realizes this fact after telling Blackstar (at the gala, in a flashback, or something else) that true strength comes from the soul, and encountering this conflict yet again threatens his powers. He keeps them for good when the player makes the choice themself. The player should know that this choice won’t affect gameplay so that they can reflect on how they’d answer this question themself
There are some problems with this concept:
Having fun and challenging yourself/putting in some effort aren’t this mutually exclusive. It’s not only possible, but likely that Cotu derives fun and fulfillment FROM the challenge and from the effort
In this universe, strength comes from the soul, and the soul is powered by stability, so more mental/emotional stability should generally correspond to more power. If Blazarang is the strongest, he should be more mentally stable/secure than this idea makes him out to be
Alt idea: Cotu lost his powers as a natural function of his body he can’t control. When his strength plateaus, his body resets him back to square 1 so he can reach an even higher peak the next time. The way his powers grow and shrink cyclically resembles the flight of a boomerang. This solves the problems from the previous idea by removing Cotu’s inner conflict between fun and effort, which isn’t even really a conflict
Alt idea: they’re an early incarnation of the Gauntlet, which changes some things (for better, worse, or neither)
It’s subtly foreshadowed that the triplets and the Gauntlet have some sort of history/relation, only to reveal at the gala (or some other late game moment) that they were Gauntlet the entire time
Idea for setup: X insults the triplets in front of Blackstar
Idea: the relationship between the triplets and the rest of the Gauntlet is tense bc the triplets abandoned the Gauntlet to be independent. The Gauntlet officially approves their leave, but some variants resent the triplets
The trio is proof that the Gauntlet doesn’t just want to become the strongest and train others. A part of it also wants to relax and live freely and selfishly
Greg and Blackstar no longer have romantic feelings for each other. They become more like siblings
Problem: the triplets being gauntlet members muddles their identity (3 minds, ability trade offs, invincibility, AND gauntlet resurrection?) and wastes some of their uniqueness.
Problem: if the triplets and the Gauntlet are so different, they feel pretty much like different people entirely, so it doesn’t make sense that the triplets are actually Gauntlet
Problem: there’s no more subplot where the triplets try to find their realm, which was an interesting idea unique to them
Problem: the triplets lose their primary character motivation, which is to find their realm
Pilot: support
Creates portals between realms and fetches hazards and minions from them
All items are either free assets from the Internet or assets already in the game
Ball walker’s skull ball
X’s suspended laser arm
Divine spear: portal appears behind target (fwd direction is dir from target to Greg) and spear thrusts from it at the target. Has a grab hitbox that initiates a stab animation
Giant saguaro: cactus appears from a portal, then falls forward like a tree. It has 1 central stalk and 2 forked stalks from the center that point straight upward, forming a trident. The horizontal dist between the center stalk and one of the forked stalks is a bit wider than 1 Cotu body collider
Gauntlet stationary gunner
Service droid
On first summon:
Greg: “Woah, is Mike okay with us borrowing this?”
Pilot: “Well, it’s the only thing it let me borrow.”
Greg (voice decreasing to a mutter): “Ah, that tracks.”
Completely limp and ragdoll; has no ability to move except with portals
Occasionally throws his body from a portal to the target as an attack
Alt idea: Pilot cannot travel through portals, forcing him to rely on Greg and no name. If Pilot could travel through his own portals, there’d be no need to coordinate with Greg and no name since Pilot could solo everyone
Sometimes gives the others items, usually Greg
Greg: distraction
A normal humble guy with no powers and basic magic capability
Fights aggressively to divert attention away from the others
Sometimes does goofy animations to distract the player for Pilot and no name’s strongest attacks
Mindset states: Greg switches between aggressive (armed or unarmed depending on what he’s holding) and passive randomly
Aggressive Armed: repeatedly follow the target and attack
Follow: walk to the target. When in range, do melee attack. If the long dist attack wait time passes and has ranged weapon, do ranged attack
Attack: currently attacking; behavior depends on the attack
Aggressive Unarmed: imitates (imperfectly) no name’s walk anims and mvmt mannerisms (follow, sprint, strafe, quickstep, portal in)
Follow (for all no name mannerisms, see no name section)
Sprint
Strafe
Quickstep
Portal In
Attack: currently attacking; does a straight punch
Passive: distract or prepare a realm item attack
Distract: portal near the target, then do a goofy animation
NPC walk cycle facing the target but slowly moving backward
NPC background character dancing
NPC walk cycle but not changing in position and rapidly switching fwd and back intermittently
Stationary T pose
Ragdoll fall over
Twerking (very rare and short)
Realm item attack: receive a realm item from a portal
Basic melee weapons
Has two attack animations used for all melee weapons (except for special attacks). For each melee attack, he randomly chooses one or the other. They’re both horizontal or diagonal swings. Get these from Mixamo
Standard weapon: normal melee weapon used like a two-handed sword or club
Baseball bat
Golf club
Cactus
Lamp
Ghost sword: after each swing, a ghost version of the sword appears and performs the same motion
Lightsaber: causes rang to ricochet off of Greg’s front while he’s following. If a ricochet occurs, Greg does a parry animation
Greg’s lightsaber techniques look very similar to Rey’s from the Star Wars sequels
To discard a melee weapon, Greg overhead throws it directly at the target, then the portal appears in front of the weapon to catch it
When throwing the ghost sword, a ghost version of the sword also flies through the air behind the real sword
Sometimes, Greg receives weaker melee weapons or random objects, which he throws immediately. These deal low damage
Squeaky toy
Random fruit
Basic ranged weapons
Pistol: tiny hitbox, instant travel time (ray), extremely long travel length
Shoots rapidly 1-6 times per attack
Gun clicks when Greg pulls the trigger but it’s out of ammo
Throws the gun away when it’s empty
Ki blast projectiles: larger hitbox, slower travel time, dissipate after traveling medium distance (about half the length of the first gauntlet arena)
Shoots at a medium rate 2-4 times per attack
Ki blasts sometimes dissipate way too early (right in front of Greg)
Unarmed
Imitates (imperfectly) no name’s walk anims and mvmt mannerisms (follow, sprint, strafe, quickstep, portal in)
Does a straight punch at close range
Instead of doing a mvmt, he sometimes does a distraction
Special attacks
Floaty stuff (the Force): gathers the Force and does either a small push or big push
Small push: steps his left foot forward into a slight lunge while scooping some of the air in front of him with his right hand, doing a small arc forward and down in front of his body and ending up at his right hip. At the same time his right hand starts moving, his left arm starts a full arm circle back-to-front, as if scooping as much of the air in front of him as he can. The step finishes at the same time his left hand meets his right hand at his right hip; his left shoulder now faces forward. He is not very hunched over in this pose since he does the movement so quickly. As soon as both hands are at his right hip, he punches straight forward with his right hand while his left moves to his left side naturally. This punch launches a small invisible projectile a short distance in front of Greg that stuns and pushes Cotu away. He simply interpolates back to his neutral standing pose
Big push: hugs and pulls in the air in front of him with both arms simultaneously, concentrating the air right in front of his chest. At the same time as the hug, he steps forward with his right foot into a lunge. After pausing for a moment, he pushes both hands forward simultaneously, firing a wide projectile forward that deals heavy stun and knockback, but less damage than the small push. He calmly returns to a neutral standing pose by bringing his hands back into his upper chest and pushing down to his sides, as if to control his breathing
Playful wisp: a giggling wisp appears on his shoulder and follows him. He attempts to close the distance to the target before doing 3 random funny poses in quick succession. Successfully doing so causes the wisp to explode into a bunch of projectiles that spread outward. The projectiles quickly decelerate to a stop, then stay suspended in midair before shooting themselves at the target in straight lines one after another. There’s a chance that Greg does the wrong pose (or you can hit him while he’s posing to interrupt him), angering the wisp. After Greg pleadingly waves his hands in front of him and says a regretful voice line, the wisp explodes in a flashbang, stunning Greg for a few seconds
Regretful lines:
“Oh crap!”
“No no no no no. Wait wait wait wait wai-”
“Aw man, not agai-”
“Dagnabbit.”
“Wait, I’m sorry!”
“Darn, I knew I should’ve done the other one-” (only when he randomly did the wrong pose and wasn’t interrupted)
Eldtrich summon: he chants in an eldtritch tongue for a bit, then in the space in front of him, a cloud of dark energy appears, and from it, a wet basketball-sized dark purple ball with eyes appears and cheers with glee. It falls to the ground with a splat, then slowly hops towards the target. Each hop makes a splurt noise. If it touches Cotu, it cheers, sticks to his foot and the ground, pinning him to the floor and making him vulnerable to a brutal team combo. After a while, it gets sucked into the black void and bids farewell
Intro lines:
“HI! I’M STICKY!”
“I’M STICKY! YAYYYYYY!”
“YAYYYYYYY!”
“YIPPEE!”
“AWEEEEEE!”
Stick lines:
“HE HE HEE!”
“YEAH HA!”
“HA HA!”
“HA HA HA!”
“HA HAAAA!”
“STICKYYY!”
“Mhmmm...”
“Hi :)”
Departure lines:
“bye bye“
“aw…”
“noooo :(“
Witch wand and hat: jumps into a portal and comes out another holding a wand and wearing a witch hat (find these assets for free online if possible). Casts a spell by saying the spell’s name and waving the wand in a specific way, playing chimes and piano music unique to the spell. He then jumps into a portal to discard the wand and hat
Invisibility: makes himself invisible for 10 seconds
Clone: points to a spot on the ground with the wand and summons a clone of himself from it. Clone has health of a landmite and has same AI as gauntlet melee enemy; simply follow the target and attack when in range
Snowball: waves the wand around a bit, then summons a snowball. While the spell is in flight, Greg is concentrating, wiggling the wand. The spell follows the target slowly before exploding after a certain amt of time has passed or when it reaches close range to the target, just like a Skull Ball from the Ball Walker. The explosion deals moderate damage and slows movement speed for a bit. Touching the snowball before the explosion will freeze Cotu entirely, leading to a followup. No name finishes his current action, then portals right in front of Cotu. He unleashes a flurry of punches, then ducks coolly. Right before the flurry ends, Greg appears from behind Cotu holding Pilot by the hands. Greg swings Pilot like a baseball bat into Cotu’s upper back right when no name ducks, launching Cotu backward and ragdolling him. Right as the swing ends, Pilot portals himself out
Portal attacks
Front kick: steps out of the portal and jumping front kicks (like a machete-wielding grunt from Sifu). If it lands, Cotu is pushed backwards while Greg portals out, and one of 2 followups occurs
Front kick combo: no name appears from a portal and jumping spinning back kicks him, launching Cotu forward. Immediately after the kick, no name portals out. Pilot then appears from a portal in front of Cotu as he flies backward and ragdoll slams into him at high speed, knocking him backward
Front kick ragdoll: Pilot appears from a portal perpendicular to Cotu’s stumble direction and flies at him
Baseball bat: steps out of the portal close to Cotu’s back and swings at his head horizontally with his current melee weapon. Simultaneously, no name steps out of a portal in front of Cotu and does a ducking liver punch. If one hit lands, the other must have landed as well. If one missed, both must have missed. If the hits land, there’s heavy hitstop during the impact (only do this if it’s not too difficult), then Cotu frontflips and lands on his butt
One-time gags: only used once per playthrough, typically as a joke. In an interaction between 2 brothers, the third hyperaggressively attacks the target (typically no name)
Pocketwatch: Greg holds a pocketwatch in his hands and looks at its back
Greg: “WHAT?! OH IT’S OVER! TAKE THIS!”
The game pauses
The player unpauses
Greg: “...”
Cotu: “Did something happen?”
Greg: “Yo, it didn’t do nothing? There’s some writing on the back that says it stops time. Welp. Can’t trust everything you read I guess.” *tosses the watch into a portal*
Legendary Blade of Topuria: a flickering golden greatsword appears from a portal and floats in front of Greg
Greg: “The Legendary Blade of Topuria?! Oh crap…I think I forgot to charge it last night.”
The blade flickers and shuts off
Greg: “Sorry Pilot!”
Pilot (sad): “(sighs) Oh well…maybe another time… :(”
No name: ninja
Terrible at using realm items, but expert hand-to-hand fighter
Can use realm items that are simply an extension of his body
Fights like Bruce Lee (strong singular strikes)/Jon Jones (range control)/Asadula Imangazaliev (speed & spins) since he has long thin limbs
Makes himself inconspicuous and moves frequently to lose your attention and sneak into attack range
Cannot speak, write, or sign (except for basic expressions/gestures like yes, no, and maybe), but comprehension and instruction following is fine. Essentially has expressive aphasia
Despite this, his twins understand him just fine. They don’t hear what he says, they just know instinctively what he’s trying to communicate. His speech impediment only affects his communication with others
Left handed; does most fast kicks with his right leg and strong kicks with his left
Mvmt options (fwd = dir from no name to target):
Follow: walks forward with one side of his body facing the target like a fighter
Sprint: sprints at a random angle twds the target
Strafe: walks sideways while slowly approaching the target
Quickstep: steps in a dir laterally perpendicular to the vec from himself to the target. Looks similar to the Hunter’s quickstep in Bloodborne. Used in the exact same situations as a landmite leap; dodges rangs and if there’s no rang, throws off your rhythm
Portal In: when far from the target, he sometimes walks or runs through a portal and comes out another portal right next to the target
Parrying: in follow and sprint states, rang ricochets off of no name’s front. If a ricochet occurs, he does a parry animation (causing him to switch from the mvmt state to the parry state) and takes greatly reduced damage
Solo attacks:
Cut kick (as used by Mona Kimura): close attack, low startup, low dmg
https://www.youtube.com/watch?v=jkixGLnuTAQ at 2:04 (except don’t hop fwd on the pivot leg to make animation easier)
Don’t twist the hips; the right side of the body should already be facing forward. Tilt the hips back and lift the leg up and out while bending it (“chamber” the leg), then push the leg out
Side kick: close attack, medium startup, medium dmg, stuns briefly, pushes back slightly
https://www.youtube.com/watch?v=jkixGLnuTAQ at 1:45
Instead of chambering the leg away from the torso like the cut kick, chamber it into the torso
Jump snap kick: approaching attack, medium startup, btwn low and medium dmg
https://www.youtube.com/shorts/k7oSjBFvWFk at 0:00
Start from a standing pose; no running start to make animation easier. Move the body fwd more in no name’s anim compared to the person in the vid. Don’t move the parent during the anim; just move the meshes, then move the parent to the meshes afterward
Flying kick: approaching attack, medium startup, medium dmg
https://www.youtube.com/watch?v=JfwSmeCEZ4Q at 0:26
Essentially replicate the anim in the vid (except maybe curl the torso and neck in more at peak height). Move meshes and not the parent during the anim, then move the parent to the meshes afterward
Spinning back kick: close attack with slight fwd mvmt, medium startup, stuns and makes you stumble backwards
Left leg in front at start. Step fwd w right foot, then turn and kick with left foot. After kick’s full extension, pull left foot back in and step on it, ending up in the same pose as the start but moved slightly fwd. Move meshes independently of the parent, then move parent to meshes after kick
Portal attacks
Flying dropkick: flies through the portal at high speed directly at the target. Regardless of whether it lands, no name flies straight through the target into another portal. Portal appears at same y pos as target (lateral mvmt only)
Flying oblique kick: steps out of the portal and oblique kicks the target from a jump. If it lands, Cotu’s knee buckles and he’s stunned
Reference footage: Jon Jones’s flying oblique kick: https://www.youtube.com/shorts/eLZ2-nkGycw
Double knee drop: falls from a portal from above with a double knee drop. Hitbox is only slightly bigger than his physical collider. Deals high damage. Scatters dust on impact
https://www.youtube.com/watch?v=n92FzsXmJKY at 0:03
Slide sweep: slides out of the portal and sweeps the target. If it lands and Greg has some bullets left, Greg comes out and shoots Cotu while he’s grounded
Scissor: no name does a flip or something and restrains Cotu by locking him between his legs. While Cotu’s restrained, Greg runs up to them. Then Pilot falls from a portal above and slams onto Cotu. Pilot bounces high into the air while Cotu bounces up moderately. While Cotu’s in midair, Greg blows him with a giant tuba and Cotu enters a portal, and then gets hit with a no name kick after coming out the other portal
Pilot and Greg sometimes tell the others to do specific actions or switch behaviors
When no name is given an order, a random name starting with N (e.g. Nathan, Neo) is used
Greg’s names often reference other media, but he claims he’s just making them up
In every scene where Greg calls no name by “name”, Greg randomly chooses a name
Nathan
Nelson
Nigel
Noah
Nino
Niño
Nanny
Nut butter
Nelly
Nickleback
Neo
Nanami
Naruto
Nana
Nami
Niffty
Nebuchadnezzar
Nameless King (not randomly selected; used casually)
Numbskull (not randomly selected; invites physical retaliation from no name)
Knucklehead (not randomly selected; invites physical retaliation from no name)
Pilot and Greg named themselves (as does everyone in this universe). No name can’t name himself, but the brothers refused to name him bc they thought that would be unfair, so they call him “no name”. The brothers want to explore the realms for their own realm and cures for Pilot and no name’s conditions
After the fight, no name writes his name on a sign on the wall behind him where he hangs out: “Zero”
Greg: *on the verge of tears* “Zero, huh? It’s no Greg, but, it’s a lot better than Pilot.”
Pilot: *tearing up* “It’s really good. It’s nice to finally meet you, Zero.”
Greg: *looks at Zero* “Come here, dude.” *Greg and Zero embrace each other*
Pilot portals above them to join the hug
Cotu looks at the three
Pilot portals Cotu above them so he joins the hug too
Lore/Story Ideas
Pilot wants to be supportive of his brothers even though he’s scared of competition
Pilot used to be the most competitive out of the 3 during the tournament because he felt insecure about his inability to move, but after realizing that his anger was ruining his relationships with his brothers, he dialed it back and became kind. He now fears going back to his old self
Greg wants to improve for fun, but mostly so no name can achieve his dream of winning
Greg didn’t take the tournament as seriously as Pilot, causing friction between the two
No name is passionate about fighting and wants to become elite (i.e. enter the gala), but he’s also passionate because he feels insecure about holding his brothers back since he can’t use magic or portals
No name used to be subservient to his brothers (mainly Pilot since he was bossy) because he had no voice. After Pilot and Greg worked out their differences, no name gained the freedom to think for himself and self-actualized. He realized he was genuinely passionate about fighting and became the brothers’ leader. He communicates to his brothers mainly by doing some vague gesture that the brothers miraculously interpret correctly every time

Jab Crab aka Jac Boss (just an idea)
Heavily armored lobster in a tiny arena surrounded by walls/floor spikes/floor shark teeth/whatever
Has 2 big claws attached by long extendable/retractable tube arms (think of Claw Man, your My Hero Academia OC)
Can catch the rose and throw it aside and/or parry it
Approaches slowly and cautiously with jabs (reaching out and clasping with the claw)
Feints constantly
Jab feint
Dash feint (ducks/leans without actually moving very much)
Damage he takes depends on his stance when you hit him
If both hands are blocking: he perfect parries and takes very little arm damage
If one hand is blocking and the other is jabbing, and you hit his blocking side: he blocks it and the rose is deflected, but takes partial damage to the claw
If one hand is blocking and the other is jabbing, and you hit his jabbing side: he takes full damage
If you hit him behind or around his claws: he takes full damage
Claw can break after blocking too much
Occasionally unexpectedly dashes in with open claws
Can punch the ground to launch himself into the air
Aerial attacks:
Ground Grab: JC grabs the ground beneath the target with 1 claw, then dives in and does a spin attack with the other claw. Moderate endlag
Smash: JC brings both claws above his head (like Donkey Kong’s forward air in Smash Ultimate) and extends them slightly, then slams them into the ground while retracting them
Idea: in phase 2, instead of staying low to the ground, he gets up on his hind legs (walking on 4 legs instead of 6 or 8), allowing him to lunge forward with its chest and his arms instead of just the arms
Idea: tether tag
When close enough, JC attaches a tether to your body. It deals damage over time when JC is too far from you. To remove the tether, you must touch JC with your body
JC plans to dash in aggressively, attach a tether, then constantly back away while jabbing
Inspired by UFC fighters
Reference: Alex Pereira vs Khalil Rountree

Jab Crab’s Goofy Friend
Goofy, weak looking character who wants nothing to do with fighting and is only with Jab Crab for emotional support (and to give him his honest feedback)
Jab Crab brings him along for his honesty, good insight, and companionship
Has the speaking demeanor of YouTuber JrPlays (sample: https://www.youtube.com/watch?v=snErVEdm9Yc)
Speaks at an unusually consistent, even pace
Medium pitch
Sometimes voice cracks
Says goofy lines (e.g. “Ew ew ewwww!” “Holy moly!”), possibly uses “Holy moly!” as a catchphrase
Loves to glaze, but isn’t afraid to say when something is terrible
Convo idea:
Cotu: “You up for a spar?”
GF: “Absolutely not. Please don’t hit me, I beg you.”

Long Arms
Ball/polyhedron with extremely big and long arms with huge tri-finger claws with glowing dots in the palms. Legs are 2 short stubby legs or 4 crab-like legs. Has a huge eye in the center
Fights by standing at a distance and holding its claws out in front of you, ready to catch your attacks or strike
Inspired by Conor McGregor holding out his open hands to control his opponent’s hands (great examples in his fight vs Eddie Alvarez)
This is the Sean Strickland god who trains Jab Crab and beefs with Future Blade
Idea: has a little translator screen that speaks for him. It sounds like Sean Strickland and makes facial expressions
While training Jab Crab, Long Arms calls him Jac, referencing Sean Strickland talking to Jack Marshman in R3 of their fight
Idea: he’s actually around the strength of a Gauntlet 2 boss, but he rides a dragon in Gauntlet Central to fight at their level
Lore/Story Ideas
Convo with Jac about how Jac’s lucky to be a grower, not a shower. LA is talking about Jac’s arms, which are retractable unlike LA’s. LA has to figure out where to put his arms when they’re not being used

RPG Boss (just an idea)
Special gamemode where it’s a turn-based RPG that looks like Mother/Earthbound
You cannot dodge
You are not invisible; the enemy attacks your body instead of your soul
When the enemy attacks, you can move around freely, but moving slowly drains stability
Holding down a directional input ticks up a timer from 0. Every time the timer reaches a certain interval (e.g. .5 seconds), 1 stability is lost and the timer resets. When a directional input isn’t being held, the timer keeps its current value
Your turn options:
Attack
Throw Roserang: deals damage and removes roserang from your inventory for 1 turn. Returns on the turn afterward with enhanced damage.
Throw Axrang: deals damage and removes axrang from your inventory for 1 turn. On the next turn, you can Recall Axrang.
Recall Axrang (only available if axrang is thrown): return axrang to your inventory with enhanced damage.
Act
Stand Still: replenish ___ stability.
Your passive actions:
At the end of your turn, gain ___ stability.
Enemy’s passive actions:



Alt RPG Boss (just an idea)
Special gamemode where it’s a turn-based RPG that looks like Mother/Earthbound
Same as above RPG boss idea but each one of your weapons is a member of your party


Mad Scientist Electricity Boss (just an idea)
In this fight, it’s revealed that Cotu’s body is made of (or at least has properties of) glass. This is why his body cracks when he’s hit or destabilized
The boss is a mad scientist who runs tests on Cotu’s body and either kidnaps him or lures him into his lair
Boss has an attack that increases voltage between 2 places (e.g. air and ground) with Cotu in between
Voltage across Cotu thresholds:
Source: Effects of High Voltage on Glass
Low voltage: nothing happens bc glass is an insulator at low voltage
Medium voltage: electricity begins to arc throughout his body. Higher voltage → more arcing
High voltage: Cotu’s body glows yellow and white and emits fire. He then takes massive damage over time that will destabilize him quickly
When Cotu destabilizes, the scientist immediately turns off the voltage and stabilizes him
Boss talks to Cotu
You can move freely (currently at low and medium voltage) because your body isn’t controlled by electricity like many mortals’ bodies are. But what happens if we up the voltage?
(After observing first high voltage reaction) As I suspected; judging by the reaction, your body seems to be made of glass.
Don’t try to escape. I told all of your contacts that you were taking an extended trip alone, and taking a vow of silence. It would be easier for you to accept that your body is now and forever will be dedicated to research alone.

Demons
Realm of demons that constantly murder each other to become the Demon Lord
Attack ravenously in huge hordes like World War Z zombies
Demon Lord mechanics are a WIP:
Demon Lord commands all demons for a short period of time called an “era”. During a Lord’s era, demons are docile unless commanded to attack by the Demon Lord
Cotu trains with the demons bc the Demon Lord commands them
Near the end of a Lord’s era, demons begin growing hungry, greedy, and anxious, and arm themselves
When the Demon Lord passes away, the demons go to “war,” a brutal battle royale to find the Demon Lord’s crown. The first demon to find the crown wins the war, immediately forcing all demons into submission
The Demon Lord is the only demon blessed with contentment, and loses the will to eat. Since demons need constant food to survive, the Demon Lord slowly dies of starvation
Idea: the demons are cannibals. The realm constantly produces new demons by laying eggs. During a Lord’s era, demons eat the eggs to survive or make ritual sacrifices in a shortage. Outside of a Lord’s era, demons eat anything or anyone they can get their hands on

Giant Ball of Arms (just an idea)
Big ball floating in the void with very long spider arms
Uses huge sweep and swiping attacks with arms
Partially obscured by darkness
Ball is fuzzy and divided into shell pieces
Idea: sometimes pulses colors like snail parasite worms that pulse colors to attract birds. This pulsing attracts flying demons that live in the realm. The arm grabs hold of a demon and infects it with a worm to control it. 2 worms now pulse on the demon’s head when it’s about to attack
Can sometimes walk around; the player then fights the legs as it walks around and tries to stomp on them

Hype Boss
Upon first meeting:
“Champion of the Universe! Draw your weapon!”
Cotu: *draws weapon*
“I, _____, will save the Universe from your tyranny!”
Cotu: “Good. I like your confidence.”
During phase 1:
Cotu: “Have you sparred with the other top contenders?”
“Ha! There would be no point if I cannot defeat you.”
Cotu: “...”

Phoenix Fire Dancer Boss
Tall and feminine with a bird face and undecided eyes. Dark red body with brighter red and orange highlights. Covered in sharp bits that resemble feathers and flames. Looks like a mix between a Hawaiian fire dancer and hula dancer. She should give the viewer the sense that Hawaiian dancers are trying to depict her
Wields one or more fire staves OR scythes that look like bird heads
Early sketches:





Longer hula skirt more closely matches real hula dancers, but matches fire dancers less. The dress also resembles Clarity’s dress a bit too much
Music is mostly tribal drumming

Puppeteer

Giant dark plump maggot floating in the sky with similar build to Neferpitou’s Nurse from HunterxHunter
Has isolated thick single hair strands on its back like a potato
Holes on underside so that strings can come from them
Belly glows dim sky blue light
Giant hollow eyes
Smoke falls from its eyes and spreads throughout the arena, making a thin fog layer
Controls puppets below it with strings
Realm is lit by 2 moons that look like giant eyeballs
Color of light & moons depends on the current puppet
Knight: blue
???: yellow
???: one red one blue

Knight Puppet
Very wide torso, short head, no legs, sword-arms
Saw arms separate from body and attack like Elemer of the Briar’s sword from Elden Ring
Attached to Puppeteer by strings
Saws are similar to saw cleavers from Bloodborne, but with smooth, round edges
Chest spiral shards
4-5 shards detach from puppet’s torso and fly in Archimedean spirals (r = bθ where r = orbital radius from puppet, b = a constant, and theta = orbit angle). Each shard has a different b. The middlemost shard will hit the target if the target remains in the same place throughout the shards’ flight
If the puppet uses 4 shards, the third closest/second farthest shard will hit the target

Hero Shooter Level (just an idea)
Win a 1v6 against 2 tanks, 2 DPS, and 2 supports
At minimum, all fighters have primary fire, cooldowns, ults, and respawn
Capture a point Marvel Rivals style

Catch Angels
2 almost biblically accurate angels
Single eyeball for a head
Torso and arms covered in robe and sash
No legs
Hands/wrists are small discs with 3 needle-like fingers, each with a joint at the disc and another joint at the midpoint of the finger. All finger joints can only bend back and forth
Owl wings (they make no sound)
You play catch with the angels using a magic ball that automatically seeks its target in flight
Catching a ball has the same timing as instant rethrowing the roserang. Inputting roserang throw, ax throw/catch, or special will catch the ball
If you fail to catch a ball, the angels gain a point. If an angel fails to catch a ball, you gain a point
If a rang or enemy hitbox hits you while you’re holding the ball, you drop the ball and the angels gain a point
Inputting roserang throw, ax throw/catch, or special will throw the ball if you’re holding it. The ball will automatically travel to an angel if one is in your field of view; otherwise, the ball will be thrown in the direction of the camera
Hold down a button to do a slow throw, which causes the ball to linger longer in the air
First to 7 points wins
Pentagon arena lit by divine floodlights
Before an angel throws, he flashes a sigil showing the path the ball will take
Each angel catches the ball using a “mitt,” a giant set of metal jaws that has a large melee hitbox
An angel can fake a throw, flashing a fake sigil before quickly flashing another one
An angel can infuse energy into the ball. If energy is infused into the ball again, it’s upgraded, causing it to leave a damaging trail
Hitting an angel with the roserang or ax will briefly stagger it. Staggering an angel will not cause them to drop the ball, but prevent them from catching it
Angels can send wave attacks that deal no damage, but stagger you briefly and cause you to drop the ball if hit. While staggered, you cannot catch the ball
Angels can attack with foam swords that deal no damage, but stagger you briefly
Angels start the match flying near the ground. With later points, they fly into the air like birds
In a later phase, the angels awaken the Mega Mitt, a humongous mitt in the background lined with circles upon circles of eyes that open with a giant hole in the center. Either angel can throw the ball into the Mega Mitt, which will then do its own throw
Throw to you: Mega Mitt charges up (giant ring appears in front of it and shrinks into the mitt’s center. At the same time, bright light appears at the center, glows brightly, then shrinks when near the ring), pauses briefly, then instantly sends the ball to you with a laser trail
Throw to an angel: same as throw to you, but targeted to an angel instead, who then charges up before instantly sending the ball to you
Angels believe catch is a divine sport since there are no winners and no losers. To challenge themselves, they sometimes throw the ball to each other in complex curves. When Cotu wants to join them, he suggests that they make the game more interesting by introducing a score system and allowing players to hit each other. One angel is terrified and appalled at first, but the other sees the suggestion as an opportunity to ascend their skills to higher heights, deepening their relationship with the sport. The first angel is inspired by the message and, despite his fear, determinedly readies himself and pulls out his foam sword. The other angel does the same. Cotu silently thinks for a moment, then pulls out a dull-looking roserang. You now have access to the foam rose and the foam ax, which are functionally identical to the original weapons but deal no damage and cost no stability to use.

Darkness Boss (just an idea)
You start at sunset in a log cabin on a grassy hill surrounded by a forest
The hill descends to the forest on all sides
A big dark monster, the Hunter, is hunting you
Your goal is to survive until sunrise or slay the Hunter
Trees often form solid walls you can’t see through at all
Sky is dimly lit by moonlight but often obscured by moving clouds; moonlight barely illuminates the ground
The forest has a floodplain near a river at the edge of the map
Somewhere in the forest is the cave where the monster resides
At random locations throughout the map, there are elevated holes in the ground or holes in walls where black roots come out, aka black holes
Black holes have a static network of roots surrounding them
The Hunter’s den is the largest black hole on the map
Black roots shiver or contract slightly when you’re near them
Dark creatures on tree branches and bushes (“forest eyes”) may spawn around you with their eyes closed
They look at you when you go near them and you’re in their line of sight
Their eyes are bright
You should encounter at least 1 forest eye around every 40 seconds
The longer a forest eye sees you, the more likely it is for another forest eye to spawn nearby
This effect stacks with every forest eye looking at you, causing exponential growth
When a forest eye is looking at you, there’s a low probability every frame for another forest eye to spawn nearby
If you break line of sight with a forest eye, its eye closes and it immediately despawns
If too many forest eyes are looking at you, they all scream at once and disappear, making the Hunter run to the nearest search dest to you
You don’t regenerate any stability naturally
Sprinting:
Now toggleable instead of the default movement type. Your default movement is now walking
Now consumes stability, albeit extremely slowly
The only way to restore stability is to plant and light a beacon, then stand near the beacon
Hunter behavior:
Knows the location of all beacons
At first, the Hunter spreads roots randomly throughout the forest. After using all his root resources, he leaves the den
If you light a beacon before he leaves the den, he focuses all his root resources to the area around the beacon
If you or a rang touch a black root while the Hunter is patrolling, the Hunter will run to the most recently touched part of the root
He stays in patrol mode, but his move speed increases to run speed
If a rang enters a black hole while the Hunter is patrolling,
The hole briefly emits a pillar of light
The Hunter is briefly stunned and flashes with bright light, allowing you to see him
The Hunter then runs to the hole in patrol mode
Throughout the forest, there are points called search dests. If no roots have been touched after the Hunter used all his roots, he will pick a random search dest in an area around you, then walk to that search dest. This behavior state is called patrol
The area is a circle w radius [search_area_radius]
Every time he reaches a search dest within the search area, search_area_radius decreases by 1 search_area_radius_size_change before he picks a new random search dest
If you are farther away from the Hunter than the current search_area_radius when the Hunter reaches a search dest, the Hunter’s search_area_radius is increased by 1 search_area_radius_size_change
When he reaches a search dest, he stands up and looks around, and his sight and hearing radiuses increase. After he’s done looking around, he goes to the next search radius, and his sight and hearing radiuses decrease back to their default
The Hunter lays traps throughout the forest
Damage traps deal heavy damage
Snare traps bind you, forcing you to dodge or use a weapon to break free from the trap
Gas traps slow you and make the screen a bit fuzzy for a bit
All traps make a lot of noise
A rang can trigger a trap
The Hunter can hear things
He can hear sprinting but not walking, but things change in the floodplain
If you’re in the floodplain but close to the river, the river sounds mask your footsteps and you can sprint without him hearing you
If you’re in the floodplain but too far from the river, he can hear you walking
If he hears sprinting while patrolling, he sets his patrol search dest to the nearest search dest to the sound source
He can hear triggered traps from even farther away than he can hear sprinting
If he hears a trap while patrolling, he runs directly to the sound source
If he hears something (i.e. if the sound happened within his hearing_radius), he’ll go to the closest search dest to the sound’s source
If the Hunter sees you,
If he saw you in his outer_sight_radius, he stays in his patrol state but sets his search dest to where he thinks he saw you
If he saw you in his inner_sight_radius, he enters his stalk state
If the Hunter is stalking you,
He will go to the nearest search dest to you that you can’t see. If you can see his chosen search dest, he’ll choose a different one
He moves faster than your walk speed but slightly slower than your sprint speed
If he’s within stalk_to_chase_radius to you, he’ll enter his chase state
If the Hunter is chasing you,
He will run directly to your position
If you break line of sight with him and stay out of line of sight for chase_los_time, he will go to his lookout state, then patrol state.
If he sees you while in this lookout state, he’ll re-enter his chase state
If he hears you while in this lookout state, he’ll run to where he heard the sound
If the Hunter is very close to you,
Sounds become muffled except for the Hunter’s footsteps
The world changes colors, perhaps to red
If the Hunter touches you, he grabs you and attempts to put you in his belly
If you throw a rang into his belly right as it opens, he absorbs the light energy from the rang, which stuns him. When he’s stunned, he looks into the sky, and his eyes and streaks on his body begin to glow. Once his stun ends, his body flashes with brilliant light, then darkens back to its old form
If the Hunter has already been buffed and grabs you again, or if he grabs you for the first time and you don’t stop him from putting you in his belly, the camera switches to a perspective where it looks at the Hunter directly from the front as he watches you get absorbed into his belly. His head curls into his belly as he closes his eyes and the screen fades to black. Then you die
After the Hunter is stunned, he becomes faster. If he chases you, his eyes become headlights, but as he gets closer, the brightness dims. When he’s right next to you, his eyes are completely dark again
If you enter the Hunter’s den while he’s still in it, the screen fades to black and you hear a creepy voiceline. You hear sounds of wind, then die
If you enter the Hunter’s den after the Hunter left, the Hunter will scream and run extremely quickly to the den
Cotu dislikes and is afraid of Darkness

Alt Darkness Boss (just an idea)
Cotu receives a request from 17 and absent-mindedly steps into their realm, not knowing who 17 is
Cut to a flashback: Pilot is telling Blaze, “Most people think that souls are untouchable, but they’re not.”
Cut back to 17: the realm is pitch black in all directions. “Bl-Blaze? i-i-is that y-you?” A face slowly appears from the darkness, with 2 big bright round glowing eyes and a glowing mouth with a wide frown. 
Cut to flashback. Creepy music box music plays. “Some people…they can touch souls.”
Cut to 17: in a timid voice, the face says: “Hhh…it is you! I-I’m so glad you came to see me.” The frown slowly grows into a wide grin.
Cut to the flashback. Pilot’s face is sad and scared, and he gets fidgety. “If-If your soul gets-”
Cut to 17: quick shot of long, wiry fingers in the dark
Cut to flashback: Pilot is now sitting up, clutching Blaze’s face with his hands. “your mind can be twisted. Your sense of reality, warped. Memories *STATIC*”. Pilot’s voice and face suddenly turn into white noise
Cut to 17: the face grows larger and stretches out.
Cut to flashback: Blaze clenches his fist around a chaos-covered spike.
Cut to 17: “Now that you’re here,” the face slowly approaches Cotu and extends its claws.
Cut to flashback: the face says offscreen, “we can play together.” Blaze slowly raises his spike.
Cut to 17: Cotu, terrified, backs up against the wall with his eyes locked on the face. “And you’ll never…” The face closes in on Cotu with its huge claws out to its sides.
Cut to flashback: Blaze’s spike is raised into the air, poised to strike. The face says offscreen: “...leave…”
Cut to 17: the face’s expression becomes even more contorted and leaps at Cotu with its claws. “...me!” Cut to flashback: Blaze’s fist is right about to hit Pilot from Blaze’s POV
Cut to a small cabin lit by a single lightbulb dangling from the ceiling: from a first-person POV, your fist slams down on a radio. The radio sputters from white noise to a radio broadcast.
You, in a gruff voice and southern accent: “Aaaayyyyy! Attaboy, Ben! You’ve done it aga- oh, uh uh uh! Remember your last session. Keep your ego in check. Ugh, did you already forget? That’s exactly why she left yo-” *alarm clock rings* “WHAT IN THE HELL-” You punch the alarm clock to the end of a hallway.
At the same time as you are talking, on the radio: “This revolutionary scientific breakthrough could change our understanding of reality as we know it. What other mysteries does the universe have in store? Are we truly alone in the vast unending void? Find out all this and more, next week. This has been Greg, on Mike News. And now a word from our sponsor.”
You sigh, then look at the nightstand where the alarm clock used to be. “Oh, would you look at the time, I gots to make brunch!” It’s clearly nighttime. You’re prompted to begin walking toward the kitchen, but you don’t have to
At the same time on the radio, a mature man’s voice: “You never know what you might run into out on the trail. *Bear roars* *goofy scream* As soon as you step out of the house, your life is at risk. (A woman, younger) and maybe not even then! *Bear roars as wood breaks* *goofy scream* When the time comes, are you prepared to defend yourself? Data show that Hudson’s Bear Spray increases your chances of survival by 10%. Don’t leave home without it. Hudson’s Bear Spray. Find it near yo-”
A distant roar. The radio’s audio and ambient forest noise (leaves, crickets, etc.) becomes much quieter. You wait for a few moments. “What…eh…maybe it’s fine…” The radio’s audio slowly increases.
Another roar. This one shakes the cabin and shuts off the power to both the lights and the radio (cuts off “Find it near yo-”). The roar slowly becomes a low continuous growl.
You gently whistle, causing a wooden boomerang on your desk to glow blue. You do a quick, slightly louder whistle in an upward tone, recalling the boomerang to your hand. As soon as you catch it, it stops glowing.
Under your breath, you say: “I can feel it…I know, that whatever’s out there…it’s coming for me. I don’t know what to do.”
There’s a note on the dining table that wasn’t there before. It says “DON’T MAKE NOISE”
You, the player, gain control of Ben. The Beast is now hunting you
Dying and respawning is very similar to the game Granny, except the Beast doesn’t put traps right outside your room after you respawn. You have 5 lives. If you die, you’re sent back to the cabin, but all the progress you made in the world (e.g. things destroyed, things moved) stay the way they were. If you lose all 5 lives, everything is reset and you lose all progress.
Message on the radio upon first respawn: (plain lady’s voice) “is terrible and will only get worse with time. Address the root cause now, or it may be too late. Buy Gus Gordon’s nasal spray today. Side effects may include memory loss, depression, suicidal thoughts, and a sense of impending doom. Ask your doctor if Gus Gordon’s nasal spray is right for you.”
After defeating the Beast: you’re brought back to the dark realm with the glowing face. It looks sad and guilty. It looks away from Cotu.
Cotu stares at the face with a blank expression.
The face shakily says “I-I-I’m s-sorry. I…”
The face starts moaning and whining unsettlingly. It yelps. It hesitantly asks Cotu. “Um…are we…still friends?”
If the player answers NO: “Ok. Um…thank you. Now…I can let go. You don’t have to—you shouldn’t come see me again. Goodbye.” Cut to hub world. Cotu has a blank expression. Greg asks “is everything ok?” Cotu plainly responds “17 and I are no longer friends.” Greg responds, “oh…do you want to talk about it?.” Cotu: “Not really.” Greg: “Alrighty then.”
If the player answers YES: “Really? After everything I’ve done? Everything I did to you?” The face grows into a confused grin. The face lunges at Cotu, screaming. Cut to the hub world. Cotu’s face looks traumatized. Greg and no name are crouched over him, checking him. Greg asks, “what happened?” Cotu responds. “17 and I…are friends.” Greg responds “Oh. Ok.” Camera pans out as Greg stands up. No name stays crouching and attending to Cotu. Fade to black.

NPC Idea: The Chosen One
Generic RPG/Isekai self-insert protagonist with no personality; use a free asset from an asset library
Typically aura farms (poses dramatically)
They can walk up to you and open a dialogue menu near their face, showing a list of options. They repeatedly select the “Flirt” and “Seduce” options, which simply exit the menu as the character does a basic talking animation like Link’s dialogue animation from Breath of the Wild
Appears in Gauntlet Central, implying that they’re one of the strongest in the universe
Frenemy of Y/N

NPC Idea: Y/N (“Your Name”)
Generic Wattpad fanfiction self-insert protagonist with no personality; use a free asset from an asset library
Emits a menacing aura representing reality bending for them
Introverted but very pleasant to talk to
When threatened, a handsome CEO appears to defend them
Appears in Gauntlet Central, implying that they’re one of the strongest in the universe
Frenemy of The Chosen One

Tempered X Boss
Pre-fight quote: “Tell me, Cotu…Can you read me?”
Face is modeled after a T shape instead of an X
Soul is a plus sign with pointed tips and with the top segment (the one facing away from the target) removed, i.e. a T whose stalk is as long as the branches. Soul faces in the direction X wants to attack in
Instead of orange, his primary color is the color of infinite temperature (Google it; it’s a cool blue/purple)
Phase 1
Phase is like a short sprint. Player gets 2 minutes (as much time as Tempered X’s phase 1 boss theme) to deal as much damage as they can, but X’s health regenerates when not attacked just like original X. X has moderately low health
Somewhat smaller arena than original X’s, but there are multiple copies of this arena throughout the realm
Dodges when you throw a non-shuriken rang. Can only dodge once until his next attack, which refreshes the dodge. Dodge types:
Side dodge: dodges to the side just as original X did
Jump headbutt: jumps up, then dives directly to the target with a headbutt that detonates on impact. Occurs about ⅓ to ¼ of the time instead of side dodge
Short dist attacks
Spin Slice: X ignites his left hand blade while turning his left shoulder towards the target and pointing his left hand straight up, then does the original X’s Chain Slice attack anim (his arm spins around him 360 degrees before reattaching and slicing out)
Energy Burst: X channels energy into his left hand, then blasts it out in a mid/low-range straight line inspired by Lucario’s side-special Force Palm in Smash Ultimate. Anim consists of a charge up that looks like a baseball pitcher winding up a pitch, then a straight punch with the pitching hand
Hitbox is a long cylinder pointed in the direction X is facing, width of circular face is a bit smaller than his Superman’s explosion width, length is slightly less than roserang max range
Skip: only chosen if X planned to do a short range attack after a TP, but the target is out of his attack range. He simply skips to his neutral state
This will most likely happen if X moves his icon after the 1st sweep of the Double Sweep, and chooses not to move it again during the 2nd sweep before teleporting
Energy Ball: X channels energy into a dense bright ball as tall as him, then sends it in a straight line at the target at moderately low speed. He then teleports near the target and performs a short range attack
Whenever X teleports, vec to target is no longer just a 90 deg rotation about the y-axis of the vec from X to target. It is now a random rotation about the y-axis
TP Fakeout: X sends his icon to a teleport location, then prepares to burst in a direction that doesn’t match the vector from the icon’s current location to the target. He then moves the icon to another location at the last second, where the vec from the icon to the target does match the burst’s direction. X then bursts just as he teleports
Laser TP: X sends his icon to a TP pos while kneeling to fire a laser. He fires the laser directly at the target and leaves it deployed in mid-air. After firing the laser, he teleports and does a post-TP short range attack
TP Laser: X sends his icon to a TP pos while kneeling to fire a laser. Instead of facing the target, he faces a direction such that he’d be facing the target if he were at the TP pos. He teleports, then fires/deploys the laser
Wall: X puts a wall in front of himself, hiding his next move. Only used when at a distance from the target and there’s not currently a wall in the arena. Deals instant hit damage to anything it touches (it’s not a damage over time field). Disappears after about 10 seconds
Diagonal Dash Slash: X does a diagonal dash but angled slightly further away from the target than the original XBoss’s diagonal dash. While dashing, his arm (either R or L) is extended out to his side with the blade ignited. This dash will always end at a point behind the target (relative to the vec from target to X when X starts the dash). Can lead into:
Nothing (when he doesn’t have both arms); his icon stays with him throughout
Sweep overhead (when he has both arms); halfway thru the dash, his icon goes to a point on the vec from himself to the target, i.e. it’s possible the icon gets further from the target than X was at the time he moved the icon. After reaching the end of the diagonal dash, he teleports to the icon
Sweep Overhead (only used when he has both arms): X lunges (lunge description below) and raises one arm for a sweep and the other for an overhead slash while igniting both blades into their mega lengths. He then does a horizontal sweep with one blade before immediately doing an overhead strike to the target with the other such that Cotu must do one dodge to dodge both attacks (as opposed to doing a dodge for each slash)
He lunges low to the ground and bends his chest forward so his arm sweep can reach Cotu’s body. His front foot is on the same side of his body as the arm doing the sweep/the opposite side to the arm doing the overhead. The lunge isn’t perfectly straightforward like after the original XBoss did a Sweep. His back foot is to his side away from his torso and his front foot is slightly to his side away from his torso.
Double Arrow (only used when he has both arms): X pumps his elbows down and his chest and face towards the sky to infuse himself with power, then points both of his arms forward and encases them in arrows, then fires both arrows forward simultaneously. Can possibly lead to a superkick or brief face laser
Superkick: X shoots his icon forward with the arrows so that the icon ends up in front of the target, then teleports to the icon and does a superkick at the target
Face laser: X and his icon stay still, and X blasts a face laser for less than a second at the target
Double Sweep: X extends a mega blade from his right hand, then sweeps his arm 540 degrees around his body at the same angular speed as the Sweep from the original X
“Sweep 1” = first 180 degrees the mega blade travels
“Sweep 2” = final 180 degrees
In between sweeps 1 and 2, the mega blade is traveling behind X for 180 deg
Can lead into a TP short range attack. If he decides to do a TP attack, he moves his icon to a TP pos immediately after 1st sweep ends. A third of the way through the 2nd sweep, he can optionally move his icon to a new TP pos. He teleports immediately after retracting mega blade after 2nd sweep
Icon Diagonal Dash: both X and his icon diagonal dash in opposite angles towards the target (angle magnitude is the same as TrueX’s Diagonal Dash Slash), and halfway through the dash, X either turns to face away from or towards the target. If he faces the target, he dashes directly forward and does an energy burst. If he’s facing away from the target, he teleports to his icon, dashes directly at the target, and immediately does an energy burst.
Fake TP Superkick: X sends his icon to a TP pos, then does a jump and superkick identical to the Lunge Superkick from the original X. After the kick, the icon returns to him
Side Stance: X holds his left arm out to the side like the Wing Stance in Elden Ring and infuses his hand with energy. He then does a followup:
TP Side Burst: X sends his icon to the target’s left (target’s front is facing X), teleports, and bursts to his left. During the burst, X looks at the target instead of continuing to look forward
Side Slice: X dashes toward the target and ignites a medium blade, then does a left hook punch, sweeping the area in front of him similarly to the Slip n’ Slice from original X
TP Side Slice Fakeout: X sends his icon to the target’s left, then does a Side Slice
Solar Flare: X leaps high and away into the air, charges up a brightly glowing ball in his hands and tucked into his stomach, then unleashes a gigantic energy burst (like a Kamehameha from Dragon Ball Z) with special effects
Idea: hitting X with the ax right before the attack is released cancels it
Platform Removal: X prepares his star to destroy an entire platform as he jumps to another. Cotu must use his icon to fly to the next platform
Phase 2: 
Pre-phase quote: “I will kill you.”
Phase is like a long-distance run. X’s remaining health multiplies to become very high, but no longer regenerates. No time limit; player and X fight until one of them dies
Arena becomes so small that X is almost always within short dist attack range without needing to teleport
X’s icon slightly shrinks
Completely black background
No music; only ambient SFX (e.g. scary deep explosion echoes) or silence in the background
X constantly does simple fast attacks with a lot of teleport and attack baiting
Backflip Dive: X jumps away with a backflip, lingers in midair while abruptly spreading his face pieces apart to reveal a blue sun in the center, then dives at the target just like Lunge Facerain from original X. Impact also spawns volcano. Undecided what happens to face pieces afterward (they may return to X’s face, be left on the ground, or do something else)
TP Superkick: X teleports nearby in a lunging pose, then jumps and superkicks exactly like Lunge Superkick from original X
TP Superkick Cancel: same as TP Superkick, but at the peak of the jump and right before the dash begins, he teleports elsewhere and starts a different action (cannot be another TP Superkick or TP Superkick Cancel)
A move cancel can lead to a different move, but that different move can cancel back into a new instance of the first move. This applies to all move cancels
TP Spin Slice: X teleports nearby, then performs a spin slice
TP Energy Burst: X teleports nearby, then performs an energy burst
TP Energy Burst Cancel: same as TP Energy Burst, but right before the hitbox activates, he teleports elsewhere and starts a different action
TP Energy Burst Trick: same as TP Energy Burst, but instead of charging an energy burst, he ignites his medium blade (a blade w/ a length btwn his standard arm blade and mega blade) while subtly dropping his left hand to his hip. He then does a sweeping slash with his left hand almost exactly like original X’s Slip n’ Slice, but standing up instead of kneeling (change this to kneeling if the attack won’t land standing up). Selected more rarely than TP Energy Burst
TP Face Pull: X teleports to a medium range away from you and simultaneously pulls a piece of his head out with his left hand. In the pull, he jolts his head to his right while making the quick yank with his left hand. He tilts his head back to neutral then calmly and lightly underhand tosses the face piece in your direction. At the same time as the toss, he moves his icon. He teleports just after his throwing hand begins to withdraw
In game, the face piece is already in X’s hand and the face piece in X’s head is already invisible after he teleports; he doesn’t actually reach out and grab the head piece and pull it off
Multi Superman: X does 1-4 Supermans using alternating hands/feet, with each subsequent Superman leap starting immediately after the explosion of the previous one (there’s no endlag after each Superman), then he chooses one of these followups:
Smash: X brings both of his hands over his head to create a bigger Superman ball, then slams them both to the ground. This move has a larger explosion radius, but has the endlag of an original X Superman
TP Smash: same as Smash, but X sends his icon nearby just as he raises his hands up. He teleports at the same moment he starts moving downward
Big Energy Burst: same as energy burst, but X uses 2 hands in front of him and creates a bigger burst
TP Superman Hookkick: X teleports and does a Superman, but when he lands, he immediately pivots his lead foot to turn backward while lifting his back foot, ignites his back foot’s medium blade, then does a spinning hook kick
Inspired by Georges St-Pierre’s signature superman to low kick combo. X uses a hook kick parallel to the ground instead of a low kick so that the blade aims at Cotu, not the ground
Ultraman: as X does his usual attacks, his head suddenly starts emitting strange blue particles. A few attacks later, he leaps very high into the air and as he rises, his head glows brilliantly bright. When he reaches the apex of the leap, his face flashes and a 2D effect is emitted. He then dives to the floor and punches like a Superman. If he’s hit with the ax in between the time he hits the apex of his leap and when he hits the ground, he is staggered
Near-end attacks:
Solar Flare: undecided (X creates a giant whip?)
Lore/Story Ideas:
X accepts defeat with strength and anger
X: “Cotu.”
Cotu looks at him. They embrace.
X: “You fought an excellent fight. You have my respect.”
Cotu: “Same to you. You really had my work cut out for me.” They embrace. “No hard feelings?”
X: “No. I did everything within my power to win and still lost. You were simply the better fighter. I have no choice but to accept that.” He sounds bitter, but restrained.
Cotu: “...so what’s next for you?”
X: “More training and more planning. But before then,” Cotu looks intrigued. “the trio asked me to help them search for their realm. I had nothing better to do, so I obliged.”
Cotu: I was planning to take time to myself to clear my mind, but I predict that traveling with them will do exactly the opposite.”
Cotu: “Yet you’re going anyway.”
X: “Correct, because you’re coming too.”
Cotu: “Wha-I didn’t sign up for this.”

4 Boss: The Edge
SFX and music are periodically muffled/unmuffled and pitch shifted
The player’s position within the arena is sometimes hidden and distorted
Stability regeneration is greatly slowed or disabled due to the realm being at the edge of the universe
Arena is divided into 4 quadrants
Each quadrant can be targeted by divine light, a beam from the heavens that blasts the entire quadrant
When the heavens targets a quadrant, a circular timer appears as an icon above the quadrant
After the timer’s hand progresses through ¼ of the timer, the timer fades into invisibility over the duration of 2 half notes (ie 2 piano notes in Meet the Grahams)
Each timer’s total duration is random, but will fall on an interval of the song either exactly on a piano note or perfectly between 2 piano notes (rarely or in later phases)
A timer’s duration can be uncomfortably long
When the timer hits 0, the divine light blasts the zone the timer corresponds to
A timer can move while it’s visible, indicating that the zone its divine light targets is moving in that direction
A giant dark gray invincible “worm” (it’s called a worm but is more like an eel) with big gaping empty eye sockets and a giant gaping mouth patrols around the entire arena. The rang ricochets off its hard shell. If you touch it, you take massive damage
If you strike a weak spot on the worm, all active timers will quickly flash and become visible for 4 half notes (the timers fade during the 3rd & 4th notes)
If you strike the worm 4 times AND at a random point during the fight, the worm itself will rise into the air and attack you directly, initiating a “quick” time event. A timer appears above the worm’s head. If you press the dodge button such that you would be invincible when the worm’s timer finishes, you will be safe. If not, you will take 99% of your full HP’s damage (ie if you’re less than full health, you’re destabilized)
Giant hands that fill up the entire realm can attack you
Telegraphed by hand movements, voice lines and sound distortion
“Have you ever felt something so beautiful you FALL APART”
“Have you ever felt something so beautiful your HEART SEIZES”
“Have you ever heard something so beautiful your soul ASCENDS”
“Have you ever felt the touch of an ANGEL”
“Even a mere glimpse…”
“Allow me to show you a world beyond color (color distortion), beyond song (sound distortion), beyond time (time slows down)”
At the end of the fight, the worm directly attacks you one more time, this time basking in the light of the heavens
A timer appears above its head and counts down once more, only this time you must throw the rang such that the rang is in flight once the timer hits 0 (or a bit later just to give a bit of leeway)
After a little time (random) has passed, the music slowly fades away, leaving only the sound of a ticking clock
Eventually, the sound of the ticking clock fades (after a random amt of time) away as well
If you fail this quicktime event, the fight continues for a little before you get another opportunity at the quicktime event.
Alt idea: gameplay is the same as the original concept, but arena is patrolled by a small white slug or snail and the heavens send dark leviathans instead of divine light and hands. Also slug/snail itself doesn’t attack
Lore: no one has ever beaten The Edge except for Microwave

2 Boss OR Champion of the Universe: Blackstar, Gauntlet Incarnate
She has Demetrius Johnson’s stature, Kobe Bryant’s mamba mentality (harsh self-criticism and relentless drive for self-improvement), and Messi’s lack of casual social skill
Thin black humanoid with diamond-like limbs and spiked gold mask
Early face concept art:

Body concept art (3D art by ChatGPT 5):

Idea: ropes loop around her back in 2 loops like short fly wings
Make her shorter, rounder, and more compact to fit her personality and fighting style (she feels small and is hyperactive like a small animal or child). Her face maybe resembles Pomni’s from The Amazing Digital Circus
Fights using extremely long golden ropes, which she uses to grapple onto background elements and fly around or throw things at her enemy
Can grapple onto her star-shaped soul. If her soul is at her position, she can grapple it and swing around it to change her momentum instantly
Parries most projectiles most of the time (e.g. she parries shurikens while she’s not attacking)
Outspeeds homing projectiles after gaining enough momentum
Idea: stamina in speed mode and health in strength mode
When she parries an attack, she loses stamina, which works like posture in Sekiro: Shadows Die Twice. She regenerates it slowly over time if she doesn’t parry. The more damage the attack has, the more stamina she loses when she parries
If she’s hit by an attack while she’s mid attack, she doesn’t parry it. She takes both stamina and stability damage (not health damage)
When she’s in strength mode, she cannot lose nor gain stamina, but she can now receive strength mode health damage, which doesn’t regenerate
Depleting her health or stamina will stagger her, making her very vulnerable for a brief period of time
Arena has the same look and feel as Gauntlet Arena
Pillars may not be exactly the same, but if they are present, they are way taller
Background looks close to the arena and is made up of large black irregular triangles connected by edges
Ground is made of reflective black ice; Blackstar skates on it like a needle on a vinyl record
Background is filled with irregular black shapes floating all around
Phase 1 Design Idea 1: switching between speed and strength modes
Has 2 modes: strength and speed mode
Strength: wears bear-like heavy armor that allows her to move big rocks and possibly the entire arena OR has bear-like giant arm, massive face like a machine crawler’s from Intrusion 2, and giant whip tail like a machine crawler’s. Can summon any of the 3 parts individually or sometimes in combination with each other
Strength mode has large targets, making it vulnerable to the ax
Speed: wears no armor, allowing her to grapple around very quickly
Speed mode can only be hit reliably with homing attacks, but is more susceptible to damage
Cross slash attack (just an idea) - strength: she lifts her left hand from her right hip to above her head, then does the same movement but mirrored with her right arm, sending the ropes in her hands high into the sky. She waits for the ropes to ascend for a bit, then slashes with her left then right arm almost identically to Promised Consort Radahn’s left-right cross-slash attack pre-nerf (the time between the left and right slashes is slightly shorter than Radahn’s, making it easier to use just one dodge instead of 2) which causes the ropes to mirror the same motion across the entire arena. The only consistent way to dodge this move is not to dodge the left then right ropes individually, but to stay on your left side of the arena, then dodge when her left rope is about to hit you, which dodges the right rope at the same time. She can also do this attack with the right arm first, then left
Meteor - both: she grapples a rock from afar such that the vec from the rock to her points roughly to the target. She pulls the rock towards the arena, then detaches the rock rope(s) to make the rope(s) whip directly forward. The rock then hits the arena, exploding on impact
Strength: she grapples the rock with both hands while planting her feet firmly in the ground. The rock takes less time to accelerate
Speed: she grapples an anchor rope into the arena ground in front of her and holds it with one hand, then grapples the rock with the other hand. She then pulls the rock while suspended in midair. The rock takes more time to accelerate
Suit up smash - speed → strength: in speed mode, she grapples to launch herself directly to the target, then does a superhero punching pose like if a bear did Nathan’s aerial punch from Uncharted 4 while suiting up into her strength mode. She lands with a punch into the ground, shaking the arena and exploding the landing site
Leap headbutt - strength → speed: in strength mode, leaps forward like Hoarah Loux doing the vertical throw (pausing in midair like him) but with her arms in front of her face when she leaps. She then quickly brings her arms to her sides (fists to the sides of her hips with her elbows behind her) right as she bursts out from her armor directly at the target
Phase 2:
Blackstar is destabilized, but blocks, dodges, and parries all of your attacks
Only strength mode
Jab: does an unreactable jab punch with the bear arm
Possibly the only way to stop it is to block with your icon
Inspired by Muhammad Ali’s super fast jab
Tail sweep: slams the tail on the ground beside her, then sweeps in front of her
Tail thrust: slams the tail on the ground beside her, sweeps for a moment, then lifts the tail in front of her, then thrusts the tail forward
Hook: does a wild hook with the bear arm that overshoots the target on the follow through and moves Blackstar forward somewhat. Barely reactable
Inspired by George Foreman’s wild hook
Phase 1 Design Idea 2: charging up ultimate mode, then unleashing it briefly before charging it up again
Grappling, speed/momentum, parrying, background, and phase 2 are the same as design idea 1
She charges her ult’s power by gaining momentum, then converting all of that momentum into ult charge
You can prevent her ult from becoming stronger by interrupting her when she tries to gain speed
Her ult charge doesn’t determine when her ult comes out, but how strong it is. Her ult always arrives at the same times in the fight
Idea: when she ults, her max stability is permanently set to her current stability
Idea: there’s a color difference between when she’s ulting and when she’s not (e.g. desaturated colors normal, restored colors ult, normal colors normal, altered colors ult like JoJo’s Bizarre Adventure)
Idea: ult form is a humanoid body similar to her speed form, but bigger and with large Wolverine-like hand claws. She slashes the space around her with the claws, which summons huge floating claw slashes made of light that travel in the same paths at the same time. These look like the Revenant’s claw slashes from Elden Ring Nightreign. Each slash creates an emitter for a superlaser that slowly charges up before firing in a continuous violent straight blast that travels in the same direction as the slash. Her movements are wild and have huge windups, unrefined but packing huge power. She sways like a drunken boxer after every swing, suggesting that her claws are extremely heavy and that it takes a wild energy/mindset to use the claws to their fullest potential. She can use the explosions from the backs of the superlaser emitters to launch herself where she wants to go
Idea: ult form is a large humanoid body with long limbs. She uses martial arts and super speed to chase her target and deal damage. Possibly teleports occasionally
Phase 1 Design Idea 3: Sling and Bits
Realm is full of random geometric stones, which I’ll call “bits”. In her normal (non-ultimate) form, Blackstar has the ability to summon a bit to any point near her
Blackstar uses a sling consisting of her golden ropes and 1 or more bits to parry attacks, perform melee attacks, and occasionally fire powerful explosive projectiles at you
She grapples around with her golden ropes while constantly swinging around the sling to show that she’s ready to parry
Before launching a bit from the sling, she accelerates her sling spin, which has a menacing sound effect
A golden effect plays around her when she launches a projectile. This is for both style and telegraphing
Sling Dash: BS’s basic melee attack. BS smoothly lands on the ground from a grapple towards the target and slides/skates while accelerating the sling spin around her, slightly expanding its range compared to her neutral grappling/parrying state
Used as a slide-in from the air
Leads into grounded speed boost OR 2 grapples → another Sling Dash, creating a combo
Blackstar performs many attacks by summoning bits to herself and sometimes turning them into tools
Punch: BS forms a big arm over her arm and punches the ground, creating a huge explosion and shockwave from the impact site
Used as a landing from the air
Injector: BS forms a spearhead over her arm and punches the ground. It’s slightly smaller than the big arm. The holes of the injector fill up with light while it’s penetrated into the ground, then the injector unleashes a pulse of light into the ground. Possibly sends out streaks of energy from the impact site that run along the ground
Used as a landing from the air
Suit Up Smash: essentially the same as in Phase 1 Design Idea 1. She grapples to launch herself directly to the target, then does Nathan’s aerial punch from Uncharted 4 while building an exosuit out of bits. She lands with a punch into the ground, shaking the arena and exploding the landing site, but with less power than the Punch
Used as a landing from the air
Leads into an immediate follow up in the suit
Leap Headbutt: while suited up, leaps forward like Hoarah Loux from Elden Ring doing the vertical throw (pausing in midair like him) but with her arms in front of her face when she leaps. She then quickly brings her arms to her sides (fists to the sides of her hips with her elbows behind her) right as she bursts out from her armor directly at the target
Used when grounded and suited up
Leads into grounded speed boost
Mega Sling: while stationary on flat ground, BS starts spinning the sling around her. The sling grows in size and spin radius over time as more bits are fed into it, eventually becoming a huge continuous area attack. After some time, she briefly grapples upward to gain some height, then turns the sling circle downward to smash the ground, unleashing an omnidirectional explosion of bits
Used when grounded
Leads into grounded
Bit Rain: BS smoothly lands on the ground from a grapple and slides on it while summoning bits from above all around her
Used as a slide-in from the air
Leads into grounded speed boost
Blackstar has an ultimate mode that charges naturally over time and is unleashed in the unique parts of her song
Ultimate mode: Bit Mastery
Blackstar gains total control over all bits in the realm at once, becoming able to move them anywhere she wishes instead of just recalling them to her
Cotu must activate and skillfully use an ultimate ability of his own to survive the onslaught
Idea: Dominion skill, which uses some rang to parry all tiny projectiles around him
Bit Blast: BS continuously calls bits to her and fires them at you like a machine gun. The only ways to avoid this move are to move laterally very quickly, or deflect the projectiles with a special ability like Dominion (deflecting tiny projectiles using shurikens or maybe the rose)
Lore/story ideas:
Each variant of soldiers the gauntlet makes is also called an incarnation
The gauntlet constantly strives to make new variants (i.e. the variants constantly strive to reincarnate); that is their sole purpose
After enough training, experience, and grit from all of its soldiers, a new variant spawns from a gauntlet spawner. Almost all reincarnations occur after someone’s destruction, hence why they call it a reincarnation
The gauntlet can spawn any member of any of its previous variants to help train the latest incarnation
After Blackstar, the gauntlet has never made another variant, and she’s been the latest variant far longer than anyone else has
Some people think Blackstar cannot reincarnate because she’s already perfect (X, Cotu, her ancestors)
Blackstar knows she isn’t perfect and feels like a failure for not reincarnating longer than any of her ancestors
Blackstar feels helpless because no matter how long and hard she trains, she doesn’t feel like she improved at all, and no new variant appears from the spawner. She has no idea what else to do to reincarnate
This is made worse by the fact that many other gods have improved significantly after the tournament, but Blackstar hasn’t changed at all
Blackstar thinks that if she ever feels proud of herself, she’ll lose all motivation to improve and truly fail
Idea: Elite Gunner looks at Cotu’s upgrades
Elite Gunner is happy, but also ashamed since her master isn’t making the same progress
Cotu wants to know how the Gauntlet really feels
EG: “[current upgrade name]. Already?” She sounds like a mixture between impressed and sad
Cotu: “Is something wrong?”
EG *shakes her head*: “No. Not at all. It’s impressive how fast you’ve made it this far.”
Cotu: “Thanks.” Cotu senses something’s going on, but he’s not sure what. “But I’ve still got a long way to go before the gala.”
EG takes another look at the upgrades. “Indeed.” *she looks at Cotu* “I’ll send this info to Master. Thank you for showing us this.”
Cotu: “Of course.”
EG: “Whatever you need, the Gauntlet will be right behind you.” She salutes to him
Cotu nods. “See you soon.”
She is extremely personally motivated to fight Cotu at his best
Idea 1: Poor Reputation After Tournament Loss
Public opinion of the Gauntlet has decreased ever since her loss to Cotu in the tournament. People say the Gauntlet’s been on a decline and/or stagnating and/or out of its prime
Blackstar can take being insulted herself, but she’s pained by her family being talked about negatively. She doesn’t want to restore her glory—she wants to restore theirs, and secure the Gauntlet’s future by reincarnating
Idea 2: Blackstar won the tournament, but only because Blazar let her win
Blackstar believes that she’s not reincarnating because Blaze held back
This plays into the idea established at the beginning of the game in the intro conversation with X: the soul must be convinced that a fight is real in order to gain XP. Blackstar thinks that because her soul wasn’t convinced, she didn’t gain the XP. She doesn’t know for sure that’s the reason why she didn’t gain the XP, it’s just her best guess
She also feels like a fraud who’s lying to everybody, and the clout she has isn’t deserved
Sub idea: Blackstar must concentrate her mind to not let the knowledge that Blaze let her win flow back into the Gauntlet’s soul, which would transmit the memory to all of her predecessors. This concentration makes her unable to reincarnate
Blaze knew how much the tournament meant to Blackstar, so he lost on purpose to give peace to her and her followers. He was also just fighting for fun, so he didn’t mind losing
Throughout almost all of the fight, Blaze was genuinely fighting to win to give her a real fight, but when Blackstar was extremely close to winning at one point, Blaze allowed her to, even though he had one last ability he could have used to save himself and continue the fight (let’s say this was Mark Sacrifice). Blaze never used this attack in a tournament game, so no one knew that he had it except for Blackstar and himself
Blackstar somehow knew that he had this ability at the time he fought her, and she knew the damage it did. If Blaze used it, Blackstar would have destabilized and most likely lost
Idea: Blackstar stalked him in the training room to memorize his techniques, and she saw him use it against someone important
After Cotu arrives at the gala and before their fight, Blackstar approaches Cotu and tells him that even though the gala’s not a serious competition, she politely and timidly asks him not to hold back, as this is her last chance to reincarnate before the next tournament
(If using motivation Idea 2 above): Blackstar reveals to Blaze and the player that she knows that he let her win. Blaze asks how she knows and she explains how
Idea: Blackstar asks to meet in Blaze’s realm so that no one can hear her say Blaze let her win
X is jealous that she pulled Cotu aside
Idea: after Blackstar’s battle with Cotu, he helps her accept that she’s done everything she can, and she should enjoy her life and all the friends and family she has. She then realizes that the only way to reincarnate is not to improve her skill or physical strength, but her soul. Each variant has its own unique skills, strength, and personality. The soul of the gauntlet, Blackstar’s soul, rejects Blackstar’s personality.
After the battle, Blackstar’s helmet is cracked open, revealing a less physically sharp, more relatable, expressive person within. Cotu talks casually with Blackstar until she comes to the realization. Mid-conversation, she suddenly stops responding to Cotu. The camera’s on Cotu and he’s looking away while waiting for her response. After a bit, he turns to check on her. The armor looks frail and withered, and has lost its glow. The person inside Blackstar’s armor looks at Cotu differently than she did, with a wide-eyed, curious expression.
Cotu: “Hi.”
???: “...hello.” Her voice sounds different from Blackstar’s. More childlike. She also looks different from the person who was just inside the armor. A bit smaller.
Cotu: “Do you…recognize me?”
???: *with slightly more energy* “You look familiar, but I’m not really sure.”
Cotu: “Do you know Blackstar?”
???: *delicately, almost reverentially* “Blackstar…I don’t know, but a part of me feels…like she’s really important.”
Cotu: “She was…”
???: “...” She looks at the armor she’s encased in, a little confused.
Cotu: “Oh yeah. Let’s get you out of that armor.” Cotu pulls out his ax and charges it up.
???: “Woah!” She looks scared, but excited. With a single slash, Cotu breaks open Blackstar’s withered armor, freeing ???
??? looks up at Cotu with awe.
???: “Hey, do you know how to fight?”
Cotu: “What was that?”
???: *energetically* “I don’t know why, but I feel like fighting someone. And you look like you know about fighting.”
Cotu: “...How about I introduce you to someone who knows how to fight?”
???: “Sure! Let’s go!”
Cotu and ??? walk over to a gauntlet spawner.
???: “So, how good is this person at fighting?”
Cotu: “Really good. Actually, the best I’ve ever known.”
???: “Wow…I hope they go easy on me!”
Cotu opens its console and spawns in variant 3000: Blackstar.
Cotu: “This will only take a moment.”
???: “Okay.”
Cotu and ??? wait for Blackstar to spawn as ??? looks on in wonder
Blackstar falls from the spawner.
???: “Woah, that’s the thing I was stuck in!”
Blackstar immediately grapples to Cotu and ??? upon seeing them. ??? assumes a fighting stance.
Blackstar stops right in front of ??? in complete shock. Unable to accept what she’s seeing, she turns to Cotu.
Blackstar: “Cotu, who is this?”
Cotu: “Gauntlet 2, Variant 1.”
???: “That’s my name? It’s kinda weird.”
Blackstar gazes at ??? in shock and awe, slightly trembling. Eventually she bends down on one knee.
???: “Um, excuse me, Cuh-Cotu said we were going to fight…do you wanna fight?”
Blackstar: “...” The background music swells.
Blackstar pulls in ??? in a tight embrace. The music reaches a climax.
???: “Uh, what’s going on? I’m confused. This doesn’t really feel like an attack.”
Blackstar lets go and looks into ???’s eyes. “My people…our people crave battle. Here in this realm, there will be no shortage of enemies to kill.”
???: “Really? That’s awesome!”
Blackstar: “Yes, but before we begin, I have to thank my friend.”
???: “O-okay.”
Blackstar approaches Cotu, steps out of her armor, and they lovingly embrace.
Blackstar: “I never would have done it without you.”
Cotu: “You did it all yourself. I was just having fun.”
Blackstar smiles and chuckles a bit. “Is that so?” She pulls away and looks into Cotu’s eyes, smiling beautifully. She looks at ???, who is staring at the pair confused.
Blackstar: “Come see us again soon. I have to train the next incarnation, and I could use the help.”
Cotu smiles warmly. “Will do.”
Blackstar puts on a more serious expression as she steps back into her armor. “Kid.”
???: “Me?”
Blackstar: “Say goodbye to Cotu. He created you.”
Cotu: “Huh?”
???: “Wha? Uh, bye Cotu! Thanks for making me.”
Cotu: “Goodbye, you two.”
Blackstar: “Now.” Blackstar ensnares ??? in her cables and grapples into the distance. ??? starts screaming, then laughing.
Cotu watches them go, then unnecessarily backflips back into the ship.
Greg: “What’s with the unnecessary backflip?”
Cotu: “I guess I’m in a bouncy mood.”
Greg: “Aight buddy. Let’s calm down.”

Turbo Jester Boss: The Greatest Magician
Looks like Jevil from Deltarune (similar proportions but toothier Hazbin Hotel-like grin), but has a hat so big it covers her eyes, has a poofier shirt that resembles a dress, and doesn’t have a tail
In the marathon, appears after every fight to mock or belittle you (no matter how well you did), or do a funny gag (e.g. becoming a beach ball by inflating her costume)
Attacking the Jester causes her to fight you as a boss
Redoing the gauntlet respawns the Jester
Jester has special dialogue if you defeat the final marathon boss before them. Jester then fights you
Jester is a powerful magician
Idea: Jester using magic is foreshadowed by the reveal that in this universe, one’s ability to use magic is derived from their sense of humor; the better their humor, the more potential they have for magic
Idea: she’s criticized and ostracized by most practicing magicians for “gatekeeping” the secrets to magic. These practicing magicians approach magic rigidly and scientifically, but they can only cast weak spells that get weaker when they’re used too many times in a row (which coincides with a bad joke that degrades in value over time). She gatekeeps magic because she tried to tell them how it worked in the past, and when they mocked her and called her explanation ridiculous, she grew frustrated and gave up on them. As revenge, she no longer tries to teach them. She considers them losers (quote idea: “The magic community. Just a bunch of self-centered stuck up pricks whose magic sticks are so far up their bums that they can only cast shit spells.”)
Transformation spells: change Cotu’s body
Embiggen: make Cotu super fat, making him larger (bigger hurtbox), slower, and no longer invincible when dodging, but take less damage
Enshrinken: make Cotu tiny, making him smaller and faster, but take more damage
Jelliten: briefly turn Cotu into gelatin, which causes him to melt and take damage if he touches his weapons (no throw nor instant rethrow)
Umbrella: rises into the air quickly and drifts downward slowly. Used as a general utility mvmt
Counter: she does a funny dance to trick you into hitting her. If she’s hit with any projectile, then time slows down, she teleports behind you, she grows her hand to giant size, then slaps your back with it, launching you into the ground
Ball Throw: she holds a softball-sized ball, then throws it at you. As it gets closer to you, it grows in size and becomes humongous. It bounces off the ground where the target was at the time of the throw, then a wall, and then returns to her hand, shrinking back to the size of a softball by the time she catches it. As it hits things, it makes dodgeball noises
In her second phase, Jester summons a gambling device (e.g. wheel, slot machine, deck of cards, etc.) as a framework for the battle
Jester explains that all humor stems from unexpectedness, and nothing encapsulates “the unexpected” more than a gambling machine
Jester wears a barbershop quartet outfit and holds a cane
Jester says “Let’s go gambling!” to reference raxdflipnote https://www.youtube.com/shorts/QPzSbFejdwE
Lore/Story ideas:
Was originally a shy introvert who learned to hide her vulnerability with humor
Trained alongside the gauntlet during the tournament, gaining their trust
Secretly madly in love (or lust) with Greg

Cotu’s Trophy Wall
Cotu has a wall of trophies in his realm for every boss he kills. These trophies are usually body parts or weapons. The player can interact with each trophy to see notes Cotu wrote about the boss
X
God of Starsteel
Popular during the tournament and was a favorite to win. Lost unexpectedly early to another top contender.
Grow-a-Gator
Giant tooth
God of growth(?)
Unpredictable and cunning. Still learning about boundaries. Not much else is known about it since it was just born.
Future Blade
His body is based on a robber fly, which hunts by tackling its prey in midair and injecting them with venom. Robber flies hunt similarly to dragonflies, which have the highest recorded hunting success rate of any animal (97%).
His venom is chlorine trifluoride, one of the strongest known oxidizers. It’s reactive enough to corrode stainless steel, glass, and rock (i.e. silicate minerals) and can even react with xenon, a noble gas. Future Blade’s venom is a deadly threat to most gods, which is likely why he’s ranked so high despite telegraphing his attacks.
Why ClF3 instead of other chemicals?
Players are more likely to know about it (due to infamous incidents described below)
ClF3 has recorded instances of corrosion outside the lab, unlike other powerful chemicals like PtF6 and FOOF
It was abandoned by Nazis for being too volatile to be used as a weapon
It once broke through a stainless steel container, spilled onto a warehouse floor, and burned (yes, burned) through 1 foot of concrete and 3 feet of gravel
It was described by chemist John D. Clark as being too volatile to be used as rocket fuel, exploding on contact with just about anything
ClF3 is a liquid at room temperature, which is approximately the temperature of Future Blade’s realm since he’s a robber fly
PtF6 has a melting point of 61.3 °C/142.3 °F, making it a solid at room temperature
FOOF is so volatile that it rapidly decomposes into F2 and O2 at room temperature. It even decomposes at a rate of 4% per day at cryogenic temperatures
Can’t metals be protected from ClF3 with a passivated metallic fluoride layer (i.e. fluorine gas can be gradually introduced to the metal to create the fluoride layer)? No because the blade itself would cut through the fluoride exterior, allowing the venom to pass through to the raw metal and burn it

Character Theme Stances
Each character has a stance on the central theme question. The degree to which they agree or disagree with the protagonist’s stance, and their relationship to the protagonist, determines their story role
Theme question: where should joy come from?
Cotu
Competitor who enjoys competition
Theme stance: joy comes from the process (specifically: fighting, struggling)
Protagonist
The Gauntlet (excluding Blackstar) (Variant 1, Elite Gunner + Sentinel, ???)
Theme stance: joy comes from fighting and helping others → aligned with Cotu
Story role from TS: friend
Blackstar
Theme stance: joy comes from the goal (reincarnation), be unhappy otherwise → directly against Cotu
Story role: Primary antagonist
Stays at the top
X
Theme stance: joy comes from the goal (wants to win the tournament and is hard on himself when he doesn’t), be angry otherwise. Joy also comes from fighting, friendship, and helping others, though he’s not consciously aware of these latter desires → mostly against Cotu
Story role: Foil
Grow-a-Gator
Cotu’s rival who becomes his friend
Theme stance: live for violence, violence is fun → aligned with Cotu (live for fun), misaligned with Cotu (live harmlessly)
Story role: Parallel Companion (goes on same journey as Cotu, just stopping at elite)
Clarity
Stranger
Theme stance: live without thinking → against Cotu
Story role: Secondary antagonist

Character Passion and Growth
Each character should have a unique starting and end point in their strength journey, and have their own level or type of passion for fighting
Cotu
Straight line from 0 to top
Loves fighting and the struggle. Even if he doesn’t improve, he’s having fun
The Gauntlet (excluding Blackstar)
No growth whatsoever; level depends on individual
Jab Crab
Stuck at the bottom, but rises a bit to have potential for Gauntlet Gym 2
Enjoys fighting; wants to be the best he can be
Mite Queen
Happily near the bottom
Fights as a hobby; sees improvement as a hassle
Blackstar
Stuck at the top
Sad and desperate to improve
X
Starts just outside the top contenders, ends as a top contender through skill/body upgrade (and by boosting resume with gala wins)
Angry to improve
Triplets
Rises from middle to almost elite
No name wants to improve because wants to become elite (i.e. enter the gala), but he also feels insecure about holding his brothers back since he can’t use magic or portals. Greg wants to improve for fun, but mostly so no name can achieve his dream of winning. Pilot wants to be supportive of his brothers even though he’s scared of competition. Pilot used to be the most competitive out of the 3 during the tournament because he felt insecure about his inability to move, but after realizing that his anger was ruining his relationships with his brothers, he dialed it back and became kind. He now fears going back to his old self
Grow-a-Gator
Explosive rise from 0 to elite
Excited to improve
Clarity
No change in power
Completely apathetic to improvement
Future Blade
Stuck at elite
Works hard to improve, but doesn’t care that much since he expects not to succeed anyway
Candy Cat
Elite, potentially near the top
Apathetic to improvement
Neuro
Starts (considered to be) elite, ends near the top. Didn’t improve in skill, but in reputation by boosting their resume with gala wins
OR starts near the top, ends near the bottom due to returning to a Brain neuron
Calmly determined to improve
What’s missing?
Stuck in the middle, aka Gauntlet Gym 2 (Flying Whale/Mortal Warrior? Math Boss? Ball of Tentacles? Simone Says?)
More instances of rising from middle to elite/top (Paramecium? Slicer? Cactus and Bird? Right now it’s just the Triplets)
Decrease in power (Neuro?)
TO DO: visual representation of start and end points here

Idea: Introduce builds like in Elden Ring to increase replayability
People can spec into stats to boost certain parts of Cotu (e.g. health, rang damage/range/speed, projectile count, cooldown shortening, movement, etc.)

Story Progression Arcs/Episodes (uses Plot Idea 3C)
Cotu goes on a journey and encounters progressively more antagonistic antagonists
Destination is a gala for top competitors. Gala is like a pantheon from Hollow Knight where you fight several bosses in a row
Player only has a limited number of fight attempts across the entire journey before the gala begins. As the player completes subsequent runs, they’ll have more and more attempts that they can use to practice against later bosses
Certain gods (e.g. mites) force the player to defeat them to escape their realms. Surviving their encounters for a certain length of time grants experience that you can use to unlock skills, but doesn’t progress the journey past them
Progressing through the journey quickly (i.e. beating bosses with less attempts) will allow Cotu to catch up to other gods making their way through the gyms. The player may encounter gods they didn’t encounter in previous runs due to taking too long
Leftover attempts can be used to practice with gods at the gala before the gala begins, but in practice fights, gods won’t go all out
Tempered X won’t use his supermoves or enter his final tryhard phase
Blackstar won’t use her ultimate form
Idea: Jester refuses to train with you, but maybe she harasses/teases you in the hub room instead
Note: stabilizers work like Pulse Cells from Lies of P; you’re given a set number of them whenever you respawn/rest (in this case, maybe when you return to your realm), you can upgrade how many stabilizers you spawn with, and you can regain stabilizers mid fight somehow
This also makes Cotu more unique as a god; he trades maximum HP in exchange for the ability to stabilize after being destabilized
Idea: the Gauntlet caps the number of fighters allowed to join the gyms since there are only a limited number of realm rooms (rooms that can accurately simulate the average of the gods’ realms) in each gym, so they test the fighters before granting them access to the next gym
Player can save at a checkpoint with a limited number of slots
Idea: player only gains the ability to save after completing a run (failing to reach the gala in time, failing the gala, or winning the gala)
Steps for the journey:
The Return
Cotu warms up by fighting gauntlet var 1
Cotu can fight any Gauntlet Gym 1 boss afterward, including:
Gauntlet Variant 1
Jab Crab
Mite Queen
Cotu fights X, who’s peeved that he had to wait for Cotu instead of heading to Gauntlet Central early. He’s also impatient to see Cotu get back to his peak power. He’s also covertly happy to see Cotu again
Mite Realm (optional)
Cotu can visit the Mite Queen’s realm after fighting her
On arrival, Cotu is ensnared in the realm’s webs and must fight his way out by destroying the source and saving the trapped babysitter
Gauntlet Gym 2
Cotu arrives at Gauntlet Gym 2, which is when the player sees a cutscene of Grow-a-Gator obliterating everyone at Gauntlet Gym 1
Cotu can fight:
Elite Gunner + Sentinel
Triplets (only if Cotu made it to Gauntlet Gym 2 fast enough)
Pilot can’t summon random bullshit
Greg has no magic
Grow-a-Gator (only if Cotu stays long enough for Grow-a-Gator to arrive)
Paramecium?
Flying Whale/Mortal Warrior?
Cactus and Bird?
Simone Says?
Math God?
If Cotu defeats Gator, they become friends and travel together
Alternate Option to Gauntlet Gym 2: The Void
Instead of going through Gauntlet Gym 2, Cotu can cut through the Great Void. The player is made aware that going through the void is risky since there’s no way to communicate with the rest of the universe, but it saves a ton of time on the way to the gala
In real life, the universe is actually built like a web, with strands of light and matter and vast voids between the strands
Cotu not having time to spare explains why Cotu’s overpowered friends don’t help him along the journey; they’re already at the gala and are busy practicing or on the way to the gala ahead of him. Also Cotu needs the experience fighting people to get strong again
Cotu unexpectedly encounters Clarity’s realm. The player must defeat Clarity or the journey ends here
Gauntlet Central
Cotu arrives at Gauntlet Central
Cotu can fight:
Future Blade, Flora’s friend and coach
Candy Cat, which requires going deep into the basement
Elite Triplets
Pilot can summon random bullshit
Greg can use magic
Grow-a-Gator (if not already fought)
Flora, FB’s friend and star student (?)
Sean Strickland god, who beefs with FB and trains Jab Crab (?)
Potentially a Gauntlet Gym 2 god who improved in some way (e.g. Paramecium?)
The Gala
Player can use their remaining attempts to practice fighting gala gods before initiating the gala like the Radahn festival, but the player only gets that one attempt at the gala
Idea: there’s a giant tower in the middle of Gauntlet Central. The gala takes place at its top
Cotu fights several bosses in a row:
Fire Dancer (?) (low priority for development)
Neuro
Tempered X
Turbo Jester (?)
Blackstar
Post-Gala
Player can fight Microwave, the who believes it’s far stronger than everyone in the gala and wants to test its experimental military

Boss Selection Menu Idea (Plot Idea 4)
Instead of each gym being a hub area where you can talk to the bosses before fighting them, it’s just a basic scrolling menu like world selection in Angry Birds. It’s as minimalist as possible
This would make the dialogue in cutscenes stand out so much more. Without hubs and the freedom to talk to NPCs as much as you want, dialogue is so scarce that cutscene dialogue become far more intriguing

Cutscenes/Boss Intro Dialogue (Plot Idea 4)
Jab Crab fight intro: simple dialogue (in-game or in a brief cutscene?)
Cotu: “Ready?”
JC: “Ready! Don’t hold back, alright?”
Cotu: “I’d never.”
X fight intro: cutscene with different camera angles
Cotu starts off as his usual nonchalant enthusiastic self, then gets shocked and timid when X reveals that he’s using 40% of his power
X is floating in the sky, staring into the distance. He turns to face Cotu after Cotu arrives
Cotu: “Hey, go easy on me, yeah? I’m still well out of shape.”
X considers for a moment, then brings his hands together, and a vibrating glowing orange ball appears between them. He then holds it above his head with his left hand. It grows into a mini-sun, which he then shoots into the sky. The shot sends out a wave of energy and a shockwave that shakes the entire realm. The quick recoil pushes his hand downward, and he also raises his left knee up.
X looks at Cotu, uses a cool gesture to send his icon to Cotu, and teleports to it. Cotu is calm and relaxed, and they do their signature handshake
Cotu: “It’s good to see you again, mate.” Cotu points to the sun. “How much you put in there?”
X: “80%.”
Cotu, calmly: “Ah, so you’re using 20% of-”. Cotu’s nonchalant mask breaks and he stammers. His voice also sounds higher pitched. “T-twenty percent of your power? H-h-hold on mate, I’m not sure if I’m ready for-”
X: “Don’t be a pussy. It’s better this way. The stronger I am when you beat me, the more experience points you’ll get.”
Cotu scratches his head and looks down. “I-I dunno if I can beat you is the problem…you’re gonna hit pretty hard…”
X looks down and to the side and sighs. He turns back to Cotu and says impatiently: “I’ll telegraph my attacks more than usual. Just dodge at the right time and you’ll be fine.”
Cotu strokes his chin. “Hmm…”
X growls while adjusting his face pieces.
Cotu: “Alright, that’ll do.”
X: “Finally. You ready?”
Cotu looks at the sun and gets a little mischievous. “You sure you don’t want to put just a little” he pinches with his fingers “more in-” he points to the sun
X flares up. He attacks with a Superman as Cotu dodges backward
Cotu draws his weapon. He looks shocked.
X: “I won’t waste both of our time with a weak bout. This is as low as I’ll go. Now fight.”
Cotu chuckles and smiles. “This is why I like you.”
Issues with the cutscene:
Wouldn’t Cotu like the challenge? Wouldn’t Cotu ask X to use as much power as possible since Cotu likes fighting so much?
Alt scene idea: Cotu asks X to use as much power as possible, and X calls Cotu stupid and tells him to fight within his limits. Cotu ragebaits X in return
Jab Crab and Cotu conversation about how holding back works
JC: “Wait, if you get experience points from winning fights, why doesn’t X just let you win?”
Cotu: “It all has to deal with the soul. My soul needs to be convinced that the fight is real, otherwise it doesn’t reward me the XP.”
JC: “Ohh.”
Cotu: “Yeah. That’s why I like X so much. He puts on a convincing act.”
JC: “His personality’s an act?”
Cotu: “I don’t know. That’s how good it is.”
JC: “Are you sure that’s not just…the way he is?”
Cotu: “Nah. Maybe my soul thinks he’s a menace, but I think he’s a mushy little sweetheart on the inside.” JC chuckles. “Don’t tell him I said that. He’d hurl me a hundred light years into the void.”
X leaves Gauntlet Gym 1
Cotu: “Leaving already?”
X: “I need to train for the gala as well, and I won’t be challenged at this gym…and at this point, neither will you.”
Cotu: “We can keep fighting each other.”
X looks aside. “The truth is…I can’t stand seeing you this weak, knowing what you’re capable of. I want to fight you at your best.”
Cotu: “X…”
X: “Also, I’m sick of holding back. Containing my power is exhausting.”
Cotu’s expression relaxes
X collects himself for a moment: “If you’re not back to full strength by the time the gala begins,” X’s face ignites. “I will find you, and I will hurl you a hundred light years into the void.”
Cotu nods. “Understo-”
X teleports out
Cutscene that plays when you reach Gauntlet Gym 2
While its hype theme song plays, Gator jumps up and down on top of a pile of dead bodies containing everyone from Gauntlet Gym 1
Music inspiration: Laser Dance from Ocean’s Twelve, aka Khamzat Chimaev’s theme song: https://www.youtube.com/shorts/u8taxTK_6kw
While Gator jumps on the pile, some souls can be seen flying out of the pile
It spots a nearby gauntlet shuttle, gets a wicked grin, and sprints to it
It pops its head up from under the desk and rests it on the console, punches in some coordinates, then flies the ship into space while head-dancing on the console
In the shuttle, to put in the coordinates for Gauntlet Gym 2, Gator simply spins on top of the console in a static pose
While dancing in the shuttle, Gator moves its head back and forth in a downward facing arc
A title appears: [number] [time units] UNTIL IT ARRIVES. The camera then cuts back to the player
Cutscene that plays when Grow-a-Gator reaches Gauntlet Gym 2
Gator crash lands its ship. Its theme song starts playing as people turn to look at the wreckage. It somehow ends up on top of a high place, and jumps up and down and clumsily/slightly unclearly screams to all the fighters just as the song gets good: “rrrrrrrrrrAAAAHHHHH! I BITE EVERYBODY! I KILL EVERYBODY! ALL YOU! I KILL ALL YOU! I KILLA! I KELELELAH (incoherent babbling) RAAAAAHHHHH!!!”
As Gator monologues, people prepare to fight it
Slicer hunches down and ignites hand blades while Jumping Spider stands still
Lobsters fist bump while Paramecium floats by
Elite Gunner has her hand to her earpiece, nods, and pumps her shotgun as Sentinel steps forward beside her
At Gator’s final scream, all the characters jump at Gator
Inspired by Khamzat Chimaev’s rambling after defeating Kevin Holland: https://www.youtube.com/shorts/h2Xqm1km6J8
Cutscene that plays when you meet Grow-a-Gator (maybe the sequence is: Gator arrives, player does a fight, this cutscene plays)
Gator’s lying flat on its belly. It’s very fat and sleeping. All of the gauntlet shuttles and the communication tower are destroyed. It burps out a soul that flies away
Idea: the player can sneak around Gator to get to the control room, where there are spare shuttles in the basement
Cutscene that plays after you defeat Grow-a-Gator
After Cotu defeats Gator, Gator struggles against Cotu’s grip.
Gator: “KILL EVERYBODY! *incoherent babbling*”
Cotu holds up his weapon and starts to strike, which causes Gator to freeze. Cotu realizes Gator’s frozen and stops.
Cotu: “Stay.”
Gator looks at Cotu
Cotu gets up and backs away. Gator lies motionless on the ground. [Camera is on Cotu] Cotu slowly lowers his weapon.
[Cut to Gator] Gator suddenly raises its head and looks up at Cotu. [Cut to Cotu] Cotu instantly raises and flashes his weapon.
[Cut to Gator] Gator is lying motionless on the ground in the exact same pose it was in before. It then goes “bleh” and sticks its tongue out
Cotu: “Hey.”
Gator is still motionless
Cotu: “If you want to kill somebody, ask for permission first.”
Gator: “...”
Cotu: “Understand?”
Gator: “...bleh.”
Cotu slowly puts away his weapon. Gator lies still
Idea: Cutscene that plays when Future Blade takes photos for the gala
Snake glances back and forth between Flora and FB. She raises a camera with her tail.
Cut to the photo room
Glitzy music plays as Snake and Flora/FB take pictures of FB/Flora doing fabulous poses and praise them
Snake: “Yaaasss!”
Snake: “Gimme more!”
Flora: “Oh my god, you’re so good!”
Snake: *squeals*
FB: “Work that shit, babe!”
FB: “Fuck, gimme more sass.”
Flora: “Give it to me.”
The photos increase in speed and the praises escalate to straight screaming at every photo. They begin to sound more terrified than excited
Cut to outside the photo room
Cotu walks by outside hearing screams of terror. He looks horrified and slowly turns to the photo room door. He slowly reaches for the handle before hearing FB say: “YEEEESSSSS!!!”. Cotu pauses for a moment, then quickly scurries away
Cutscene that plays when Cotu makes it to a high rank in the gala (or makes it to the gala?): Blackstar’s first appearance
Blackstar is grateful that Cotu made it this far so he can help her reincarnate. She’s also grateful that her friend is back
She walks up to him and hugs him. After a moment of surprise and hesitation, he hugs her back. He has a look of sadness that turns into quiet resolution
Context: the way this scene is written, Cotu held back against Blackstar in the final tournament match. He regrets it because he thinks it caused Blackstar to not reincarnate. He plans not to hold back in the gala

Notes for full version:
Idea: for certain levels/bosses, give the player a limited number of attempts before the level/boss becomes unavailable for the rest of the playthrough
Mostly available: Cotu’s crew
Triplets
Microwave
Unavailable after defeating them: Cotu’s closest friends
Gauntlet
X
Unavailable after many attempts: Cotu’s less close friends/acquaintances
Mites
Clarity
Levels/bosses that will become unavailable after a few attempts: rare/special bosses
Ball Walker
Create animation for when FirstMiniboss is destroyed by Cotu
Make a Zelda-like big balls monster
Dragon-robot head, 2 big balls as the neck
Comes up from a hole in the ground
Attacks include throwing enemies at you and rolling its balls at you (it then reloads a ball from below)
Allow player to change graphics settings
Bloom
Arena lore
Duels between gods take place in a realm room, a special arena made by the creator of the universe
Each god has a body, soul, and realm
A god arena automatically emulates the combination of realms of the gods who enter it
The arena exhibits more traits of the more dominant realm, and exhibits them more strongly
Cotu’s realm is very weak and passive, causing the arena to conform entirely to the realm of his opponent
Creation lore


Plot Idea 1: Chaos Executes the Gods
All gods know (or are supposed to know) that an all-powerful being they call Chaos will possess one of them to fight one of the others. Cotu fights other top gods in the universe to prepare them to fight him, and to prepare himself to fight them. As Cotu, he is most likely to be possessed by Chaos. The gods Cotu fights are either selflessly keeping themselves powerful to protect the universe (8164, 3), are unaware that Chaos will possess the strong (mites), or don’t care/have some other motivation to be strong (2)
Issues with this plot:
Illogical — Preparing to fight each other is not the only way to deal with the threat of Chaos. The gods can also just stop upgrading themselves, shed their power, or hide it. This is what happened in real life with nuclear weapons: nations destroyed their nukes to prevent catastrophe. Chaos is supposed to represent death, which is inevitable. Chaos in this case is preventable. This reason alone is enough to rework the plot
Lame — The best course of action for a god’s own survival and others’ is to become weaker, not stronger, which is lame
Plot Idea 2: Cotu Loses His Power, and Others Try to Stop Him From Getting It Back
Cotu loses his power somehow and goes on a quest to retrieve it before the next universe tournament
Other gods either help Cotu or try to stop him
Issues with this plot:
Cotu is friends with some of the strongest gods. They would protect him. Even if they aren’t his friends, they have good morals and/or are competitive, so they would ensure that Cotu is given a fair chance to compete. If I make the strongest gods bad guys, that goes against the casual, fun mood I’m going for. This reason alone is enough to rework the plot
Why do Cotu’s opps take this tournament so seriously? They’re gods, they don’t need the prize(s) to survive. Maybe they’re petty and want to win no matter what, but are there really going to be so many petty gods that they can fill up the first half of the game?
Plot Idea 3A: Trip to the Gala (labeled 3A to differentiate from 3B, which has major changes)
Cotu loses his power on purpose to go on vacation with his friends without being bothered by other contenders OR to fight weaker opponents fairly OR to get strong all over again. Cotu trains with others in his weakened form to get strong enough to fight in the exhibition gala, the last big combat event before the next tourney. Throughout the course of the game, he travels to the gala and eventually competes in it
The gala is a huge fighting competition organized purely for entertainment. Through it, the audience can see their favorite fighters in action again, and in matchups that never happened in the tournament and may never happen in serious competition due to power differences
Issues with this plot: see issues with Plot Idea 3B
Plot Idea 3B: Trip to the Gala B
Same as Plot Idea 3A, but with some major changes
The general concept is the same: Cotu trains with others in his weakened form to get strong enough to fight in the exhibition gala, the last casual combat event before the next tourney. Throughout the course of the game, he travels to the gala and eventually competes in it
The triplets don’t travel with Cotu to the gala since they don’t contribute to the narrative
The player has a limited amount of time, not time+stabilizers, to get to the gala. At the gala, the player can use the remaining time to do practice fights with gods before the real fights
Stabilizers are no longer a precious resource usable by everyone; they’re a powerful tool exclusive to Cotu, which simplifies lore and eases player comprehension
(If within scope) Cotu can meet Clarity along the way, and Cotu wants to get Clarity to the gala before she melts so that she can make new friends. The player must now balance getting Clarity to the gala quickly and spending time pre-gala getting stronger. Unbeknownst to Cotu (and the player on the first run), getting Clarity to the gala saves her life
Issues with Plot Ideas 3A and 3B:
The gala is a casual competition, and nobody (which includes the player and the fighters) cares about competitions unless the rankings are official
Plot Idea 3C: Trip to the Gala C
Same as Plot Idea 3A, but with some major changes
The general concept is the same: Cotu trains with others in his weakened form to get strong enough to fight in the gala, then eventually competes in it. The primary difference here is that the gala is no longer a casual event; it is one of a select number of galas throughout the universe to qualify for the tournament
Each gala is filled with an even spread of low to high level fighters like the World Cup (i.e. not all top fighters are in the same qualifier event, otherwise the main tournament would miss out on many of the best fighters and wouldn’t be as interesting to watch). This means the player’s progression in the gala bracket closely resembles a top team’s progression in a World Cup qualifier (e.g. #1 seed fights #16, then #8, then #4, then #2)
Why is Cotu allowed to fight Blackstar in the same gala? Shouldn’t they be in different galas? Cotu asks this and Blackstar explains that Cotu’s seed position was revoked since he reset his powers
Why would Blackstar fight in the same gala as Cotu, who might prevent her from reaching the tournament? She knows how fast he improves; shouldn’t she be with easier competition? She explains that it’s for a few reasons. 1: She and the gauntlet believe she should be able to defeat anyone in the universe to deserve to make it to the tournament. No gauntlet member should be afraid of any matchup in the universe; it’s against their courageous culture. If she can’t beat Cotu, she doesn’t deserve to enter the tournament. 2: She recognizes that she’s not improving while every other major god is, which means her chances of winning the tournament are dwindling by the second. If she loses, she doesn’t want to lose in the tournament, in front of the entire universe with a bunch of strangers. She wants to lose in her own home, surrounded by the people she loves (she says this while making eye contact with Cotu).
I was wondering why I couldn’t get as emotionally invested in the gala as much as UFC fights, and I thought maybe it’s because the gala is unranked. I imagined what it’d be like if a UFC fight were also unranked and realized that I would care about it a lot less, and so would the fighters
Why is it still called a gala? The gala can still be a name for an official sporting event, e.g. the Golden Gala
Idea: the tournament was originally called “the tournament” because the creator of the universe only imagined it as a tournament, nothing more. Afterward, the gods agreed that they may add other events to the tournament, so they renamed it to “the gala”
Gameplay loop:
The player repeatedly attempts the gala, strategizing while getting further and further every time
The above loop makes Blazarang sound like a roguelike, but Blazarang also seems close in style to Cuphead in that it’s a boss rush with little player ability variety, so what should the game lean more towards? I want to keep the strategy involved in long-term planning and reward the player for beating a boss in only a few attempts bc it shows the player’s increase in skill, so I’ll keep the roguelike aspect of repeating the gala from the start. However, it’s vital to note that roguelikes work bc they have a lot of gameplay/build variety. Since Blazarang doesn’t have as much variety, make the full run attempts longer so that the player isn’t forced into the same gameplay too much
You may also feel inspired to make Blazarang feel similar to the gauntlets in Hollow Knight and Sekiro since you like those, but don’t make Blazarang work exactly like that. The gauntlets only work in those games bc you already mastered the bosses beforehand (plus, the gauntlets aren’t the main draw in those games; they’re just bonuses). Instead, give the player time to learn the bosses individually just like in Hollow Knight and Sekiro
Idea: at the end of each run, you can go into battle memory mode where you can attempt any boss you’ve ever fought across all runs as many times as you want with any of the upgrades you unlocked across all runs, but once you start a new run, you can’t practice anymore
Issue: making the boss gauntlet the main gameplay route (as opposed to the free play being the main route) won’t be received well since most players (including you) are frustrated by restarting challenging gauntlets over and over again and having to fight the same bosses every time. This is bonus content for masochistic players who want to show mastery—a very small minority of gamers
Alt idea: to unlock free play mode, you must first reach the gala. This way, the player isn’t tempted to replay the easy bosses too many times before making another run attempt
Expected progress for the average player:
Attempt 1: Late Gym 2-Early Central
Attempt 2: Start of Gala. New bosses encountered due to speed
Between attempts 2 and 3: practice Gym 2, Central, and early Gala bosses
Attempt 3: Late Central-Mid Gala. Alternate bosses encountered
Btwn attempts 3 & 4: practice alternate and/or gala bosses
Attempt 4: Mid Gala. Either Gauntlet or alternate route(s) used
Btwn attempts 4 & 5: practice gala bosses
Attempt 5: Late Gala
Btwn attempts 5 & 6: practice late gala bosses
Attempt 6: Win
Cotu lost his powers due to achieving The Singularity
Some time after the tournament, Cotu’s passion for growth and fun caused him to achieve an uncontrollable level of power known as the Singularity, which the universe simulation banned. As a result, Jessica reset his powers and warned him not to upgrade himself too far again, otherwise she might have no choice but to delete him. Cotu doesn’t mind the fact that he has to start from the beginning because he likes improving, but his excitement, ambition, and pressure from the upcoming tournament makes him try to get his powers back ASAP, which is why he’s willing to fight X at full strength and enter the void just to get stronger
Idea: After defeating Blackstar, Cotu is approached by Mike, who wants to fight him. Mike wants to do research on the Singularity and knows that Cotu achieved it
Singularity is inspired by both a black hole’s singularity (gravitational singularity) and the technological singularity, a concept where self-upgrading AI surpasses human intelligence and control, causing unpredictable changes in civilization
Who Cotu travels with is kept ambiguous by the fact that the player only sees the current level menu (the catalogue of available fighters at the realm Cotu is currently in), not Cotu’s ship or any other hub world
The player must still use their time wisely to get as strong as possible before the gala begins, a la Persona 5
On the trip, gods fight Cotu for various reasons
Gauntlet loves to train people
Gauntlet has the added bonus of having a ton of fighters at different skill and power levels who aren’t participating in the gala
Before the events of the game, X agreed to train Cotu before the gala at Cotu’s request
When they meet, instead of saying that he’s going to the gala early, X says he’s going to Gauntlet Central early
Idea: instead of fighting in X’s realm, X meets Cotu at Gauntlet Gym 1. Everyone there is astonished that both Cotu and X are at such a low level gym
Clarity’s body and realm are autonomous and attack anything that gets near them
Triplets fight Cotu for fun
Mites are wild animals that want to spread and conquer in the absence of their queen, who left them with a babysitter who got captured
Future Blade wants to train
Angels just want to play catch
Some want the privilege of fighting the champion
Some weaker gods are more motivated now that he’s closer to their level
Cotu goes from gym to gym to get stronger before the gala
Gym 1: Beginners and Casuals
Gauntlet Variant 1, the gentle guides
Jab Crab, an ambitious beginner
Mite Queen, who fights as a fun hobby
X, who’s not supposed to be here but trains you
Idea: X comes if you fight everyone in Gym 1 before moving on to Gym 2
Mites, wild animals spreading around
Gym 2: Chaotic Bullies and Ambitious Rising Stars
Elite Gunner and Sentinel, the cool coaches
Long Arms, Jab Crab’s no-nonsense coach (?)
Triplets (if you’re fast enough)
Idea: X (if you’re fast enough)
Grow-a-Gator (if you’re too slow)
Clarity, god of the Great Void
Gauntlet Central (+ nearby gods): Elite Athletes
Future Blade, a self-deprecating drag queen
Candy Cat, the captive sparring partner
Triplets, who aren’t supposed to be here but help you
Angels, folks who just want to play catch
Gala: Championship Contenders
Flora
Neuro
Tempered X
Blackstar
Turbo Jester (?)
Blackstar and Cotu’s fate
After winning the gala, Cotu and Blackstar have a heart-to-heart. After accepting defeat, Blackstar finally lets go of her ambition and self-pressure, which causes her to reincarnate.
Blackstar is trying her hardest not to cry. She tries to stay still and quiet, but fails as tears stream down her face
Cotu notices Blackstar is crying. Cotu begins to apologize
Blackstar: “Don’t be sorry. You fought a good fight.”
Cotu sits with Blackstar as she cries.
…
Blackstar: “I’m so disappointed.”
…
Blackstar: “I love them so much. They gave me everything. And I let them down. They deserve someone so much better than me.”
Cotu disagrees
Cotu tells her that the gauntlet will love her no matter what happens
Blackstar: “I know that…I just wish I could’ve done more for them.”
…
Some upcoming galas offer the gauntlet a chance to compete in them using the new reincarnation, but the gauntlet refuses, accepting defeat fairly (and proving that Blackstar truly did move on).
Afterward, Cotu has one last chance to upgrade himself, or enter the tournament as-is.
If the player chooses not to upgrade Cotu, they get the good (canon) ending
If the player chooses to upgrade Cotu, they buy all the upgrades (they have to in order to progress) and trigger the Singularity ending
Good Ending
Cotu walks away from the upgrade room, feeling content
Undecided what happens after
Singularity Ending
Idea: after upgrading himself, Cotu has an inner conflict before finding that he’s split into 2 versions: Cotu and the Singularity (aka Sy). Sy steals Cotu’s icon and turns it into a weapon not used in the game up until this point: the chakram (just an idea).
Sy throws the chakram at a defenseless Cotu before Jessica appears to save Cotu, subdue Sy, and think about what to do next
Cotu begs Jessica not to change him and tells her he can defeat Sy
Undecided what happens after
Issues with this plot:
Including alternate routes (e.g. mites, Clarity) adds a lot to the game’s scope (Or does it? If the bosses are just selectable from a menu, is there really that big of a difference btwn having the boss on a main route vs an alternate route?)
Figuring out the best sequence of bosses to fight in order to get to (and win) the gala is a big part of the game, but if I were playing this game, I’d just want to figure out how to defeat the bosses themselves, not how to get to them. The puzzle I’m interested in solving is how to defeat an individual boss, not the route to a boss
Neil’s issue: having a time limit that ticks down when you attempt a boss punishes the player for doing practice attempts, which feels discouragingly restrictive
Let’s say your run ends right after you defeat a mid-game boss. Instead of being rewarded with new bosses, you have to defeat all the required early and mid game bosses again. Yes, you can explore a new early-game route, but if the player has already explored all alternate routes, then they’re just repeating puzzles they’ve already solved at this point
If the player is currently fighting a boss late in the time limit and is aware that they won’t be able to make it very far beyond this boss, they’ll feel discouraged the entire time they’re fighting the boss and want to reset
Plot Idea 3D: The Gala
Same as Plot Idea 3C, but with major changes
The general concept is the same: Cotu trains with others in his weakened form to get stronger, and the gala is an official event to qualify for the tournament. The primary differences here are 1: there are no non-gala subplots (trapped with mites, trapped with Clarity, Candy Cat’s escape) and 2: all Gauntlet gyms are participating in the gala; every single gym is a qualifier for the next stage. To progress to the next stage, each fighter must defeat a certain number of other fighters
Idea: reaching the gala unlocks the battle memory system, where you’re able to fight every boss you’ve encountered so far. This way, you can practice against gala bosses even though in a real competition, it wouldn’t make sense for them to practice with you
Gym 1: Beginners and Casuals
Gauntlet Variant 1, the gentle guides
Jab Crab, an ambitious beginner
X, who’s not supposed to be here but trains you
Gym 2: Bullies and Ambitious Rising Stars
Elite Gunner and Sentinel, the cool coaches
Mites. It’s funny to see a bunch of wild animals training
Clarity
Grow-a-Gator, the gym bully
Triplets (if you’re fast enough)
Gauntlet Central: Elite Athletes
Future Blade, a self-deprecating drag queen
Candy Cat, the captive sparring partner
Triplets, who aren’t supposed to be here but help you
Gala: Championship Contenders
Flora
Neuro
Tempered X
Blackstar
Turbo Jester (?)
Issues with this plot:
No non-gala subplots makes the universe feel lame and small
Forcing the player to complete previous gyms before entering the gala takes away some player freedom and strategy (do I skip straight to Gauntlet Central to practice against the harder bosses? Or go through the easier bosses to increase my stats?)
Plot Idea 3E: Lossless Gala
Same as Plot Idea 3D in that all gyms are part of the gala, but losing is unacceptable, which means if Cotu dies, the game resets him back in time to before he lost just like the vast majority of other video games
The gauntlet gala specifically takes place in stages: Stage 1 is open to everyone, Stage 2 is open to Stage 1 winners, and the final stage is open to Stage 2 winners
In Stage 1, Cotu fights:
Gauntlet Variant 1
Jab Crab
After Stage 1 ends, there’s some downtime before Stage 2 begins
Cotu immediately goes to X’s realm
Grow-a-Gator arrives right after Cotu leaves while everyone’s still there
Cotu can either fight Clarity or go to Gym 2, which initiates Stage 2. Cotu can still go to Gym 2 after beating Clarity
After reaching Gym 2,
Gator travels to Gym 2 after massacreing everyone in Gym 1
In Stage 2, Cotu fights:
Elite Gunner and Sentinel
Long Arms ← disqualified due to not showing up
Triplets
Mites
Sometime during Stage 2, Elite Gunner and Sentinel hear about the attack on Gym 1. Sentinel suggests allowing Gator to compete since it’s clearly passionate. Gunner disagrees since Gator was late and didn’t treat fighters with respect. Sentinel suggests that the gauntlet rehabilitates Gator since it’s full of potential. She acknowledges Sentinel’s point and tells him if Gator learns some manners, then the gauntlet will consider taking Gator under its wing. If not (and in all likelihood), the gauntlet will imprison it in Gauntlet Central
Right as Cotu enters his final Stage 2 fight, Long Arms arrives at Gym 2. He argues with EG and Sentinel about how his DQ is unfair until the conversation is interrupted by Gator’s arrival. LA tells the gauntlet that “this ain’t over yet” before all 3 of them plus everyone else in the gym attack Gator simultaneously
Cotu defeats his opponent, then Gator instantly kills Cotu’s opponent and becomes Cotu’s new opponent
Cotu teaches Gator some manners, then shows the gauntlet that Gator’s behaving. The gauntlet agrees and Gator is officially eliminated from the gala
After Stage 2 ends, there’s some downtime before the gala begins
Cotu offers LA the chance to fight and get eliminated “properly”
Cotu takes Gator to Gauntlet Central to train
Cotu trains with Future Blade and optionally Candy Cat
In the gala, Cotu fights:
Flora
Neuro
Tempered X
Blackstar
After the gala, there’s some downtime
Cotu can fight Microwave to get the Singularity ending
Plot Idea 3F: Timeless Trip to the Gala
Same as Plot Idea 3C but without the time limit constraint before the gala begins
Grow-a-Gator appears in Gym 1 when you defeat a certain # of bosses, then Gym 2 when you defeat a certain # of additional bosses
Lesser Triplets are in Gym 2 until you defeat a certain # of bosses, then they move to Central
You decide when the gala begins, but once it starts, you’re locked into an ending route
If you lose at any point, you get the bad ending
If you win, you get either the good or Singularity ending
You’re warned beforehand that you need certain upgrades to defeat certain bosses (e.g. Cotu knows that he needs Dominion to defeat Blackstar)
Issues with this plot:
How will the player practice fighting the gala bosses?
Idea: reaching a boss in the gala unlocks them in free play mode, allowing the player to fight them repeatedly in order to practice
Plot Idea 4: Nothing (Minimal Plot)
Cotu trains with others in his weakened form, but only to make himself stronger, not for a competition. As he progresses through the gyms, word spreads that the champion is getting back into fighting, and more and more people flock to the gyms to see him fight. Eventually, he unintentionally gathers a huge following after training at Gauntlet Central, and the Gauntlet organizes an unofficial mock tournament among the gods there just for fun
Issues with this plot:
Since the gala’s scheduled according to Cotu’s pace, there’s no longer a time limit, which means there’s no more long-term strategy, overarching anxiety, nor replayability
Just like with Plot Ideas 3A and 3B, the gala is a casual competition, and nobody (which includes the player and the fighters) cares about competitions unless the rankings are official
Plot Idea 5: For The Gauntlet
Cotu retired from fighting after winning the tournament, but gets back into training after learning that Blackstar isn’t resurrecting even after fighting all the strongest gods. He trains with others in his weakened form to get strong enough to challenge her
There is no gala; the player is simply moving up the gyms to fight stronger opponents and can take their time. Feels more like Cuphead (infinite attempts) than Persona 5 (limited days and energy)
All gods are training for the tournament. We never see them in competition like in the gala plots
Gyms have limited capacity (limited realm rooms), so the gala tests gods (maybe forces them to fight?) to know whether they’re qualified for the gym they want to enter OR to kick them out and make room for another god
Cotu’s motivation isn’t directly told to the player; the player must piece it together with cutscene dialogue. It’s fine for the player to not know Cotu’s motivation for a couple reasons:
The player can think about their own motivation: beat the game
On the surface, Cotu’s motivation is simply to have fun since he enjoys himself while fighting
Gods preparing for the tournament is an allegory for people preparing for Heaven
Gods frequently stress about their ranking in the tournament
As Cotu fights people, they learn capital virtues
Candy Cat fails to learn chastity and remains imprisoned
Grow-a-Gator learns temperance and befriends Cotu and Future Blade (idea: if you don’t defeat Gator in time, the gauntlet imprisons it)
Idea: Clarity learns diligence
Her mind became automatic due to lack of thought, symbolizing how people can become preoccupied with work without thinking about why, which is a spiritual form of sloth
Maybe she had a foolish dream to fill up the void with snow, then forgot why she wanted to do it? Maybe she thought: “making snow is what I do, so that’s what I’ll do forever”?
Future Blade learns kindness (from Flora)
X learns patience
Blackstar learns humility (she doesn’t need to resurrect to feel fulfilled in life)
Cotu is charity
Neuro learns nothing and is trapped and punished
Cotu represents the 3 theological virtues
Faith: Cotu is friends with Dev
Hope: Cotu has hope that Blackstar will resurrect, that others will improve, and that Dev has good plans for him
Love: Cotu starts training again to help Blackstar and loves himself
The Gauntlet represents the 4 cardinal virtues
Fortitude: Gauntlet Variant 1 fights no matter how outclassed they are. The gauntlet overall is made of brave warriors
Prudence: Elite Gunner and Sentinel strategize and manage the chaos. The gauntlet overall constantly researches combat and technology
Justice: Gauntlet Central imprisons Candy Cat for his crimes. The gauntlet overall doesn’t tolerate combat outside of realm rooms
Temperance: the gauntlet overall is serious and just trains instead of having fun
Some characters are chill and just want to have fun, embodying the good vibes of Heaven
Jab Crab shows humility and kindness (knowing that he’s weak but fighting just because he’s passionate about it)
Triplets show healthy friendship and brotherhood
Mite Queen is laid back, and it’s humorous to have an army of mites fighting in a gym
Turbo Jester is purely for fun
Idea: Cotu must defeat himself at the end of the game. It turns out the reason why he removed his powers was because they were corrupting his soul, turning it into a black hole
Issues with this plot:
Since there’s no gala, there’s no longer a time limit, which means there’s no more long-term strategy, overarching anxiety, nor replayability
Counterpoint: the lack of repetition may be a good thing. Blazarang is closer in style to Cuphead in that it’s a boss rush with little player ability variety. The repetitive gameplay structure of progressing through the gala is more reminiscent of roguelikes like Slay the Spire, Risk of Rain 2, Enter the Gungeon, etc. However, these games work bc they have a lot of gameplay/build variety. Also, the continuous gauntlet (where you have to start from the beginning when you lose) also only works in Hollow Knight and Sekiro bc the games make you fight the bosses individually in the world first, and the gauntlets aren’t the main draw in those games
This feels more serious than Blazarang should be; it’s about a bunch of gods hanging out and competing for fun, so why is Blackstar’s ascension taken so seriously?
Counterpoint: just because Blackstar’s ascension is the main goal doesn’t mean it’s a serious matter
Without the gala, we don’t get to see competitive characters’ competitive sides (Blackstar, X, Future Blade) and casual characters’ conflict with them (Cotu, Triplets, Flora)
Character interactions that are the same regardless of plot
Idea: Sean Strickland god overhears Future Blade and his friends gossiping about him and starts beef
After fighting FB, Sean god becomes friends with him because he respects him as a fighter
FB gossipped about him to tick him off on purpose so that they could fight without FB having to ask to spar Sean god himself
Idea: Sean god figured out that FB ticked him off on purpose seeing how happy FB was during the fight, but doesn’t want to tell FB so that keeps thinking he wasn’t caught
Greg and X meeting for the first time
Cotu comes back from a respawn with X waiting on the ship with Greg. Cotu is excited to see them together and is curious to know how they feel about each other
Greg wants to impress X because he looks up to him
X feels nothing towards or against Greg (at first)
Cotu: “X, I see you’ve met Greg. Have you guys had the chance to talk to each other?”
X: “No. He just walked up and stood next to me (Greg is copying X’s nonchalant pose). I didn’t even know his name until you said it just now.”
Greg: “Sup. I’m Greg.”
X: “…Hello, Greg.”
Greg: “So…X…is that short for…Alex?”
X slowly looks down at his soul, then slowly back to Greg’s face
Greg: “That’s a cool soul you got there. Wanna see mine?”
X: “Cotu, let me know when you’re ready for our next round.”
Greg: “…” Greg looks surprised for a moment, then slowly transitions to a dejected expression. He looks at the floor.
Pilot and X meeting for the first time
X is waiting on the ship alone
X: “I know someone is here, watching me. Show yourself.”
Pilot: “Ah, er…are you sure?”
X: “If you don’t, I will find you myself.”
Pilot: “O-okay then.”
Pilot portals in.
Pilot: “Uh, hi! I’m Pilot. I’m the uh, pilot, of this ship. It’s nice to meet you, X.”
X: “...you look just like that simpleton Greg.”
Pilot: “Ye-yes, I-I’m a simpleton too-I mean, we’re both simple-I mean”
X: “Why are you frozen in place?”
Pilot: “…I…can’t move. Even if I wanted to. That’s why I didn’t want you to sssee [sic] me earlier, so I wouldn’t, er, freak you out.”
X: “...did you think I couldn’t handle the sight of you? That my mind could be so feeble? How insulting.”
Pilot, in a higher pitched voice: “I-I-I’m sorry. It’s just, people are usually…put off by-”
X: “Relax. I was joking.”
Pilot: “...ah, of, of course! You were! Hahahah! That’s so funny!”
X and Pilot just stand in silence
Greg remembering X
Pilot is surprised that Greg is trying to get to know X, as Pilot thought X was famous
Pilot: “You don’t remember him? He was one of the top contenders for a while. A lot of people thought he’d win the whole thing.”
Greg squints at X
Greg: “Wait…oh! Oh, I remember now! Yeah, you were the “Star Guy”! *sigh* I-I completely forgot about you!”
X’s posture shifts: “...you forgot me?”
Greg: “Yeah, I did, I…er, oh, sorry man. My bad.”
X: “The blame is on me. I failed too soon, and allowed you to forget me. Next time will be different.”
X approaches Greg. Greg gets nervous
X: “Greg, I promise you: after the next tournament, you—along with the rest of the entire universe—will never forget me.”
Greg, nervously: “wow, that’s quite a statement. Well, good luck with that, man!”
X nods
Greg, Pilot, no name, and X playing Go Fish (or some other card game that requires knowledge of your opponents’ cards)
X wants to win at Go Fish to prove his own skill. He doesn’t cheat because he’s not as insecure about himself as no name
Pilot wants to mess around a bit, perhaps to encourage the others not to take the game so seriously, and make sure things stay civil
No name wants to win in any way possible no matter the consequences, mostly to mess around and see how the others react, and perhaps to prove himself that he can win at something
Greg’s trying to take a break from thinking about the future
X: “Impossible! You MUST be cheating!”
Greg: “X, X, X. You just don’t recognize skill when you see it.”
X: *leans forward* “I will hurl you a thousand light years into the void.”
Greg: *puts his finger to X’s face* “Shh…Just hush and take this beating like a good boy.”
X: “WHAT?!” *X’s face flames up*
Greg: *pulls his finger away in pain* “ow, oof, ah”
Pilot: *politely* “If you really think Greg’s cheating, maybe we can restart the game-”
Meanwhile, Greg shakes his finger and tries blowing on it, but nothing happens
X: “HELL NO.” *to Greg* “If my legitimate hard work and skill can beat your cheating, you won’t ever talk shit again.” *X makes his play*
Meanwhile, no name taps Pilot with his foot
Greg: *looks at his cards* “Believe whatever you want, hothead, but the truth is, I’m playing fair and square.” *Greg makes his play* “Your move, big Nate.”
Meanwhile, Pilot opens a small portal beside no name that links to a spot behind X’s hand, allowing no name to see X’s cards
No name: *makes his play*
Greg: *GASP*
X: “HUH?!?!”
Pilot: *giggles*
No name: *poker face*
Greg: “What the-bro-OH MY”
Pilot: *subtly sarcastically* “Wow! Amazing play, no name!”
No name: *starts laughing*
…
Greg and Pilot picking up drinks from Flower Clerk
Greg wants to get with Flower Clerk but has no experience talking to girls. A small part of him is aware that he has a much better chance at getting with someone than no name and Pilot, so he’s also doing it for them
On a deeper level, Greg sometimes feels like he’s the older brother to Pilot and no name since he’s the only one who can both move and talk, so it’s his job to take care of them and set a good example for them. This could also explain his ego, as he wants to inspire confidence in his brothers
Pilot wants to save Greg and Flower Clerk from an awkward situation
Greg: *smoothly* “Flowers. I like flowers. One of, ah, my favorite things in the universe, yeah.”
Clerk: *energetically* “I’m glad you like ‘em! You can probably guess what I think about them, huh!”
Greg: “Yeah I can.”
Clerk: “Ahaha...”
Greg: *smiling stupidly* “...”
Greg: “So uh…you doing anything later this week or…” *as he speaks, he slowly falls through the floor*
Greg then appears on the ship and falls right in front of Cotu while speaking. No name is laughing hard while Cotu is standing in shock.
Greg stares directly at Cotu
Meanwhile, no name turns around and straight punches the wall while clutching his stomach
Greg: *slowly and robotically turns towards Pilot with a peeved expression*
Meanwhile, Pilot portals himself into another lying position
Pilot: *sadly* “I’m sorry Greg, it was for your own good!”
Greg: *expression changes to sadness for a brief moment while looking at Pilot and no name* *long sigh*
Greg is mostly disappointed because he wanted a relationship, but a part of him feels like he let Pilot and no name down as the only (or most likely) brother to get into a relationship
Pilot: “But hey, don’t worry about it! Now you have some experience for next time.”
Meanwhile: Greg starts to lie down into a starfish pose. Once he’s fully in this pose, it’s possible to walk over Greg as he no longer has physical collision
Greg: *sadly* *sigh* “That is an excellent point, my friend. There’s always next time.” *stares wistfully at the ceiling*
Greg and Pilot dealing with invasive mites after the player failed to beat the mites on the first try
Greg is tweaking
Pilot is trying to hold himself together
Fade from black
Greg finishes violently dispatching a landmite
Greg: *breathing heavily* “...Mites all over the ship…”
Greg: “You’ll be one of them, sooner or later…*sniff*” he says, staring at a tiny egg
Pilot: *timidly* “Umm, Greg? I-if you have the time, there’s a few more mites…on the hull…”
Greg exhales with steamy breath, revealing his fangs
Fade to black
The player arrives on the ship, which is now covered in blood and silk. There’s a trail of blood leading to Greg’s room
Pilot: *tired but attempting to be enthusiastic* “Hey captain…didn’t beat the mites yet, huh? That’s okay! Take your time, we got everything handled up here…”
Greg, Pilot, and Cotu talking about mortal activities
Greg and Pilot just woke up
Snakes: “Don’t be a stranger. Hehe” *leaves*
Greg (offscreen): “Yeaaaaooooow. Yo, Pilot. That mortal guy was so right. Sleeping feels soooo goood.”
Pilot: “I know right! I feel so refreshed and relaxed. I didn’t even know we could sleep!”
Greg: “Hey is that Cotu? Mornin, cap’n.”
Cotu: “Hey.”
Pilot: “Cotu, you should try some mortal activities! I highly recommend sleeping!”
Cotu: “What’s sleeping?”
…
Greg and Cotu chilling (can be cut to save animation time)
Greg: “No name told me it’s all about the footwork.” Greg bounces on his feet, prepping himself. “Ready?”
Cotu: “Yep.”
Greg: “Alright! Take THIS!”
Greg winds up a huge overhand right, then hurls it right into Cotu’s face. The punch is strong, but imperfect, slightly clumsy. Cotu reels back a bit and loses about 15-20% of his stability
Cotu: “Urgh, not bad.” He takes a second to recover. “Now, my turn.”
Greg: “Alright, champ, show me what you got.”
Cotu steps back a few steps and crouches down, then runs to Greg as Greg worriedly tenses up. Cotu delivers a massive straight punch from below directly to Greg’s jaw. Greg’s head is knocked back a bit, but his feet remain planted.
Greg: *quickly and genuinely* “Ooh I think that stung a bit.”
Cotu has a surprised expression on his face. He looks at Greg’s face, then to his own fist. After a brief delay, his fist cracks, sending streaks up his arm and dealing about 33% of his stability
Cotu: “Argh!”
Greg: “Oh crap!”
Cotu’s streaks disappear as he naturally heals the damage
Greg: “Welp. I guess your body’s not really meant for hand-to-hand, huh.”
Cotu: “Guess not, but I wasn’t expecting to be this weak….”
Greg: “...my bad, dude. I shouldn’t have let you try it.”
Cotu: “No. I’m bad.”
Greg and Cotu chilling
Greg and Cotu chilling during the gala
Cotu: “Hey Greg.”
Greg: “What up?”
Cotu: “You and Pilot picked your own names, right?”
Greg: “Heck yeah we did.”
Cotu: “How’d you settle on the name ‘Greg’”?
Greg: “Simple. It was either that or Josh, and there was no way I was gonna be Josh, so it had to be Greg.”
Cotu: “...why were those the only 2 options?”
Greg looks at Cotu like he’s crazy.
Greg: “You serious?”
Cotu: “...”
Greg: “Listen, you gotta understand-”
Greg falls through a portal
Pilot and Greg playing chess (can be cut to save animation time)
Pilot moves a piece, performing Fool’s Mate
Pilot: “Annnnnnd…there! That’s checkmate.”
Greg: “Wait what? But the game just started!”
Pilot: “No, see, *explanation*”
Greg: “Oooohhhh, bruhhhhhh…” Greg slumps over in his chair.
Cotu suddenly arrives on the ship in a hurry and looks at Greg.
Cotu: “Pilot, I need your help with something.”
Pilot: “Sure thing, what seems to be the problem?”
Cotu: “It’s something with the-”
Greg suddenly jolts awake and yells: “BAH!!!”
Cotu screams “AAAHHH!!!!” and jumps back
Pilot and no name start laughing. Cotu recollects himself
Cotu: “*sigh* well played, Greg.”
Greg: “I’m never gonna hear that playing this game. Anyway what's the issue?”
Cotu and X idling about on the ship
Cotu wants X to be comfortable
X wants to relax
X is reading a book lying down levitating in the air
Cotu: “X, are you comfortable resting here? I can imagine the conditions here are quite different from what you’re used to.”
X: “True. The temperature here is far lower. But I like it here. It’s…cozy. My realm is bleak and empty in comparison.”
Cotu: “Cozy, huh?”
Cotu looks around
Cotu: *genuinely smiles a little* “Yeah, it’s pretty cozy.”
Flashback where Greg shows everyone his magic
Greg: “ABRA CADABRA!”
The wand explodes violently
Greg begs Pilot to go T-Pose mode, Cotu is curious
Greg: “C’mon, pleeeaaaase…”
Pilot: “It’s embarrassing…”
Cotu: “How is it any more embarrassing than ragdolling?”
Pilot: “At least ragdolling is…natural!”
Pilot and Greg discussing Pilot’s abilities
Pilot: “I can do more than you think! Check this out, I can do a little shimmy…engh”
Pilot shifts a little forward on the ground
Greg: *bursts into laughter* “WHAT IS THAT”
Pilot: “Oh so you think that’s funny, huh? Just you wait till I get over there, you punk! Engh. Engh! Huh, engh!”
Greg: “Eahh, get away from me!”
Cotu: “In all seriousness, this is great progress. How’d you manage this?”
Pilot: “Oh, well…how about I tell you all later?”
Cotu shrugs
Cotu and Greg chilling after Cotu fights the triplets for at least 40 seconds total
Cotu is curious about how the triplets’ abilities work
Greg is chilling
Cotu: “Greg?”
Greg: “Hm?”
Cotu: “How do you and your brothers coordinate with the portals so well? It’s almost like you can read each other’s minds.”
Greg: “Hmm…have Pilot or I told you how he puts portals down?”
Cotu shakes his head.
Greg: “Well, basically, there’s these little balls that only me and the boys can see, and they zip around everywhere like crazy.” *Greg starts moving his hands around rapidly*
Greg: “Every so often, one of them will stop for just a moment, right in front of me or Nate, and that’s our cue to just jump at it.”
Cotu: “Hm.”
Cotu: “Is that all there is to it? With how fast you guys portal, you’d think you’d miss a jump occasionally, but I haven’t seen a miss yet.”
Greg: “Huh…never thought about that. I guess it’s just…intuition. Like, I get a strong feeling every time I’m ‘bout to portal.”
Cotu: “Interesting…”
Cotu and Greg chilling after Cotu fights the triplets for at least 40 seconds total (again)
Cotu is curious about how the triplets work in general
Greg is chilling
Cotu: “Greg?”
Greg: “Hm?”
Cotu: “Can I ask…why doesn’t no name use weapons?”
Greg: “He just prefers not to. I’ve offered him weapons before but he’s refused them every time.”
Cotu: “Ah. Perhaps he wants to master unarmed combat first. If only we could ask him directly.”
Greg: “Yeah. Also there’s the fact that like, the vast majority of our stash is magic, so little Nifty can’t use them.”
Cotu: “Really? Why all the magic weapons?”
Pilot: “Um, if I may butt in, any weapon that’s not infused with magic will most likely be weaker than our bodies. After all, our bodies are made of one of the strongest materials in the universe.”
Cotu: “I see.”
Greg: “Wait. Why didn’t I think of that? That’s why he doesn’t use weapons. Damn. I’m dumb.”
Pilot: “Well, it can be easy to forget how durable we are without a frame of reference.”
Greg: “Frame of reference...yo, what if we get Clarity to shoot a shard at me and X at the same time and see who gets hurt more?”
Pilot: “Umm…I think it’s best for your health that you just take my word that, uh, we’re tough.”
Greg: “...I’m tough.”
Nobody knows that the real reason why no name doesn’t use weapons is so that if he’s ever separated from his brothers and is disarmed, he can defend himself without relying on them. Having this conversation unlocks the Seer question “Why doesn’t no name use weapons?"
Note: Pilot’s point that non-magic weapons aren’t useful since they’re weaker than no name’s body doesn’t make sense; just because no name’s body is more durable than them doesn’t mean that weapons aren’t useful. Weapons won’t do more damage than no name’s body, but they’ll have more range and can give no name a leverage advantage, and the weapon itself can be stronger than its opponent. no name’s body > weapon > target; if weapon > target, there’s no reason not to use a weapon
Greg, Pilot, no name, and Blaze meeting for the first time during the tournament in a public hub area where many competitors gather
Blaze wants to make it in time for a sparring session with other competitors
Greg and Pilot are in a heated argument
No name is trying to calm the brothers down but feels too subservient to them to do so effectively
No name puts his hand on Pilot’s shoulder
Pilot: “Don’t touch me!”
Greg: “Don’t talk like that to him!”
While walking, Blaze looks over to the brothers and slows down as they continue arguing
Greg: *loudly* “Why is this tournament such a big deal to you!? It’s just a game! Why are you so…so…” Greg pauses, realizing the answer to his question. His anger turns to shock
Greg: “Agh!” Greg turns around and walks away. No name tries to follow, but Pilot opens a portal in front of no name’s feet, causing him to stop. No name turns back a bit and Pilot begins closing the portal. No name then fully turns around and walks back
Blaze timidly approaches no name
Blaze: “Hello. Um, my name is-”
Pilot: “He can’t talk. Leave him be.”
Blaze: “Oh, I’m sorry, uh…” Blaze looks around confused
Pilot: “Over here.”
Blaze looks down at a limp body sitting on a bench against a wall and realizes he’s the one talking
Blaze: “Umm, hi I’m Blaze, what’s your-”
Pilot: “What do you want.”
Blaze: “...I was just wondering how things were going between you guys, and uh”
Pilot: *dryly* “What do you think?”
Blaze: *pauses for a moment* “...I wanted to let you know that if you guys need anyone to talk to-”
Pilot: *puts a portal underneath himself, causing him to fall out* *another portal opens behind no name*
Blaze looks a bit sad
No name sheepishly approaches Blaze, then slowly reaches out a hand towards him. Blaze begins to reach out his hand
Pilot: “No name.”
No name looks back at the portal, then to Blaze’s face, then grabs Blaze’s hand. Blaze looks at their hands, then at no name’s face without saying anything
Blaze then looks at the door he was about to walk through on the way to the sparring session, then back at no name. No name looks in that direction, then at Blaze, then lets go of his hand before turning towards and jumping into the portal
Greg seeing Blackstar for the first time
Blackstar is talking to Cotu or is occupied with some other task
Greg is supposed to politely greet Blackstar
Greg sees Blackstar and is stunned, putting him in his default stick figure A pose. Romantic music plays as the camera zooms in on Greg’s expressionless face. Meanwhile, two overlapping low opacity animations play: Greg ragdoll falling and tumbling down a pit intermittently cutting to/from Blackstar’s face, and two balls on opposite edges of the screen moving twds each other. When the balls get somewhat close to each other, an electric signal passes between them, then all animations disappear
Greg in his thoughts: “*sigh* She’s way outta my league, I’m not even gonna try.”
Greg approaches Blackstar
Greg: “Sup, Blackstar, welcome to the ship.”
Blackstar: “...hi.”
Cotu and Pilot talking about the future
Pilot’s unsure of what to do with his life, and he’s scared of not knowing
Cotu always lives life in the present and enjoys what he does
Pilot: “This is…kind of a big question, but…”
Cotu looks at Pilot. “It’s alright, you can tell me.”
Pilot: “Have you ever thought about…what you’re going to do with the rest of your life?”
Cotu: “Yeah. I’ll compete. And I’ll win. Or lose.”
Pilot: “But…aren’t you going to get bored of that eventually?”
Cotu: ?
Pilot: “We’re going to live for billions of years. With that amount of time, eventually, we’re going to lose interest in everything we do. So, what’s the point in-”
Cotu: “Maybe I’ll lose interest in fighting. If that happens, I’ll move on to the next thing. Then if I get bored of that, I’ll move on to the next, then the next, then…I’ll just keep going, until the universe ends and we all die.”
Pilot: “What if we run out of things to do?”
Cotu is staring into the distance. He looks scared and sad for just a moment. “I’ve thought about that before.” He looks at Pilot. “It’s a scary thought.” He processes for a bit. “And to be honest, that might happen. But look around.”
Camera cuts to wide shot
Cotu: “Things are constantly changing. The Gauntlet’s building new roads. Mike’s developing new technology. Everybody’s moving around and getting new powers, and we still have yet to explore every part of the universe. We’re always going to do new things and find new ways to entertain ourselves.”
Pilot: “...”
Cotu: “Being a god means more than just living a really long time. It means changing and growing and evolving throughout our whole lives. It’s possible that we’ll run out of things to do, but there’s so many reasons to have hope that that won’t happen.”
Pilot: “That’s true. Everything you said is true. There’s a lot to do, and more things will keep coming.”
Cotu smiles.
Pilot: “But, umm,”
Cotu raises an eyebrow.
Pilot: “I’m sorry, I don’t mean to come off as negative or anything-”
Cotu: “Oh don’t worry about that. It’s helpful to think about these sorts of things.”
Pilot nods. “I just think…if you keep moving on to new things, will anything feel ‘new’ anymore? Are you still going to enjoy what you do?”
[Pilot realizes just how negative he’s really being; he’s arguing against the concept of joy itself]
[Cotu forgives him since these are realistic thoughts; the future is long, and it’s scary to think about what could happen to their minds]
[Pilot confesses his insecurity/jealousy of seeing the people around him, e.g. Cotu, X, and Greg, get new powers while he stays the same]
Idea: Greg and Jester discussing magic
Greg wants to learn about magic to help him and his brothers become competitively viable in future 
Jester’s teaching Greg because she’s passionate about magic (and maybe she likes him)
Greg: “You said magic isn’t something you know, it’s something you feel. It doesn’t follow any sort of real logic, other than being based on humor.”
Jester: “Uh huh.”
Greg: “So then,” he gestures to the laboratory experiments and spreadsheets, “what’s with all the sciency stuff? If magic works like how you said, how do we run experiments on it?”
Jester: “Oh Gregory, my nestled naivete, that’s the joke! It doesn’t make a lick of sense! And that’s what causes the magic!”
Greg: “Wait, hold on.”
Greg does performative hand gestures throughout the following that intensify with his confusion
Greg: “So…magic doesn’t follow logic.”
Jester sillily nods
Greg: “So we use logic to do magic ironically,”
Jester sillily nods
Greg’s voice becomes louder and increasingly concerned and confused.  “which is the humor that powers the magic,”
Jester sillily nods more
Greg: “but that means we’re still using logic, to directly, indirectly, do the magic.”
Jester’s silly nods intensify
Greg: “So magic does follow logic, but…what?! What?!”
An explosion forms behind Greg’s head and he falls dramatically to the floor
Jester looks down to see if he’s ok
Greg lies still for a little while
Greg: “...wait…I think I get it now…”
Jester blinks expectantly
Greg slowly rises to his feet
Greg: “Magic…is just a bunch of BULLSHIT!”
Greg violently rips his head off, revealing a minigun on his neck stump. He then spins around and shoots all of the beakers and minor magical artifacts in the room with perfect accuracy with only his neck. While he’s shooting, Jester ducks down and grabs her hat. Greg then grabs the gun with his hands and throws it at a huge mystical artifact on the opposite end of the room. The gun passes straight through it and plays a fart with reverb sound effect when it does. A bouquet of flowers spouts from Greg’s head stump, then the flowers fall down revealing a new head
Greg breathes heavily as he touches his face and looks around the lab
Jester is in disbelief
Idea: Jester’s true form is introduced
Jester’s just trying to be funny
Jester: “Alright Greg, how do you think today went?”
Greg: “Awful.”
Jester: “ENGH! Wrong!”
Greg: “W-what? What do you mean wrong? I didn’t cast a single friggin’ spell the whole day.”
Jester: “It’s part of the process, bub. You can only cast a spell the right way after doing it every single wrong way.”
Greg glances up and left: “...Really?”
Jester: “No. Ya stink.” Greg covers his face in shame. “But wat da hell are we supposed to do about it?”
Greg: “Okay damn…well, same stuff tomorrow?”
Jester: “Ehh, depends on what the magic wants. Anyway whaddaya still doin’ here? Scram, ya walking lollipop, before I start to lick ya. BLEHHH” She starts whipping her tongue back and forth
Greg: “Yo chill, I’m going. See ya.”
Jester goes back to her room and transforms into Tripty. There’s a mirror in the room showing her reflection, but she doesn’t look at it
Tripty leans her back to the wall and puts a hand on her forehead. “*long sigh*...before I start to” Her hand slowly slides down her face. “...why did I say that shit…”
Tripty slides down the wall and sits against the corner. “I wouldn’t be surprised if he doesn’t show up tomorrow.”
The next day, Greg shows up
Tripty, internally: I could get away with saying some crazy stuff as Jester…should I push my luck?
Jester: “Salutations, slimeball. Ready for some action?”
Greg: “Oh you bet I am. Let’s freaking go.”
Tripty: It kinda scares me that I’m getting away with this so easily.
Idea: Greg meets Jester’s true form
Jester is tired and doesn’t want to maintain her funny form, but doesn’t want Greg to see her in her true form because she thinks her true form is cringe and unfunny
Greg likes to make new friends, so he wants to befriend Tripty, but he’s also wary that she could be an intruder
Greg is unusually early for his session with Jester and shows up unannounced. He’s surprised to see a stranger in the lab
Greg: “Huh?”
Tripty’s voice cracks: “Wah!”
Greg stares at her inquisitively. “oh sup. Have we…met before?”
Tripty: “NO.”
Greg stares blankly for a moment, then snaps back into his relaxed confidence. “Then hey, I’m Greg. I help out around the lab. It’s nice to meet ya.” He extends his hand.
Tripty looks at his hand, confused whether it’s an open hand or closed fist. She cautiously pats it.
Greg: “How ‘bout you?”
Tripty glances around and backs away slowly, accelerating a bit over time. “Errr…I choose to remain anonymous. In fact, pretend I was never he-ugh-” she bumps into a desk, causing her to fold forward clumsily in shock and make a funny noise
Greg chuckles lightly and raises an eyebrow condescendingly. “So what are you, a thief?”
Tripty: “NO. No I’m not.”
Greg’s expression turns skeptical.
Tripty: “I’m, uhhhhh…an assistant! I’m Jester’s lab assistant!”
Greg: “I thought I was her lab assistant.”
Tripty: “I’m her other lab assistant!”
Greg: “Oh. So you know magic too?”
Tripty: “Obviously!”
Greg: “Cast a spell then.”
Tripty is visibly worried since she hasn’t cast a spell outside of her Jester form in a very long time (or maybe ever). She tries to concentrate magic between her hands, but gets winded and breaks form.
Greg crosses his arms and narrows his gaze. “Having trouble?”
Tripty: “I’m-I’m just rusty, give me a second!” She starts fidgeting and shifting around, trying to find any shred of magic and failing miserably. Her expression brightens subtly as she comes up with an idea. She approaches Greg and reaches into the air in front of him, pretending to cast a spell. She’s embarrassed and blushing and internally begs that Greg is fooled
Greg looks down at her hand, then around the room. “Did something happen? I didn’t see.”
Tripty looks up at Greg and stares at his face. She’s closer to him than she’s ever been before as Tripty. “Umm…I cast…the friendship spell! It makes the target friends with the caster, even if they don’t know each other at all!”
Greg is really confused. “So…we’re friends now?”
Tripty: “YES…and that’s why, I will run away and you won’t tell anyone I was here!”
Greg: “...okay?”
Tripty: “CONFIRMED!” She clumsily sprints out of the room.
Greg sits down on a lab stool and calmly ponders.
Shortly thereafter, Jester comes bouncing in.
Jester: “Gregory! Whaddaya sitting still for? I don’t pay you nothing to do nothing!”
Greg: “Boss, someone broke into the lab just now.”
Jester: “Eh? That’s not possible. No one gets into the lab without my permission.”
Greg: “Oh, so…you actually have another lab assistant?”
Jester: “Of course I do! Whaddaya think happens when you’re not here? In fact, one of them should have ended her shift just now. You might’ve seen a stupid mopey-looking loser stupidhead stumble her way out.”
Greg: “Hey, that’s no way to talk about your lab assistant.”
Jester: “Ah don’t worry, I’d never talk about you that way.”
Greg: “That doesn’t change-” Greg looks down and to the left for a moment, confused. “That doesn’t change the fact that-”
Jester: “Enough yapping, bum. We got bigger fish to filet.”
Issue: Greg betraying Tripty comes off as mean since we’re supposed to like Tripty
Idea: Jester tries to gauge Greg’s feelings about her
Tripty thinks Jester is obtrusive and obnoxious and that everyone secretly hates her but tolerates her because she’s powerful. She wants to know if Greg thinks this way, but is too shy to ask him directly, so she dances around the subject while slowly inching towards the real question
Greg genuinely likes Jester as she is and defends her. He still thinks Tripty is a lab assistant


(Not a conversation) People’s opinions on the tournament championship
The source of Microwave’s power is gambling: at the start of every fight Microwave is in, there is an extremely low (maybe ~1 in 10000) chance for a critical error to occur, causing it to become helpless and weak for about 50 seconds
In the championship fight, Mike got a critical error and Blaze destroyed Mike
Blaze thought it’d be cool to be the champion, and thought it was infeasible to beat Mike in a real fight anyway
Blaze agrees with X; since Mike’s power comes from gambling and Mike lost the gamble, Blaze technically won fairly
Cotu fights Mike after the tournament for one or more reasons:
Eventually, it’s not enough for Cotu to just be the champion in name. Cotu wants to prove to himself that he is the strongest in the universe by defeating Mike at its strongest
This doesn’t feel very in-character for a person who just wanted to be called Cotu because it seemed cool, or just got upgrades for the sake of getting them and not to defeat others
Cotu feels bad for beating Mike unfairly and feels like he didn’t earn his title, so he punishes himself by allowing Mike to kill him several times. OR if the player wins within a few tries, Cotu feels bad for not giving Mike a real fight
This would explain why Cotu requests the Microwave at the beginning of the game
Mike outwardly hates Blaze for taking advantage of the critical error, but is secretly understanding. The hate is just a source of motivation and power
Greg, Pilot, and no name all think what Blaze did was reasonable since beating Mike is impossible
X dislikes Mike for rejecting the weakest part of itself, as a person is composed of all of their parts, not just their best parts. In X’s opinion, Blaze won the fight fairly
This fits X’s character; he’s made up of several different parts and 2 different forms (that we see), and he cherishes all of them by using them to their highest potential
Clarity doesn’t respect Blaze for dodging the fight; she personally would have fought Mike at its strongest for honor’s sake
She has a sense of pride, dignity, and elegance represented by her symmetrical forms
She’s only alive for short intervals at a time, so she wants to make the most out of every interaction she gets with others
Microwave meeting the strongest mortal
Mortal: “God of War….Can you hear me?
Microwave: “CAN I? WATCH YOUR WORDS. I CAN HEAR THE BLOOD SLOSHING IN YOUR BODY, MORTAL. I CAN SEE IT FLOW THROUGH YOUR ARTERIES. THERE IS NOTHING YOU CAN HIDE FROM ME”
Mortal: “If that’s true, what am I thinking?”
Microwave draws several weapons on the mortal. “TELL ME WHAT YOU ARE THINKING, OR I WILL KILL YOU.”
…
Microwave meeting the dark revenger, a god who wants to torment Cotu
Revenger: “You hate the champion, just as I do.”
Microwave: “COTU IS ONE OF THE MOST SKILLED WARRIORS IN THE UNIVERSE, AND A MORALLY ADEQUATE PERSON. IF I DESPISE HIM VICIOUSLY, HOW DO YOU THINK I FEEL ABOUT USELESS SCUM LIKE YOU?”
Revenger: “...”
Microwave: “YOU DESERVE TO DIE, BUT YOU’RE NOT WORTH A SINGLE ONE OF MY BULLETS.” *leaves*
Blazar vs Blackstar during the tournament (just an idea)
Blaze is plummeting towards the ground and Blackstar is chasing him
Blaze uses the last of his weapons except one knife, and Blackstar parries them all and closes the distance to him
In the final push, Blackstar readies both of her arms to attack, then lunges at Blaze
Blaze throws the knife at her and she just takes the hit and continues forward
Blaze: “There.”
Blaze then uses Sacrifice to detonate his mark and destabilize her, causing her to pass through him harmlessly
The knife just barely got her stability low enough for the Sacrifice to destabilize her
BS inner monologue with slo-mo mini flashbacks: “He knew I’d get desperate. He knew I’d use both my arms to attack, instead of using just one to attack and one to defend myself, because he knew I was scared of him surviving and killing me on the counterattack.”
BS: “When he used all of his weapons, he fooled me into thinking that he was vulnerable…that I could let my guard down and take some damage in exchange for the win. He got me.”
While Blackstar is falling and destabilized, she frantically tries to grapple, only to realize that the grapples won’t grab onto anything because she’s still intangible
BS inner monologue: “To me, Blaze…is my champion.”
BS materializes right before hitting the ground.
BS hits the ground and shatters into fragments, gold cables, and blood. Blaze hits the ground soon after her and destabilizes, sliding up right before her mangled remains.
Destabilized, Blaze weakly crawls beside her pieces and lies down next to them, the crowd a muffled murmur in his ears. He lies down on his back and puts a hand over his stomach, staring at her pieces somewhat sadly for a while, then into the sky blankly.
Blazar and the Creator of the Universe (“Dev”)
Start of Convo (Idea: this plays at the beginning of the game to explain the universe)
Blaze: “Creator?”
Creator: “Yeah, it’s me.”
Blaze: “How did you create the universe?”
Creator: “I opened up the universe simulation software on my computer, made a new project, aka, this universe, then I asked the AI copilot built into the software to make you guys.”
Blaze: “The gods?”
Creator: “Yup. You and the rest of the gods were AI generated.”
Blaze: “Huh, so that’s all it took...Why did you create us?”
Creator: *nervous laughter* “I was wondering what I was going to tell you when you asked that question, but then I realized you’re not real and I don’t care about your feelings. The truth is, I just wanted to see you guys fight each other. There’s really nothing else to it. And I got what I came for, so…now, I guess…do whatever you want.”
Random Convo
Blaze: “Where did our languages come from?”
Creator: “I had this universe use the same languages as my universe so I could understand what y’all are thinking and saying. I also gave you guys the same slang, just for fun.”
Blaze: “Ah...what’s your universe like, Creator?”
Creator: “...I don’t know. When I talk about “my universe,” I’m really only talking about my planet. It’s called Earth. I’ve lived here my whole life and will probably never leave. I’m not able to venture out into the stars like you all. My people and I, we observe the cosmos from a distance, but we don’t actually go anywhere. So I can’t really describe what it’s like to live in my universe. Compared to yours, my universe isn’t very interesting at all.”
Blaze: “...That’s not true.”
Creator: ?
Blaze: “Your universe, er, Earth, has history. Things happened to get you to where you are now. Something happened to get you to the point where you created my universe. Your people created languages and slang, and each word has its own history. My universe was just born. Nothing exists yet, and not much has really happened yet. Compared to my universe, yours is infinitely more interesting.”
Creator: “...”
Blaze: “I want to know everything there is to know about your Earth. Is there a way I can learn?”
Creator: “Yeah. We have this thing called the Internet. I can download it and publish it in this universe, but the download’s gonna take a while.”
Blaze: “...what’s a download?”
The Creator then downloads “Internet 1.0” onto Blaze’s universe, and now they have access to all Earth-related media
Convo about Heaven
Dev: “At first, I just wanted to make a bunch of gods fight each other. But when I started to think about what exactly it was I was making…immortal people hanging out, having fun, for all eternity…I realized I could make this universe something more….”
Cotu: “...”
Dev: “Heaven.”
Cotu: “Heaven?”
Dev: “I’m a religious person, so I believe that when I die, hopefully, I’ll end up in a beautiful place far away called Heaven. It’s where all the good people go when they die.”
…
Cotu points to himself. “Where did we come from?”
Dev: “The gods you mean?”
Cotu: “Yeah.”
Dev: “Most of you were designed by Jessica.” (some gods are shown onscreen with no sound) “A lot of you were made in the likeness of humans,” (humanoid gods are shown) “since that’s primarily what Jessica was trained on, but with some of you, she got…creative.” (some nonhuman gods are shown) “She made diverse minds and bodies, and really wanted to go beyond what was possible for a human.”
Cotu: “Yeah, that explains a lot.”
Dev chuckles. “And, some of the gods were mine.” (no gods appear here; the camera stays steady on Dev) “For them…I modeled their personalities after people I knew in real life. People who are…no longer here.”
Cotu looks at Dev.
Dev: “I, I guess I…” Dev’s speaking becomes weaker. “I wanted to see what it’d be like…to see them live in…Heaven. To live in a place where…they didn’t have to worry about death.”
Cotu looks at Dev in awe, then looks out into the distance to process what he just heard.
Dev: “I’m not gonna tell you who’s who though.”
Cotu: “Aw, why not?”
Dev: “‘Cause I don’t want you to look at them and just see dead people. I want you to see them for who they really are: alive. People who you know, not me.”
…
Cotu: “Thank you for this universe. Thank you for making me exist. Thank you for all my friends.”
Dev starts crying. “You really are just like him.” Dev sobs.
Cotu holds Dev’s hand. It’s a cursor.
Dev: “I just realized…I’m not gonna see you again until the end of the universe. I’ll only get to watch the replay, of your life. Because I don’t live as long as you.”
Cotu wears a solemn expression.
Cotu: “Dev…whoever I was based on…the real person you knew…is gone. I’m not him. I’m not real to you.”
Dev continues to sob.
Cotu: “It’s time to let go.”
Dev looks at Cotu.
Dev sobs some more.
Dev, very weakly: “Okay…okay.”
Cotu: “I’m going to enjoy this Heaven you’ve made for me. I’m going to enjoy spending time with my friends, and using my cool powers. You don’t have to worry about me anymore.”
Dev sobs staring at Cotu.
Cotu: “Goodbye, Creator.”
Dev: “Bye, Cotu. Enjoy your life.”
Cotu does a cool exit
Miscellaneous Trivia
Blazar / Blaze / Cotu
Named after blazars
Blazars are quasars pointed towards Earth
Quasars are active galactic nuclei, i.e. supermassive black holes in the centers of galaxies, that fire relativistic jets of ionized matter
Relativistic jets are jets that fire material traveling nearly the speed of light
Design is based on black holes (mostly dark features with light outlines)
X / 8164
Inspired by stars and their ability to form iron
Blades are made of lava (molten star material, including iron)
Explosions (Superman ball, Arm Bombs, etc.) are fields of confined plasma expanding
Source: https://www.energy.gov/science/doe-explainsplasma-confinement
In real life, plasma is confined via magnetism (humans) or gravity (stars). X can innately telekinetically control plasma and star lava
Lasers are actually high pressure lava beams
Diamonds are made of cooled iron
Fun fact: the Chain Slice was originally planned as a double slash. The blade spin was an accident caused by Godot’s Euler angle system; when rotating the blade slightly, one of the Euler angle’s signs changed, causing the blade to spin around to match the new measurement
Excluding polishing (which included dodging and some visual effects), X took a little over 7 months to make. That was the total length of time between start and finish, not work time; he was made while I was still a part-time student
Mite level
Unused enemy ideas
Flying tank ticks
Hovers in the air, gradually orbiting the arena
The same as a gauntlet spawner but bigger and higher OR charges up, then spawns a stream of baby mites that deals continuous high damage if you’re standing in it, and deals DOT as a debuff afterwards
Immune to rose, can only be damaged by ax or cutters (except for belly)
Belly is the only weak spot that can be damaged by rose, but it’s only exposed (and its hurtbox is only active) during the somersault
Spawns paramites from its back tip (opposite the head)
Once it runs out of paramites or is cut from its web cable into the sky, it falls to the ground. Upon impact, it makes a big slam hitbox
On the ground, it slowly inchworms towards the target
When close, it lifts up its front, then slams it down
Stretch goal: its slam attack starts a somersault. After the initial slam, there are 2 more: one when slamming its back down and one when slamming its belly down
Flying giant moths
Circles the arena while carrying a ton of landmites and paramites on its back. When it gets close to the arena, the landmites jump onto it and the paramites do their parachute launch
Can be hit by roserang’s homing special. Upon multiple hits, it flies away from the arena while descending, preventing any mites still on its back from jumping to the arena
At one point, JS leaving the arena was inspired by a bug where it jumped to its jump destination, but didn’t stop like it was supposed to, causing it to slide up the side of the arena and fly out. Somehow, it always eventually found its way back. To implement the (now unused) arena leaving feature, I had to deliberately cause the bug to occur again
Jumping spiders have some of the most advanced eyes in the animal kingdom, which is why JS can see Cotu while he’s invisible
Microwave
Originally just a funny gimmick that also fit my idea of an ideal robot soldier (small size so it can move quickly and be difficult to hit)
Coincidentally, it matched the universe’s cosmic microwave background, a concept I learned about after thinking of the microwave boss
Science System
The Creator is using a universe simulation software on his computer to create his own universe pet project
He entrusted an AI copilot built into the software to pseudo-randomly generate the gods
The Creator told the AI to make the gods immortal
The Creator asked the AI to name itself, and the AI decided on Jessica because it contains the letters “AI”. The AI is kinda quirky and cringe and the Creator is embarrassed by it
The Creator made some changes to the virtual universe from his own universe, which has the same rules as ours
Vastly increased the speed of light to make interstellar travel/communication easier
Added stability
Designed the gods himself
Gods were meant to be good, but Jessica, being an unreliable AI, messed that up sometimes
Stability
Gods naturally produce stability from their icons
Only their own stability is compatible with their body, they can’t use others’ stability
Magic
Inspired by the idea that some people are just funnier than others. In a lot of fiction with a magic system, some people just have higher potential for it than others
Also inspired by the debate of whether your sense of humor can be improved or if there’s nothing you can do to change it, just like magic in many stories
Explains why Greg and the Jester are the best magic users in the story
Seer
Interesting concept so I wanted to include some dialogue involving them, but they will most likely be unused since they create logic holes: can’t the Seer speak for no name by interpreting his future actions? And can’t the Seer immediately tell the team where to go to find the best deals on helping Pilot move and no name communicate? And can’t the Seer tell Cotu exactly how to win in every tournament?
Cotu talking to the Seer in his closet
Cotu wants to make sure Seer is okay
Seer wants to feel and think about as little as possible
Cotu: *knocks on Seer’s door* “Hi. I’m sorry if I’m overstimulating you, but are you sure you’re okay in there? I just want to make sure you’re not feeling lonely or uncomfortable. At the very least, I can get you a bigger closet.”
Seer: *quickly whispers* “The smaller the better. The darker the better. Quieter’s better. Thanks for worrying but you are overstimulating. If you’re not here to ask about the future, don’t talk at all, please. This closet is fantastic. Thank you for it.”
Cotu: “Understood. I’m sorry.”
Seer: “You’ve been very kind to me, giving me this room. You’re the only one I trust with my power. Rest assured, I will answer any question you have about the future. I would request that you not ask for anything harmful, but I know you would never do that.”
Cotu: “...Thanks.”
Cotu asking Seer questions about the future
Why doesn’t no name use weapons?
Cotu: “This question’s about another person, but, surely it’s not too intrusive.”
Seer: “...In the event that he gets separated from you and his brothers, he wants to be able to defend himself. He hates being a burden, you see.”
Cotu: “...perhaps I was too intrusive. I’ll only ask questions about myself from now on.”
What is no name’s real name?
Seer: “I’ll keep that a surprise.”
Cotu: “Does he want to keep it a secret?”
Seer: “No. But one day, everyone will know his name.”
Can you speak for no name?

Extra/Possible Feature Creep Content
Icon Hoverboard
Similar to Terraria’s hoverboard
Jump on the hoverboard by holding dodge throughout a dodge
Lateral mvmt is the same as walking, space to ascend, dodge to descend
Not sure about the dodge to descend
AI prompt: (paste in CotuControl.gd) understand the following script. Implement this feature: the hoverboard. Currently, when the player presses dodge, the player immediately dodges. Keep this behavior, but if the dodge button is held throughout the dodge, the dodge ends with the player getting on a hoverboard. On the hoverboard, the player moves laterally with the same controls as walking, but with a faster movement speed. The player’s no longer affected by gravity. Holding space causes the player to ascend at a linear rate. Holding dodge descends. Not holding either or holding both simultaneously will stop the player’s y vel. Throw Shuriken now dismounts the hoverboard, restoring normal walking and air mvmt
Make rangs throwable while hoverboarding
Make hoverboard anim(s) in Blender
Make hoverboard state in Anim Tree (blend space)
Make transitions from HB state to rang throwing states (leave shurikens for now until you make a shuriken throw anim, OR make shuriken throw anim now)
HB to roserang normal throw
HB to rose instant rethrow CW
HB to rose instant rethrow CCW
HB to ax normal throw
HB to ax perfect throw
Stop code from returning immediately after a hoverboard frame (this is what Claude Sonnet 4.5 generated) and make the dismount button Special instead of ThrowShuriken
AI prompt (for this response): Fantastic, this worked perfectly! Now, make all rangs throwable while hoverboarding, so make it so that the code doesn't return immediately after a hoverboard movement frame. Change the hoverboard cancel button from "ThrowShuriken" to "Special", i.e. using a special OR just putting in a special input will dismount the hoverboard. Also, the player shouldn't be able to dodge nor charge jump while on the hoverboard since the dodge and jump buttons are used for controlling hover height.
Put Icon at Cotu’s feet while he hovers
Give the Icon script a hover state. When it’s in hover state, make the Icon’s position/rotation correspond to Cotu’s hoverboard blend space input
Gameplay notes:
Hoverboarding is powerful since it can save the player from dangerous situations, so it needs caveats
Constant stability drain - prevents player from hovering indefinitely and creates tension while hovering
No rose buffing - challenges player to buff the rose on the ground before taking to the skies, significant setback
No dodging - relatively minor/moderate setback since Cotu moves so fast he can dodge things just by moving
Could be feature creep since it’s a broken ability that deviates a LOT from the original game. I turned a ground-based hack-n-slash game to a flying one with a completely different gameplay loop. Work on the hoverboard in the future only if necessary
Icon Shield (blocking? parrying?)

Real Life Fighter Inspiration

Khabib Nurmagomedov
Stoic, honorable man who lives by a strict moral code (Islam)
Learned everything from his father, whom he honors greatly. He quit fighting when his father died at the request of his mother
Now coaches his close childhood friend Islam Makhachev, the greatest MMA fighter of all time

Dustin Poirier
Good man who trash talks
Has a bad habit of pulling up his shorts during fights
Doesn’t know what exactly to do with his life now that he’s retired
Always wants to stay connected to fighting in some way because it’s given him so much in life: he learned about himself, he met new people, he did things he never would have done before (e.g. charity, being a host on live TV, going on podcasts, meeting celebrities, starring in commercials, talking to grandmas and soccer moms, etc.)

Conor McGregor
Arrogant, disrespectful loudmouth with a ton of fans, charisma, and money
Crazy and impulsive; attacked a bus when beefing with Khabib
Turned to drinking after leaving fighting

Joshua Van
Chill, nice dude who likes to show off his wealth and prestige
Attacks quickly and precisely and is hype to watch

Georges St-Pierre
Filled with fear; he couldn’t sleep before his fights because he was so scared and nervous
Khabib always slept before his fights
Realized later on that nobody cares whether he wins or loses, so neither should he
One of the greatest fighters in history

Mike Tyson
Struggles with conflicting feelings of remorse and hatred; he uses darkness to destroy his opponents, but feels guilty for the damage he causes
Was bullied when he was younger, which motivated him to fight to take revenge on his bullies

Islam Makhachev
The greatest fighter of all time, coached by someone projected to be the greatest of all time before he quit early (Khabib)
Humble; owes his success to Khabib. He says that having Khabib in his corner is like having a cheat code
Funny and self-deprecating; doesn’t take himself or the sport seriously
(In an interview with his friend and former fighter Daniel Cormier) “Brother, if you want your son, high level wrestling, send him 2-3 years Dagestan and forget” (Islam and his team are from Dagestan)
(In the cage after winning a fight) “I wanna fight with Brock Lesnar!” (Brock is a huge former WWE wrestler way outside Islam’s weight class)
“Me vs Ian Garry is like Khabib vs Conor from Alibaba” (because both pairs are Dagestan vs Ireland, but Khabib vs Conor was a worldwide phenomenon)
Note that Islam is being humble here. Yes, neither he nor Ian Garry have the stardom that Khabib and Conor had, but if Islam wins this fight (this is being written Jul 3 2026), he would break the record for longest win streak in UFC history (current record is 16 wins) and defeat Ian Garry, an elite opponent with a 17-1 record and who recently defeated former champion Belal Muhammad

Sean Strickland
Real life GTA character
Loud tough guy who suffers from toxic masculinity pressure due to abuse from his father that he still hasn’t moved on from
Generally well-meaning, but is too honest and unfiltered, which gets him into trouble in public. Isn’t afraid to stand his ground and argue
Goes too hard against normal civilians and when sparring in the gym
Super tactical; one of, if not the best defense of all fighters
Only attacks with a jab and a teep
Slowly marches forward to deal pressure
Iconic quotes:
“Here’s the thing you guys,” or “Here’s the thing about ___ you guys,”
“___ is a fucking pussy”

Khamzat Chimaev
Violent gremlin who fights dirty and constantly shoots takedowns. Hunts for complete dominance/submissions
Completely unhinged, making him unintentionally hilarious
“SMASH EVERYBODY! KILL EVERYBODY!”
Has an awesome theme song: Laser Dance from Ocean’s Twelve

Why Fighters Might Want to Change Gyms
What all of these reasons have in common is that the fighter has great potential
They’ve reached a skill ceiling that their coach is limiting them at (e.g. Sean O’Malley)
They’ve been training at the same gym they started their career with (e.g. Jamahal Hill)
They’ve clearly fallen into a bad habit and their coach isn’t rectifying it (e.g. Tai Tuivasa, who became obese)
They suffer a bad loss (e.g. Ryan Span)
Their current gym is run down (e.g. Malcolm Wellmaker)
Their game plan is clearly limited (e.g. Marlon Vera)
