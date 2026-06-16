Blazarang Ideas Doc Backup Jun 15 2026

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
Not very strict since all attacks are easily strafed or backed (“backed” = dodged by backing away from enemy)
Aim: 1
Very little precision is necessary since targets are everywhere
Grounded aim is occasionally helpful against shields and gunners
Homing is completely optional (except for gunners on high ground, which are trivial)
DPS: 1.5
Optimal DPS is irrelevant since enemies have low health. The only exception is when the miniboss spawns, where it’s best to kill it before additional enemies spawn. Miniboss + enemies is challenging, but not super challenging since keeping distance from the enemies is so effective
X: 9/20
Evasion: 2
Much running
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
Clarity: 10/20
Evasion: 3
Running is useless
Well timed dodges of her arm and her minions are necessary
Positioning: 2
Stay in the narrow safe ring between the outer blizzard and her head snowfall. She largely does this on her own since she circles around you
Stay away from her minions’ snow clouds
Aim: 3.5
Requires precise aim and timing to hit her small weak spot right before her attack. You cannot rely on grounded weapons sweeping the area since the weak spot’s too high up
Head is moving a bit, but not very much
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
Make snowflake “tattoo” on underside of hat (and possibly beyond) materialize in an intricate animation as the head tilts up and starts glowing in double slice anims
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
Current task (polish)
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

Mite Level
Hilly grounded arena
Huge hilly floor with varying slopes
Dark gray silt texture
Draw sketch
Make model
Collision only
Huge hilly arena doesn’t feel like Blazarang bc it’s so open world-like and not like you’re fighting an opponent. Also making smooth polygons for sand is hard
Alt idea: same as hilly grounded arena but a giant bowl and ground isn’t necessarily silt
Make model
Player cannot walk on edges of arena for some reason to prevent harvestmen and jumping spider from running off edges and having IK look weird
Idea: edges are covered in mite lord saliva, causing you to be slowed and take massive damage when you walk there
Make saliva particles that rain from the mite lord’s mouth onto the ground
Create mite saliva terrain in Blender
Idea 1: create new polygons in the ground itself
Idea 2: make the terrain a plane for Blender’s hair particles, and each hair particle is a circular patch of venom
Undo edge boundary idea; player should be allowed to walk on edges so they can choose to take the risk of falling and see the jumping spider’s funny IK bug
Prevent harvestmen from dropping close to and walking near the arena edges
Harvestman target pos doesn’t update when player is too far laterally from the center of the arena
(do this after you add random pos egg drops) harvestmen always drop randomly instead of on top of the player
Mites spawn in via giant eggs that fall from the sky and explode when hitting the ground
Several landmites and paramites spawn from a single giant white egg at once
Eggs fall from the sky and are destroyed when they hit the ground
When an egg hits the ground, the egg script calls a func in the mite arena that spawns mites from the egg
Landmites and paramites spawn leaping
Landmite has a var called init_leap_dir. In start_leap(), if this var is not Vector3.ZERO, then landmite leaps in init_leap_dir and sets init_leap_dir to Vector3.ZERO. If it is Vector3.ZERO, landmite leaps in body_meshes.transform.z
Egg has an init_leap_dir variable. When egg lands, it repeatedly spawns landmites while rotating the init_leap_dir vec for each mite
Change eggs so that only one mite spawns at a time from an egg, negating the need to make them leap
Flatmites spawn in individually in much smaller black eggs
Harvestmen spawn in large brown eggs
Eggs can damage enemies, enough to one-shot a landmite
This gives the mite queen personality bc she’s deploying her troops recklessly and doesn’t care if they die, making her look dumb, impatient, and cruel
Try to make it so that move_and_slide is only called once instead of twice in all enemies
Currently, it’s called in both physics process and nav agent velocity computed
You may simply need to double all mvmt speed numbers
Enemy eggs fall periodically
All code for this is within mite level main arena node
If there are too many enemies on the map, no eggs are dropped
If there are too many enemies on the map, the time until the next egg is dropped does not decrease
Every time an enemy is spawned in via an egg, the total living enemies num increases. Every time an enemy dies, the number decreases
Mite level uses object pooling
When loading the level, instantiate the max num of living enemies + one tier 1 egg’s worth of extra troops
Make ~40 landmites, 8 paramites, 4 harvestmen, and 2 flatmites
Keep flatmites, harvestmen, and non-elites in separate dicts
Why dicts? You have to check whether a mite is alive, and you can either do find_child many times and check each mite’s state (if you use a list of inst names), or check whether dict[inst_name] = true. The dict way is much faster
When an enemy dies, how does the dict know to set its alive state to true? Enemy_killed signal
When an enemy spawns from an egg,
Position the enemy onto the egg
Activate and show the enemy
Note: Tier 1 eggs used to contain 4 random non elites (landmites and paramites) and Tier 2 eggs used to contain 8 random non elites. This was changed so that mites don’t spawn inside each other and to make eggs drop more frequently
(Tier 1) Choose 1 dead landmite from the non-elites dict
(Tier 2) Choose 1 dead paramite from the non-elites dict
(Tier 3) Choose the first dead flatmite from flatmite dict
(Tier 4) Choose the first dead harvestman from harvestman dict
When an enemy dies,
Deactivate the enemy and hide it by moving it down
Eggs increase in tier over time
First (wave 1) eggs are tier 1
4±1 eggs
Next (wave 2) eggs are tier 1 or tier 2
4±2 eggs
60/40 between tier 1/2
Next (wave 3) egg is tier 3
1 egg
Next (wave 4) eggs are tier 1 or tier 2
4±2 eggs
50/50 btwn tier 1/2
Next (wave 5) egg is tier 4
1 egg
Next (wave 6) eggs are tier 1
2±1 eggs
Next (wave 7) egg is tier 4
1 egg
Next (wave 8) egg is any tier
8±1 eggs
40/40/10/10 btwn tiers 1/2/3/4
Eggs are dropped directly on the target (Cotu’s body) no matter what elites are nearby, possibly letting the player bait the egg dropper into destroying its own elites
Change eggs so that most drop directly on the target and a few drop randomly in the arena
Has thin layer of fog throughout the arena that prevents faraway objects from being seen
Fog thickens when jumping spider spawns
Fog is airborne microscopic mites
Try this: https://www.youtube.com/watch?v=zNbku2qrtDM&t=212s
Fog eggs drop periodically OR certain enemy eggs contain fog
If fog eggs exist, fog egg drop system is separate from enemy egg drop system (bc fog eggs don’t need to account for how many enemies there are)
Alt idea was used instead
If certain enemy eggs contain fog, give all eggs a low chance to deploy a fog field
Chance of deploying a fog field increases dramatically when spider spawns
Environmental elements
Giant worm body (body behind the giant mouth above the arena)
Make sketch
Detailed inner mouth with ridges and eggs
Make the mandibles look more realistic and detailed
Idea: giant background web strands
Draw sketch
Create strands in Godot
Stability regen is slowed within the level due to microscopic mite infestation
Model notes:
Very low poly
The geometry of the top of a mite’s back is a flat hexagon
Long thin legs, each with 2 segments
Smart trash mob landmite
Concept art:

Model and rig made
Dies in 4 once-damage-buffed rose hits or 3 unbuffed ax hits
Has 3 mvmt states:
Follow (can’t leap): walk towards the target while waiting for the leap cooldown timer to end. When it ends, you can leap, the forced leap timer begins, and the leap cooldown timer resets
Follow (can leap): walk towards the target. If the forced leap timer ends or the roserang is nearby, leap
Bite: when you’re close to the target, stop moving
Leap: jump towards the target. Does a short leap when close to target and long leap when far
Landmite returns to follow state upon landing, not after a certain amt of time has passed while leaping
Mite jumps when y pos is close to target’s y pos, not just when the ground is completely level
Has a random chance (~25%) to have no leap cooldown after a leap, allowing it to leap multiple times in quick succession
Mouth hitbox is extended during jump (mouth hitbox is always active)
Bite anim made
In Godot, anim moves body itself fwd, then back to idle (done through code in Landmite parent node)
When biting, its mandibles grow and open, making its melee hitbox nearly as wide as its body
Replace bite with a tongue attack with a range about 1.5 times its body length. When it’s tonguing, it doesn’t turn, so you don’t need to make a mite turning anim
Give fangs a permanent hitbox to make landmite more threatening
Flying paramites
Die in 2 once-damage-buffed rose hits or 1 unbuffed ax hit + explosion
Look like spider mites
From the ground, they jump into the air, then grab onto a web thread that spontaneously descends from the sky to their feet. They then follow the target while hanging upside down as they very slowly descend
Stop flying towards the target when they’re laterally within about 15 meters
While flying, they spit webs at the target, which do a little damage and temporarily slow Cotu. When they hit the ground, they become little webs that also temporarily slow Cotu when stepped on. They disappear after a bit. The webs also heal other mites if they hit them while the spitweb is airborne. Mites can’t touch grounded spitwebs at all
When their altitude gets too low (about 3 Cotus high), they flip rightside up, release their thread which flies into the sky, then fall straight down.
If they land on or right next to Cotu, they quickly bite while continuing to fall to the ground (there’s an active hitbox on its mouth, but no bite anim)
They then run away and repeat the cycle
Mvmt states:
Launch: quickly move up and away from the launch point (spawn point)
Follow: move towards the target laterally while falling slowly (no acceleration)
Fall: fall straight down to the ground
Paramite switches to retreat state upon landing, not after a certain amt of time has passed while falling
Mites can walk on slopes
Create test slopes in TrenchBroom
Code mites so that their y axis is set to the normal of the plane they’re walking on
Try setting global rotation.x to atan(normal.z, normal.y) and global_rotation.z to atan(normal.x, normal.y)
The result is super glitchy; mites get distorted with every step. In the test scene where you control the mite, the mite glitches out when going up slopes
Try recreating the mite mvmt code in the controllable mite test scene
Instead of being received from the player inputs, mvmt input is the difference between velocity from the landmite script and the mite’s current direction
This was overcomplicated and unnecessary
Don’t rotate mite parent; only rotate paramite proc anim meshes and only use parent for mvmt
Done; below is a description of the process
Most importantly, the rotation of the body meshes (for both landmite and paramite) is now independent of the parent node; parent controls its own mvmt and body meshes' rotation. The parent's own rotation no longer changes.
Landmites and paramites now run up slopes; the upward direction of their bodies point in the direction of the slope they're running on. Did this by setting their basis in the paramite proc anim meshes script based on the normal of the slope they're on. The normal is obtained not by getting the avg normal of the planes formed by the points where their feet hit the ground, but by getting the normal of a single raycast emitted by the script itself.
Also created a new func in landmite and paramite parent scripts that convert a vector pointing in the direction of mvmt to a rotation for body_meshes (paramite proc anim meshes) to achieve. This is done by getting the arctan2(x,y) of the vec (where x = vec.x and y = vec.z), minus the body_mesh rotation.
Use the single-raycast logic to make flatmites run up slopes
Big stepper: harvestman
Super tall
Walks on 4 long thin legs (very front and very back legs) and uses the remaining 4 to poke at anything underneath it
Does idle pose or anim when target isn’t close
Does rapid poke anim when target is close
Damage over time is dealt when near the poking legs
Make model & rig
Draw sketch

Make model
Make rig
Central body’s orientation & offset adjusts with the ground slope it walks on, just like a landmite
Central body’s height from the ground is about ½ to ⅔ of the way up the paramite’s max height
Single-segment flat body with long thin legs
Moves with NavAgent3D so it can avoid other harvestmen and paramites can avoid them (don’t forget to set height)
Harvestman on NavigationAgent3D avoidance layer 3
Avoids other harvestmen, ignores all other mites
Landmites and flatmites ignore harvestmen, paramites avoid them
Spits tiny mites in a long burst when within range like a bile titan from Helldivers 2
Works the same way as a landmite bite state
When spit cooldown is 0 and within firing range, switch to spit state, in which harvestman stops moving
After spit, return to follow state
Spit anim made and implemented
Make anim where it exits an egg
Flatmites
Looks like a landmite but flat and black with a white hexagon on its back
Dies in 1 hit
Has no melee attack
Runs around the target quickly and erratically while waiting for its attack to charge. Once it’s ready, the mite stops, looks at the target, jumps, and shoots a shotgun blast of spitwebs at the target
Since the mite is flat, it’s impossible to hit it until it jumps
Mvmt states:
Follow:
Neutral: mite sets its target position to a random point near the target, then runs to it. After the leap cooldown ends (can_leap = true), and as soon as the roserang is in flight and far away, the mite enters leap startup mode (in_leap_startup = true)
Leap startup: mite runs directly to the target instead of a random position. Once the mite is close enough, it leaps
Leap: mite leaps into the air and spits at the target. Does a short or long leap depending on how far it is
Leap ends when flatmite lands on the ground after spitwebs have been spat, not when a time duration passes after the spit
Miniboss Jumping Spider
Size of a Helldivers 2 Stalker
Make model & rig
Find reference
Use a hairless or short-haired spider bc making a hairy spider (e.g. a jumping spider) w/o hair might look off
Draw sketch (if you want)
Make model
Make rig
Separate each leg object into 3 separate objects, 1 for each bone. Try not using the Separate tool in Blender, but using loop cuts
Add vestigial bones at ends of limbs so Godot IK works
Set up IK in Godot
Idea: before it arrives, a pop-up appears warning that players with heart problems should exit this level before it’s too late
Idea: coached by its creator throughout the level to show the spider’s intelligence, its relationship to others, and hint to the player that the player needs to understand the spider to defeat it
Idea: dialogue is only audible if the player has a translator charm equipped
“Listen well, my child. To win, you must understand your enemy.”
“Look closely. The dark one there. Do you see him?” *hiss* “Good. Watch him run. Watch him dance. Learn everything you can.”
*hiss* “Do not underestimate him, child. He is weak, yes, but he is still Cotu.” *hiss*
“Rrrrrrr…Never let your enemy know your next move. Just as you are collecting information about them, they are doing the same to you.”
“Do you see your openings?” *hiss* “Huhuhuhu. Good, my child. Very good.”
As the spider descends into the arena for the first time: “Remember, my child…know your enemy, and you will never lose. Keep your distance. Bide your time. And when you see an opening…TAKE HIM.”
Arena spawns jumping spider after final mite wave
When it arrives,
All mites run to the edge of the stage and jump/fall off
In all mites, make leave frame func. Leave frame func doesn’t change target position
Target position is set to a point at edge of arena when switching to leave state
Landmites start leaving when in follow state
Paramites immediately fall to the ground if they’re in follow state. Once they’re in retreat state (i.e. they touch the ground), they switch to leave state
Paramites no longer use tweens to track follow progress bc they’re not cancellable. Follow progress is now set every frame
Flatmites start leaving when in follow state
Harvestmen explode
No need for leave frame func; simply make harvestman do a twitch anim, then die (call hurtbox die func)
Jumping spider descends a silk thread
The arena is filled with more mist, making faraway visibility even worse (start working on this once you start adding mist to the arena)
Code Jumping Spider AI
Implement all AI states (except Curious) and test on simple slopes
Try using a tween instead of setting the spider’s velocity to make its jumps more reliable (no chance of bouncing off target)
This doesn’t work because the CharacterBody3D automatically snaps to the floor unless its velocity is changed (spider moves twds jump dest, but slides along floor). Setting floor_snap_length to 0 (which I thought would disable floor snapping), adding velocity right before the tween, and not calling is_on_floor during jump didn’t work
Try turning off physical collision during the jump
In switch_to_attack, turn off physical collision with everything except arena
In attack_frame, reactivate collision upon landing
Targets your body instead of your icon, unlike other enemies/bosses
States
Curious: spider doesn’t fear you. Only used when the player encounters the spider for the first time. For details, see “On first meeting” section below
Walk: spider is walking to its next dest. Switches to Aim state after reaching it
Spider has a desired minimum distance from you when attacking (walk_dest_dist_from_target). Take the dir Cotu’s body is facing, and starting from the target, go walk_dest_dist_from_target in the opposite direction. Get a random point around this position (walk_dest_radius) in the x & z axes, then fire a ray from high above this random point straight down. If it hits a part of the Nav Mesh (or some terrain the spider can get to), then set the walk dest to this. If not, increase the random pt radius by 10%, get another random pt, and check the new one. Repeat until a valid point is obtained
If the walk dest enters Cotu’s FOV, spider recalculates it
Imagine the camera was actually attached to Cotu’s body and facing the same direction as his body. That’s the character’s field of view
FOV only considers x and z pos, not y
Potential code to get random point in Nav Mesh: Godot 4 New Navigation Server Random point AI (Tutorial)
Time 7:54, line 43
Add a max walk time in case the walk dest keeps entering Cotu’s POV and the spider can’t choose a walk dest
Aim: spider is stationary and turns to face you if the y axis angle btwn its body’s forward dir and the dir from it to you is too high. “Too high” threshold is set to a random value btwn min and max vec angle every time the spider turns to make turning less predictable. For a few seconds (~2.0-4.0), spider won’t attack. If it’s hit during this state, it goes back to the walk state. Afterward, spider switches to Ready state
Spider repeatedly switching to walk state when hit out of aim state makes player aggressively chase the spider
Ready: spider continues to be stationary and turns to face you, but the spider constantly turns. When you do an action that triggers an attack, front legs are raised to point towards you for about half a dodge’s length, then the spider jumps. After some time passes with no trigger action, it attacks
Attack: spider jumps at you and bites. It continues chasing and biting until you hit it, which switches it to the retreat state
Bite anim made
Bite anim activates and deactivates hitbox, allowing spider to damage you multiple times while staying in close proximity to you (without repetitive reactivation, hitbox would constantly be touching you, meaning you’re only hit once initially)
Jump duration is about half the length of your dodge; jump occurs about half a dodge’s length after the start of the action that triggered it
Jump dest is calculated using your position + your vel at the time the jump begins
Jump dest = your pos + your vel, then
Jump dest -= a small fraction of the vec from spider to jump dest, so the mouth of the spider ends up at jump dest
Retreat: spider quickly turns to, then walks to a walkable point far in the opposite direction of you, then switches to Walk state
Spider has a minimum desired distance from you when retreating (min_retreat_dist). Take the dir from Cotu to spider, and go min_retreat_dist in that direction. Fire a ray from high above this point straight down. If it hits a part of the Nav Mesh (or some terrain the spider can get to), then set the walk dest to this. If not, reduce the dist by 10% and check again. Repeat until a valid point is obtained
On first meeting: Curious state (implement this after all other states)
Stands and stares at you
Occasionally turns towards you
Occasionally turns towards a jumping destination
It turns to 1 or 2 points on the way to the jumping dest, pauses for a moment for each point, then turns to face the jumping dest
Every time spider switches to walk state (either due to retreat state ending or aim state being interrupted by a hit), instead of going back to walk state, sometimes it runs to a faraway point (faraway state) and:
Leaves the arena by climbing a vertical path, then a bunch of webs fall from the sky. This makes it harder for the player to just walk/dodge backward at the center of the arena every time
Make leave points on 4 points of the arena
(135, 29, 0)
(-135, 29, 0)
(0, 29, 135)
(0, 29, -135)
Spider can choose to leave after retreating
When spider decides to leave, it runs to the closest vertical path contact point, turns towards the path, and runs straight upward
Create list of vertical path contact points
Make leave state
Leave state has 4 phases: walk to leave point, ascend, wait, and descend
Walk to contact point: simply walk to closest contact point (similar to retreat state)
Ascend: rotate body towards path and immediately ascend while walking
Add code in JS proc anim meshes that locks rotation but allows leg mvmt (this code was replaced by fake mesh movement instead)
Make ascend walk anim
Wait: wait above the arena as eggs fall (this code isn’t all that happens; main spider, now invisible, walks to descend point during wait state. In descend state, fake spider mesh will descend from the sky)
Make web egg
Make func that sequentially drops 8 web eggs in random locations (mostly near the center of the arena)
After testing, these webs don’t do much bc they’re far from the player most of the time. Drop 4-8 eggs around the player
Descend: teleport to a random point above the arena, then descend a silk thread to the ground (don’t animate the transition btwn thread descent and ground until descend code works) (this code was replaced by fake mesh mvmt instead)
Make descend anim
Make descend pose
Make ground contact anim where that spider extends its legs and tilts forward when close to the ground
Spider rotates (about y axis) twds target
Make fake meshes top level and change code to match (changed by following code)
Put fake meshes inside an outer node (pivot), then make all fake meshes y rotation code affect the outer node. Inside the outer node, the fake meshes are rotated 90 deg forward (on the x axis) so that the spider faces up and fwd. This simplifies the code to y rotate fake meshes twds target so that you can use the same y rotation code as the main spider without accounting for rotating the spider down
Silk thread during descent
Silk thread mesh in spider scene
Spider leaves the silk mesh behind after descending; it instantiates silk thread mesh after touching the ground
After touching the ground, spider switches to aim state
Why not spawn a flatmite? Player would have to pay attention to the flatmite to know whether to dodge, but if the webs only fall when the spider leaves the arena, there’s nothing for the player to keep track of/respond to
Spider used to spawn all enemies, but players would see that as lazy game design
Design vertical path visuals (mandibles)
Switches to aim state (this was simply another method of reaching aim state without walking to a walk dest, which is often too close to Cotu)
Faraway state tasks:
Switch to faraway state if it stops walking (walk max duration ends) within a dist slightly farther than rose throw’s dist of you
Sometimes switch to faraway from retreat
Faraway state funcs/inclusions (switch to faraway, faraway frame, physics process inclusion, velocity computed inclusion)
Choose faraway dest
Post-faraway choice
Leave
Aim
Leave state tasks
Decide: jump out laterally or jump straight up? Jump straight up looks goofy, so jump out laterally close to arena ground level at rim
Leave state funcs/inclusions (switch to, frame, physics process, vel computed)
Aim, ready, and jump (aka switch_to_attack) states now have 2 modes: aim at target, or aim at walk_dest
To make spider want to leave,
When exiting faraway state, if rng.randf > leave_chance, spider wants to leave
When spider wants to leave,
In switch_to_aim,
aiming_at_target = false
choose rim dest (walk_dest is set to a point on the rim of the arena)
Implemented as choose_far_dest(on_rim = true)
Aim timer is low since the player doesn’t need as much time to prepare
In switch_to_ready,
Ready timer is low for same reason as aim timer
In switch_to_attack,
Attack timer is very low so the spider returns to the arena quickly
In attack_frame,
temp_attack_stop_dist is set to a very small value so that the spider slides/flies out of the arena instead of stopping at the point
In switch_to_retreat,
Spider teleports to a random location outside the arena before choosing retreat dest so that it returns unpredictably
For now, spider reappears on ground at edge of arena. Eventually, consider making the spider descend from the sky/giant flying mouth (sometimes)
Erratic stop-and-go movement (as opposed to smooth acceleration and deceleration) for all mvmt except attacking and retreating
Mixups
At end of retreat state, spider has a chance to go directly to aim state (instead of faraway or walk) to throw off the player’s rhythm
When spider’s movement erratically stops, it switches straight to ready if it’s close enough to you
Double jump: when spider switches to attack, instead of jumping at the target, there’s a chance (maybe ⅓) for it to jump to a point behind the target, then return to the ready state (w its min duration), then jump to target
When switching to faraway state, spider can jump to faraway point instead of walking if the dest is too far from its current position
When spider’s movement erratically stops in walk state, it jumps to its walk dest if the walk dest is too far
When spider’s health is below half (phase 2), the spider stops attacking the player when the player does the action that the spider responded the most to
In phase 1, count how many times the spider jumped in response to a rang throw vs a dodge
Spider has separate response funcs for when Cotu throws vs dodges (rather than linking them both to ready_action_trigger)
In phase 2, stop responding to either rang throw or dodge
if phase2 and throw_responses > dodge_responses:
Throw response func doesn’t trigger jump anymore
if phase2 and dodge_responses > throw_responses:
Dodge response func doesn’t trigger jump anymore
Instant jumps from far away to your position (goes from Ready to Attack state) right when:
You throw a rang (not instant rethrow)
You dodge
Some time passes without you throwing or dodging
Hitting the spider while it’s chasing makes it retreat. Spider’s jump attack cannot be interrupted bc if it could, the player could just throw the ax and wait for the spider to jump into it
Add interactions with environment and environmental hazards
Silk
Web patch
Before implementing AI, think of counterplay a player may use and how effective it would be. This is done to gauge difficulty, fun, and potential spider counterplay/adaptation
Some things a player might try are:
Bait attack with rang throw
Throw the rose, then quickly dodge: Wrong
Spider jumps in when you throw, then you dodge the attack, then spider bites you, then rose hits it on the way back
Throw the rose, then the ax immediately after (or vice versa): Correct
Spider jumps in when you throw the first rang, then gets hit by the second
If the spider gets hit by this or the throw-dodge method twice, it no longer attacks when you throw a rang
Bait attack with dodge
Dodge when the rose starts changing direction towards you
Spider jumps in when you dodge, then gets hit right when it tries to bite you (if the rose is close enough)
If the spider gets hit by this method twice, it only attacks when you dodge and the rose is close to you/unthrown at the time you dodge
This way, by the time the spider arrives to bite, the rose is as far as possible when the dodge ends
Dodge, then immediately recall ax (ax must already be out)
Spider jumps in when you dodge, then spider bites you, then ax hits it on the way back. The window where the ax hits before the bite is too short to be consistent for the average player
If the spider gets hit by this method twice, it only attacks when you dodge and the ax is unthrown
Don’t look at it for a while, then dodge right when it jumps at you, then attack it
Spider jumps in, you dodge, then you hit it while it’s in endlag
Track what actually worked and gauge whether it’s fun to figure out and/or do
In practice, here’s what actually worked/didn’t work (“backward” = away from spider):
Note: shurikens were unimplemented at the time of this testing
(Untested but strong theory) use shurikens constantly; consistent but slow
Constantly hits it out of aim state, but doesn’t do enough damage on its own, and you need the spider to be close to you to deal enough damage to it
Bait attack by throwing the rose, then quickly dodge; consistent and slow/medium
Spider jumps in when you throw, then you dodge the attack, then rose hits it on the way back
Not fun if the player can simply go to the center of the arena and walk backwards, which stops them from engaging with the slopes
Bait attack by dodging when the rose starts changing direction towards you; consistent and fast
Spider jumps in when you dodge, then gets hit right when it tries to bite you (if the rose is close enough)
Somewhat fun and challenging since the player has to constantly instant rethrow and remember to dodge only after the spider switches to ready state. May get repetitive after a few hits so introducing environmental hazards and/or adaptation may be beneficial here
Bait attack by dodging around ax (or recalling it); ineffective
Spider jumps in when you dodge, and either tanks the ax hit or doesn’t touch ax since you dodged around it
This covers “Dodge, then immediately recall ax (ax must already be out)” case in speculation above
The effective method is to wait for the spider to jump on its own bc its mvmt will stop before your dodge ends instead of at the same time your dodge ends
Throw rose in front of you constantly; inconsistent but fast
Rose gets buffs, but there’s 2 cases to keep in mind: the rose hits the spider right after the spider lands (so it stops chasing immediately), or the spider jumps through the rose, lands, and bites you before the rose returns
Not fun bc it’s inconsistent and player can simply go to the center of the arena and dodge backwards, which stops them from engaging with the slopes
Leave the ax in midair with you btwn the ax and the spider, then when the spider jumps, dodge around the ax and backwards, causing the spider to run into it; consistent and fast
Seems easy at first, but you can’t touch the ax (bc you’d catch it) AND can’t dodge so far to the side that the spider runs/swings around the ax entirely
Fun bc it’s creative and rewarding for the player to figure out


Ready trigger reaction effects
Outward-moving lines around its head to show that it’s hissing when it detects a throw or dodge
Hiss sound effect
Step SFX
Background Decor
Idea: Small bugs flying all around outside the arena to make the illusion that there are a lot more enemies than there actually are
Save this for the full polished version
Giant worm whose mouth is open and pointing down at the arena from far above. This is the source of the enemies
Idea: Cotu eventually enters its mouth and fights the Centipede inside
Lore: this worm is the mites’ realm. The Centipede is the true god of the bugs and is sending out its babies and pets to play
Hard egg: egg about the size of a bigweb egg that’s simply a solid object in the arena. Breaks (disappears) after a while. No mites can destroy it except charging hopmites
Test if mites can navigate around solid objects that aren’t part of the nav mesh (simply add a collision shape on top of the ground)
They can! I tested this with a cube over twice their width and they could still navigate around it. With a smaller round object, they could totally avoid it
Hard eggs all disappear once jumping spider arrives
Jumping hopmites (work on this after shurikens; even though you’re currently familiar and comfortable with mite code, you don’t know how (or if it’s possible) to make hopmites stand out from both landmites and shield enemies aka melee tier 3s from gauntlet level 1)
Looks like a camel spider with an ant door head
Dies in 3 unbuffed rose hits from behind or 1 unbuffed ax hit + explosion
Has big head that ricochets rose hits from the front
Mvmt states:
Stalk: slowly walks towards the target
After a leap, a leap cooldown occurs. During the duration of the leap cooldown, mite is in follow state
After a leap cooldown, a stalk period occurs. During a stalk period, the mite leaps if a roserang gets too close to it
After a stalk period, the mite leaps
Bitemites: to be added before or instead of hopmites
Thick mites (size is btwn landmite and jumping spider, slightly smaller than hopmite if it is made) with huge jaws that deal big damage, but dies more easily than landmites
Dies in 5 once-damage-buffed rose hits or 2 unbuffed axrang hits + 1 unbuffed axrang explosion
Has somewhat more health than a landmite, but is easier to hit since it’s a big target and can’t jump
Runs significantly faster than landmites but can’t jump
Jumping Spider is a gimmick boss that doesn’t fit the rest of the level. Replace it with the Megamite
Gigantic thick mite with a back full of eggs like a Surinam toad, but instead of a set of holes, it’s one big hole that acts like a bowl (this makes modeling easier)
Slowly walks on walls and floors with the same code as the procedural anim spider (instead of a nav agent, set the mite’s walk and turn inputs to make it walk around the arena)
Periodically launches eggs from its back
Has a weak point on its face
Tasks:
Decrease size of arena. Arena was big originally because I thought the mites should have a Helldivers 2-like open map, but now I want it to be like a claustrophobic pit nest

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

Snowflake Boss: Comet/Clarity
Design notes:
Final boss of the first half of the game. A pivotal opponent that gives Cotu a major movement ability
Idea: defeating Snowflake gives player option of either flight/hovering (fast mvmt with locked altitude or limited altitude control) or high jump + double jump
Gateway boss between low-mid level grunts and insane planet destroyers
First instance of a god not being friendly and/or communicative towards Cotu. Transition character from his friends/acquaintances (Gauntlet, X, Mite Lord?) to strangers/enemies (possible kidnapper bosses who try to stop Cotu from gaining the experience to win the next tourney)
Story:
The crew is trying to get through the Great Void, but along the way they happen to encounter a stray comet on a collision course with the ship. Despite the crew’s evasive maneuvers, the comet seems to follow them, which is when they realize it’s actually a realm. By the time they realize it, it’s too late and they’re trapped in the realm’s raging blizzard. The crew attempt to contact anyone in the realm via wireless signal, but get no response/noise. Since the triplets are too important and take too long to regenerate, Cotu enters the realm to ask the god to take down the blizzard if possible.
When Cotu first enters the realm, he encounters nothing but a frigid snow wasteland in the dead of night with a heavy blizzard. The only light source is himself; the sky can’t be seen through the blizzard fog. Eventually, he encounters a collection of floating shards with an eyeball in the center, watching him. He notices that embedded in the iris is a soul, confirming to him that this is the realm’s god and not an auto-sentry. He tries talking to the god, but it doesn’t speak nor move. He gives a shard the lightest touch, and it slashes him as the god awakens
In Phase 1, the soul is messy: a distorted hexagon with spikes, tears, and other flaws around it. Its body is a creepy chaotic collection of floating shards in heavy snowfall, almost like a 3D snowflake. The sky becomes a bit brighter than it was during the boss intro
In phase 2, its soul becomes more (but not fully) symmetrical/cleans itself somewhat, its shards reshape to form a dress, and the eye reforms into/grows a wide-brimmed hat atop the dress. The sky brightens up to a morning fog feel and the snowfall becomes normal
Idea: the soul is a large pointed hexagon snowflake-like shape that follows behind Comet like Cotu’s soul when he moves
In phase 3, the soul becomes perfect and symmetrical. The hat shrinks and folds inward, taking the appearance of a radially symmetric arrowhead/bird covered in pointed eyes, and the dress shards shrink and fuse to create a lattice-like mesh. The sky becomes crystal clear, revealing stars and nebulas
In phase 3, ground is covered in ice, allowing Cotu to ice skate on it like Mario in Super Mario Galaxy 2
Cotu automatically moves in the direction the player last moved
Movement speed (including dodge speed) is increased
Idea: special dodge anim has Cotu soaring into the air, going higher than he usually does on a dodge
Boss punishes the player for running and rewards the player for fighting close-up. This contrasts with X and the Gauntlet, which reward the player for running away
Blizzard fills entire arena except for a circular clearing around Clarity
Boss punishes player for attacking constantly and rewards player for waiting for the perfect moment to strike
Clarity spends quite a lot of time just strafing, tempting the player to attack and stressing them out due to the accumulating frostbite
Idea: Clarity has a weak spot under her “hat” OR in her chest shard. It’s exposed at certain points on every attack (vulnerability timings vary with each attack). Easy to dodge attacks expose the weak spot for short periods of time, while difficult attacks expose it for longer. If you hit it with a damaging enough single hit, she gets stunned and takes heavy damage
The weak spot disappears in phase 3 bc the weak spot represents asymmetry/imperfection, and phase 3 represents perfect symmetry
Idea: Clarity parries/blocks attacks with an ice wing, not her arm shard
Idea: Player gets to choose whether to send the hub ship through Clarity’s realm during phase 3
When the player reaches phase 3, Clarity does a long transition animation while Cotu and the triplets have this conversation
Greg: “The sky’s clear. We can move through now!”
Pilot: “No, it’s too risky! What if we get shot down? Or the blizzard comes back?”
Greg: “It’ll only take a few minutes for us to cross the whole realm, and Cotu’s already distracting the god. He just needs to last long enough for us to escape, and he can wormhole back to the ship.”
Pilot: “But if we crash, we could be stuck here! It’s too dangerous!”
Player then gets to choose
If player chooses to fly through,
Clarity stops trying to hit Cotu for a moment to shoot down the ship instead. If she’s hit with a big enough move, she’ll be stunned
If player does nothing, she successfully shoots down the ship
Idea: at the end of the fight, a cutscene plays where Cotu unlocks flight, flies up to Clarity in the sky, disables her wings, and she falls to the ground, destabilizing
Story Idea:
Clarity can only achieve sapience once per month, and every time she does, she’s at the center of her realm. Since it takes a week’s journey at her speed to escape her realm, and she only keeps sapience for 3 days, she has never escaped her realm
When Cotu defeats her for the first time, she’s reduced to a tiny snowflake on the ground. As he tiredly begins to walk away, she calls out to him:
Clarity: “Wait! Please…take me with you.” This is the first dialogue we hear from her.
Music begins to calm down, but not fade out. Perhaps switch to a more calm track played at the same time as the real boss track? Cotu: “Why?”
Clarity: “...” Snow begins to fall.
Cotu: “It’s okay. I’m just curious, that’s all.”
Clarity: A short pause. “I can only achieve Clarity once per month, for three days at a time.” Fade into flashback. “And every time I do, I find myself at the center of my realm. But my realm is quite vast…every time I try to leave, my three day window ends, and I fall apart to mindless pieces once again. I have never once left my realm…but I wish to see the breadth of the universe. To know if its distant corners hide beauty like mine. I want to-”
Cotu scoops up the snowflake in his cupped palms along with some snow. He’s kneeling on the ground. He stands up.
Clarity: (quietly) “I want to meet people…and make friends.”
Cotu: (pulls out his pager) “Greg?”
Greg: “Cap’n?”
Cotu: “Set the microwave to freezer mode.”
Greg: “Roger.”
Camera cuts to snowflake’s face in Cotu’s palms, then cuts to snowflake inside the freezer-microwave. The freezer is facing a window; snowflake is staring into space
Greg: “Pretty nice view, huh?”
Clarity: “Seeing my realm from the outside for the first time, it’s…surreal. And somehow,” she says in a whispered breath: “terrifying.” Camera is pointed towards the realm, making it look small and distant.
Greg: “Woah.”
Clarity: “...”
Greg: “That just gave me chills.” Pause. “Hehe. Get it?”
Clarity: “What’s more terrifying, is that I don’t have the strength to permafreeze you for your impudence.”
Greg: “...You remind me of someone. I gotta introduce him to you someday.”
Cut to Cotu and Pilot.
Pilot: “It’s nice having another guest onboard.”
Cotu: “I’m glad you feel that way, ‘cause she’s here to stay.”
Pilot: “What will happen once her 3 days are up?”
Cotu: “She doesn’t know. She’ll probably just turn into pieces and wake up in her realm again.”
Pilot: A short pause. Pilot looks a bit sad for a moment. “Then we’d better show her as much of the universe as we can before then, right captain?”
Cotu: “Obviously.”
Pilot smiles.
Story Idea: Defeat
Cotu and Pilot are buried in snow on the ship
Cotu: “Somebody’s gonna notice we’re gone and come looking for us. Once they enter the void, this realm will find them, like it found us.”
Pilot: “...yeah.”
Cotu: “...We’re not going to be trapped here forever. But…we’re probably not going to make it to the gala.”
Pilot: “...You know, I remember looking at this void a while back, on a map. It was never this big, as far as I can remember.”
Cotu looks at Pilot
Pilot: “There were more stars. Dotted all along the edges. But now they’re gone.”
Cotu: “Maybe they fused with the nearby strands.”
Pilot: “No, the gravity’s not strong enough there to do that so quickly. I think it was this blizzard…the blizzard consumed them all. It ate the stars.”
A long silence.
Cotu: “I’m sorry Pilot. I failed you.”
Pilot doesn’t respond
Cotu: “Pilot?”
Cotu: “...”
Cotu: “The Gauntlet will find us. Mike will find us. Someone will…”
Cotu freezes
Cotu’s frostbite status naturally builds up over time. Some thing(s) in the fight (could be certain attacks, environment zones/hazards, etc.) increase Cotu’s frostbite status on contact → these were changed in implementation, mostly simplified; see “Changes from initial concept”
Frostbite has 3 stages:
Stage 0 (no frostbite): Cotu behaves normally, but after enough frostbite buildup is accumulated, he reaches stage 1
Stage 1 (Ominous): Stability regen and movement are slightly slowed, but stability cost of all abilities (dodging, attacking, etc.) decreases
Reaching Stage 1 is expected, almost inevitable in the fight unless you play nearly perfectly
Stability regen debuff is about half as potent as mite infestation
Stage 2 (Tense): Stability regen and movement are slightly slowed further, stability cost of abilities decreases slightly again, and damage taken from any attack is increased
Stage 2 is reached after the player makes a moderate amt of mistakes after Stage 1
Stability regen debuff is about as strong as mite infestation
Stage 3 (Fatal): Stability regen stops and damage taken is slightly increased
Stage 3 is reached when the player makes a bit more than some mistakes after Stage 2
Stabilizing or destabilizing removes all frostbite and resets Cotu to Stage 0
Cotu will not accumulate cold while destabilized
Idea: a charm will keep Cotu from building frostbite over time and reduce attack-based frostbite accumulation
Consider making a cover of Dmitri Shostakovich’s Waltz No. 2 with piano/chime instruments (perhaps for phase 1)
Consider making a cover of Carol of the Bells with piano/chime instruments (perhaps for phase 2)
Carol of the Bells’s melody is public domain; only the English lyrics are copyrighted
Phase 2: Ballroom Dancer
Almost radially symmetric (except for blade)
Has a hat and central torso shard aka gem. In its neutral state, 6 shards surround its central gem and point down like a dress
The central gem looks in its mvmt dir, not at the target (except for double slice retreat, where it looks in the opposite dir of its mvmt dir)
Snow constantly falls from the hat
A 7th shard is used as a sword to deflect the roserang
When Comet attempts to deflect the ax, she blocks it while the ax vibrates inside the shard. She struggles against the ax’s strength for a moment before spinning to the side and pulling her shard out and away from the ax. She turns this spin into a sweep attack where the broken shards of the shard and mist are sprayed out in a wide sweep at the target
If the ax detonates while inside the shard, the shard is heavily damaged or destroyed and Comet staggers backward instead of sweeping
Hitting dress shards with the ax or rose will crack them. After they’re cracked enough, they’ll shatter, forcing Comet to regenerate them
Attacks typically shoot out shards. If a shard hits the ground, one of 2 situations occurs:
Injection: shard injects energy into the ground, then returns to dress. Summons a weak enemy (e.g. a bird)
Ejection: shard injects energy into the ground and stays in the ground. Summons (or becomes) a strong enemy (e.g. a snowman) and dress shard must be regenerated
Some attacks require Comet to have a certain number of shards in its dress
Comet floats just above the ground and either flies fwd (fwd = dir to target) or at a random angle sideways. It switches between these mvmt types randomly and somewhat frequently (every 4-7 seconds)
Whenever Comet begins an attack, it locks its current mvmt vector and attacks while moving at that dir and speed, with the exception of the following attacks:
Jump Shot: it keeps its mvmt dir but dashes, then jumps
Square: it moves in a specific path (to a point above the target, then up, then directly down onto the target)
Comet’s icon is a ring bent to look like a V when viewed from the front. It floats beneath the gem and above the dress, making it look like a collar
Idea: ring is bent to look like an M; it’s essentially the same as the V but with 3 bends instead of 2
Alt idea: icon is a giant snowflake eye that floats behind Clarity and watches the target creepily. It also telegraphs certain attacks
Arena contains a large central ice pillar that rises into an ice tree canopy like a baobab tree
Parry Countercombo (needs ≥4 shards): used when Comet deflects the roserang (idea: only when Comet deflects the roserang when using a certain defensive stance). Comet dashes forward with the sword shard at her side and trailing behind her, then slashes up at the target with the sword while spinning in the slash direction. At the same time as the slash, she leaps backward high in the air and throws 3 shards down and at the target while continuing the spin slash airborne. In the air, her sword ends up by her side as the she descends back to the ground gracefully
Jump Shot (needs 6 shards): Comet dashes in its current mvmt dir, leaps into the air, and points its spears at the target while they revolve around the gem, forming a cannon. The arm shard shoots from the cannon, blasting the gem backward and the shards outward, forming a star shape. The shards and the gem pause and stay suspended in the air for a moment, then the shards fold back around the gem 1 by 1 to form the dress again (dress faces away from the target) as the gem transitions to its next move (either floating downward or another attack). The projectile creates a frost blast on impact
Wing Shot (needs ≥ 3 shards): Comet gathers 3 shards into a wing as the dress rotates, brings the wing backward around either its left or right side, and up (similar to how X brings his arm backward right before Right Arm Slice), then throws the shards from either its left or right side (e.g. if wing was brought backward around its right side, shards are shot from its right side). The shards all travel in the direction of the target; one of them stops short of the target, one of them directly hits the target’s position, and the last hits behind the target
Wing Uppercut (≥3): Comet gathers 3 shards into a wing as the dress rotates, brings the wing backward around either its left or right side, and down, then slashes forward (fwd = dir to target) and upward while rotating in the slashing direction similar to the spinning uppercut from Mergo’s Wet Nurse in Bloodborne. After the uppercut, the shards are pointed downward and stab the ground in front of the Comet. The shards then become snowmen
Spiral (6): 3-4 shards are shot out and fly in Archimedean spirals (r = bθ where r = orbital radius from gem, b = a constant, and theta = orbit angle). Each shard has a different b. The middlemost shard will hit the target if the target remains in the same place throughout the shards’ flight
If the boss uses 4 shards, the third closest/second farthest shard will hit the target
Slice Combo (6): while Comet slowly floats towards the target, a shard from the left performs a sweeping slice in front of Comet, then a shard from the right does the same, then left, then right, then the remaining 2 shards are simultaneously shot directly at the target
Saw Top (≥4): Comet turns into a spinning top where the dress shards are the rim and the bottom of the chest shard is the bottom tip. The dress spins faster and faster as Comet charges into the target, then after Comet travels for a while, her dress returns to normal
If Comet is hit with the ax when the dress is fully flattened, Comet is stunned for a bit
Cannon (6): Comet balances on one shard while the rest of the dress shards form a tube shape pointing away from the target. The gem is then fired at the target while a plume of snow is shot from the tube in the opposite direction. The shot causes the tube shards to spread out into a fan shape, which they hold for now. The gem somewhat homes in on the target like a magic projectile in Elden Ring, then after traveling for a bit, the gem slows to a stop. The shards, still spread out, then zip simultaneously to the gem and reform the dress, dealing damage along the way
Single Shot (≥1): shard is raised from dress beside the gem, then shot at the target at high speed
Single Slice (≥1):
Context: WalkForward/Left has 2 modes: Passive and Aggressive. The only difference between them is that aggressive has the arm shard raised more than passive. Single Slice will only occur in WalkForwardAggressive
Single Slice Half Windup: arm shard is raised/rotated from beside the dress up to halfway btwn its original orientation and an orientation where it’s at shoulder height and parallel to the ground
Single Slice Full Windup: arm shard is raised/rotated to shoulder height and is parallel to the ground. Done some time after Single Slice Half Windup
Single Slice Release: arm then slices in front of Comet in a sweep
Mixup: WalkForwardAggressive has a chance to do SingleSliceEntirety instead of half→delay→full→delay→release
Double Slice Retreat (≥2): two shards are raised from dress beside the gem, then slice in front of Comet in a sweep simultaneously. Just as the shards cross paths, Comet leaps backward far. While rising into the air, the shards rise beside the gem and point in the target’s direction. At the apex of the leap, the shards fire in a streak, one directly at the target and one behind it
Square (≥4): Comet flies to a point directly above the target, then shoots down 4 shards around it. These shards are turned into snowmen that chase the target and do melee attacks. Comet then disappears into the sky while snow begins to fall rapidly around the target. The snow intensifies over a period of about 5 seconds, then snowfall stops following the target. Comet then falls from the sky and explodes on impact with the ground with all of its shards replenished
Streak (≥4): 4 shards rise to a point above the gem 1 after another and shoot downward and in the direction of the target one after another. A shard won’t travel directly to the target necessarily; they’ll travel a set distance. The first will land right in front of Comet, while the 2nd, 3rd, and 4th shards will travel farther. These eventually turn into snowmen
Icicle Rain (≥2): Comet shoots 2-4 shards at the central pillar, causing icicles to rain from the ceiling. Small markers on the ground show where icicles will fall. The more shards Comet shoots, the more icicles fall and the more screenshake occurs when the pillar is struck
Grab (=5): shard points at and slowly approaches the target from a side angle, then thrusts forward. If the shard hits Cotu, the shard brings him towards Comet and Comet stops moving. The shard plants itself and Cotu into the ground directly underneath the gem, then the other 4 remaining shards repeatedly stab Cotu in quick succession multiple times as snow rains down on him. One of the stabbing shards then stabs Cotu and stays inside him, then pulls outward (away from Comet) before finally flicking out and upward, launching Cotu. When Cotu gets up, he has the snow slowdown debuff for a longer period of time than usual
Phase 3: Snow Angel
Idea: for certain attacks, an actual comet flies across the sky in the lateral direction from Comet to the target, dropping giant projectiles at high speed from far away
Idea: Comet does a little dance to summon the comet and show which attack is coming
Ice pillars: huge pillars that stay embedded in the ground for a long time
Giant shards: huge shards (perhaps 6) that drop one after another in a straight line towards the target. Larger shards drop closer to the target. Shards linger for a bit in the ground before shattering
Task notes:
Make early sketches


Her body kind of resembles an upside down hand; maybe lean into this concept a bit more
Lion’s mane jellyfish motif

Make Blender 3D sketches

Both pics have the same dress shard angles. Left: all dress shards point to head. Right: freestyle design according to what I liked
Freestyle looks better, so maybe instead of using code to animate the shards, you should just give them bones and animate them manually

6 legs conveys dress motif more clearly than 4 legs. Also put spike pattern on hat
Make rig
Dress shards cannot be children of central shard or head bc center/head should be able to move in a direction, then the dress shards lag behind (they only move after a mild delay, like they’re being pulled)
Head should be child of center bc head and center shouldn’t be offset/offtimed from each other
Arm should move with center
All dress shards are siblings of central shard, hat and arm are children of central shard
Make basic anims/poses to get a feel for movement/attacks. Don’t worry about polishing until you have the full moveset
Walk forward
WalkForwardPassive
WalkForwardAggressive
Walk left
WalkLeftPassive
WalkLeftAggressive
Turn left to forward
Run left
Make basic attacks
Single slice forward
SSFHalfWindup
SSFFullWindup
SSFRelease
SSFEntirety
Single slice left
SSLHalfWindup
SSLFullWindup
SSLRelease
SSLEntirety
Feedback from the future: the problem with these single slice stages is that progression between stages takes way too long. The stage transitions are slow in order to be subtle, and combined with the pauses between stages, Clarity will spend far too long doing nothing threatening. This would only work if a bunch of enemies were spawning
Make shard hexagonal instead of rhombic
Make more complicated melee attacks
Parry Countercombo
Deflects with the arm shard. Front dress shards rise for support
Dashes forward with the sword shard at her side and trailing behind her
Slashes up at the target with the sword while sword is spinning in the slash direction
Leaps backward high in the air while continuing the spin slash airborne
3 shards are raised from the dress and fired downward
In the anim, the dress shards are raised beside Clarity. In engine, when shards are fired, the rig’s dress shards will be made invisible and replaced by instantiated projectiles
In the air, her sword ends up by her side as the she descends back to the ground gracefully
Single Shot
Shard is raised from dress beside the gem, then shot forward (not at the target) at high speed
Arm shard points to the shot shard as it’s raised, then flicks it forward
Arm shard retrieves shot shard
Walk left variant done
Walk forward variant done
Jump Shot
Comet dashes in her current mvmt dir
Leaps into the air
Points her shards at the target while they revolve around the gem, forming a cannon
The arm shard shoots from the cannon, blasting the gem backward and the shards outward, forming a snowflake shape
The shards and the gem pause and stay suspended in the air for a moment, then the shards fold back around the gem 1 by 1 to form the dress again (dress faces away from the target) as the gem transitions to its next move (either floating downward or another attack)
Spiral
3-4 shards are shot out and fly in Archimedean spirals (r = bθ where r = orbital radius from gem, b = a constant, and theta = orbit angle). Each shard has a different b. The middlemost shard will hit the target if the target remains in the same place throughout the shards’ flight
If the boss uses 4 shards, the third closest/second farthest shard will hit the target
Animate shards with code
Idea:
arm shard stabs the ground,
scrapes it in a sweep to 
raise 3 dress shards,
then raises her arm and spins it forward (drawing a circle with the tip to her right) like the final swing of parry countercombo to 
deploy the shards (execute this in-engine)
Square
Comet flies to a point directly above the target, 
then shoots down 4 shards around it. These shards are turned into snowmen that chase the target and do melee attacks.
Comet then disappears into the sky while snow begins to fall rapidly around the target. The snow intensifies over a period of about 5 seconds, then snowfall stops following the target. 
Comet then falls from the sky and explodes on impact with the ground with all of her shards replenished
Streak OR Spread
4 shards rise to a point above the gem 1 after another 
and shoot downward and in the direction of the target one after another. A shard won’t travel directly to the target necessarily; they’ll travel a set distance. The first will land right in front of Comet, while the 2nd, 3rd, and 4th shards will travel farther. These eventually turn into snowmen
OR
4 shards rise to separate points above the gem simultaneously 
and shoot downward and outward like a shotgun spread. These eventually turn into snowmen
Regen shards
Comet retreats backwards, 
then drives her arm straight down into the ground while becoming a shrine-like monument like Stonehenge, where the dress shards are the stones. Dress shards materialize 1 by 1; the more shards are missing, the longer the regen takes
During the anim, her head weak point is vulnerable, but not directly from the front since the arm is blocking it. The arm also cannot be damaged since it’s also regenerating
This is the longest head weak point vulnerability period in her moveset by far
Try adding Comet to the engine and moving her in the world to get a sense of how the fight will go
Basic fwd mvmt
Basic left mvmt
Re-evaluate Comet’s moveset by comparing it to Sekiro because you had a gut feeling something was wrong
Comet punishes rose with parry countercombo: way too punishing since Comet flies far away afterward. Punishing the rose this hard makes it too obvious that the ax is the intended way to fight her, which takes away the player’s satisfaction of figuring this out on their own
Comet’s arm shatters when trying to deflect ax: way too rewarding since Comet’s arm is completely shattered, making her super vulnerable. This also makes it too obvious that the ax is the intended way to fight her, which robs the player of the experience of solving the puzzle
Comet should be beatable with the rose, but optimally defeated with the ax. The ax versus Comet here should be like the anti-illusion items (snap peas, lazulite ax, etc.) versus the Corrupted Monk in Sekiro
Sekiro comparison (Genichiro example)
Genichiro:
Player has initiative - Genichiro passively waits, allowing player to get first hit
Player has impact - Genichiro has to block/deflect your hit
Player always makes progress when attacking - Genichiro takes posture damage when he blocks
Constant uptime - player can constantly attack or defend attacks
Comet:
Player has initiative - Comet passively waits, allowing player to get first hit
Player has impact - Comet has to deflect your hit
Player always makes progress when attacking - Comet’s shards take damage when deflecting 
NO constant uptime - when Comet deflects, she does the parry countercombo where she flies high in the air and away, forcing the player to run to her or her to them
Solution(s) to Comet’s moveset:
Replace Parry Countercombo with Parry Counterslice, a quick melee counterattack with little to no movement
Turn Parry Countercombo into Retreat Combo
Remove parry
Rename anim
Create Parry Counterslice, a quick melee counterattack with little to no movement
Pretend to fight Clarity in the engine to see how the fight goes
Add Clarity’s strafe left attacks
Write queue, start, end, and choose attack funcs
Make anim tree anims and transitions
Save Clarity anims to file to add func callback tracks
Reconsider whether Clarity should parry
Clarity parrying isn’t an intuitive concept because she’s composed almost entirely of long, sharp shapes, implying that she’s built purely for attack
It also doesn’t make sense for her to parry a small projectile with a thrusting blade weapon; it would make more sense if it were a bludgeon-type weapon (like a baseball bat hitting a ball). The player wouldn’t know that she’s capable of parrying just by looking at her
Find a way to remove the immediate transition from single slice left ending (blade is on Clarity’s left) to walk left passive (blade is to her right)
Add a left blade walk left passive?
Add an attack that starts with the blade to her left?
Give her the option of either long endlag returning to base pose or a double slice?
Give her a 6-7 hit melee combo like a FromSoftware boss?
This seems too complex, maybe just keep it simple and do double slice mixups (slow vs fast)
Make her double slice every time, but mix up whether it’s immediate or delayed? ← I went with this option, at least for now
Create a mapping for Clarity’s telegraphs to her actions (at least for double slice). Assume that the soul acts more like Cotu’s soul, traveling behind her
Tilts head → an attack is coming
Soul rotates 60 deg quickly → her next action is quick
Soul rotates 60 deg slowly → her next action is slow
Combinations:
Tilts head + soul rotates quick → quick slice incoming
Tilts head + soul rotates slow → slow slice incoming
No tilt + soul rotates quick → quick blade reset
No tilt + soul rotates slow → slow blade reset
Replace/rework Parry Counterslice
Replace it with Flick Slice, where she drags her tip across the floor, then flicks up suddenly, then raises the blade again and slashes down diagonally back to starting position
Consider reworking slices entirely, at least with their style. Since her most iconic moves are long, complex, sine wave-like attacks like jump shot (she bends down to accelerate, then rises up smoothly, maybe she should have wave-like attacks with her slashes as well
Keep long, possibly multi-stage slice windups because they force the player to split their attention between her minions and her blade
Keep arm self-axis rotation from slice windups since they don’t mess up the blade’s path during the slice like you thought they did
Long Slice: she raises her arm high, then slices behind her, then in front of her like the first hit of X’s right arm slice
Clarity controls the fight. She doesn’t follow the player, the player follows her. She moves on her own set path and the player has to stick by her side or get caught in the storm
She stays in Walk mode continuously and moves her head to look at the target as it moves around her. No shards move when she’s just looking at the player
Her head looks directly at the player like X’s head
To tilt side to side/forward and back, an anim player in her head’s scene plays an anim to perform the rotation (as opposed to complicated rotation code and node setups)
It turns out that side tilts don’t show up well when Clarity’s looking down at the player, so just do forward/back tilts
The attacks she does correspond to where the player is around her (to her left, to her right, to her front, etc.)
Idea: to hit in any direction around her, she turns her arm to correspond to her head’s direction
Try making Clarity always face you while she’s moving, then make her lower half invisible. Then add a second Clarity meshes instance that only shows the dress shards and simply stays on the walk forward anim and points in the walk dir
You once considered not making Clarity’s arm face you as you move around her. Instead, it would have stayed in one place, and Clarity would have used different attack anims depending on where you are standing relative to her at the time the attack begins. The only problem with this is that if you move around her during the windup of a move, the windup cannot rotate with you, meaning you’re way out of the way as long as you successfully rotate around her
Currently, she just walks in straight lines in random directions. Allow her to walk clockwise, in which case she uses the walk left anims instead of the walk forward anims
You recently changed the chest and hat keyframes of the double slice anims to match walk forward. Make 2 more double slice anims to match walk left
Make walk clockwise code. You already have code that makes Clarity orbit around the target, now make code that treats Clarity’s current vel as a tangent vec of a circle, then makes her orbit around the circle center
Get perpendicular vec to her vel with length equal to walk_circle_radius, then set her orbit center to her global pos + that perp vec
Give Clarity the same Godot keyframes for DoubleSliceForward as DoubleSliceLeft
Add walk left anims/transitions to anim tree
Walk left passive
Walk left aggressive
Double slice delayed
Double slice immediate
Add body anim tree (in addition to arm anim tree) so that walk anim matches mvmt state
Add 3rd state: circling (around the player)
Clarity can move in a straight line, move in a circle around a set point, and move in a circle around the player. When circling around the player, Clarity’s body should use the walk left anim. Otherwise the body should use the walk forward anim
When in straight or curved state, Clarity’s body should face the direction she’s moving. When circling, the body should face the target
The transition between non circling and circling is abrupt and jarring, find a way to mask this in the future. Maybe when the angle between her and the target is just right?
Add close range dress shard attacks, which mostly stomp on the ground and create frost fields that increase frostbite
Make anims in Blender
Front stomp: front 4 shards
Left stomp: left 3 shards (Clarity’s left side)
Right stomp: right 3 shards (Clarity’s right side)
Back stomp: back 2 shards
Add minion enemies
Idea; Tiny Dancers, Cotu-sized playful warriors who spiral around Cotu before approaching him and doing melee attacks
Only move when the target moves for same reason as ice sprites
Giggle creepily
Decided not to use this design since it’s somewhat redundant with Clarity herself being an elegant dancer-like enemy. Ice sprites hint at a more playful, whimsical personality
Idea: Ice Sprites, small nuisance enemies that follow and surround the target and try to explode on it like the Ice Spirit from Clash Royale
These contrast with Clarity by being small and cute, unlike the Tiny Dancers
Only move when the target moves, making the player choose between staying still to keep the sprites away and moving to stay within Clarity’s safe zone
Make the initial scene + placeholder mesh
Make basic script where all it does is follow you until it reaches a desired dist, and it only moves when the target moves
In reality, it moves when Cotu’s walk input magnitude > 0. The target’s velocity isn’t set (its global pos is set directly) so you can’t get the target’s vel
Make ice sprites attack
Once in attack range, they continue following the target only when it moves, but after some amount of time, they explode
Make the sprites circle around and surround you, perhaps they try to get a minimum distance away from each other, Clarity, and the target before approaching the target?
On second thought, what exactly does this add to the gameplay? They can already be circumvented by the player not moving, so making them circle around before approaching only makes them feel like a non-threat for most of their lifetime, making them feel boring. It also makes them harder to predict and therefore more frustrating/luck-based, or at least they’ll feel that way to a new player
Idea: make ice sprites jump to move. If the player is pressing a walk input at any time an ice sprite is grounded, it’ll jump. It moves in the safe velocity calculated by nav agent 3D velocity computed so it avoids other enemies
Make script-level variable safe_vel
3D vel computed only sets safe_vel now
If the ice sprite is grounded, its vel is set to safe_vel + jump_speed
Idea: make the jump_speed somewhat low so it does a bunch of little hops like butterfly flutters
Add hitboxes later when you make the frostbite mechanic
Fix Clarity’s arm/shoulder looking off-center when looking beside/behind herself. Maybe she should only be able to turn her arm meshes toward the target while circling, since the rest of her body rotates towards the target too?
Maybe she should only stomp or do big mvmt attacks when moving straight? This makes sense for the fight bc when she moves straight, the player needs to chase her, which encourages the player to get close, putting them at higher risk of getting hit
To test this, implement stomp anims
Re-center the center shard so it’s aligned with the middle dress shards. The asymmetry formed by the center shard didn’t appear intentional since there aren’t other striking asymmetrical aspects of Clarity’s design
Reimport stomp anims with the new center shard
For left and right stomps, make stomp shards go straight down instead of sideways so there aren’t any gaps in the frost clouds where the player can stay close
Make stomps choosable in anim tree and add stomp to anim tree conditions and attack code
Make each stomp get chosen depending on where the target is relative to Clarity
Stop Clarity from only choosing the left stomp no matter where the target is
Turns out this bug was simply caused by me forgetting to put the “Stomp” condition in the anim tree transition
Stomps should stop Clarity from moving once the shards are embedded in the ground, then let her move again when the shards are pulled out
Update code to stop Clarity from moving if a new var “stationary” is true
Add func set_stationary to set stationary to true
Add anim keyframes in stomp anims that call set_stationary when shards are embedded in floor and when they’re pulled out. When Clarity pulls out the shards, the mvmt she was doing pre-embed should continue
For more testing, implement big move anim selection and mvmt
Implement Jump Shot
Make Blender anim that’s a copy of jump shot to walk left named JumpShotToWalkLeftNoActions. One anim tree will use the normal jump shot anim, which has functional keyframes like method calls, and the other will use the no actions version so that same actions aren’t done twice
Before jump shot, fake head (head that faces towards player) and arm meshes turn forward, then fake head goes invisible and body anim tree head becomes visible
Both body and arm anim tree do the same anim at the same time
Jump shot mvmt
Accelerate forward
Jump high
Start facing player decelerating to a stop mid-air
Gently float down
Make the direction her head/arm/body look (look_state) independent of her behav_state
The look dir during the curved state is set with information obtained within the curve frame func, so isn’t look state not independent of behav_state? Correct. Retool code to not use look dir; each look state code block should decide its own look dir
Check/clean up code so that turn speed is used consistently in look state funcs
Add transition from walk to run forward
Add landing anim (dress shards spread and recompress and chest goes down and up upon hitting the ground)
Clarity’s rotation during the ascent looks unnatural when viewed from her right since she rotates (in y axis) counterclockwise in the anim, then clockwise towards the target. Make another jump shot anim mirrored across her forward axis for when the player’s to her right
Make the anim selectable in anim tree depending on whether the player’s to her left or right
Make blade linger longer in the ground. Remember to move forward all Godot action keyframes that happen after the blade de-penetrates
Make jump shot end attack sooner so she starts circling while recovering from the landing. When she starts circling after the landing recovery it looks sudden and rigid
When Clarity decides to do a jump shot, she should do the dip and rise anim, THEN check whether the target is to her left or right, then do the appropriate rotation. Currently, she checks where the target is before the dip and rise, during which time the player can walk around to her other side
Create new anims JumpShotDipRise and JumpShotDipRiseNoActions in Blender and import them to Godot
Copy functional keyframes from the dip-rise sections of original jump shot anims to the new dip-rise anims
Remove dip-rise functional keyframes from original jump shot anims and move remaining functional keyframes back 75 frames
In Blender, remove dip-rise keyframes from jump shot anims and remove non dip-rise keyframes from dip-rise anims
In anim tree, make the JumpShot condition cause a transition to JumpShotDipRise (or noactions version in body anim tree) then JumpShotDipRise transitions to normal or CW
As it turns out, there’s a bit of delay between the dip rise anim and the rest of the jump shot when transitioning between the 2 anims in the anim tree. Just keep everything in 1 anim. If the player happens to cross Clarity’s forward vec in between her rush forward and jump, it is what it is. The animation when she rotates the opposite direction to where the player is looks good too
Undo all diprise-related changes above
Will also remove CW version of jump shot because the normal CCW version has much more arm movement, and the CCW version doesn’t even look bad when viewed from the right. The only angle where it looks bad is when the player is behind Clarity to her right, but that can be rectified by making Clarity do a different attack when the player is behind her to her right, like Square
Maybe she could do thrust attacks when moving straight? Then the shoulder orientation won’t stand out
The problem is thrust attacks are difficult to land given that she’s so much bigger than Cotu. Come back to this later and do the ideas you’re more certain about first
Maybe she could have an attack where she drags the tip of her blade across the ground to create a frost field hazard, summon enemies, or both?
Not a bad idea, but come back to this later and do the ideas you’re more certain about first
After testing, I’ve decided that when she’s not attacking or about to attack, Clarity shouldn’t move straight at all. She should not have a straight neutral state. And when she is moving straight, she should look forward in the direction she’s moving. There’s no way for her to look at the player with her head and/or arm while her body moves straight and have that look graceful/elegant. When she looks straight forward while moving straight, it looks like she’s not paying attention to the player and becomes unintimidating, which is fine in short periods before a straight mvmt attack (e.g. jump shot, dragging sweep) but not as a long-duration neutral state, which makes her seem unaware and removes the tension of the fight. She should feel like a predator or duelist eyeing her prey, not helpless prey or a mindless drone
When would Clarity ever use the projectile attacks if she’s rarely facing toward the player? After she uses Square or Jump Shot. She’ll land facing the player at just the right dist to use any projectile attack. These will be a staple combos of hers: Square/Jump Shot → projectile attack. Jump Shot leads into Walk Left attacks (so I don’t have to animate Jump Shot to Walk Forward) and Square leads into Walk Forward attacks
Check if you can put a hitbox/hurtbox on a bone attachment, which would save you a ton of time by removing the need to animate hitbox position/rotation keyframes
You can! But you had to make the hitbox much bigger and longer than her arm. This is fine since her arm moves so quickly in her attacks and is completely out of the way when she’s not attacking
Why didn’t I do this for X or the Gauntlet enemies? I SHOULD HAVE. I would have lost a bit of fine-tuned control in exchange for loads of time. I thought I spent a lot of time trying to get bone attachments to work for X, and I never followed through on it for some reason I don’t remember. I thought it was something to do with rotations being off, but when I tried attaching fake blade meshes (just capsules) to the hand bone attachments, they worked perfectly as blades! I tested RightArmSlice, SlipnSlice, StrafeSlice, and DualBladeDash and it worked well for all of them! The blade wasn’t rotated correctly for some parts, but they could be fixed just by adjusting X’s hand rotation in Blender. Yes, it wouldn’t work for attacks where the arm detaches from X like ChainSlice, but I could just make blade keyframes for those attacks specifically as special exceptions. Either I wanted too much control over tiny details that weren’t worth the time, or I just didn’t know about bone attachments
Implement Single Shot anim (do Walk Left version so you can test JumpShotToWalkLeft to SingleShot)
Add Single Shot anim to anim tree
Issue: when Clarity rotates around while the projectile shard is penetrated in the ground, the shard also moves, which looks kinda funny. Not that noticeable since Clarity moves so slowly and the ground doesn’t really have frames of reference to show how far the shard moved
Solution 1: stop Clarity from moving while shard is in the ground. Kinda lame since she has no gameplay nor story reason to stop moving (it’s just so the animation doesn’t look wonky)
Solution 2: make the shard stay in the ground and become an enemy. Clarity then won’t retract it though, which sucks because the anim looks cool
Single shot won’t accomplish nearly as much as spiral or spread, so is it even worth using? Possibly not. Implement spiral or spread first
Implement Spiral anim
Possible Issue: Spiral has such a long startup that by the time she fires the shards, the player will already be at her side. Test this by making Clarity choose Spiral immediately after Jump Shot finishes
This is true; even with Cotu’s walk speed halved, Clarity’s dash speed increased 33%, and her long-dist wait (the time btwn her landing and choosing Spiral) reduced to 0-0.1, Cotu gets to Clarity long before spiral fires the shards
The point of this task “When would Clarity ever use the projectile attacks…” is to see what a big mvmt → projectile attack would look/feel like. Now that you have jump shot to spiral, you don’t need to implement square nor spiral yet. Prioritize more core features like head stun and blizzard
Implement Square anim + mvmt (later)
After implementing head stun and blizzard, I confirmed the Possible Issue described above: Cotu gets to Clarity long before Spiral (or any projectile attack for that matter) has a chance to deal damage at a range
Solution 1: make Clarity dash much farther. This may seem unfun bc the player has to spend a long time running back to her, which is the biggest reason why players hated the Elden Beast boss fight in Elden Ring (before Torrent was permitted in the boss room). However, the Elden Beast running away was only tedious because it didn’t cause any real threat, it only dragged out the fight (yes it created the threat of that one projectile combo, but once the player memorizes it, the threat disappears). By closing in the blizzard, Clarity running actually creates an attack that forces the player to respond immediately.
With the way the jump shot is animated, Clarity dashing much farther would look unnatural, so keep the jump shot dash vel roughly the same. This does mean that after a jump shot, she can’t get far away enough to do a projectile attack, but that’s ok bc now there’s variety: when she dashes away, either she does a jump shot and ends up at melee distance, or she does a different move and ends up at ranged distance.
Next task: make a move where she ends up at ranged distance
Also consider taking the retreat from RegenShards and using that as a way for her to transition from a walk state to a projectile attack
The problem with this is that the retreat is a short burst instead of a long swoosh wave-like mvmt, and there’s no cool attack during the retreat, unlike js and square
Make Clarity staggered when she gets hit in the head while vulnerable
Make Clarity stagger anim
Make head hurtbox
In Clarity’s script, add an on_head_hit func that connects to head hurtbox’s hit_received signal
If damage is over stagger_damage_threshold, stagger occurs
Stagger func deactivates anim tree and plays stagger anim on anim player. This would be cleaner if anim tree root was a blend tree instead of state machine so you could overwrite the state machine output but that wouldn’t be worth the time
Stagger func sets behav_state to STAGGERED
Stagger func makes Clarity move backward a bit
Fix bug where Clarity has 1 glitched weird frame when anim trees are reactivated after stagger
You proved that the anim tree reactivation causes the glitch by reactivating them before and after the stagger anim completed, which always caused the glitch frame
Try using state_machine.travel(“Stagger”), which either takes the shortest path to an anim or teleports to it
var state_machine = animation_tree["parameters/playback"]
state_machine.travel("SomeState")
When Stagger occurs, try programmatically adding a Stagger node, adding a transition from the current node to that node, then taking the transition path, then deleting the node and going back to the previous node after Stagger anim ends - didn’t try this since state_machine.travel worked and made more sense
Try making a default anim that’s the same as WalkLeftAggressive  - didn’t try this since state_machine.travel worked and made more sense
When Clarity’s anim meshes head switches visibility with her dynamic head, there’s a noticeable instant change. To fix this, make reset head rotation func
Dynamic head’s rotation is set to a default rotation towards the player
Instead of this, the head’s rotation is now set manually via a func parameter. The plan for switching head visibility is for me to go to the keyframe where I want the transition to happen, make both heads visible, rotate the dynamic head so that it matches the anim meshes head, get the dynamic head’s current rotation, then put that into the set head rotation func
For some reason, when I reset the head’s rotation, then start calling the lerp function, the head instantly snaps into its final position instead of smoothly moving towards the final position
I still don’t know what caused the instant snapping because the final solution’s code is the same, but to fix the issue, I just had to make ClarityHead not top level
Create the blizzard that’s everywhere except for the area right around Clarity. Blizzard safe zone extends just barely past Clarity’s blade
Before making the frostbite mechanic, make the blizzard. For now, the blizzard simply deals damage over time
Make a gigantic damage-over-time hitbox that covers the entire arena
Make a Clarity arena script. In this script, check the distance btwn Cotu (not the target) and Clarity. If Cotu’s too far away (i.e. just out of Clarity blade range), activate the DOT hitbox. If he’s close, deactivate it
Add blizzard particles
Make snowflake mesh
Create particles node parented to Clarity
Ring emission shape; inner radius extends just beyond Clarity’s blade, outer radius is huge but doesn’t have to be the size of the arena
Draw pass has snowflake mesh
Make blizzard in background scene to add more layers to the snow
Make head’s glowing weak spot
Fix bug where head doesn’t look up during double slice → this happened bc head was parented to body meshes and not arm meshes, but body meshes doesn't play the attack animation, and the anim playback track on arm meshes couldn’t find the head
Fix bug where OmniLight doesn’t appear
Try deleting and re-adding omni light anim tracks. Since ClarityHead anims are also possibly problematic/glitchy since the anim player tracks didn’t originally point to it, try deleting ClarityHead tracks too
110-180, 300-360/276-336
Deleting the omni light tracks successfully restored the light
Try setting light energy in RESET track → the light still didn’t show up, but in the absence of other omni light energy keyframes, the RESET track does successfully set light energy
Try using tweens to set head brightness
Make head mesh
Make hat concave instead of a flat bottom
Make head hollow on the top like a bowl, then put a long horizontal slit btwn the head and the hat to form an opening, then put the head light in the bowl
This is better than the 2 eyes design from the sketches bc the 2 eyes design looks too human; this design is more inhuman. Human parallels should be vague and apparently unintentional
It’s not possible to tell there’s a slit (it just looks like a slightly lower-rimmed bowl), but even if it were possible (e.g. by making a top on the gem, it would look more like a tough mask (like on a Dark Souls boss) than a soft weak spot
Try making head a flat gem like the flatmite’s body, but more round
The current diamond head with the pointed bottom fits in with the rest of the design’s sharp edges, but the head needs to look significantly weaker/softer than the rest of the body so it looks like a weak spot and it needs to catch the player’s attention by looking different
The flat gem looks uninteresting af. Not ugly, but boring. At least the diamond looked interesting
Try making head just a light and nothing else
Try first with a sphere, then use a Sprite3D of a blurry circle
Try adding fog around the head that falls down from it → fog hardly showed up in tests so I’ll work on other things for now
Make head grow/shrink anims separate from head tilt so head can be tilted up and head can shrink between double slice slices
Make the frostbite mechanic
Add frostbite properties to Cotu
Add frostbite_buildup property to Cotu
Add current_frostbite_stage_threshold and current_frostbite_stage properties to Cotu
Add export var frostbite_stage_thresholds, a list of the thresholds needed to progress to each new frostbite stage
If each hit deals on average 10 frostbite buildup,
Stage 1 begins after just 1-2 hits
15 buildup, so 1 full hit and 1 minor mistake
Stage 2 begins after 3 more hits (30)
Stage 3 begins after 3 more hits (30)
Add frostbite_buildup to hitbox code
Give blizzard frostbite
Give Clarity’s arm hitbox frostbite
Make frostbite stage progression code in Cotu’s hurtbox
Move all current frostbite properties from Cotu to his hurtbox since frostbite increases on hit. All Cotu himself needs to worry about is which frostbite stage he’s on so he knows what debuff applies, and for that, the hurtbox can tell Cotu when the frostbite progresses
In on_hit, if hitbox.frostbite_buildup + frostbite_buildup > current_frostbite_threshold, current_frostbite_stage += 1 (if it’s less than len of frostbite_stage_thresholds), frostbite_buildup = 0, and current_frostbite_threshold is selected using current_frostbite_stage
Move all “receive” code in hurtbox.gd to one func: receive_hit(hitbox, hitter). This way, you won’t have to make and call a separate method for each property of the hitbox (heal, damage, debuff, frostbite buildup)
Change code so that when the threshold is met on stage 2, stage switches to 3 but the bar stays full instead of resetting to 0
Make a blue health bar connected to Cotu’s frostbite
Make a snow level script to control the frostbite bar, just like how the X boss level 1 script controls the X health bar
In hindsight, shouldn’t both of these scripts be in the view control scene and not the level scene? The UI is at the viewcontrol level, not the level level. This doesn’t matter enough for me to care about fixing it
Add health bar as a child of UIRoot in snow level view control
Make frostbite debuffs
Changes from initial concept
Frostbite doesn’t slow movement; the snow does. This way, the player doesn’t have to deal with mvmt speed that changes, which can be annoying and isn’t part of the challenge. The challenge is dodging and staying within Clarity’s attack range with lower mvmt speed
Stability cost of actions doesn’t decrease and damage taken doesn’t increase; these pretty much cancel out, so both effects were removed to make the situation easier to understand. Also, both of these effects combined would make the fight emphasize proper dodging instead of both proper dodging and proper stability management, and the latter is more compelling
Stage 1: Stability regen is slightly slowed (about half as potent as mite infestation)
Stage 2: Stability regen is slowed further (about as strong as mite infestation)
Stage 3: Stability regen stops
Add frostbite stages as debuffs
In stability regen code, check current frostbite stage to know how much to slow it by
Make big-movement attacks like jump shot clear the blizzard, then the blizzard slowly creeps back in over time
Make clear blizzard func (turned into expand and contract blizzard safezone funcs)
(Ideally) existing snow particles are blown away from Clarity via a particle attractor, then they stop falling around her
The arena script currently checks the player’s dist from Clarity to know whether to activate the DOT hitbox. To clear the blizzard, simply increase this dist when Clarity jumps, then decrease the dist over time
Make blizzard hitbox a child of Clarity to make it easier to control
Increase the range of the body light, then decrease it over time
Brighten the color and light of the sky, then decrease it over time
Brighten and clear the fog, then bring it back
Environment dims (sky darkens, fog light darkens) and fog greatly increases when Cotu stands outside the blizzard safezone
In physics process, set fog density using a clamp and Cotu’s dist from Clarity. Min fog is when Cotu’s in the safezone, med fog is when Cotu’s approaching the edge, max fog when Cotu is at least 3m outside the safezone
Change the above code so that instead of setting fog density to the target density cdirectly, you’re moving toward the target value every frame
Do the same 2 steps for environment sky color and fog light
Keep the fog values in the blizzard contract func the same since the blizzard has to close in first before the fog increases again
Remake Snow Level from the ground up to make fog in game match fog in editor. The fog in game currently doesn’t obscure faraway objects or terrain, just changes color
I got the fog to appear correctly using just a Level at the outermost layer, which directly contains WorldEnvironment, UIRoot, cotuCB, Clarity, Icon, and the arena floor. From here on out, levels that are filled with fog or don’t have massive background elements (mites, snow) should just be a Level and not a viewcontrol hierarchy. Viewcontrol hierarchy should only be used when necessary to show background features. Code in cotuCB, Clarity, Cotu’s weapons, hurtbox, and Level have been changed to account for either viewcontrol hierarchy or simple Level
Let the player aim the power throw and axrang
Holding down throw button long enough to initiate power throw mode zooms in the camera (try decreasing FOV → there are parameters that allow you to both decrease FOV and move the camera forward physically. Tweak to your liking after testing)
Power throw throws the roserang at the camera direction in the vertical axis instead of just the lateral plane
Zoom in makes a UI crosshair visible (and same with zoom out)
Repeat the above for the axrang
Make it so that the axrang is only thrown when the throw button is released instead of pressed
Claude’s code restructured the if statements of the ax throw code, which broke things. Try just recreating the power throw code → this worked
Make zoom in occur after same amt of time as rose min power throw charge time → it does, but it’s controlled by a different var just in case
Make ax throwable omnidirectionally instead of just laterally
When power throw/charged axrang throw is released, the camera zooms out on its own. Is this nauseating?
No, but it makes it hard to tell whether the attack landed bc the camera zooms out and Cotu’s body gets in the way. It’d be way nicer if the player could zoom on their own separately from charging a throw. Then, the roserang power throw and ax would only move omnidirectionally if the player’s zooming
Let the player zoom in/out by holding right-click
Zooming in/out won’t make the player busy, but charging a throw will
If the player’s zooming, then any ax throw (normal, perfect, or charged) will move omnidirectionally
If the player’s zooming, then roserang power throw will move omnidirectionally. If not, the power throw will move laterally
Fix bug where zooming breaks when you spam zoom button → fixed by making zoom state only toggle after the tweens complete, so a state can’t change while a tween is still in progress
When head is exposed but not brightened (e.g. between slashes in double slash), hitting it will deal damage but not stagger. When head is exposed and brightened, hitting it will stagger
Add keyframes to double slice anim that activate and deactivate hurtbox
Add keyframes to double slice anim that toggle staggerable state
Make it so that Clarity body meshes and arm meshes each have their own glb import. Them sharing the same glb import is causing buggy behavior with ClarityHead (their anim players are confused which ClarityHead to activate, changing ClarityHead keyframes removes the ice material)
Export Clarity Blender project as ClarityBodyMeshes.glb to create the second glb
Give each dress shard its own hurtbox. Each dress shard can break after taking enough damage, and if enough shards are broken, Clarity must regenerate them
The optimal range for the roserang to hit all the shards is also the optimal range for Clarity to hit you
Make dress shard hurtbox script (child of EnemyHurtbox) where die just makes the shard invisible
Ice sprites spawn naturally from the blizzard, not from shards. This way, the player can’t easily predict when an enemy will attack
To add to the surprise, ice sprites should also move regardless of whether Cotu’s moving, rather than only when Cotu moves
The blizzard already tells the player to stop moving, so if ice sprites also tell the player to stop moving, there’s no conflict between the desire to move vs not move; it’s an easy choice to just not move (except for when Clarity runs away occasionally). The ice sprites create an interesting conflict between moving and not moving → move away from ice sprites, but stay close to blizzard safezone
Ice sprites invading Cotu’s space also causes conflict between zooming in on Clarity’s head and looking around for sprites
Sprites do damage
In snow level:
Add ice sprite spawn rate
Instead of spawning every ____ seconds, which would make their spawning predictable, there’s a [spawn rate] chance of one spawning every second
Prevent player from walking right up to Clarity’s legs
Add falling snow/mist from Clarity’s head to her feet
Snow particles
Snow mist/fog (try using this: https://www.youtube.com/watch?v=e_6ZA-xa_DQ → I used method 3, LOD + shader)
Add DOT hitbox at Clarity’s feet
Clarity stomps while circling → this really isn’t necessary since the close rang DOT is so high
Instead of having 2 variations of DoubleSliceLeft, make RaiseRightSlice and RaiseLeftSlice(+variations). In code, when Clarity chooses the DoubleSlice attack, she performs RaiseRightSlice (the first slice of the current DoubleSliceLeft), which is the same every time. Then she does WaitLoweredLeft for a random len of time, then a random RaiseLeftSlice sequence
Left/Right refer to sides of her body, not the direction the arm travels in
The player should feel like the arm raise telegraphs the slice, only to realize the head is the real telegraph. The goal is for the player to feel rewarded for fighting the subconscious urge to dodge when she raises her arm
+ means the actions occur sequentially in the same anim
→ means the actions are in separate anims
Left of | is the sequence of actions, Right of | is the anim name(s)
RaiseLeftFast+FastGlow+SliceLeft | RaiseLeftSliceFast
Baits player into thinking raise means slice
RaiseLeftFast → WaitRaisedLeft → MediumGlow+SliceLeft | RaiseLeftFast → WaitRaisedLeft → LeftSliceFromWait
Punishes player for thinking raise means slice
RaiseLeftSlow+SlowGlow+Slice | RaiseLeftSliceSlow
RaiseLeftSlow → WaitRaisedLeft → MediumGlow+Slice | RaiseLeftSlow → WaitRaisedLeft → LeftSliceFromWait
Make anims
RaiseRightSlice (same as first slice of DoubleSliceLeft___)
WaitLoweredLeft (pose after first slice of DoubleSliceLeft___)
RaiseLeftSliceFast
RaiseLeftFast (same as raise in DoubleSliceLeftImmediate)
WaitRaisedLeft (pose after raising arm in DoubleSliceLeft___)
LeftSliceFromWait (same as second slice of DoubleSliceLeftImmediate minus the raise)
RaiseLeftSlow (RaiseLeftFast, but lengthened to be the same as raise in RaiseRightSlice)
Remove old SingleSlice anims to reduce clutter. DON’T remove DoubleSliceLeft anims so you can copy functional keyframes from them in Godot
Import to Godot and add functional keyframes to anims
Importing the new glb forces you to put in the new clarity_meshes inherited scene to replace the old ClarityArmMeshes, which means you have to remove and re-add the body light, ClarityHead, and head hurtbox, which are children of the head bone. Changing them messes up their transforms, so here they are
BodyLight: 
ClarityHead, EnemyHurtbox, and EnemyHurtbox’s collision: 
Reimport glb after saving all new anims to anim files
I just realized that the Wait anims are just static poses, so they don’t need to be saved to anim files, but oh well it’s too late now
Add functional keyframes
RaiseRightSlice (first 216 frames of DoubleSliceLeftImmediate)
WaitLoweredLeft
RaiseLeftSliceFast (same as frames 270-365 of DoubleSliceLeftImmediate, which includes 20 frames before and 35 frames after the slice)
RaiseLeftFast
WaitRaisedLeft
LeftSliceFromWait (same as frames 270-365 of DoubleSliceLeftImmediate, but w/o the arm raise and with medium head glow instead of fast glow)
RaiseLeftSlow
Make anim tree sequences
Remove SingleSlice and DoubleSliceForward anims to clear the areas
On DoubleSlice chosen, RaiseRightSlice → WaitLoweredLeft → (wait for random len of time) one of these 3 options
RaiseLeftSliceFast
RaiseLeftFast → WaitRaisedLeft (wait) → LeftSliceFromWait
RaiseLeftSlow → WaitRaisedLeft (wait) → LeftSliceFromWait
Since the length of the wait anims are variable, don’t use state machine transitions to transition out of them; use the anim tree playback travel method to teleport from the wait nodes to their next nodes
Make wait_lowered_left(), which waits, then teleports to one of the 3 raise left sequences
Make wait_raised_left(), which waits, then teleports to left slice from wait
Make WaitLoweredLeft and WaitRaisedLeft call their respective funcs
Make head tilt down on right slice and tilt up on left raise so it’s not just tilted up the entirety of the time she’s waiting on the left side
Implement Square (edit: changed to Backflip) anim + mvmt
This anim can be used when the player happens to be standing behind and to the right of Clarity, which is where jump shot looks bad
Issue: Clarity’s supposed to be intimidating, and with the current concept for Square, she flies high into the sky and stays unseen for a long time before landing, making her less oppressive (because she’s not there) and making the gameplay more tedious
Solution 1: instead of flying high into the sky, she crouches down, then elegantly backflips into the air (potentially spinning into the jump) while flying backwards and slides back onto the ground instead of slamming. This also makes her more unique than X, who does a similar straight up → straight down slam (Triangle while headless → Volcano Dive)
Inspired by Kuroki’s huge backflip when transitioning to phase 2 in Sifu
How does she attack now? Idea: she shoots somewhere between 2-4 shards in a spreadshot
Idea: try making her stop, then dive when she shoots the shards instead of finishing the backflip
Make Backflip anim
Code mvmt
Add backflip to anim tree
Add snow cloud to hide Clarity when she hits the ground
After testing, I don’t like how big the mvmt is for Backflip. It doesn’t feel like Clarity. She’s supposed to have slower mvmts broken up by sudden small outbursts, and when she does do big mvmts, she should slowly accelerate into them, not go from stationary to full speed instantly like in the Backflip. This sudden acceleration implies that she has speed/mvmt capability that she should not have, and it makes her feel more like X than herself
After some more testing, I actually kinda like how the Backflip looks. Give it a while before coming back to the Backflip before making a final decision
Implement LongSlice
Implement FlickSlice
Re-add arm hitbox and tiny particles since they got accidentally deleted with the DoubleSlice rework
Add trail effect to arm shard
Allow the player to destroy ice sprites
Give ice sprites hurtboxes (and health in globals)
Make them explode on death
Separate charge up from explode anim
When ice sprite gets close, do chargeup anim. When chargeup anim ends, do explode anim
If at any point ice sprite dies, immediately explode
Remove the NavAgent, which makes their mvmt needlessly unpredictable. Simply decrease their jump vel when close to the target
Implement RegenShards
Reimport Clarity.glb to save RegenShards to an anim file
Add anim to anim tree
Add RegenShards as an attack choice in code
Make RegenShards mvmt
Add functional keyframes to RegenShards
Mvmt and attack status
Head tilt/glow
Hurtbox is vulnerable
Rethink how Clarity’s combat should play out
After testing, I realized that the core gameplay loop involved repeatedly switching my attention between Clarity and the ice sprites, which felt similar to switching between the doors and the camera in Five Nights at Freddy’s. This also made me realize that the arm rising was the most important telegraph for an upcoming attack. The head was not as useful bc it glowed too soon before the attack. As a result, FlickSlice and LongSlice (as they are now) are conceptually counterintuitive to the core gameplay loop. If the player happens to be focused on the sprites, the quick/sneaky attacks will likely catch the player off guard, which feels unfair due to the lack of telegraphing.
To put the issue above another way, look at the core gameplay loop below. FlickSlice sneakily moves the arm in its startup and LongSlice raises the arm quickly. Both of these attacks don’t give the player enough time to prepare to dodge or prepare to hit the head bc they’re still in ice sprite/dress mode
Here’s the core gameplay loop I think I should emphasize, which should feel fair and challenging:
Clarity is passive → player hits the ice sprites and Clarity’s dress shards while periodically checking the arm
Clarity raises the arm slowly → player notices the arm rising and either prepares to dodge or prepares to hit the head
Player dodges the attack or staggers Clarity
Player switches back to looking at ice sprites and hitting the dress shards (while periodically checking the arm)
2 potential problems with the above loop:
Boring: attacking the enemies and the legs is really simple and easy
Unfair. When Clarity attacks, she demands your full attention, and if there just happens to be an enemy nearby, you’re screwed
After testing, come back to the problems above and see if they’re still present
Potential solutions:
When Clarity gets staggered, a shockwave rings out that instantly kills all nearby ice sprites
Periodically, body shards do their own attacks that challenge the player’s positioning instead of just timing (e.g. projectiles parallel to ground, stabs into the ground to create frost fields)
Give LongSlice long startup time
Problem: to distinguish itself from double slice, long slice rises higher than it, which ends up getting unnaturally close to Clarity’s hat. Consider not using it at all and substituting it for body shard attacks
Conceptualize body shard attacks that challenge the player’s positioning (including existing concepts)
Idea: make the shards write like pens since they look like pens
Most shard attacks are smaller versions of the most basic fundamental body shard attacks from phase 1
Wing Shot (needs ≥ 2-3 shards): Comet gathers 2-3 shards into a wing as the dress rotates, brings the wing backward around either its left or right side, and up (similar to how X brings his arm backward right before Right Arm Slice), then throws the shards from either its left or right side (e.g. if wing was brought backward around its right side, shards are shot from its right side). The shards all travel in the direction of the target; one of them stops short of the target, one of them directly hits the target’s position, and the last hits behind the target
Wing Uppercut (≥3): Comet gathers 3 shards into a wing as the dress rotates, brings the wing backward around either its left or right side, and down, then slashes forward (fwd = dir to target) and upward while rotating in the slashing direction similar to the spinning uppercut from Mergo’s Wet Nurse in Bloodborne. After the uppercut, the shards are pointed downward and stab the ground in front of the Comet. The shards then become snowmen
Slice Combo (6): while Comet slowly floats towards the target, a shard from the left performs a sweeping slice in front of Comet, then a shard from the right does the same, then left, then right, then the remaining 2 shards are simultaneously shot directly at the target
Shards Cross: 2 shards orient themselves toward a point in front of Clarity (i.e. on the vec from Clarity to the target), then move toward that point, crossing through each other and forming an X
Dodge by walking in a cardinal direction
Issue: this is similar to X’s lasers
Shards Frost Field: 2 shards orient themselves toward a point in front of Clarity, then stab down into the ground. A chargeup anim plays, then a frost field spawns at the point
Dodge by running away from the explosion
Shards Rainbow Unified: 2 shards travel in a circular path in front of Clarity
Dodge by staying the right distance from Clarity
Shards Rainbow Opposite: same as rainbow unified but the shards start from opposite ends and move in opposite directions
Dodge by staying the right distance from Clarity
Shards Front Thrust: 2 shards thrust forward laterally, then turn upright as they are recalled to the dress
Dodge by staying in the center or moving far left/right
Tricky Single Shot: 1 shard is placed in an awkward/unexpected position relative to Clarity and shoots
Shard Sequence: Clarity does a long preset pattern of shard attacks, wherein she continuously and sequentially loads up, shoots, and retracts shards
Load new shard, shoot previous shard, and retract previous previous shard all occur within the same action interval
Intervals are synced to boss music
The patterns should be reminiscent of the patterns from Phase 1, except here, the shards should probably only travel in straight lines (e.g. no spiral shot) so they’re more understandable/predictable
One Shard Sequence: each shard attack uses 1 shard
Two Shard Sequence: each shard attack uses 2 shards
Mentally test Shard Sequence gameplay
I think it’s a great addition because it forces the player to reposition instead of allowing them to stay in the same place the whole time, which completely wastes the player’s ability and desire to move.
Implement body shard attacks
Make new Blender project that only animates Clarity’s dress shards
KEEP the body, hat, and arm so that you know whether or not the dress shards would overlap them in the anims
Import the ClarityDressShards glb and make an inherited scene
Here’s the plan for Clarity’s scene:
Each dress shard is represented by a ClarityDressShards inherited scene, but with all other shards turned invisible
When Clarity does a shard sequence, all 6 ClarityDressShards scenes run the same anim at the same time
Should you make 6 anim trees, or just run shard sequences via code? I’d rather do the code
Get a reference to all anim players in code
Try getting all anim players to play the same anim simultaneously
Dress shards should normally rotate just as the body does
When a shard is loaded (moved into firing position), that ClarityDressShards scene stops moving and rotating with Clarity. When a shard is fired, the same stopped behavior continues. When a shard is retracted, ClarityDressShards slowly moves and rotates to match Clarity’s position
Each dress shard needs to track its node, anim player, mvmt status (stationary or not), and turn speed
Make a class representing a dress shard. The class has a node, anim player, and turn speed property, which is a lerp speed like body_turn_speed. This turn speed property is tweened from 0 (when the shard is/was stationary) to body_turn_speed when the shard is recalled. Mvmt status doesn’t need to be tracked in the class; just use node.top_level. Add helper funcs that are called when the dress shard is stopped/recalled
Dress shards rotate func should use the dress shard’s turn speed
Make 6 instances of the dress shard class. Reference them in a dress shards dict
Make script-level funcs that stop and recall individual shards
Make a script-level func that plays an anim on all dress shards at once
Test calling the funcs
How will the shards know when to start and stop following Clarity? We need callback keyframes in the dress shard anims. Which ClarityDressShards will have those callback keyframes? None of them. Export another glb from the same ClarityDressShards Blender project: ClarityDressShardsMaster. This will contain all functional keyframes and run alongside the other dress shards scenes, but not be visually shown
Just as a reminder to future me, another glb is required bc master will contain different anim data from normal dress shards (dress shards will have none, master will have functional keyframes)
Make single shard sequence 1
Plan anim
For all anims, shard takes:
18 frames to load/recover
18 frame delay pre-shoot
12 frames to shoot 48 meters
27 frames of endlag post-shot
36 frames of recovery/per stage
Fan out: imagine a line perpendicular to the vec from Clarity to target, and the line is slightly in front of Clarity. The front right shard moves horizontally along the line, then shoots at a mild angle to the line (maybe 30 deg), the middle right shard moves slightly less far horizontally, then shoots at a medium angle to the line (either 45 or 60), then the back shard moves less far horz than the middle and shoots at a higher angle (maybe 75). The left shards then repeat this process mirrored starting from the back to front
Make right half of anim - for now, call it SingleShardSequence1 since it could change in the future
Import anim
Make functional keyframes (shard stopping and recalling)
Repeat above for left half of anim
Scale up single shard seq 1 to 6 seconds
For all anims, shard takes:
23 (rounded up from 22.5) frames to load/recover
23 (rounded up from 22.5) frame delay pre-shoot
15 frames to shoot 48 meters
30 frames of endlag post-shot
45 frames of recovery/per stage
Increase the angle differences btwn shards in single shard seq since they overlap too much
Make double shard seq 1
Plan anim
Shards have slightly longer load/fire/recover timings than single shard seq so the player can learn the patterns
LR sweep: back right + front left load/fire/recover together. Halfway through their recovery, middle right + middle left load. Halfway through MR and ML’s recovery, front right + back left load together
How is shard collision avoided? Issue: when shard paths intersect, there’s a very high likelihood of the shards hitting each other during recovery (collision on the shot can be avoided by vertical offset). Try changing the sweep so no shards intersect. This also makes Clarity more unique than X
LR sweep 2: back right + front right, then back left + front left → the loading here looks ugly
I realize now that if any 2 shards from single shard seq 1 are loaded simultaneously, they’re either going to be ugly in loading or intersect or both. Make the double shard seq use its own angles
Dual straight: 2 middle shards point straight forward and thrust, forcing the player to stay in the middle. Then just as their recovery begins, 2 front shards point straight fwd and thrust, forcing the player to evacuate the middle
Make anim
Duplicate single shard seq 1, reorient the shards and remove irrelevant keyframes, then scale the anim so that each shard takes 30 frames to load/recover instead of 23 → scale by 1.33
Import anim
Make functional keyframes
When shards are recalled, there is a clear jolt in the shard when the recall begins (the shard doesn’t smoothly initially transition from its shot position back to Clarity). To fix this, try lerping each DressShards’s rotation to 0 in recall instead of lerping turn speed
I think the reason why the jolt occurs is that each DS is constantly being rotated by its turn speed every frame unless it’s stopped, in which case turn speed is 0. When the turn speed suddenly becomes nonzero, the DS instantly lerps some distance towards the body instead of smoothly transitioning from 0
Restructure the scene & code so that only DressShardsMaster rotates with the body, and all other DS’s are children of DSMaster. When a DS is stopped and then recalled, its pos and rot are offset from DSMaster, so by lerping rot to 0, the DS should smoothly transition back to Clarity
Why is DSMaster not a child of body meshes? It could be for now, but to make the scene look cleaner and in case I want behavior individual to DSMaster and not body meshes, I’ll keep them separate
Remove turn speed from DS class
Change DS recall func to lerp rot to 0
There’s still a small jolt, but it’s an improvement from the previous implementation. It’s smoother and the code is simpler
As it turns out, when a DressShard’s top_level state is set to false, its rotation and position instantly become 0. Fix this
At the start of recall, save the shard’s current global position and rotation. Then, set top_level to false. Then, put the shard back into the saved global position and rotation. Then, lerp the position and rotation to 0 → This didn’t work
As it turns out, setting the top_level state doesn’t reset the DressShard’s position and rotation to 0! It does exactly what you thought it does; it keeps the shard’s offset position/rotation, but makes the shard top level. The reason why the shard was instantly reset was bc the tweens instantly ended instead of properly taking up 45 frames. Why did this happen? Bc the frames func used get_physics_process_delta_time, which was undefined in the DressShard class’s scope. Fix this by making self.node call get_physics_process_delta_time
Move hurtboxes to dress shards
Add hitboxes to dress shards
Change Long Slice so the blade doesn’t reach all the way up to Clarity’s head level
But then how will it be differentiated from DoubleSlice? Make Clarity raise her head a short delay after LongSlice arm is fully raised (turns out only the animation edit was needed; functional keyframes like head raise and grow are identical)
Change all anims and anim tree so that the WalkLeftPassive/Aggressive states are replaced with just WalkLeftAggressive
In Blender, make all slash anims end with WalkLeftAggressive and reimport
In anim tree, make all slash anims transition to WalkLeftAggressive instead of WalkLeftPassive (skipped bc anim tree won’t be used anymore)
Remove WalkLeftPassive anim from Blender
Allow Clarity to choose dress shard attacks (edit: also restructure nodes and code so that ClarityArmMeshes and ClarityDressShardsMaster choose their attacks by playing anims directly from their respective anim players instead of using anim trees)
Should you use an anim tree? No. If you make an anim tree, it would use DressShardsMaster’s anim player. On the 0th frame of every anim, DressShardsMaster would have to call a func to play the same anim on all DressShards, meaning all DressShards would play their anims at least 1 frame behind DressShardsMaster, OR I’d have to move all functional keyframes at least 1 frame backward, which is not only time-consuming, but also doesn’t work if any functional keyframes fall on the 0th frame bc then they’d be run on the -1st frame
Instead of an anim tree, call dress shard anim funcs in code using a system like long dist wait time. Also, can’t you just use DressShardsMaster as the new ClarityBodyShards? Yes, but how will attacks where Clarity’s entire body is used (e.g. JumpShot) work now? It’d be better to have both ClarityArmMeshes and ClarityDressMeshes be controlled via code so they’re in the same place. Now the plan is for both ClarityArmMeshes and ClarityDressMeshes to choose anims to play directly in code
In code, replace all instances of ClarityBodyShards with ClarityDressShardsMaster (I just changed the get node to DressShardsMaster instead of changing the name)
Update/delete anim keyframes with ClarityBodyShards
Delete references to body anim tree in code
Delete ClarityBodyShards anim tree
Delete references to arm anim tree in code
Problem: arm anim tree controls DoubleSlice logic. Should you keep the arm anim tree after all? No because the arm anim tree actually DOESN’T control DoubleSlice logic (at least not fully). Remember that transitions between double slice anims actually occur largely via code bc the amts of time Clarity waits in the lowered left and raised left positions are randomly set. All the anim tree does is transition from the slice anims to the wait anims, which isn’t necessary bc you can simply have Clarity perform the slice anim (or raise left anim), call the corresponding wait func, then not perform any further anim, and the functionality will be the same if not simpler.
Add wait funcs to the end of RaiseRightSlice and RaiseLeft funcs
Finally delete references to arm anim tree in code
Delete ClarityArmMeshes anim tree
Change code so that an anim is played in choose/queue_attack instead of setting a parameter in anim tree
Make long dist wait time system for ClarityDressShardsMaster
Cehange the current attack funcs/vars into arm attack funcs/vars
Create new snowflake versions of attack funcs/vars (dress shard attacks are controlled by the snowflake entity)
Create new snowflake attack lists and have Clarity choose from them in her queue_snowflake_attack func
Create a separate snowflake+eye entity that houses Clarity’s soul, floats over Clarity’s shoulder, stares at the player creepily, and telegraphs dress shard attacks
Design is inspired by a snowflake w/ spiky branches and a hexagonal center. Don’t use a snowflake with clear hexagonal branches bc those don’t match Clarity’s spikiness


Also inspired by a monstrance:

Sketch snowflake and snowflake+Clarity sketches

Make meshes
Note: make shards disconnected from each other in edit mode so you can later separate them by connection (linked parts) into separate objects
On the xz plane, make the right half of a sector of the snowflake that will be repeated radially. Only work in a flat plane for now
Mirror the half over the y axis and z axis w the array modifier w clipping
Use the array modifier to repeat the sectors in a circle
Add hexagonal donut plates to the center front/back to add depth
Early 3D meshes:


These are mostly traces of the snowflake reference
I’m trying to make the snowflake look like it has eyes. 1 and 3’s eyes are too small to be impactful from a bit of a distance. 2 has the biggest eyes, making them the most disturbing and noticeable. Improve upon this

I prefer the slotted eyes more since they look more layered
Make the branches thicker



On second thought, I like a simpler design better: one central eye surrounded by plate armor and 12 spikes

Repeat the above steps for the new design

Make the 3D details
Protective shell around eye
Spikes

Add colors

The snowflake entity lowkey looks better 2D than 3D; consider the possibility of just using it 2D. Look at the 3D version in the engine before rigging
Import to Godot (don’t forget to check Apply Modifiers in import settings)
Give the 3D one a lighter ice material than Clarity
Make a 2D version and import it
Give the 2D one a glowing white or light blue material
Make an empty Node3D as a child of ClarityArmMeshesand add both the 3D and 2D versions as the Node3D’s children
Compare the 2 versions and see which one’s better
The 3D version’s better bc it makes sense for it to darken when the player gets too far from Clarity (bc it’s a solid object that interacts with light). The 2D version is supposed to be ethereal, not solid and tangible. However, it unfortunately also darkens when far from Clarity due to the fog even when glowing and unshaded
Make snowflake entity look at the target faster than ClarityArmMeshes
Try fusing the smaller shards to the inner eye and the larger shards to the outer face plate

Rig snowflake (everything except eyelids)
Apply modifiers
Separate each big spike and the central eye (7 components total)
Make rig
Put bones inside all shards
Parent bones to objects by nearest
Rig snowflake eyelids
What expressions should the eye make?
Samples (sample #s increase left to right, then down):

1 and 2 seem viable, maybe 5 can be a transition state
Samples redo where pupil doesn’t change shape as much:

The angry eyes don’t fit the mysterious, inhuman look I’m trying to achieve with phase 2. Here’s my intended progression of expressiveness and relatability in Clarity phases: phase 1 is unrelatable (no face, no eyes, no humanoid body), phase 2 is almost humanoid (vaguely human-shaped figure, one eye that can do simple expressions), phase 3 is humanoid (clearly humanoid body, expressive face). Keep eye expressions simple; simply open and close it
Samples redo with only simple eyelid opening and closing

I decided that eyelids should simply open and close. Central eye can rotate
Idea: make 3 different versions of the central eye where each version has more opened eyelids. Simply switch each version of the central eye visible and invisible to open it
Every several seconds (in a system like long dist wait time), snowflake does a telegraph anim, then the corresponding dress shard attack plays (if there is one)
Outer shards and face plate constantly slowly rotate. Once they turn ⅙ of a full 360 rotation, a telegraph anim plays
Make rotation anim
Make telegraph anims
SingleShardSequence1: back right counterclockwise to back left
DoubleShardSequence1: middle left + middle right, front left + front right
Make snowflake flash brightly at the end of an attack telegraph anim
Make anim tree
Neutral → Rotate → Single1 OR Double1
Snowflake vulnerability mechanics
Snowflake brightens and eye widens as slow rotate anim progresses
Hit snowflake during attack telegraph anim to damage dress shards and deal a small, fixed amt of damage to Clarity’s health regardless of the actual attack’s damage
Snowflake hurtbox
This doesn’t have to be an actual hurtbox script since the snowflake itself doesn’t have its own health or debuffs. It just has to be an Area3D that sends signals to Clarity and her shards when it gets hit
Every dress shard that popped out of snowflake so far in the anim is damaged by the attack; the longer the player waits before hitting the snowflake, the more dress shards are damaged
Add snowflake_linked bool to DressShard class
Clarity func that sets individual shard snowflake_linked to true
DressShard func that damages its shard
Self-damage hitbox in each dress shard initially set inactive
DressShard code to activate self-damage hitbox and quickly deactivate it
Simplify above system by adding a func to enemy_hurtbox script: receive_hit_no_hitbox, which only deals damage and doesn’t heal, apply debuffs, etc.
DressShard code now calls the func
Remove self damage hitboxes in each dress shard
Clarity func that damages all shards whose snowflake_linked is true
Func that sets unlinks all shards
Anims call appropriate funcs
Shards are linked at the frame when their corresponding snowflake shards start moving
Snowflake hit also slightly damages Clarity
Use receive_hit_no_hitbox func in enemy_hurtbox script
Snowflake stagger
Stagger anim in Blender
Stagger func
Change damage_all_dress_shards func to on_snowflake_hit func, which will contain functionality for damaging all dress shards, damaging Clarity, staggering, and unlinking all dress shards
Snowflake stagger func
Switch snowflake anim tree to Stagger
Dim snowflake
Add stagger state to anim tree
Make stagger anim close snowflake’s eye
Ensure that only player hits > Clarity stagger threshold cause snowflake to stagger
Current task
Idea: snowflake shoots projectiles far into the distance that become ice sprites
Idea: snowflake shoots projectiles OR a continuous plume of snow (like Clarity’s body snow clouds) directly at the target
Give dress shards med-to-high defense to communicate that it’s not optimal to hit the dress shards the whole time
Hit particle effects
Clarity head stagger
Snowflake entity stagger
Dress shard normal hit
Dress shard snowflake link hit (more particles)
Dress shards glowing to show that they’re now linked to the snowflake entity
Dress shards stop glowing when snowflake entity locks in the attack and unlinks all shards
(Skip if you think it’s not relevant for now) Implement Phase 1
Body is a 3D snowflake with many branches
Concept art from ChatGPT (note that this looks more flat than what the snowflake should be)

It’s just a weak spot (the soul + the body’s weak spot in the same position), and the 6 dress shards. The weak spot stays in one position or slowly moves in a set path while 1 or more shards do a repeating pattern of mvmt (e.g. thrusting back and forth across a straight line). The player must cross the shards (or at least one of them) to get to the weak spot
All of the components stay inside the blizzard safezone, which is much bigger than the ballroom dancer’s safezone but doesn’t move with her
Shard patterns:
2 shards thrust back and forth parallel to each other
Same as above but the thrust path rotates about its center
Alternating left and right wing shots
Spiral: 3-4 shards are shot out and fly in Archimedean spirals (r = bθ where r = orbital radius from gem, b = a constant, and θ = orbit angle). Each shard has a different b. The middlemost shard will hit the target if the target remains in the same place throughout the shards’ flight
If the boss uses 4 shards, the third closest/second farthest shard will hit the target
Remove WalkLeftPassive and WalkForwardPassive. The passive/aggressive difference is too subtle to see and can frustrate the player. The subtle non-attacking vs attacking modes are shown via the lowered arm and the slowly rising arm
Reconsider whether to do Double Slice Retreat. It has the same quick acceleration problem as Backflip
I decided not to implement it, but some version of it may be used for Phase 1
Make attacks that send Clarity so far away that she can do a projectile attack afterward instead of a melee
This is to solve an older issue where Clarity doesn’t get far enough to do projectile attacks after jump shot (“Cotu gets to Clarity long before Spiral…”)
Idea: bird form attacks. Clarity becomes a bird and poses in bird form for a little while (to telegraph that she’s doing something dangerous) before flying far away
Idea: Swoop attack
Mvmt is almost the same if not identical to sword Crucible Knight’s flying thrust in Elden Ring. Clarity flies in a straight line at the target and ends up far behind it. While flying, Clarity’s wings are spread, which cover her path in snow that acts the same as the blizzard
Unfortunately, Clarity is incapable of looking like a bird. Birds have wings, a body, a tail, and a beak. Naturally, Clarity’s dress shards would form the wings, her hat becomes the body, the center shard becomes the beak, and the arm shard becomes the tail. This bird is really ugly bc the hat makes the body look too wide to be aerodynamic, the dress shards are too thick to resemble wings, the bird has no head (just the beak), and neither the wings nor tail have enough feathers or feather imitations. The animal Clarity matches the most is a jellyfish, which still has symbolic value. The bird form was supposed to symbolize Clarity’s desire for freedom, while the jellyfish symbolizes Clarity’s lack of intelligence and awareness, which actually suits this form of hers more. A bird would suit her final form where she achieves total clarity
Idea: jellyfish form attacks. Clarity becomes a jellyfish and propels herself far away in the same way a jellyfish does
Jet Dash: Clarity hops a bit into the air and suspends herself, defying gravity. While suspended, she tilts forward and spreads her dress shards out while tucking in her arm shard. She then compresses her dress shards and dashes forward while pushing a plume of snow in the opposite direction
Idea: Spin
Like an ice skater, Clarity leaps into the air, tucks in her arm and dress shards, and spins rapidly while decelerating to a stop midair. All of her dress shards then fire out in all directions, land, and become ice sprites. She then dives straight down into the ground and regenerates the shards
Jump Shot creates a huge frost field on impact
Blizzard safezone shrinks to nothing if you take too long to defeat Clarity
Idea: Whiteout - fog thickens, ice sprites spawn from the blizzard at an alarming rate. Clarity meanwhile does single slice stage progression (start passive → pause → subtle transition to aggressive → pause → subtle half windup → pause → subtle full windup → pause → attack)
Idea: phase transition
Clarity causes a huge whiteout, brightens the sky, and runs away. The player has a limited amt of time to find her before the sky begins to darken and the snow intensifies. When the sky gets too dark, the blizzard is reactivated. Somewhere in the snow, Clarity is in a tall sceptre form. The player must hit her head, which sits at the head of the staff, to deactivate the attack
Idea: occasionally, songbird-like ice creatures will fly onto Clarity and stare at the target. They all fly away when she attacks, but there’s a slight chance they fly away beforehand to explore around
Idea: Cotu can make snowballs and throw them with no stability cost (but making a snowball isn’t fast). Hitting an ice sprite with a snowball triggers its explosion

Reconsider whether the player should be able to restabilize during the invincibility period after destabilization
Currently, if the player destabilizes, there’s absolutely no skill involved in restabilizing. If you use a stabilizer during the invincibility period, you’re right back to normal. Wouldn’t it be more thrilling and challenging if the player had to wait until they were vulnerable again before being able to use a stabilizer?
I still like the idea of being able to use a stabilizer while you’re still stable in order to become invincible temporarily (e.g. during a grab), but wouldn’t it be confusing or nonsensical to the player if the stabilizer was usable all the time except that brief period right after destabilization?
Perhaps at the start of the game, stabilizers should only be usable when destabilized. Eventually, you can upgrade yourself so that stabilizers give a boost of some kind? Although this feels like scope creep and you might need to keep it simple, silly

Make Different Game Mechanics Intersect; to create depth, you should be able to use multiple skills simultaneously
Vid on Interesting Mechanics vs Depth: https://www.youtube.com/watch?v=Fuf_SpKCYVY
One of the biggest issues I noticed with Blazarang is that you can only use either the rose or the ax at a time, not both simultaneously or rapidly. This limits the player’s creative expression. As the vid above explains, if there are a lot of different game mechanics in a game, but they don’t intersect, the game feels shallow. To combat this problem in Blazarang, try allowing the player to use both the rose and ax and possibly more simultaneously
When the player unlocks the ax, they also gain the option to automatically instant rethrow when the rose hits Cotu
Idea: a ghost hand instant rethrows the rose while Cotu himself does what the player wants
Idea: when Cotu inputs a non-rose throw button right before the rose hits him (i.e. as if the player is using the that button to instant rethrow), something beneficial happens
Ax
Ax gets buffed?
Rose gets thrown backwards?
Shuriken
Shuriken costs no stability
Chakram (come back to this after you add Chakram)
Chakram does a full circle instead of a semicircle (but the chakram doesn’t move faster, so the slash takes twice as long overall)
When the player unlocks the ax, they also gain the option to automatically throw the ax. This means the ax is automatically thrown in whatever direction the player camera is looking (throw is omnidirectional if zoomed in), then detonated when it’s near an enemy, hits a wall, or travels its max distance, then automatically recalled, then automatically perfect caught
Idea: ghost hand does the throwing, detonation, and recalling
Additional synergy abilities
Homing ax: if the player’s next roserang instant rethrow will be homing, and the player normal throws the ax such that the roserang hits Cotu in the last (instant_rethrow_window_secs) before the ax anim ends, the ax will be thrown as a homing throw, following the same targeting rules as a shuriken. The ax can still be detonated
This knowledge is available when both the ax and homing instant rethrow are unlocked
Power throw ax combo: if the ax was perfect caught and is now unthrown, then while holding power throw, press throw ax to throw both the powered roserang and ax at the same time in the same direction
Alt idea: instead of being able to use both the ax and rose simultaneously, try making the ax an ultimate ability
Hitting enemies with the rose charges the ax
When the ax is fully charged, the player can use it in a sweeping slice or throw. Both of these attacks have low startup & endlag and deal very high damage (akin to critical hit damage in Dark Souls 3)
After the initial attack, the ax’s damage diminishes greatly, becoming its normal form in the game currently. The ax is usable in this form for a short period of time before becoming inaccessible until the next ax full charge
If Cotu isn’t holding the ax when the ax timer ends, it explodes and disappears
Idea: when the ax is airborne, dodging causes the icon to stop following Cotu just like dodging when the rose is airborne. This can be used to dodge gigantic attacks (as a substitute for a super jump or long dodge for example)

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

Power Throw to Mark Rang Upgrade
Power throw automatically homes to mark position when mark is active

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
Phase 2: EG runs around on footb
Run 360: EG strafes around the target, then jumps while spinning about the y-axis 360 degrees. When she faces away from the target, her shotgun’s muzzle flashes with light. The second time EG faces the target (not the target + its mvmt dir), she fires. She lands facing the direction she was originally running in. Does extra damage
Spawn Grenade: EG throws 1-3 cubic grenades around the target, each of which has a tiny beacon to the sky. 5 seconds after a grenade is thrown, a spawner box from Gauntlet 1 flies vertically from far above onto the grenade’s x and z pos, spawns a random enemy from the choices below, then flies back into the sky
Sentinel
Frag Grenade: EG throws 1 spherical grenade directly at the target’s pos + Cotu’s mvmt dir. 4 seconds after the grenade is thrown, it explodes dealing damage in a spherical hitbox around it
Slide Buckshot: EG strafes around the target, then slides into a crouching position while taking aim at the target. She then fires at the target + Cotu’s mvmt dir
Switch Strafe: EG abruptly pivots and starts running in the opposite direction. Chosen when Cotu throws the rang
Slide Buckshot: EG slides towards the target (dodging underneath the rang), exits the slide in a crouching position, then fires straight ahead in the direction she’s facing
Pull Up Cover: EG stomps the ground, causing a black rectangular prism to rise from the ground. This prism is part of the arena, so the rang cannot pass through it. The prism will slowly sink into the ground over time, eventually disappearing. This move usually leads into her reloading her shotgun
Smoke Pillar Grenade: EG throws an odd-looking grenade that turns into a smoke pillar on impact. It does no damage but creates a big plume of stylized cubic smoke that is extremely difficult to see through. It lasts for about 30 seconds
Sentinel
Cyan melee supporting enemy
Wields a big thick sword with a blade about as tall as GauntletMeleeTier1’s body
About 2 heads taller than GauntletMeleeTier3 and even bulkier
Runs at the target, then performs a dash slash that looks similar to the Little Prince’s guardian ability from Clash Royale

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

Items
Shop has a menu of items
Shop window
Menu
All item placeholder textures
Selected panel (item panel or level panel) is highlighted in some way
Items can be used in a level for an effect
Icon Shockwaves
Temporarily, when the roserang hits the icon, a shockwave bursts from the icon
Stabilizer (health potion)
Use item animation placeholder
Item effect implemented
Animation: a ball revolves around Cotu while decreasing its orbital radius and rising above him over time, settling directly above his head. It then slams into his head
Chaos (chaos potion)
Temporarily, every hit puts a mark on the enemy’s current health after dealing damage. The enemy is unable to heal past the chaos mark
Use item animation placeholder
Item effect implemented
Super Stabilizer: restores all stability and makes you invincible for a short period of time
Multirose: temporarily allows you to have up to n (3?) roserangs
All rangs still consume stability unless you consume a Super Stabilizer

Grow-a-Gator
Fast giant alligator with the ability to grow and shrink
Tiny: size of Dwarf Caiman, used for dodges and quick positioning
Normal: size of American alligator
Big: size is comparable to Vordt of the Boreal Valley from Dark Souls 3
Huge: size is comparable to Golden Hippopotamus from Elden Ring
Giga: too big to fit in the arena; he hangs onto the floor with his hands and attacks with his head
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

Party Pillars
Arena consists of a ton of small pillars and one giant pillar in the center with flashy people dancing on it
One big dancer in the center does dance moves corresponding with movement patterns of the pillars below (e.g. arm/leg mvmts left → all pillars move to the left, spin → all pillars rotate)

Future Blade
Large swordsman with robber fly motif; long wing-like cloak threads/scarves and long snout
Idea: scarves have eyes on them that glow before an attack
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
Lore/story ideas:
Is a high-level contender
Zesty, sparkly, clearly put effort into his own visual design
Jealous of all other fighters because his attacks are telegraphed the most
Line idea: “Ugh, I’m just…so jealous, of, like, literally everyone who isn’t me, ‘cause, like look at this.” He swiftly raises his blade right in front of Cotu, which gets telegraphed with a before-image
Compensated for his telegraphing by improving his speed and precision greatly
Idea: kidnaps Cotu and other top contenders to prevent them from training and/or competing in the next tournament
I decided that Candy Cat fits the devious/predator aesthetic more
Relates to and quickly grows attached to Cotu as he’s the first person he’s met who really seems interested in their own visual design like FB is
FB only comments on this if the player chooses a non-default skin
FB: “Oh my god. You have no idea how many gods thought I was CRAZY for changing my looks this much.”
Cotu: “Really? I didn’t know it was that big of a deal to people. I never got comments like that.”
FB: “*sigh* I wish I had your blissful ignorance.”

Cactyrants: Evil Cactus and Giant Bird
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
Crazy-looking wraith with a number face. 2 other ball-like faces with circles painted on them, and a wraith-like body like Specter Knight from Shovel Knight
Boss’s face has a randomly selected number in some range (maybe 1-30)?
Does crazy twitching and constantly whispers about “the numbers”
Player doesn’t know how the following attacks work, they only see the numbers, then the attacks
3 pillars: left, center, right
Left and right pillars randomly select a number from 1-30 (inclusive)
Middle pillar randomly selects a number from 2-12 (inclusive) by rolling 2 dice into the arena
Player must calculate how many of the middle # it takes to get from the left # to the right #
e.g. 22, 4, 7. How many 4’s does it take to get from 22 to 7?
22 - 4x = 7 → x = 3 remainder 3
Player uses the quotient to anticipate the next attack
Boss uses the remainder in their prime factorization
Boss’s goal is to assemble all numbers used in the prime factorization of their face number (e.g. if it’s 12, the factors are 2, 2, and 3)
Once the prime factorization (PF) is complete, the boss celebrates and does a supermove before choosing another random face number

Candy Cat
Giant cat monster made of sugar crystals and candy bits
Top of its head is 4 giant spikes forming a mask above its mouth, and its mouth looks like Denji’s from Chainsaw Man with big teeth and a wicked grin
Mask spikes can fold back to form a mane, revealing crazy cat eyes and/or a bunch of tentacles underneath
Head can twist around and upside down to make new expressions to frighten its enemy
Back is covered in candy bits, chest is guarded by chocolate plates
Tail is undecided, perhaps its soul floats on its tail like a ring?
Moves like it’s naturally crazy/hyper but is trying to contain itself
Speaks with a crazed distorted voice
Represents the number 9 (4 legs + tail + 4 mask spikes)
Idea: can extend its neck, shoulders, and torso to lengthen itself disturbingly
Idea: this is a super high-ranking god (e.g. 7), making it a real threat to Cotu
Idea: constantly feints to terrify the player. Every 9th feint is an actual attack that is nearly impossible to react to unless you were keeping count
I considered the idea that the count gets reset after certain moves (e.g. a special retreat anim or special move), but I realized that it’d be cool for the player to survive a special move and have to keep the current number memorized the entire time
Idea: creates giant wormholes that travel incredibly long distances in the universe
Idea: he plans to use the wormholes to kidnap Cotu and never get caught
Idea: guards a secret wormhole that leads from the beginning of the game (gauntlet var 1) straight to the gala
Uses the candy bits on his body as projectiles
Idea: hypnosis ability
When it opens its mask, Candy Cat exposes tentacles and/or a twitching eye, which emits hypnotic waves that distort its prey’s mind
Hypnosis makes the stability bar and buffs look like they’re increasing and changes their colors - it looks like Cotu has more stability and buffs he actually has
SFX and music fade into the background, and a child’s voice reverberates clearly to say relaxing words
“Relax.”
“Be calm.”
“Ease your mind.”
“Don’t move.”
“I love you.”
“Don’t worry.”
Used immediately before a powerful attack
Uses molasses to slow its victims
Song is calming, seductive, and insidious
Idea: song has deep distorted lyrics
So soft, so sweet, so nice
And it could be yours for a low low price,
Come a little closer, don’t be shy
Why should a god be afraid to die?
Idea: this is the kidnapper, not Future Blade and his goons. Candy Cat wants to kidnap Cotu so that Jessica will let him into the next tournament
I want to have a kidnapper and a disqualified fighter to show that the gods aren’t just good or mentally-handicapped with good intentions (i.e. Clarity). It would make sense if the kidnapper and DQed were the same character
Candy Cat, not Mike, is the one who made the deal with Jessica to gain great power in exchange for a random chance of failure. Cotu (or X) caught him in the act and got him DQed. Candy Cat now wants to kidnap Cotu and hold him hostage until Jessica (who’s in charge of the next tournament) allows Candy Cat to participate in it. He thinks that because She helped him before, She’ll help him again
This doesn’t make sense bc the gauntlet, Blaze, and other strong gods would keep an eye on Candy Cat, ensuring that he won’t do anything dangerous. In any case where Candy Cat poses a real threat to other gods, ask yourself if it’s possible for other gods to intervene and stop him. If so, why are they wasting time with the gala instead of addressing the elephant in the room? If not, that means Candy Cat poses a threat to all of the strongest good-willed gods combined, which makes them look weak and breaks the power balance of the lore
Alt idea: Candy Cat got disrespected by Cotu somehow in the tournament and is taking revenge by keeping him in his sticky realm (e.g. burying him in syrup and forgetting about him). He is petty and pathetic
This makes sense but wastes Candy Cat’s visual design. If it’s pathetic, why is it so big and intimidating?
Alt idea: Candy Cat feels incredibly good when victims are submerged in his syrup-filled stomach, so he’s been kidnapping people and putting them in his syrup. He lures them in by offering training better than the gauntlet’s. The people at the gala are wondering why some gods aren’t showing up yet
This doesn’t make much sense bc surely the gods can team up to beat Candy Cat and stop him from doing this
Alt idea: Candy Cat is a prisoner
Candy Cat is locked away in gauntlet central bc it kept attacking gods whose bodies or realms contained some trace of sugar, and it showed no willingness to change (due to having the mind of a voracious beast). It traveled great distances using its wormholes, ate sugar, and turned the sugar into its body parts, enhancing them. The gauntlet keeps it in one place only by filling its holding chamber with sugar alcohols, which satisfy it and stifle its power.
To train, gods can fight Candy Cat in a gauntlet holding cell. The gauntlet grants special access to that particular god, then gives Candy Cat a controlled dosage of sugar, then covers the challenger in sugar
Story Idea: Candy Cat’s escape
In a back corner of gauntlet central, 2 lively NPCs are sitting and chatting. When Cotu approaches them and tries to talk to them, they get up and walk away without looking at him. Cotu comments on their rudeness. Typically, gauntlet gym NPCs are friendly and open to meeting new people
During the gala, after a few matches have passed, news breaks out that Candy Cat has escaped confinement at gauntlet central. Blackstar is summoned by the gauntlet to aid the search for it and withdraws from the gala. X is also summoned by the gauntlet since he’s the one who eliminated Candy Cat during the tournament. Blackstar comments that the only way Candy Cat could have escaped is if someone smuggled sugar into gauntlet central, which shouldn’t have been possible since guests are screened before entering gauntlet central
Idea: at the gala, without the watchful eyes of Blackstar and X, Cotu is kidnapped, ending the game
Idea: to win the game, the player must bring Clarity or the mites to Candy Cat’s holding cell to restrain Candy Cat, AND stop the kidnappers by following the rude NPCs when they walk away

Neuron Boss: Neuro
Shaped like a neuron where 1 axon terminal is the head and 1 axon terminal is a set of feet. The head and feet are constantly flickering and changing shape. They have no arms. Their base form is tall, so they have to hunch down to talk to others at face level. They can also “sprint” by running with both their head and feet on the ground
Can move incredibly quickly, fly, and change size extremely (e.g. they can grow their head to fill up the entire sky)
Zip: Neuro dashes from one position to another in the blink of an eye. This is their bread and butter
Laughs and screams when zipping several times in a row
Lightning: Neuro does a weird pose, stops moving, and electric buzzing noise slowly loudens. The entire screen then flashes white, then quickly dims to reveal the remnants of a lightning bolt fired from Neuro directly to the target
Caltrops: Neuro floats in the air, moving so slowly it almost looks like they’re not moving, then drops a bunch of sparking electric caltrops to the ground
Switches from their base blue mode to pink/purple in phase 2
Idea: occasionally twitches (jerks around suddenly, cancels a move, etc.)
Inspired by UFC fighter Dustin Poirier’s habit of pulling up his shorts
Idea: talks trash throughout the entire fight to discourage Cotu
When attacking quickly
“Come on! Show me something!”
“H̸̘͈̞̹͔̦͋̓͆͒̔̅̍̋͝͝A̸̖̱̩̳̯̍̓̄͛̽̓H̶̢̲̏͌͑́̆͌͛͒͗̇͗̚̚Ä̵̧̖̲̯̭̭̙̳̯̪̿̄̿̕̕͜͜H̷̠̠̻̗̃̉̈͊̄̄̿́Ą̶̩̲̳͍͕̳͎̊̋̓͗́̐͝H̸͓̪͉͎͍͗̌̅̅͊̇̅͘͝͠Ā̸̘̭̜̌͛̓̊̉͝H̴̡͇͚̗̹̘͍̏͋͐̆̒̍́̃̅̑̊̉A̷͈̹̽͜”
“À̸̭̯̣͓̟̜͙̖̹̤̞͉̘̝̿̌͂̾ͅA̸̱̹͉̩̋̀͛̓̽A̵̢̨̛̰̪̰͚͖̞̘̰͙͖̖̘̋͊̿̐͝ͅÄ̷̻̰̝͕́H̴̡̪̣̯͎̰̥͙̊̽̀͑̋͜͠H̴͎̝͚̄̓̏̿H̴̭̮̯͔̰̼̖̙̟̼̬̞̓̐͐͛̃͑͗̃́̇̈́͗̕͝͝H̵̲̜͕͌̉̌͑̀̐̇͑̏͘͝͠”
When hit
“Is that all you can do?”
“You can’t do ANYTHING to me!”
When you get destabilized
“Oooh, you better use a stabilizer!”
“HAHAHAHAHAHA”
When you use a stabilizer
“You’re nothing without those heals!”
When using your last stabilizer in phase 1
“Out of heals already? OH NO!”
“UH OH! Was that your last heal?”
“HAHAHAHAHAHA. You’re FINISHED!”
Lore/Story Ideas:
One of the highest ranking gods from the tournament
Voice sounds like Bill Cipher from Gravity Falls, but pushed a bit in the direction of Skeletor’s voice, and electrically synthesized
Loud, narcissistic, witty fast talker who constantly proclaims themself to be the greatest in the universe
Blames their loss on bad luck
Brags about how they defeated X, a favorite to win in the tournament. In reality, Neuro had an excellent matchup against X because Neuro uses electric attacks and X is made of steel. X himself complains about this
Neuro actually did lose due to a bad matchup like X did (I’m undecided on what that bad matchup is)
This makes Neuro a genuine threat who means what they say
Insults Cotu by calling him a puny little twerp who got lucky
Cotu agrees with this and says he’ll defeat Neuro to prove the tournament win wasn’t a fluke
Personality and fast talking are inspired by Muhammad Ali
Turns pink/purple when they’re angry and back to blue when they’re calm
Convo idea:
Undecided person: “Do you ever think about the fact that you have no friends?”
Neuro: “Absolutely not. Why should I care for the attention of inconsequential losers who will only hold me back?”
Undecided: “Because having friends is nice. They care about you.”
Neuro crackles. “Easy for you to say. Your friends are better than you. If you were as great and awesome as me, you’d realize that nobody around you is worth your time.”
Undecided isn’t convinced but says nothing.
Neuro: “I’m done wasting time with your asinine inquiries. Go talk to your friends instead.” Neuro zips away

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
Problem: the triplets being gauntlet members muddles their identity (3 minds with ability trade offs AND resurrection?) and wastes some of their uniqueness.
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
Pilot: “Actually, it’s the only thing it let us borrow.”
Greg (voice decreasing to a mutter): “Well, alright, yeah.”
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
Greg: “WHAT?! IT’S SO OVER! TAKE THIS!”
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
When he tries to speak, it sounds like quiet white noise. Greg and Pilot tried to decode it to no avail
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
Pilot: “You get in here too, Cotu!”
Cotu: *joins the hug and closes his eyes*

Whipspider/Crab Boss (just an idea)
Heavily armored crab in a tiny arena surrounded by walls/floor spikes/floor shark teeth/whatever
Can catch the rose and throw it aside and/or parry it
Approaches slowly and cautiously with jabs (reaching out and clasping with the claw)
Feints constantly
Occasionally unexpectedly dashes in with open claws
Inspired by UFC fighters
Reference: Alex Pereira vs Khalil Rountree
Idea: in phase 2, instead of staying low to the ground, it gets up on its hind legs (walking on 4 legs instead of 6 or 8), allowing it to lunge forward with its chest and its arms instead of just the arms

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
Your body isn’t controlled by electricity like many mortals’ bodies are, which is why you can move freely (currently at low and medium voltage). But what happens if we up the voltage?
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

TrueX OR Tempered X Boss
Pre-fight quote: “Tell me, Cotu…Can you read me?”
Face is modeled after a T shape instead of an X
Soul is a plus sign with pointed tips and with the top segment (the one facing away from the target) removed, i.e. a T whose stalk is as long as the branches. Soul faces in the direction X wants to attack in
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
Whenever X teleports, vec to target is no longer just a 90 deg rotation about the y-axis of the vec from X to target. It is now a random rotation between -90 and 90 deg about the y-axis
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
Side Slice: X holds his left arm out to the side, then 
Platform Removal: X prepares his star to destroy an entire platform as he jumps to another. Cotu must use his icon to fly to the next platform
Phase 2: 
Pre-phase quote: “Focus up.”
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
TP Sweep: X is in a side squat with his left foot extended. His left arm is pointed towards his left foot while his right elbow is almost resting on his knee (imagine it’s on his knee, but moved up a bit such that his right hand is near the bottom of his ribcage. Also his right hand is slightly below his right elbow pointing straight to his left). He then ignites his medium foot blade. He then sweeps his left foot in front of him in a 180 degree turn, ending with his butt facing the target
TP Sweep Trick: X is in the TP Sweep starting position, but instead of igniting his foot, he charges up his left hand with an energy burst, then punches his left arm fwd to release the burst. He then teleports away while still side squatting. Selected more rarely than TP Sweep
Near-end attacks:
Solar Flare: a wave of blue energy rises in the distance for a long time. Eventually, it crashes into the arena

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

2 Boss: Blackstar, Champion of the Gauntlet
Story:
She has Demetrius Johnson’s stature, Kobe Bryant’s mamba mentality (harsh self-criticism and relentless drive for self-improvement), and Messi’s lack of casual social skill
After Cotu arrives at the gala and before their fight, Blackstar approaches Cotu and tells him that even though the gala’s not a serious competition, she wants him to promise her not to hold back, as this is her last chance to reincarnate before the next tournament
X is jealous that she pulled Cotu aside
She is extremely personally motivated to fight Cotu at his best
Public opinion of the Gauntlet has decreased ever since her loss to Cotu in the tournament. People say the Gauntlet’s been on a decline and/or stagnating and/or out of its prime
Blackstar can take being insulted herself, but she’s pained by her family being talked about negatively. She doesn’t want to restore her glory—she wants to restore theirs, and secure the Gauntlet’s future by reincarnating
Alt idea: Blackstar and the Gauntlet don’t care about pride. The reason they care so much about becoming stronger is because their entire identity is training others, but if all the gods become far stronger than them, then no one would want to hang out with them anymore
With this idea, Blackstar’s character flaw is that she believes friendship is transactional
Problem: the Gauntlet still has plenty of weaker gods to train
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
Realm is full of random geometric stones, which I’ll call “bits”
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

Jester Boss: The Greatest Magician
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
Jellify: briefly turn Cotu into gelatin, which causes him to melt and take damage if he touches his weapons (no throw nor instant rethrow)
Umbrella: rises into the air quickly and drifts downward slowly. Used as a general utility mvmt
Idea: in her second phase, Jester uses the last of her magic to transform herself into a ravenous beast, revealing her eyes and hair
Story ideas:
Was originally a shy introvert who learned to hide her vulnerability with humor
Trained alongside the gauntlet during the tournament, gaining their trust
Secretly madly in love (or lust) with Greg

Story Progression Arcs/Episodes
Cotu goes on a journey and encounters progressively more antagonistic antagonists
Destination is a gala for top competitors. Gala is like a pantheon from Hollow Knight where you fight several bosses in a row
Idea: you have the option of telling the event organizers about the kidnappers. If you tell them, they don’t participate in the tournament
Idea: Player only has a limited number of fight attempts and stabilizers across the entire journey before the gala begins. As the player completes subsequent runs, they’ll have more and more attempts and stabilizers that they can use to practice against later bosses
Certain gods (e.g. mites) force the player to defeat them or use many stabilizers to charge the ship’s stability shields to escape their realms. Surviving their encounters for a certain length of time grants experience that you can use to unlock skills, but doesn’t progress the journey past them
Progressing through the journey quickly (i.e. beating bosses with less attempts) will allow the crew to catch up to other gods making their way to the gala. The player may encounter gods they didn’t encounter in previous runs due to taking too long
If the player initiates the gala while still possessing attempts and stabilizers, the leftovers can be converted into skill points and other unlockables before the start of the next run
The player is told about this game mechanic at the start of the entire game so they know they should do it
Idea: each gala battle win multiplies the SP/unlockable potential of the leftover attempts and stabilizers
Idea: using stabilizers in the gala is against the rules, so when entering the gala, the player has the option to convert them to XP to level up/upgrade skills before the first gala fight, or save them to be converted to skill points, items, etc. for the next run
Idea: leftover stabilizers post-gala can be converted to super stabilizers in the next run (e.g. 4 stabilizers → 1 super stabilizer). Super stabilizer may provide a damage boost + temporary invincibility (via infinite stability) + no startup time on weapon throws + …
Idea: Skill Tracks
At the gala, participants can sign up for the Casual or Hardcore track. In the Casual track, participants can use any number of stabilizers they want. In the Hardcore track, stabilizers are forbidden
OR fighters in the Casual track have a limited number of stabilizers they can use throughout the entire gala. This can be justified in-universe by saying they’re hard to come by
Casual fighters (including but not limited to):
Grower Gator
Future Blade
Triplets (as a surprise)
Hardcore fighters (including but not limited to):
Tempered X
Turbo Jester
Blackstar
Whichever track the player joins, the player is allowed to train with members of the opposite track (i.e. fight them some number of times, limited or unlimited) before initiating the gala
The player can only choose one track per run. If they want to try the other track, they have to start the journey from the beginning
Idea: the player gets some kind of bonus, e.g. more XP per defeated boss, after each journey, but for story reasons, the player always starts with 0 XP and 0 upgrades at the start of each run
If the player joins the Casual track, they can train with TX and Blackstar, but they won’t go all out
TX won’t use his supermoves or enter his final tryhard phase
Blackstar won’t use her ultimate form
Idea: Jester refuses to train with you, but maybe she harasses/teases you in the hub room instead
The idea that stabilizers are consumables usable by everyone creates some issues:
If every god has a unique form of stability, how are they all stabilized by the same object? A stabilizer that works for one god shouldn’t work for another
Saving all your stabilizers until you get to the gala feels like cheating against the competition. You’re bringing in an advantage originating from outside the gala
It’s probably better for the player’s sense of accomplishment if stabilizers worked like Pulse Cells from Lies of P; you’re given a set number of them whenever you respawn/rest (in this case, maybe when you return to your realm), you can upgrade how many stabilizers you spawn with, and you can regain stabilizers mid fight somehow
This also makes Cotu more unique as a god; he trades maximum HP in exchange for the ability to stabilize after being destabilized
Player can save at a checkpoint with a limited number of slots
Order of encounters:
Cotu’s friends (supporting Cotu)
Gauntlet
Ball Walker (maybe)
X
Clarity (neutral)
Mites (opposing, but nonintimidating)
Angels (optional, fun distraction)
Kidnappers (opposing and intimidating)
Centipede (maybe)
Darkness (maybe)
Tempered X
Blackstar
Microwave
Notes:
Mites were originally planned to be a cute friendly faction with their creator being a friend who wants Cotu to play with their toys, but Ball Walker’s shape and toy-like nature fits that better. Mites were meant to send the message that someone could have a strange appearance but friendly personality, but Ball Walker can do the same since the contraption is strange looking but subconsciously friend-shaped
Steps for the journey:
The Return
Cotu comes back from vacation and warms up by fighting gauntlet var 1 (+ var 5 with the gauntlet tower miniboss)
Cotu fights X, who’s a bit peeved that he had to wait for Cotu instead of heading to the gala early. He’s hiding the fact that he wanted to see Cotu again
Cotu and the triplets start heading off to the gala
The Void
After some time, Cotu and the triplets are given a choice: take the long route to the gala through the web strand of light and matter, or take the shortcut through the Great Void. Going through the void is risky since there’s no way to communicate with the rest of the universe when you’re deep enough in the void, but if they take the long way, Cotu won’t have as much time to fight other gods (in game, he won’t have as many attempts) before the gala begins. The crew doesn’t have the time to spare since they spent too much time on vacation
In reality, the universe is actually built like a web, with strands of light and matter and vast voids between the strands
The crew not having time to spare explains why none of Cotu’s overpowered friends help him along the journey; they’re already at the gala and are busy practicing or on the way to the gala ahead of him. Also Cotu needs the experience fighting people to get strong again
If the player chooses the void, the crew encounters Clarity’s realm. They didn’t expect to see any form of life so deep in the void. The player has to defeat Clarity  or the journey ends here
Why don’t stability shields work? I want the Clarity shortcut to be actually risky for the player
(Alternative to the Void) The Web
If the player chooses the long route on the web, I’m unsure what exactly will happen
Idea: along the way, the player has the option to fight minor or gimmick bosses, which can give Cotu experience in exchange for time, or the player can skip the minor bosses to have more time to get to the gala
Minor/gimmick bosses:
Elite Gunner and Sentinel
Cactus and bird?
Simone Says?
Idea: at some point along the web, the crew is attacked by the mites, and either Cotu destroys the mitriarch or the crew consumes a lot of stabilizers to charge the shields so they can escape
The Kidnapping
Cotu gets kidnapped by Candy Cat and has to defeat him or the journey ends here OR somebody kicks Candy’s ass and saves Cotu
Idea: The crew sees an advertisement for extremely cheap stabilizers, so they go to Candy Cat’s booth to buy them, then get kidnapped. Greg argues that even if it’s a scam, Cotu can just beat up the scammer
The Gala
The player gets only 1 attempt to fight Tempered X, Blackstar, and (hopefully) Turbo Jester OR the player can use their remaining attempts to practice fighting Tempered X and Blackstar before initiating the gala like the Radahn festival, but the player only gets that one attempt at the gala
Post-Gala
Player can fight Microwave, the one competitor disqualified from the tournament


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
X Intro Cutscene
X starts floating towards Cotu as the music starts. Cotu approaches X
X and Cotu pause in front of each other
Cotu: “Go easy on me, okay?”
X nods subtly
X raises his arm to the side. Cotu does the same. Right when the music goes silent, they slap their hands together back and forth twice before going in for a fist bump. Right before their hands collide (which would be painful for Cotu), their fists both stop in front of each other, then they open their hands and pull them back like an explosion happened between them.
The camera cuts to X’s face, which ignites
Cut to Cotu, whose eyes widen
Cut to a camera near the ground that looks up at the two. X punches the air in front of him with a plasma sphere. Right before it hits Cotu, Cotu dodges backward. The plasma sphere explodes just as the music kicks in
Camera returns to player’s POV
Comet Intro Cutscene
Comet descends elegantly from high above in an intricate, delicate dance, suggesting she is more of a cosmic force of nature than a person
Script: Cotu and Comet are sassy
…
Comet: “A coward like yourself stands no chance in such a weakened state.”
Cotu: “Coward? So you judge me as well.”
Comet: “I have my reasons, do I not?”
Cotu: “...No, you don’t.”
Comet: “Hm! Our measures are about equal, currently. Let us settle this debate by the blade, champion.”
Cotu: “Sure.”
Alt script: Comet is more cold than sassy
Comet: “So, you have chosen me to be your next opponent. A bold choice for a coward like yourself.”
Cotu: “...”
Comet: “Too afraid to talk back? Then I have but one request. Allow me to have this bout through to its chilling end. Don’t you dare run from me.”
If the player exits the bout early, Comet will prevent them from trying again for a while
Comet: “So you ran away. I will not entertain your attempts to insult me.”
Make a Zelda-like big balls monster
Dragon-robot head, 2 big balls as the neck
Comes up from a hole in the ground
Attacks include throwing enemies at you and rolling its balls at you (it then reloads a ball from below)
Allow player to change graphics settings
Bloom
Arena lore
Duels between gods take place on a god arena, a special arena made by the creator of the universe
Each god has a body, soul, and realm
A god arena automatically emulates the combination of realms of the gods who enter it
The arena exhibits more traits of the more dominant realm, and exhibits them more strongly
Cotu’s realm is very weak and passive, causing the arena to mostly conform to the realm of his opponent
Marathon: fight all bosses in a row, only being able to refresh items every so often
Player can only bring in a few items for each leg of the marathon
Items can be replenished from storage after each leg
There’s a break after each fight, and the player decides when to initiate the next one
Hard mode option: Adds the Jester (see “Jester Boss: The Greatest Magician”)
Sequence:
Gauntlet Tower
…
Microwave
Ultimate villain: Entropy aka Chaos
“The Universe created you all by using me. And in exchange, I get to hunt you all down. One by one.”
In the real universe, all life is born in order to convert the universe’s low entropy into high entropy at an accelerated rate.
In Blazarang’s universe, all life is born using Entropy’s power (same as our reality). Whereas in our universe, entropy is simply the passage of time where our lives happen and then we die, in Blazarang’s universe, Entropy created the contenders to kill them eventually.
Why does Entropy target the strongest first? The strongest have the most energy and therefore the most ordered structures. Destroying them means destroying the greatest sources of order, increasing the universe’s disorder the most.
Why does Entropy want to kill everyone? It’s his life’s purpose: his art, and a game he finds fun. Entropy takes his role very seriously and greatly enjoys it; to the Big Bang, this universe is just a pet project
Why is the “Universe” called the Universe? People call him that because he calls himself that. He calls himself the Universe (or the Voice of the Universe) because he thinks he’s the only ruler of the Universe
The fact that everyone calls the Big Bang the Universe infuriates Entropy
Entropy possesses the strongest champion like a ghost and uses them to slay other contenders
Just for fun, Entropy may also possess a weaker champion whom he thinks has a chance of defeating the strongest, e.g. possessing Blaze to fight rank 3
If the player fulfills the conditions for unlocking chaos, they unlock chaos damage, initiating their possession
Current chaos condition: after starting a new game, the player visits 9 realms in a row without getting destroyed
If not, Entropy possesses another contender. That contender then becomes the final boss, who acts the same as the original contender but can deal chaos damage (and possibly has other attacks or attack supplements)
Final Boss A: Possessed Contender
The player did not meet the conditions for unlocking chaos
Current chaos condition: after starting a new game, the player visits 9 realms in a row without getting destroyed
Entropy possesses a contender only after the player learns of the existence of Entropy and learns that Cotu’s traveling throughout the realms to train others on how to fight him
The player should learn of Entropy’s existence early on
The possessed contender acts the same as the original contender but can deal chaos damage (and possibly has other attacks or attack supplements)
After defeating the possessed contender, Entropy tells the player (not Cotu) exactly how to get Entropy’s attention and unlock chaos damage
Choices for possessed contender are WIP
The Edge
Non-choices for possessed contender:
Blackstar: her love for her family is too strong
Microwave: hates Entropy too much to be possessed
Final Boss B: Player’s Choice
The player met the conditions for unlocking chaos and either accepted it or failed to fight off the possession
Entropy then forces Cotu (the player) to choose who to fight. After the player makes their choice, Entropy possesses Cotu. There is no discernable difference between Cotu pre and post possession (other than he stops talking/thinking for himself) and the possession itself has no visuals nor audio
Entropy sees the free choice as a last act of kindness before the possessed vessel loses free will
Why don’t other contenders come to help? Entropy created a barrier preventing all communication and travel to/from the chosen’s realm
Potential dialogue:
Cotu: “Chaos damage? But only Chaos can use Chaos damage…I was Chaos? This whole time?”
Entropy: “Yes, as is everyone.”
Final Boss C: ???
The player met the conditions for unlocking chaos and fought off the possession, but didn’t meet the requirements for True X or The Hunter final bosses
Final Boss D: True X
The player met the conditions for unlocking chaos and fought off the possession, and the player defeated X on the first try this playthrough
After Cotu defeats True X, X accepts chaos to try to defeat Cotu
Final Boss E: The Hunter
The player met the conditions for unlocking chaos and fought off the possession, and earned a super badge from every boss before then (doesn’t matter which playthrough they did it on)
After failing to possess Cotu, Entropy possesses the contender with the best chance of defeating him
Idea: the Seer
One contender has the ability to see the future
Whatever he genuinely believes will happen in the future is correct. This ability is used in the same way that a human uses their imagination, only the Seer is always correct
The Seer can’t just imagine anything he wants and have that be the future (ie he doesn’t literally control the future)
The Seer still has free will; he can imagine himself doing any action within his capabilities, then imagine the future that would happen if he did any of those actions
Head is just a bunch of expressionless eyeballs
Wears a mask that can emote
Plot Idea 1: Chaos Executes the Gods
All gods know (or all gods are supposed to know) that an all-powerful being they call Chaos will possess one of them to fight one of the others
How do they know this? The creator of the universe told them himself
How does the creator know? This is what Chaos did to every single one of his earlier universes
Cotu fights other top gods in the universe to prepare them to fight him, and to prepare himself to fight them. As Cotu, he is most likely to be possessed by Chaos
Why is Chaos unpredictable? Chaos could possess someone other than Cotu if it believes that it’s a challenge to fight Cotu, or possess Cotu himself if it believes that Cotu is weaker than other gods and makes him more challenging to play as
Before and during the events of the game, most of the strongest gods shed their power by destroying parts of themselves and refusing to regenerate them in their realms, leaving their realms unoccupied and filling the universe with the remains: stardust
The gods you fight as Cotu are either selflessly keeping themselves powerful to protect the universe (8164, 3), are unaware that Chaos will possess the strong (mites), or don’t care/have some other motivation to be strong (2)
Why is Cotu the captain of a crew of a ship? He needs his crew to transport him to people who request to fight him or people he requests to fight; he currently can’t transport himself
Why is the rank 2 god (the microwave) aboard the ship if it can transport itself anywhere? To observe Cotu, analyze his opponents and give Cotu the intel mid-fight, and provide items to Cotu if he needs them. These items either prolong the fight (allowing Cotu to get more training in the same fight) or shorten the fight (allowing Cotu to train with others sooner)
The microwave is only a small part of the bot’s true body. The rest of it is training against several gods at once
Why doesn’t the microwave train with Cotu more often? Cotu doesn’t want to fight it, so you, the player, don’t have the option to fight it until late in the game
Premise: Why do the events in the game happen?
Cotu fights others and travels the universe for fun. This is the universe’s way of rewarding him before Chaos kills him
He visits Blackstar to say hi
He spars with X for fun
He helps Ball Walker’s owner out of kindness
He helps with the mites out of kindness; he really shouldn’t be dealing with them since they make life harder
He fights the triplets for fun
He fights Mike for closure
Character Conversations: what are their motivations?
Cotu and X
X wants to have a long-term goal
Cotu wants to know everything he can about his friends before he dies or kills someone
Cotu: “X, what are your plans for the future?”
X: “...I don’t know. I really don’t know. And that pisses me off. … But I know what I want for now. I want to keep being your friend. And hopefully beat you one day.”
Cotu: “Oh, you’ve beaten me before.”
X: “But I’m still not better than you. Not yet…maybe not ever.”
Cotu: “Don’t underestimate yourself, friend.”
X: “Don’t patronize me.” *sigh*
X and Cotu
X wants to get to know Cotu before he passes
Cotu wants to share everything about himself before he passes
X: “...Cotu?”
Cotu: “You can call me Blaze, if you want.”
X: “Blaze…why did you want to become champion?”
Cotu: “...”
Cotu: “The truth is, I love what I do.”
Cotu: “Throwing the boomerangs, flying around, getting stronger, I loved all of it. That’s why I reset all my upgrades after winning the tournament…so I could unlock them all over again.”
Cotu: “That tournament gave me the chance to be me, and pushed me to become the best version of myself. I was just lucky enough to win.”
Cotu: “So the reason I became champion is really just selfish. I’d like to say I did it for others, and I do want to protect them, but that’s not the whole truth….I’m sorry. I thought you should know.”
X: “...Cotu.”
Cotu: “?”
X: “I’m glad to have you as a friend.”
Cotu: *smiles* “...Same here.”
Cotu and Mite Monarchs
Cotu wants to know everything he can about the universe before he dies or kills someone
Mite monarchs want to cause as much havoc and mayhem as possible out of sheer pettiness from missing out in the tournament (WIP)
Cotu: “Why are you doing this?”
Queen: *bites Cotu*
King: *shoots webs at Cotu*
Cotu: “Ouch.”
X and Blackstar
X wants to have a long term goal. He looks up to Blackstar
Blackstar wants to protect her family for as long as she can, but is unsure of herself
X: “What’s your plan?”
BS: “I’m creating as many different versions of ourself as I can, all at varying strength levels. So that maybe, instead of destroying our soul, it will destroy every individual body we make. That’s the plan, anyway. I still need to bargain with it and…get it to agree.”
X: “...Are you sure this is going to work?”
BS: “I don’t know if I have another choice. If you have a better idea, I’d love to hear it.”
X: “...”
BS: *motivational sendoff here*
Plot Idea 2: Cotu Loses His Power, and Others Try to Stop Him From Getting It Back
Cotu loses his power somehow and goes on a quest to retrieve it before the next universe tournament
Other gods either help Cotu or try to stop him
Some gods look for his source(s) of power to hide, destroy, or use it/them
Some gods try to kidnap Cotu and hold him captive until the next tournament ends
Some gods try to intercept Cotu’s efforts to retrieve his power
Greg and Cotu chilling after Cotu returns to full strength
Greg is curious about why Cotu reset his powers
Cotu is chilling
Note: Cotu knows (or at least has a strong hunch) that the microwave is the runner up, but Greg doesn’t, likely because Cotu knows about the grudge and Greg is more optimistic
Greg: “Hey, now that you’re back to full strength, I gotta know. Why’d you reset yourself in the first place?”
Cotu: “...Mostly because I like the feeling of getting stronger.” Brief pause. Greg nods. “And I wanted to get away from the contenders. I didn’t want to get challenged by them as soon as I got out of the tournament.”
Greg: “I thought you liked fighting.”
Cotu: “I do. I just needed a break.”
Greg: “...wouldn’t the other contenders also be on break?”
Cotu: “Not all of them…some of them wanted to keep going.” Cotu’s tone becomes darker. “The runner up. It holds a grudge against me. I knew it would demand a rematch as soon as the tournament ended.”
Greg: “Really? I didn’t think it would take it so personally.”
Cotu: “It did. And now, it hates me. I hoped…” Cotu hesitates, embarrassed by what he’s about to say. “by the time I got back to full strength, it wouldn’t be mad anymore.”
Greg: “Do you know? If it’s still mad?”
Cotu: “I’m afraid to find out. But I’ll have to face it eventually. It deserves a rematch.”
Greg: “No, dude. That win was fair and square. You don’t owe it anything.”
Cotu: “I know. But I want to give it some closure.”
Greg: *sigh* “...you’re a brave guy, Blaze. I hope things turn out ok.”
Cotu: “...”
Greg: “Actually wait, it hasn’t bothered us so far. The whole time while you were getting your strength back, it didn’t come check on you at all.”
Cotu: “...”
Greg: “Maybe it’s not so bad, eh?”
Cotu: “...maybe not.”
Greg and Cotu followup conversation about the runner up
Greg is confused
Cotu wants to explain
Greg: “Did you know it was the microwave the whole time?”
Cotu: “I predicted it was, but I wasn’t 100% sure.”
Greg: “Damn.”
Plot Idea 3A: Trip to the Gala (labeled 3A to differentiate from 3B, which has major changes)
Cotu loses his power on purpose to go on vacation with his friends without being bothered by other contenders. Cotu trains with others in his weakened form to get strong enough to fight in the exhibition gala, the last big combat event before the next tourney. Throughout the course of the game, he travels to the gala and eventually competes in it
The gala is a huge fighting competition organized purely for entertainment. Through it, the audience can see their favorite fighters in action again, and in matchups that never happened in the tournament and may never happen in serious competition due to power differences
Low tiers fight top tiers, individuals fight teams, fighters eliminated early in the tournament get their chance to shine, fighters who were weak but improved a lot after the tournament get their chance to shine
This is the equivalent of a casual martial arts competition with crazy matchups and everybody is in their prime, e.g. Demetrious Johnson vs Jon Jones (DJ is much smaller), Islam Makhachev vs Khabib Nurmagomedov (they’re best friends), Mike Tyson vs Muhammad Ali (2 of the best heavyweight boxers in history but from different eras), Tom Aspinall vs Valentina Shevchenko and Kayla Harrison (heavyweight champion vs 2 best women), Bruce Lee vs Jackie Chan vs Donnie Yen vs Jet Li (4 celebrity martial artist actors)
The gala leans into all of the things human beings can’t do but gods can
Fighters can sustain irreparable damage
Fighters are all in their prime because the concept of a prime doesn’t exist for them (or if it does, it works completely differently from a human’s, e.g. a fighter repeatedly enters and exits their prime on a cyclical basis, a fighter’s body/performance is randomly determined)
At the gala, he fights at least the following 2 gods:
Tempered X, who wants to show the universe what he’s truly capable of after being eliminated unexpectedly early in the tournament
Blackstar, who wants to prove that she’s ready for the tournament by fighting the champion
Jester? Would be fun but can remove if out of scope
Microwave possibly makes a surprise appearance? Maybe as a bonus event as in this timeline, Blackstar is the rank 2. Microwave was disqualified for making a deal with the Creator: incredible power in exchange for a tiny chance to critically malfunction
On the trip, gods fight Cotu for various reasons
Cotu asks the Gauntlet to train him, and they love fighting and helping others
X fights to help Cotu get stronger before the gala
Clarity’s body and realm are autonomous and attack anything that gets near them
Triplets fight Cotu for fun
(an idea for now) Mites are wild animals that want to spread and conquer (although they’re treated like fully sapient gods by other characters)
(an idea for now) Future Blade wants to kidnap/sabotage Cotu to prevent him from fighting in the tourney
Grow-a-gator helps Future Blade because he likes chaos
Angels just want to play catch
Some want the privilege of fighting the champion
Some weaker gods are more motivated now that he’s closer to their level
Pilot and Greg’s first scene: post-gauntlet variant 1
Assumed game sequence for this scene: player starts the game in gauntlet, then either wins or loses to return to the ship. The following script is for a win
Cotu’s feeling good but wants a bigger challenge
Pilot and Greg want to congratulate Cotu for beating the gauntlet just after vacation
Pilot is offscreen and speaking through the ship’s PA system
Greg’s chilling leaning against a wall
Cotu steps out of the portal from the gauntlet into the bridge
Pilot: “Welcome back, Cotu. Congratulations for conquering the gauntlet!”
Cotu smiles and chuckles
Greg: “Hey, not bad for your first fight outta vacation.” Greg daps up Cotu.
Cotu: “Thanks guys, but that was just the first variant of the gauntlet. And they were going easy on me.”
Greg waves off Cotu, dismissing his modesty. “It’s still something dude. You were really moving out there. Haven’t seen you move like that since the tournament.”
Pilot: “True that!”
Cotu: “Maybe. But you can really compliment me when I fight the top fighters again. At the gala.”
Pilot: “Ooh, someone’s excited. Unfortunately, it’ll be a while before we make it all the way back to the Center of the Universe. We traveled pretty far for this vacay.”
Greg (quickly and quietly): “Worth it though.”
Interestingly, Gemini interpreted this line as a point of tension, instead of just a quick sitcom-like insert like how I originally intended it. Gemini thought that there’s some controversial reason why the friends went on vacation that will be revealed later.
Cotu: “Even so, I don’t know if I’ll have enough time to get back to full strength by the time we get there. I’ll have to train hard along the way.”
Pilot: “We’ll do our best to help in any way we can, just give us the word!”
Cotu: “*sigh*...I love you guys.”
Greg: “Oh stop, you’ll make Pilot blush.”
Pilot: “I already am. *squee*”
Pilot and Greg’s first scene alternate dialogue: less talking
Same setup as original dialogue
Pilot: “Welcome back, Cotu. Congratulations on winning your very first fight since the tournament!”
Cotu smiles and chuckles
Greg: “You still got the moves.” Greg daps up Cotu.
Cotu: “Thanks guys, but that was just the first variant of the gauntlet.”
Pilot: “It’s still impressive, especially since it’s your very first fight since the tournament.”
Greg: “What he said.”
Cotu: “Maybe. But you can compliment me when I fight the top fighters again. At the gala.”
Pilot: “Ooh, someone’s excited. Unfortunately, it’ll be a while before we make it all the way back to the Center of the Universe. We traveled pretty far.”
Greg (quickly and quietly): “Worth it though.”
Interestingly, Gemini interpreted this line as a point of tension, instead of just a quick sitcom-like insert like how I originally intended it. Gemini thought that there’s some controversial reason why the friends went on vacation that will be revealed later.
Cotu: “Even so, I don’t know if I’ll have enough time to get back to full strength by the time we get there. I’ll have to train hard along the way.”
Pilot: “We’ll do our best to help in any way we can, just give us the word!”
Cotu: “*sigh*...I love you guys.”
Greg: “Oh stop, you’ll make Pilot blush.”
Pilot: “I already am. *squee*”
Pilot’s first scene alternate scenario: Pilot’s by himself at first, then Greg and no name are introduced
Assumed game sequence for this scene: player starts the game in gauntlet, then either wins or loses to return to the ship. The following script is for a win
Cotu’s feeling good but wants a bigger challenge
Pilot wants to congratulate Cotu for beating the gauntlet just after vacation
Pilot is offscreen and speaking through the ship’s PA system
Greg and no name are offscreen
Cotu steps out of the portal from the gauntlet into the bridge
Pilot: “Welcome back, Cotu. Congratulations for conquering the gauntlet!”
Cotu smiles and chuckles
Cotu: “Thanks, but that was just the first variant. And I’m pretty sure they were going easy on me.”
Pilot: “Hey in all seriousness, it wasn’t bad for your first fight out of vacation. I haven’t seen you use moves like that since the tournament!”
Cotu: “Maybe. But just you wait until I fight the top fighters again. At the gala. Then you’ll see some moves.”
Pilot: “Well someone’s excited. Unfortunately, it’ll be a while before we make it all the way back to the Center of the Universe. We traveled pretty far for that vacay.”
Cotu: “It was worth it though.”
Said in a way that could be interpreted as a quick insert, but also as a foreboding line hinting at some hidden reason why the vacation was worth it
Cotu: “But…I don’t know if I’ll have enough time to get back to full strength by the time we get there. I’ll have to train hard along the way.”
Pilot: “We’ll do our best to help in any way we can, just give us the word!”
Cotu: “*sigh*...I love you guys.”
Pilot: “Oh stop, you’ll make me blush.”
Cotu: “Where are the others anyway?”
Pilot: “Oh, they’re still working on that training dummy I requested, but they should be done soon.”
Cotu: “Where is it?”
Pilot: “It’ll be in the big spare room to your right.”
Cotu enters the room and sees Greg and no name getting attacked by the dummy. Chaos ensues. Possibly Cotu (the player) steps in to help
…
The dummy is eventually contained
Greg: “All the stats’ll show up on the big screen. You can see your total damage dealt, damage per shot-”
No name bumps Greg’s arm.
Greg: “Huh? Oh damage per second, my bad. And uh, total number of hits. You can reset it with that button over there. And that’s pretty much it.”
X’s first scene: Cotu meets X for the first time since vacation
X wants to help Cotu train but is impatient to get to the gala early to train. He wants to get there early bc he doesn’t like his chances
Cotu is grateful for X’s patience and knows X isn’t the patient type
Cotu: “X.”
X: “Cotu.”
X floats towards Cotu, then they do their signature handshake
Cotu: “Thanks for waiting for me mate, I really appreciate it.”
X: “You better be grateful. I should be halfway to the gala by now.”
Cotu: “Damn, that early?”
X: “If you consider that early, you’re gonna be late. We need to get there early to have as much time as possible to train, especially with the Gauntlet. You know they’re going to be fully booked. Now, let’s not waste any more time.”
Cotu: “Right.”
X points to a diamond near the arena
X: “This is a timer. When the diamond closes,” X closes the diamond. “time’s up.” He reopens the diamond. “And when time’s up, I win.”
Cotu: “And why’s that?”
X: “Because that’s how long it takes for my ultimate attack to fully charge. And right now, you have no way of stopping it.”
Cotu: “Oh.”
X: “Of course, since we’re just training, I won’t actually use it, but in a real fight, if I were to get it…the fight would be over.”
Cotu, surprised: “...I didn’t know you had an ultimate attack.”
X does a brief, slightly confused sigh
X, a bit quieter than before: “I must not have used it in the tournament.”
X, back to normal: “Now, is everything clear? Are you ready?”
Cotu: “Erm, you’re gonna hold back right? I’m not as strong as I was.”
X: “Ugh. So needy.”
X holds a glowing orange ball in his hands, then throws it into the sky. It grows into a mini-sun
X: “That,” pointing to the star, “is roughly 60% of my power.”
Cotu: “So you’re fighting me with a full 40? You know I can’t take that.”
X’s face ignites. “I DON’T GIVE A SHIT.”
Cotu: “Alright then. I guess I’m ready.”
X: “Finally.”
Idea: Cotu and X on the ship
Cotu: “Hey, I just realized you’re not doing your teleporting tricks. You really do give a shit.”
X: “Enjoy it while it lasts. At the gala, I’ll use everything.”
Idea: X departs
X: “You know…it pains me. Seeing you this weak, knowing what you’re capable of…”
X collects himself for a moment: “If you’re not back to full strength by the time the gala begins,” X’s face ignites. “I swear, I will hurl you a hundred light years into the void.”
X teleports out
The Gauntlet and Blackstar
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
EG: “[current upgrade name]. Already? Damn.” She sounds like a mixture between impressed and sad
Cotu: “Is something wrong?”
EG *shakes her head*: “No. Not at all. It’s…impressive how fast you’ve…made it this far.”
Cotu: “Thanks.” Cotu senses something’s going on, but he’s not sure what. “But I’ve still got a long way to go.”
EG: *sighs in relief* “Yeah.” *she looks at Cotu* “I’ll send this info to Master. Thank you for showing us this.”
Cotu: “Of course.”
EG: “Whatever you need, the Gauntlet will be right behind you.” She salutes to him
Cotu nods. “See you at the gala.”
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
Ending ideas:
Sad ending: the player doesn’t beat Blackstar
Cotu is apologetic
BS is sad but tries to look resilient and optimistic in front of Cotu
She reminds him that the gala’s mostly just for fun, so she tells him to go have fun
The triplets reassure Cotu that he did his best
Since most Gauntlet reincarnations happen immediately after one of their bodies is destroyed, Blackstar destroys herself in numerous ways numerous times before the next tournament, which she then loses surprisingly early. The Gauntlet still tries to help other competitors but gets phased out since everyone else’s strength outclasses it. It gets sidelined
Good ending: either the player beats or doesn’t beat Blackstar and she does or doesn’t reincarnate. Regardless, she doesn’t pressure herself anymore
BS asks Greg if he wants to hang out sometime
Things that stay the same regardless of ending
X still struggles to find satisfaction in life, so he decides to travel with the triplets and help them find their realm while he figures things out
His struggle is that his goal is to win the tournament, but he just isn’t strong or smart enough
Plot Idea 3B: Trip to the Gala B
Same as Plot Idea 3A, but with some major changes
The general concept is the same: Cotu trains with others in his weakened form to get strong enough to fight in the exhibition gala, the last casual combat event before the next tourney. Throughout the course of the game, he travels to the gala and eventually competes in it
After the tourney, Cotu lost his power naturally as a function of his body instead of on purpose
Why would Cotu get rid of his own powers without pressure from Mike? It doesn’t make sense for Mike to pressure him bc Blackstar would defend Cotu’s actions
The triplets don’t travel with Cotu to the gala
There’s now a contrast between the dark desolate nothingness and danger of the pre-gala journey and the fun of the gala
The triplets are now a reward for making it to the gala instead of an accompaniment useless to the story
The triplets and X playing cards is still possible, and it makes more sense here bc it’s a social event
The player has a limited amount of time, not time+stabilizers, to get to the gala. At the gala, the player can use the remaining time to do practice fights with gods before the real fights
Stabilizers are no longer a precious resource usable by everyone; they’re a powerful tool exclusive to Cotu, which simplifies lore and eases player comprehension
Inspired by long-term time management from Persona 5, where the player must balance using the time for IRL vs in-palace progression
(If within scope) Cotu can meet Clarity along the way, and Cotu wants to get Clarity to the gala before she melts so that she can make new friends. The player must now balance getting Clarity to the gala quickly and spending time pre-gala getting stronger. Unbeknownst to Cotu (and the player on the first run), getting Clarity to the gala saves her life
Making companion characters other than Clarity is probably not worth the time and effort
At the gala, he fights at least the following 2 gods:
Tempered X, who wants to show the universe what he’s achieved
Blackstar, who wants to prove that she’s ready for the tournament by fighting the champion
Jester? Would be fun but can remove if out of scope
Microwave possibly makes a surprise appearance? Maybe as a bonus event as in this timeline, Blackstar is the rank 2. Microwave was disqualified for making a deal with the Creator: incredible power in exchange for a tiny chance to critically malfunction
On the trip, gods fight Cotu for various reasons
Cotu asks the Gauntlet to train him, and they love fighting and helping others
X fights to help Cotu get stronger before the gala
Clarity’s body and realm are autonomous and attack anything that gets near them
Triplets fight Cotu for fun
(an idea for now) Mites are wild animals that want to spread and conquer (although they’re treated like fully sapient gods by other characters)
(an idea for now) Future Blade wants to kidnap/sabotage Cotu to prevent him from fighting in the tourney
Grow-a-gator helps Future Blade because he likes chaos
Angels just want to play catch
Some want the privilege of fighting the champion
Some weaker gods are more motivated now that he’s closer to their level
Character interactions that are the same regardless of plot
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
X: *leans forward* “I will hurl you five hundred light years into the void.”
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
Greg: “I’ve been doin’ some training with no name.” Greg bounces on his feet, prepping himself. “Ready?”
Cotu: “Yep.”
Greg: “Alright! Take THIS!”
Greg winds up a huge right cross, then hurls it right into Cotu’s face. The punch is strong, but imperfect, slightly clumsy. Cotu reels back a bit and loses about 15-20% of his stability
Cotu: “Urgh, not bad.” He takes a second to recover. “Now, my turn.”
Greg: “Alright, champ, show me what you got.”
Cotu steps back a few steps and crouches down, then runs to Greg as Greg worriedly tenses up. Cotu delivers a massive straight punch from below directly to Greg’s jaw. Greg’s head is knocked back a bit, but his feet remain planted.
Greg: *quickly and genuinely* “Ooh I think that stung a bit.”
Cotu has a surprised expression on his face. He looks at Greg’s face, then to his own fist. After a brief delay, his fist cracks, sending streaks up his arm and dealing about 33% of his stability
Cotu: “Argh!”
Greg: “Oh crap!”
Cotu’s streaks disappear as he naturally heals the damage
Greg: “Welp. I guess your vessel’s not really meant for hand-to-hand, huh.”
Cotu: “Guess not, but I wasn’t expecting it to be this weak….”
Greg: “...my bad, dude. I shouldn’t have let you try it.”
Cotu: “No. I’m bad.”
Greg and Cotu chilling
Greg and Cotu chilling during the gala
Cotu: “Hey Greg.”
Greg: “What up?”
Cotu: “You and Pilot picked your own names, right?”
Greg: “Heck yeah we did.”
Cotu: “Out of all the names in the universe, why’d you settle on the name ‘Greg’”?
Greg: “Simple. It was either that or Josh, and there was no way I was gonna be Josh, so it had to be Greg.”
Cotu: “...er, why were those the only 2 options?”
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
Pilot: “Sure thing, captain. What seems to be the problem?”
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
Jester calls Greg “weirdly attractive” in an offhand comment in her usual antics, then reverts back to her true form (codenamed “Tripty” for now) in private
Tripty leans her back to the wall and puts her hands on her forehead: “...why did I say that shit…”
Tripty slides down the wall and sits against the corner. “I’d be surprised if he showed up to the lab again.”
The next day, Greg shows up
…
Idea: Greg meets Jester’s true form
Jester is tired and doesn’t want to maintain her funny form, but doesn’t want Greg to see her in her true form because she thinks her true form is cringe, unattractive, and unfunny
Greg likes to make new friends, so he wants to befriend Tripty, but he’s also wary that she could be an intruder
Greg is unusually early for his session with Jester and shows up unannounced. He’s surprised to see a stranger in the lab
Greg: “Huh?”
Tripty’s voice cracks: “Wah!”
Greg stares at her inquisitively. “oh sup. Have we…met before?”
Tripty, assertive: “NO.”
Greg stares blankly for a moment, then snaps back into his relaxed confidence. “Then hey, I’m Greg. I help out around the lab.” He extends his hand.
Tripty looks at his hand, confused whether it’s an open hand or closed fist. She cautiously pats it.
Greg: “How ‘bout you?”
Tripty glances around and backs away slowly, accelerating a bit over time. “Prefer not to say. In fact, pretend I was never he-ugh-” she bumps into a desk, causing her to fold forward clumsily in shock and make a funny noise
Greg chuckles lightly and raises an eyebrow . “So what are you, a thief?”
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
Tripty: “I’m just rusty, give me a second!” She starts fidgeting and shifting around, trying to find any shred of magic and failing miserably. Her expression brightens subtly as she comes up with an idea. She approaches Greg and reaches into the air in front of him, pretending to cast a spell. She’s embarrassed and blushing and internally begs that Greg is fooled
Greg looks down at her hand, then around the room. “Did something happen? I didn’t see.”
Tripty looks up at Greg and stares at his face. She’s closer to him than she’s ever been before as Tripty. “It was…an invisible spell.”
Greg: “What did it do?”
Tripty: “I cast…the friendship spell! It makes the target friends with the caster, even if they don’t know each other at all!”
Greg is really confused. “So…we’re friends now?”
Tripty: “YES…and that’s why, I will run away and you won’t tell anyone I was here!”
Greg: “...okay?”
Tripty: “IT’S CONFIRMED!” She sprints out of the room.
Greg sits down on a lab stool and calmly ponders.
Shortly thereafter, Jester comes bouncing in.
Jester: “Gregory! What are you idling about for? I don’t pay you nothing to do nothing!”
Greg: “Sorry boss. A thief broke into the lab just now.”
Jester: “A thief? That’s impossible. No one gets into the lab without my permission.”
Greg: “Oh, so…you actually have another lab assistant?”
Jester: “Of course I do! In fact, one of them should have ended their shift just now. You might’ve seen a mopey-looking hobgoblin stumble her way out.”
Greg: “Hey, that’s no way to talk about your lab assistant.”
Jester: “What, you don’t agree? Have you seen her?”
Greg: “Yeah, she’s alright. Kinda cute, if I’m being honest.”
Jester looks confused for a second. “Hey! Don’t get distracted now, you bum, we got work to do!”
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
Mortal: “Titan of War….Can you hear me?
Microwave: “CAN I? YOU’D BEST WATCH YOUR TONE. I CAN HEAR THE BLOOD SLOSHING IN YOUR BODY, MORTAL. I CAN SEE IT FLOW THROUGH YOUR ARTERIES. THERE IS NOTHING YOU CAN HIDE FROM ME”
Mortal: “If that’s true, what am I thinking?”
Microwave draws several weapons on the mortal. “TELL ME WHAT YOU ARE THINKING, OR I WILL KILL YOU.”
…
Microwave meeting the dark revenger, a god who wants to torment Cotu
Revenger: “You hate the champion, just as I do.”
Microwave: “COTU IS ONE OF THE MOST SKILLED WARRIORS IN THE UNIVERSE, AND A MORALLY ADEQUATE PERSON. IF I DESPISE HIM VICIOUSLY, HOW DO YOU THINK I FEEL ABOUT USELESS SCUM LIKE YOU?”
Revenger: “...”
Microwave: “YOU DESERVE TO DIE, BUT YOU’RE NOT WORTH A SINGLE BULLET OF MINE.” *leaves*
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
Blazar and the Creator of the Universe
Start of Convo (Idea: this plays at the beginning of the game to explain the universe)
Blaze: “Creator?”
Creator: “Yeah, it’s me.”
Blaze: “How did you create the universe?”
Creator: “I opened up the universe simulation software on my computer, made a new project, aka, this universe, then I asked the AI copilot built into the software to make you guys.”
Blaze: “The gods?”
Creator: “Yup. You and the rest of the gods were AI generated.”
Blaze: “Huh, so that’s all it took...Why did you create us?”
Creator: *nervous blaughter* “I was wondering what I was going to tell you when you asked that question, but then I realized you’re not real and I don’t care about your feelings. The truth is, I just wanted to see you guys fight each other. There’s really nothing else to it. And I got what I came for, so…now, I guess…do whatever you want.”
Random Convo
Blaze: “Where did our languages come from?”
Creator: “I had this universe use the same languages as my universe so I could understand what y’all are thinking and saying. I also gave you guys the same slang, just for fun.”
Blaze: “...What’s your universe like, Creator?”
Creator: “...I don’t know. When I talk about “my universe,” I’m really only talking about my planet. It’s called Earth. I’ve lived here my whole life and will probably never leave. I’m not able to venture out into the stars like you all. My people and I, we observe the cosmos from a distance, but we don’t actually go anywhere. So I can’t really describe what it’s like to live in my universe. Compared to yours, my universe isn’t very interesting at all.”
Blaze: “...That’s not true.”
Creator: ?
Blaze: “Your universe, er, Earth, has history. Things happened to get you to where you are now. Something happened to get you to the point where you created my universe. Your people created languages and slang, and each word has its own history. My universe was just born. Nothing exists yet, and not much has really happened yet. Compared to my universe, yours is infinitely more interesting.”
Creator: “...”
Blaze: “I want to know everything there is to know about your Earth. Is there a way I can learn?”
Creator: “Yeah. We have this thing called the Internet. I can download it and publish it in this universe, but the download’s gonna take a while.”
Blaze: “...what’s a download?”
The Creator then downloads “Internet 1.0” onto Blaze’s universe, and now they have access to all Earth-related media
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
