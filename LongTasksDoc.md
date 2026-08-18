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

Snowflake Boss: Comet/Clarity
Design notes:
Final boss of the first half of the game. A pivotal opponent that gives Cotu a major movement ability
Idea: defeating Clarity gives player option of either flight/hovering (fast mvmt with locked altitude or limited altitude control) or high jump + double jump
Gateway boss between low-mid level grunts and insane planet destroyers
First instance of a god not being friendly and/or communicative towards Cotu
Thinks differently from all other gods you encounter
First (or one of the only) instance(s) of a god not caring about competition at all. Falls completely outside the spectrum of casual gym goer → tryhard athlete
In her base form, which is most of the time, she’s focused on a mindless, repetitive, cyclic task (e.g. feeding ice to her soul). She only fights you after you damage her enough to break her out of her work cycle, which is when her soul orders her to defend her realm and herself
Occasionally, her body experiences an “error” that helps you in some way (e.g. exposes a weak point)
These “errors” are her true self trying to break free from the cycle by hurting herself
Story:
Cotu is trying to cross the Great Void, but along the way he happens to encounter a stray comet on a collision course with the ship. Despite his evasive maneuvers, the comet seems to follow him, which is when he realizes it’s actually a realm. By the time he realizes it, it’s too late and he’s trapped in the realm’s raging blizzard. He attempts to contact anyone in the realm via wireless signal, but gets no response/noise. Cotu enters the realm to ask the god to stop the blizzard
When Cotu first enters the realm, he tries to call out to the god, only to realize he has lost the ability to speak. He also finds it difficult to put his thoughts into words. Every time the player dies, Cotu comments on how it’s harder and harder to think clearly. As the phases of the boss fight progress, Cotu’s thinking becomes clearer again. Cotu’s mental state mirrors Clarity’s
Phase 1: No speech, no thoughts
Phase 2: No speech, little to no thoughts
Phase 3: No speech, more complex thoughts
Final phase (victory): normal speech
At first, Cotu encounters nothing but a frigid snow wasteland in the dead of night with a heavy blizzard. The only light source is himself; the sky can’t be seen through the blizzard fog. Eventually, he encounters a collection of floating shards repeating a simple pattern of movement atop a giant hexagonal ice platform in the snow. He guesses that this is the realm’s god. He tries talking to it, but it doesn’t speak nor change patterns
The player must hit the shards to force the god to regenerate them, which is when it exposes its weak spot. The god occasionally switches between patterns
In Phase 1, the body is divided into separate parts. At the center and high in the sky is a creepy and chaotic spiky ball of shards, almost like a 3D snowflake. This houses Clarity’s soul. There are 7 grounded glowing orbs surrounding the soul: 6 glowing orbs far around the spiky ball and 1 glowing orb underneath it, which sits atop a giant hexagonal platform. The orbs are all blasting ice magic into the snowflake. The snowfall is heavy
Each of the orbs is a fragment of Clarity’s mind, and they are obedient slaves to Clarity’s soul. The soul tortures the orbs by draining their power for an unknown reason
As the fight progresses, the orbs rearrange themselves to get closer together (and form more human shapes), allowing Clarity to think more clearly
As the fight progresses, the orbs also get closer together to the soul, which represents Clarity accepting the bad parts of herself and becoming one whole
In phase 2, the orbs become the arm and dress shards and the giant hexagonal platform shrinks to become Clarity’s hat. The spiky ball sheds its layers to become the snowflake entity. The sky brightens up to a morning fog feel and the snowfall becomes normal
The soul recognized that it was in danger and temporarily ceased its torture to assemble its mind
In phase 3, the hat shrinks and folds inward, taking the appearance of a radially symmetric arrowhead/bird covered in pointed eyes, and the dress shards shrink and fuse to create a lattice-like mesh. The snowflake entity either becomes the platform she rides on like the Silver Surfer from Marvel, or a floating headdress behind her head. The sky becomes crystal clear, revealing stars and nebulas
In phase 3, ground is covered in ice, allowing Cotu to ice skate on it like Mario in Super Mario Galaxy 2
Cotu automatically moves in the direction the player last moved
Movement speed (including dodge speed) is increased
Idea: special dodge anim has Cotu soaring into the air, going higher than he usually does on a dodge
In Clarity’s final form (true Clarity), she becomes a tiny snowflake with an eye and finally gains the ability to speak
Line ideas:
“I have achieved true clarity. Did you play a part in this?”
If Cotu dies in any phase, the player starts the fight from phase 1 all over again
Represents self-hatred
In her base form, Comet’s soul constantly drains energy from her mind
As she progresses through her forms, she slowly brings the separate parts of her mind closer together, allowing her different parts to understand each other, which gives her humanity, intelligence, and perspective
Eventually, the two parts of her accept each other for who they are, and they agree to become whole
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
Clarity: “What’s more terrifying, is that I don’t have the strength to freeze you for your impudence.”
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
After testing, I don’t like how big the mvmt is for Backflip. It doesn’t feel like Clarity. She’s supposed to have slower, suspenseful mvmts broken up by sudden small outbursts, and when she does do full body mvmts, she should slowly accelerate into them, not go from stationary to full speed instantly like in the Backflip. This sudden acceleration implies that she has speed/mvmt capability that she should not have, and it makes her feel more like X than herself
After some more testing, I actually kinda like how the Backflip looks. Give it a while before coming back to the Backflip before making a final decision
My final decision is that Backflip does look good, but it doesn’t suit her character, feel, or gameplay
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
Rethink how Clarity’s combat should play out (highlighted so you can return to this later)
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
After testing, come back to the problems above and see if they’re still present → they are
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
Give dress shards med-to-high defense to communicate that it’s not optimal to hit the dress shards the whole time
Defense subtracts from hitbox dmg
My first idea for defense was to make it absorb a percentage of dmg taken instead of a constant, but then I realized it doesn’t make sense for defense to absorb a lot more damage for bigger hits
Dmg taken = max(hitbox dmg - defense, 1)
Additional particle and glow effects
Create long hexagon particles
Tiny snowflake particle burst (made it, but not sure I wanna keep it)
Snowflake entity stagger
Hexagon particles spawn periodically in a wide sphere around snowflake and slowly radiate out
Tiny snowflake particle burst
Change the above to just hexagon particles bursting out
Clarity head stagger
Hexagon particles spawn periodically in a wide sphere around snowflake and slowly radiate out
Tiny snowflake particle burst
Change the above to just hexagon particles bursting out
Dress shard normal hit
Glow effects (glow bright, then dim)
Particles (no more liquid splash, but snow/ice bits)
Snowflake link particles (or something else that shows that the snowflake has linked itself to a dress shard)
When a snowflake shard fully extends, a dot (“snowflake link particle”) appears at the tip of the shard. This dot travels from its spawn location to the front of its corresponding dress shard
Each dot is a node3D initially located at the position of its fully extended tip
In each telegraph anim, when a snowflake shard fully extends, the dot is set to visible and moved via position keyframes from its current location to its location on Clarity’s dress
OR an equivalent dot appears on Clarity’s dress at the same time as the snowflake dot. This solution is better bc when the snowflake dot is set to visible and it starts moving on the same frame, it’s hard to tell that the dot’s even on the snowflake in the first place
After implementing the above, the dots look weird and break immersion when they’re drawn in front of everything else. Even if they’re not drawn in front of everything else, they still don’t really communicate the link between the snowflake and the dress shards bc they appear and disappear (on both the snowflake and dress) too quickly for the player to really think about and understand what they’re supposed to mean, which makes them feel random
To mitigate how unnoticeable they are, perhaps change the highlight/outline color of the shards on both the snowflake and shards instead of using tiny hard-to-see dots
Give linked snowflake and dress shards a faint blue highlight, outline, or glow, which is much clearer than the tiny link particles
Make a shader material and put it on all dress shard meshes as a next pass (instead of the current cartoon shader)
In DressShard class, make a new link_to_snowflake_hit func. In it, set the link state and tween the shader parameters over time to make the outline materialize (increase opacity and shrink around the shard)
Also in DressShard class, make a new unlink_to_snowflake_hit func. In it, set the link state and tween the shader parameters over time to make the outline disappear (either expand the outline outward and make it disappear, or simply shrink it so it’s a subtle outline
Put shader material on snowflake shards
In the Clarity func (not the DressShard func) that links a shard to snowflake, also make the outline materialize on the corresponding snowflake shard
Update unlink all shards to dematerialize/shrink snowflake shards
Remove old link particles (but keep the stagger particles that come from hitting the snowflake)
Dress shard snowflake link hit (more particles)
Add a GPUParticles3D node to all dress shard link particles, and make the particles emit when stagger occurs
Dress shards also light up when snowflake link hit lands
After testing, I realized that it’s hard to tell that the dress shards take damage when the snowflake is hit bc when the player hits the snowflake, their camera is zoomed into the snowflake, so the dress shards are out of frame. To make matters worse, the player is probably also looking at/thinking about Clarity’s head/shoulder to know whether they’re in immediate danger of a slice, giving another reason to not look at the dress shards and thus not know that they take damage when the snowflake does. Perhaps it’s better to simplify things by making the snowflake simply link to Clarity’s health
On the other hand, the snowflake linking more and more shards as the telegraph anim progresses poses a unique and interesting challenge for the player; get greedy and damage more shards, or play it safe and stun the snowflake so that you’re safe from the next attack. Although it’s not easy to notice that the dress shards take damage when the snowflake is hit, there are 2 things that can help quite a bit with that: reduce the zoom in distance when aiming, and make a unique sound when the dress shards are hit by a snowflake link hit
Reduce the zoom in dist and make zoom in over-the-shoulder again like in The Legend of Zelda: Breath of the Wild
Regen shards’s likeliness of being chosen as an attack increases the more shards are destroyed
Note: since regen shards uses both the arms and dress shards, it should only be chosen when both the snowflake and main body are in neutral state, making regen shards even rarer (which is a good thing; it should happen rarely)
Regen shards is chosen by queue_arm_attack. In queue_arm_attack, a new attack_chances dict is made that contains the arm_attack_chances sfet in the inspector combined with a new local var regen_shards chance, which is determined by math and the regen_shards_max_chance set in the inspector
Regen shards chance is a number in range (0, regen_shards_max_chance). Each destroyed dress shard increases regen_shards_chance by ⅙*regen_shards_max_chance → regen_shards_chance = num_of_destroyed_shards * regen_shards_max_chance / 6
regen_shards_chance is partially subtracted from every chance in arm_attack_chances → for attack, chance in arm_attack_chances, make a new entry in a new attack chances dict (“all_chances”) where all_chances[attack] = chance - regen_shards_chance / float(arm_attack_chances.size())
After the for loop, new attack chances[“RegenShards”] = regen_shards_chance
Regen shards chance is being calculated directly, but all chances ends up adding to > 1. Why is this?
Turns out I forgot to remove RegenShards from arm_attack_chances. arm_attack_chances isn’t supposed to contain it under this new system
Before working any further on RegenShards, re-examine the relationship btwn the snowflake, head, and dress, and consider whether everything makes sense. Also fill in any gaps in knowledge
Hit snowflake to damage dress shards and stop dress shard attack (+ slight Clarity damage)
Hit head to damage Clarity herself and stop arm attack
Why is the damage received from the snowflake and head inconsistent? Currently, it’s because the snowflake is used primarily to damage dress shards, which leads to RegenShards, which allows the player to attack the head. Instead of being its own hurtbox for Clarity, it leads to Clarity’s head hurtbox. → Okay, so why does it damage Clarity at all? So the player doesn’t feel like they’re missing out on damaging Clarity by going for the snowflake. The player essentially gets constant progress on the boss healthbar regardless of whether they target the snowflake or head. This does create an additional source of dopamine/uptime, but it comes at the cost of being confusing and unintuitive during initial learning (“Why does hitting the snowflake also hit the boss? Bigger question, why does hitting the snowflake deal so much less damage than hitting the head? Should I be targeting the snowflake instead of the head?”), which would create a bad first impression of the fight and greatly reduce subsequent dopamine hits
Simplify the fight and emphasize the snowflake process (snowflake → dress shards → head) by removing snowflake’s damage to Clarity
What’s stopping the player from just using homing attacks on the head and snowflake? That’s the way the player’s been taught to deal with high targets thus far → nothing; the player should use homing attacks to hit high targets. However, I’ve only tested Clarity thus far with manual aim; do homing attacks break the balancing of the level? Let’s look at each case individually
Power throw → balanced bc it must be aimed and timed
Ax throw → balanced bc it’s mechanically equal (or almost equal) to power throw
Homing instant rethrow → test this (I’m leaning balanced bc you have to aim it to some degree) → it’s balanced bc it’s hard to time several instant rethrows in a row simultaneously while aiming
Currently, the homing instant rethrow doesn’t need to be aimed at all; it just autotargets the nearest target. Change it so that the enemy has to be within your aiming cone like mark placement, and make the targets get sorted by their proximity to the screen’s center (i.e. by the dot product of the cam to target vec and the cam fwd vec)
After implementing and testing, it turns out that homing instant rethrow is sensibly balanced for this fight, but not just because you have to aim it; it’s because you have to time it. Timing several instant rethrows in a row is difficult when you’re also concentrating on Clarity, the snowflake, and the enemies, so sustaining your instant rethrow chain until the snowflake is vulnerable and aiming the camera so that the snowflake’s in the center and thus most likely to be targeted is understandably difficult. Also, aside from easier aim, the biggest advantage homing attacks have over manual aim attacks is damage, but since the snowflake and Clarity’s head are only vulnerable for a single hit, any manual throw is at least as effective as a homing hit. This satisfies my goals for the gameplay; I didn’t want the player to fight Clarity the same way they’d fight any other aerial enemy (by using homing instant rethrow). I wanted the player to manually and carefully aim and throw, so the fact that manual aim is actually the most effective tactic here is the best case scenario for the gameplay I’m intending
Homing special → balanced bc you have to build up buffs and time a button press, and its damage <= the damage of a manual throw
In conclusion, the Clarity fight doesn’t need to be changed at all to nerf homing attacks bc manually thrown attacks are at least as effective as them
It’s difficult to determine what the snowflake will do during RegenShards, and it may be easier to visualize different options after implementing RegenShards non-snowflake functionality, so do that first
What will the snowflake do during RegenShards? One of its primary gameplay purposes is to (eventually) make the head vulnerable, so making the snowflake a target (and thus taking attention away from the head) seems counterintuitive. Should it do nothing during the regen? Or defend the head?
What is it required to do?
Not do its usual rotation, which would imply that a dress shard attack is coming
Idea: snowflake spawns ice sprites or shoots a snow plume at the target periodically
Make snowflake descend to ground and get stabbed by the arm shard
Stop facing the player
Move snowflake to the floor at Clarity’s center
Regen shards functionality (aside from snowflake anim during RegenShards)
Dress shards perform RegenShards anim
After looking at RegenShards again, it appears to have a sudden start, which doesn’t fit Clarity’s slow mvmt. Change the anim to have a slow start
Is it easier to recreate RegenShards in ClarityDressShards Blender project or make Clarity (aka ClarityArmMeshes in Godot) fully visible + make her dead shards invisible? I currently think the latter
Write func that makes ClarityArmMeshes visible but all dead dress shards invisible
RegenShards is only chosen as an arm attack when dress shard anim isn’t playing and snowflake is in neutral state
Snowflake is in neutral state when anim tree’s state machine playback’s get_current_node() == “RotateSlow”
Make RegenShards and Staggered share a new behav state: STOP
When RegenShards is chosen as an arm attack, behav state is set to STOP so that no arm attacks are chosen during the anim. Switch_to_stopped is not called since that calls the Stagger anim (for now)
RegenShards calls end_arm_attack at the end to switch back to circling
Make func to regenerate dress shards (calls regen func for each DressShards object)
Make sure snowflake doesn’t trigger a dress shards anim during RegenShards. Recall that snowflake anims are controlled automatically by tree transitions, not through code
Make snowflake do a temporary test anim during RegenShards. Replace this anim later
Shard visibility logic
Arm meshes becomes visible, but the shards in arm meshes corresponding to dead dress shards are kept invisible. At the same time, all dress shards die to become invisible (so they’re not seen stationary during the anim) and invincible
Why do dress shards need to be invincible? So that if a dress shard is destroyed during RegenShards, I don't have to make the corresponding shard in arm meshes become invisible. Note that this isn’t an issue if arm meshes is never visible
Arm meshes dress shards all become visible underground
At end of anim when Clarity returns to base pose, arm meshes dress shards become invisible and dress master dress shards regenerate (regen_dress_shards)
After implementing shard visibility logic, I think that having both arm meshes dress shards and dress master dress shards be visibly used in the same anim creates needless complexity. I think recreating RegenShards in the ClarityDressShards Blender project is simpler now. What is the new visibility logic? Dress shards regenerate underground → that’s it
Create RegenShards in ClarityDressShards Blender project → turns out this is super easy since the rigs are the same across both projects; simply use Append
Update the code and anim keyframes to use dress master dress shards
Update switch_to_stop so that it doesn’t play the arm stagger anim nor sets velocity. It only changes behav and look states. The on_head_hit func should call switch_to_stop, then play the arm stagger (and not set vel either; that should be done by the anim callback keyframes since it’s not related to state and related to visual mvmt). When RegenShards is chosen as an arm attack, the code should also call switch_to_stop
Head is continuously exposed until anim ends
Visual effects
Snow particles when shards penetrate into ground
Shader that makes shards glow brightly near ground level
Fix bug where a snowflake link hit can stagger the head
Snowflake hits no longer damage the head; this makes things simpler for the player bc now there won’t be the confusion of why snowflake hits also damage Clarity
Fix bug where dress shards have functional hitboxes and hurtboxes when destroyed
Toggle hurtbox collision by setting monitoring. You could have moved the hurtbox under the map like you do with mites when they die, but toggling monitoring to false is easier to code
Toggle hitbox collision by getting a reference to the hitbox in the hurtbox script, then setting the hitbox’s monitorable property
Add more depth to Clarity’s current basic attacks
Animate Dress Shards TripleShardSequence1 in Blender
Animate Snowflake TripleShardSequence1 in Blender
Import dress shards anim to Godot
Make dress shards anim keyframes
Import snowflake anim to Godot
Make snowflake anim keyframes
Add TripleShardSequence1 attack to snowflake attack chances
Move dress shard hurtbox, hitbox, and ground penetrate particles into shared parent node so that you don’t have to copy the same transform to all of them whenever the transform gets reset for some reason (when you imported the new ClarityDressShards, the hurtbox transform got reset, but not the hitbox)
The shared parent node will have the transform to move the hurtbox, hitbox, and ground penetrate particles from the center of Clarity's crotch to its dress shard. For now, these components have their own transforms which are identical (except ground penetrate particles are slightly lower than the center of the shard)
Ground penetrate particles each have an offset of -2.4 in the parent node’s y dir
Rework TripleShardSequence1 to differentiate it from DoubleShardSequence1
Add QuadShardSequence1
Single1 tests continuous awareness, Double1 tests precise positioning, Triple1 tests precise positioning from a weird angle, and Quad1 tests precise positioning/distancing
Animate snowflake entity and dress shards
Import anims and add them to moveset
Think about the fight’s story as a whole so you know how to create gameplay to tell the story. You already have the gameplay essentials: aiming, timing, target selection, precise positioning, and precise dodging; the remaining gameplay to make moving forward should be in service of the story
List all memorable moments/elements ranked by emotional power and logical sense
Cotu walks away after he believes he killed Clarity, only for true Clarity to call out to him as a tiny snowflake. They talk for a bit before Cotu forgives her and carries her to his ship
Player and Cotu are surprised that Clarity can talk and think, and feel sympathy for her
Player feels tension when Cotu initially hesitates to approach her, then relief when Cotu chooses to forgive her (or when the player gets the choice to forgive her)
Wouldn’t Cotu only have lost his patience if she killed him several times? What if Cotu defeated her on the first or second try? → Cotu isn’t mad that she killed him—he’s mad that she destroyed his ship and stranded him in her realm without communicating with him 
Clarity’s 2nd phase transforms into the 3rd: a more humanoid figure wearing a dress
Clarity’s 1st phase transforms into the 2nd: rather than a formless being with no mind, Clarity becomes a somewhat humanoid golem controlled by the snowflake eye
Cotu sees Clarity for the first time: a mysterious, formless being made of ice shards. Cotu is bewildered
3rd phase Clarity looking around, realizing she’s in her realm, and running away into the sky
Player is shocked that she has emotions and she doesn’t want to fight you anymore. Player feels surprise and sympathy
If she’s running away, what is the threat to the player in the 3rd phase? → When she creates her giant ice pillar, the goal can become getting to the ship while dodging and/or breaking falling ice chunks from the pillar → if Cotu and Clarity are moving in different directions in phase 3, how do we get the moment where Cotu meets true Clarity? What reason do they have to meet up again? Maybe the player can choose whether to fly to her in the ship or leave?
List story ideas that incorporate memorable moments
Clarity is primarily made up of 2 parts: a body, which stores her conscious mind, and a soul. Her soul initially has complete control over her body, but as the fight progresses, her soul grows closer and closer with her body, and they eventually unite into one being
Phase 1: soul drains energy from body
Phase 2: soul (snowflake entity) orders body to attack
Phase 3: soul and body attack together
Final phase: soul and body are united
Find the most engaging story idea from the list
Clarity unites her soul and body/mind to finally think clearly
Make snowflake control the arm
Idea: central eye’s glow now telegraphs the arm, not the dress shards. This has the added bonus of removing the redundancy of the dress shard attacks being telegraphed by both the eye glow and the rotation (why look at the rotation if you can look at the glow + shard outline animations?)
Issue: the glow flash when shards converge at the end of each shard seq telegraph anim is no longer possible, making the attack initiation anticlimactic
Idea: a hexagon icon appears on the snowflake’s face plate and grows and disappears to command Clarity to do a slice. A hexagon appears around the snowflake and shrinks to signify a slice is about to occur
During testing, make hexagon appear at the start of each slice anim
Implemented for:
RaiseRightSlice
LongSlice
RaiseLeftSlow (not RaiseLeftFast since that will be removed)
LeftSliceFromWait
After testing, make hexagon appear before the start of each slice anim; queue arm attack will play the hexagon anim, then the actual attack anim. Note that the hexagon anim must be part of the arm anim player, not the snowflake anim player since that’s playing a rotate or telegraph anim
Make PreArmSlice anim in Blender where nothing happens. Its duration matches the lifetime of the hexagon
Import anim to Godot and put hexagon startup anim in it
The above strategy doesn’t work bc it also requires setting arm anim keyframes, and if you don’t set them, the arm goes to the default pose. The hexagon anim cannot be part of the arm anim player.
Try making a separate anim player in snowflake entity meshes that only controls the hexagons
Make TriggerArmRaise and TriggerArmSlice anims
Make Clarity script call snowflake hexagon anims and wait for them to finish before performing arm actions
Make snowflake play different hexagon anims for LongSlice and RightSlice
Idea: snowflake controls the head to do head attacks
Snowflake can optionally play the TriggerArmRaise anim while the arm is already raised, which makes the head appear and infuse the arm with energy. Only after the head is raised can Clarity’s head be hit and staggered, preventing the snowflake from commanding another arm anim (the snowflake not commanding another arm anim while already happens in code)
First try adding this feature to RaiseLeft, as it doesn’t automatically lead to a slice
Make a copy of WaitRaisedLeft called InfuseLeft
Make a copy of LeftSliceFromWait called LeftSliceFromInfuse
Import InfuseLeft and in it, raise the head
Import LeftSliceFromInfuse and in it, lower the head
In wait raised left state, make Clarity choose between LeftSliceFromWait and TriggerArmRaise → InfuseLeft → LeftSliceFromInfuse
Then implement this feature on RaiseRightSlice by creating 2 new anims: RaiseRight, and RightSliceFromWait OR keep RaiseRightSlice as-is to simplify the fight. I decided on the latter bc now there’s 2 possibilities for each side raise: RaiseRight can lead to RightSlice or LongSlice, and RaiseLeft can lead to LeftSlice or Infuse → LeftSlice
Create shader effect for arm getting infused (and uninfused when Clarity gets staggered instead)
Create shader
Tween shader’s “glow_progress” property over time from 0 to 1 when Clarity infuses arm
Tween glow_progress back to 0 after slice
Make arm leave lingering snow DOT hitbox after an infused slice
Create basic infused slice hitbox scene
Spawn infused slice hitbox in infused slice anim
Add effects
Make ring mesh
Make cloud particles
Make ring appear both CW and CCW during the slice
Make leading edge of ring glow brightly as it forms
Make arm emit cloud particles while infused
Idea: snowflake progresses through shard sequences, and jump shot is at 6: Single → Double → Triple → Quad → ??? → Jump Shot
Will hitting the snowflake cause it to progress forward a sequence?
Ensures that the snowflake isn’t hard stuck at the same seq due to the player stunning it every time
Punishes the player for doing the right thing
I don’t like this idea bc it makes the snowflake feel too predictable
Figure out how to add Jump Shot to moveset
Make Jump Shot anim start from WalkLeft, not WalkForward
List all jump shot requirements to know how to implement it
Must be used sparingly
Must be difficult to deal with
Only usable when arm, dress shards, and snowflake are in neutral
All 6 shards must be present
List ideas that implement all requirements, then choose the best one
Jump shot is simply the snowflake shard sequence that uses all 6 shards
Arm, dress shards, and snowflake must be in neutral (which happens in about 1 of 3 snowflake attacks), and all 6 shards must be present (let’s say for the sake of making the jump shot guaranteed to occur, jump shot is only chosen immediately after regen shards), then there’s a ⅙ chance jump shot gets chosen
If a single jump shot is super powerful (or possibly permanently changes the fight, e.g. by adding a spire), then it wouldn’t be fair if multiple jump shots occurred in quick succession. Are the odds of this happening low enough for this idea to be fair?
Note: the situation I’m trying to gauge is that the player’s in the fight, and the jump shot just occurred. What are the odds that another one happens within n attacks?
AI prompt: There’s an enemy in my game called The Snowflake. It attacks after waiting a consistent time interval. It has 6 attacks to choose from, and each one has an equal chance of being chosen every time the snowflake attacks. One of these attacks is the jump shot. Every time the snowflake chooses to attack, there’s a ⅓ chance that certain conditions are met for the jump shot to occur; if these conditions aren’t met, the jump shot is removed from the attack pool before the attack is chosen. If the snowflake attacks n times, what are the odds that at least one of the attacks is a jump shot? Solve for n = 1,2,3,4,5,6

Fun fact: this was easily calculated by finding the chance that the jump shot never occurs in n attacks—(17/18)n—and subtracting it from 1
The chance of a jump shot being chosen in a single attack is ⅓ * ⅙ = 1/18
The highest chance that I was willing to tolerate for a jump shot occurring twice in a row was 1/50, but according to the table, the chance of that happening is actually 1/18, which is way too high. In just one more attack, the chance increases to ~1/9, then ~⅙ after.
Jump shot is chosen immediately after the first use of regen shards. This makes it feel like a story event: Clarity first meets you and tests your mettle with simple attacks, you beat that, she gets a newfound respect for your power and regens her shards, then she ups the ante with a jump shot, showing that she’s getting serious and using more powerful moves. Jump shot in this case is similar to the volcano dive X does halfway through phase 1
I like this for the story aspect, and it makes Clarity feel alive and feel like she’s making decisions. But is this the only time jump shot is used during the fight? I think it’s too cool to be used only once per fight; figure out other times when it’s appropriate to be used
With the first jump shot, Clarity shoots directly at you, creating a glowing spot on the ground where the shard lands. From this spot, a mysterious polyhedral entity (“the spawner”) slowly rises into the air, and the blizzard now centers on this spot instead of Clarity. This spawner constantly drops snow clouds that rapidly damage Cotu if he’s touching them
Clarity now orbits around the spawner, not you, from a far distance. She intermittently infuses her arm, then shoots it at the spawner, causing it to accelerate upward. Your goal is to stop Clarity from accelerating the spawner upward to make this phase last as long as possible, so that the next phases are as short as possible (or if you’re somehow strong enough, don’t start at all). She still uses her dress shards to attack you, but she uses different sequences in which the shards move more slowly in exchange for more range. They can also move in spiral patterns
Idea: this phase also introduces head shard attacks. The head can reveal itself and fire 2 triple shot attacks with tiny glowing blue projectiles
When the spawner is at its max height, Clarity regens her shards again, does a second jump shot, this time shooting at the spawner. This detonates (but doesn’t destroy) the spawner at the top of the spire, which sends ice projectiles flying everywhere and stops it from dropping snow clouds. After this jump shot, the blizzard goes back to being centered on Clarity
Idea: the spawner looks like a hexacontium 
The spire entity now spawns ice sprites while Clarity goes back to phase 2.1 (plus some additional attacks, e.g. infused slice, head shard attacks). Perhaps every time Clarity regens her shards, she jump shots the spire entity to send ice (and possibly a bunch of ice sprites) everywhere)
If using the head shard attack idea, Clarity also now shoots 6 shards per shot instead of 3
Idea: Clarity’s head can also amplify the natural snow falling from her head so that it covers a much wider area. As the head grows and the hat tilts up very slowly, the snowfall radius increases. To deactivate the snowfall, you must hit the head
Best idea: the idea immediately above. Jump shot is used after every instance of regen shards. It’s also used to transition from phase 2.1 to 2.2 (rising spawner)
Make JumpShot get immediately chosen after any use of RegenShards
Make snowflake’s JumpShot anim include both the telegraph startup and the actual JumpShot behavior so the JumpShot is the length of the telegraph startup + JumpShot anim (120 startup + 520 JumpShot length = 640 frames total)
In snowflake’s anim tree, make RegenShards (which is called Test for now since the anim doesn’t actually do anything visually) transition to JumpShot
Stop RegenShards anim in ClarityArmShards from bringing Clarity back to neutral
Make a func that starts the JumpShot anim in ClarityArmShards and all DressShards
Make snowflake’s JumpShot anim call the start_jump_shot_anim func
Ensure JumpShot returns Clarity to neutral
Code summary: Immediately after RegenShards, the snowflake anim tree goes to the snowflake's JumpShot anim, which contains both the snowflake telegraph with the tiny shards and the actual behavior of the snowflake during the entirety of JumpShot (actual behavior is yet to be decided). As a result, snowflake calls the func start_jump_shot_anim right when the JumpShot anim in ClarityArmShards and DressShardsMaster is supposed to begin. This func plays both anims in both objects. Afterward, ClarityArmShards, all DressShards and the snowflake return to neutral
Make phase 2.2: rising ice sprite spawner
Make sprite spawner (or sprite spawner effect meshes) in Blender
6 hexagons like the snowflake’s hexagon effect
Each hexagon starts with scale = 0, then after some num of frames, each hexagon grows one after another. After reaching max size, the hexagon shrinks down to nothing, then starts again. Hexagons also all rotate in different axes and directions on said axes, creating the illusion of a 3D shape made up of 2D shapes
Turn the above anim into a looping one
Spawner constantly looks at camera so that thin edges of the hexagons aren’t seen
Make spawner spawn from jump shot impact site if the jump shot is used for the first time
Remake anim where all hexagons grow from scale 0 and use it as the “appear” anim, then use an anim tree to immediately transition from the appear anim to the looping undulate anim
Make blizzard center on spawner instead of Clarity
Blizzard center is a node var that’s set to the ice sprite spawner when it spawns
When the blizzard closes in, it closes in around the blizzard center
Rename Clarity’s BodyLight to BlizzardLight, and make its size depend on the blizzard safezone radius
Clarity moves the BlizzardLight to the spawner’s position when spawner appears
Even as the spawner rises, the blizzard safezone area and light remain on the ground. The spawner has its own light
Idea: spawner visuals move up while the main node remains grounded. This way, Clarity can still simply set the target node to the instantiated inst node
Make spawner rise and grow over time
Use tweens to make spawner rise and grow
Make spawner’s omni light bright at first, then dim as it rises above the ground
Make Clarity orbit around and face her body twds spawner instead of target. Head behavior is undecided; try making her look at the target, then the spawner,  then choose what looks best → looking at spawner is best
Make Clarity orbit in a circular path around the spawner (or move toward the path if she isn’t there already)
Make Clarity long range dress shard attacks
Make brief outlines, then follow through with details
TripleShardSemicircleSequence1 (her left 3 shards spiral CW)
TripleShardSemicircleSequence2 (her right 3 shards spiral CCW)
QuadShardSemicircleSequence1
QuadShardSemicircleSequence2
TripleShardFanSequence1 (same as TripleShardSequence1 but shards spread out over time, move slower, and travel farther)
TripleShardFanSequence2
QuadShardFanSequence1
QuadShardFanSequence2
Long range dress shard attacks occurs after every snowflake interval instead of every 3 intervals
Make and import snowflake RotateSlow1Seg anim
Try making triple shard attacks faster than quad shard attacks
Make func keyframes for long range dress shard attacks and short snowflake interval
Import all new long range dress shard anims
TripleShardSemicircleSequence1
TripleShardSemicircleSequence2
QuadShardSemicircleSequence1
QuadShardSemicircleSequence2
TripleShardFanSequence1
TripleShardFanSequence2
QuadShardFanSequence1
QuadShardFanSequence2
Import short snowflake interval anim
Short snowflake interval
Make snowflake telegraph anims for long range dress shard attacks
Shards stick out more and move more slowly than in usual dress shard attacks
QuadShardFanSequence1
QuadShardFanSequence2
QuadShardSemicircleSequence1
QuadShardSemicircleSequence2
TripleShardFanSequence1
TripleShardFanSequence2
TripleShardSemicircleSequence1
TripleShardSemicircleSequence2
Snowflake uses telegraph anims for long range dress shard attacks
Make snowflake use code to select an attack instead of an anim tree since the anim tree would get way too crowded
Make the play_anim_all_dress_shards use the current snowflake anim as the attack string so you don’t have to put in the attack string as a parameter every time
Test the above code with original snowflake telegraph/dress shard anims bc they already have keyframes for the snowflake telegraph anims
Import all new snowflake anims and add functional keyframes to them
QuadShardFanSequence1
QuadShardFanSequence2
QuadShardSemicircleSequence1
QuadShardSemicircleSequence2
TripleShardFanSequence1
TripleShardFanSequence2
TripleShardSemicircleSequence1
TripleShardSemicircleSequence2
Spawner spawns cubes as it rises
Make spawner, not the environment, spawn ice sprites
Spawner drops snow as it rises
Snow DOT hitbox
Snow visual effect
Allow Clarity to use RegenShards during this phase
Issue: Clarity uses dress shard attacks so often that the following condition is essentially always true: Clarity’s dress shards are attacking, or the snowflake is telegraphing the next dress shard attack. She only chooses RegenShards on queue_arm_attack when this condition is true. 
Try allowing the snowflake (not just the arm via queue_arm_attack) to choose RegenShards as well
Make sure arm is neutral
Ensure that all current phase transitions and other triggers (e.g. first jump shot) happen through a formal structure and not just test code (e.g. jump shot manual trigger)
Only the first JumpShot spawns the spawner; use a flag for this
Clarity only does a JumpShot after RegenShards if circling the icon
Make and import snowflake RegenShards anim
Snowflake’s RegenShards anim calls a func that plays JumpShot unless Clarity is circling the spawner
Current task
Make Clarity spawner boost attack(s)
Idea: instead of infusing her arm and shooting it at the spawner, Clarity infuses her arm and uses it to create a tiny ringed planet that floats towards the spawner. The player must destroy it before it reaches the spawner, or else the spawner gets boosted
Effect idea: a bunch of lines appear and rapidly dart around to form 1 or more hexagonal shapes, then the hexagonal shapes start rotating and a planet grows inside them
Idea: spawner spawns 2 different cubes: linger cubes (lingering DOT hitbox) and burst cubes (high single hit damage but no lingering hitbox and lower health)
Animate snowflake in jump shot
Figure out what snowflake should do
Idea: snowflake rotates and hollows itself out to create a window for the arm shard to shoot through it
To fit Clarity’s attack theme of continuous large area coverage, try making her slices move much slower (except for infuse slice, which needs to be fast to make the ring)
I undid this change bc although slow attacks fit Clarity's theme of continuous area coverage, they remove the necessity to pay close attention to an element in the fight (Clarity's head before, snowflake now) to know when to dodge. With slow attacks, the player can simply react to the blade itself. Clarity doesn't just test the player's ability to weave through continuous area coverage; she tests their attentiveness and reaction speed as well
Consider making Frostbite incurable via stabilizer, which makes the fight feel scarier and unfair
Try adding a violently vibrating spinning planet thing in the middle of the infused slice ring so it’s more clear that it deals damage in the center
Make Clarity’s body shard always deflect projectiles (give it a heavy enemy collider)
Make Clarity’s hat deflect projectiles, but not bounce projectiles away when vulnerable
Idea: ice sprite rework
Ice sprites aren’t threatening at all. You can easily walk away from them to dodge their attack. I want the player to actually think about the ice sprites. I also want this fight to symbolize the power of ice: slow, creeping power that builds up over time until it’s overwhelming. Simple, but brutal and effective if left unchecked.
Core concept: ice sprites build up over time until they’re everywhere
Instead of being spawned in the blizzard, they’re spawned via projectile from a spire, a structure that spawns at the impact site of a jump shot OR a giant snowflake icon on the ground that appears at the site of a jump shot
An ice sprite starts out as a hopper, which behaves identically to the current ice sprite, except if the ice sprite is destroyed before it destroys itself, it doesn’t create the snow hitbox
If the ice sprite destroys itself, glowing snow particles slowly rise into the air, then settle at a point high up (around top of snowflake level or higher). At this point, the ice sprite fairy starts manifesting
The ice sprite fairy starts off as a glowing blue-white dot. It gets brighter over time, and right before it spawns, it plays a telegraph anim of some kind (e.g. a bunch of particles emitted or received). During this telegraph anim, if you hit the ice sprite fairy, it dies in one hit
When the ice sprite fairy fully spawns, it mostly just meanders randomly in Clarity’s vicinity and occasionally shoots fast projectiles that create a snow cloud just like the ice sprite explosion. It dies in 3 rose (or ax) hits, but right before it fires a projectile, it glows brightly, and when it glows brightly, you can hit it to kill it in 1 hit
Snowflake anim during RegenShards
Snowflake looks boring just lying there getting stabbed; try making a branching snowflake pattern form on the ground as it’s stabbed
Idea: make a big snowflake mesh in Blender, then use a shader to expand the visible area of the snowflake mesh starting from the center to outward. This expanding area is preferably a hexagon so the snowflake’s branches appear evenly
OR instead of lying on the ground, the snowflake goes to where the hat is and transforms, showing that it’s vulnerable
Snowflake invulnerability anims
Idea: make face plate spin on the y axis when hit by a projectile while invulnerable
Currently, this doesn’t work bc the face plate is right behind the central eye’s spikes. This could work if the central eye’s spikes could detach and move outward, allowing the face plate to spin
Add shrinking outline onto face plate when it’s vulnerable
Remove RaiseLeftSliceFast and RaiseLeftFast since Clarity must be commanded by the snowflake to move it quickly, and she shouldn’t infuse the arm just to lift it quickly
Make dress shards emit a sound when hit by a weapon and a different sound when hit by a snowflake link hit
Implement Phase 1
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
Implement Phase 3
Looks more like a person. Has a secretary bird-like face, a more feminine human-shaped chest, and a solid dress instead of dress shards. She has 1 arm with a cake-knife looking shard for a hand and maybe a long baggy sleeve made of icicles. She can use this to throw shards. Maybe she has shards orbiting around the back of her head
Idea: Comet form
The arena floor turns into ice so Cotu can skate on it. The air near the ground is filled with intense fog. The player must skate around until they find an icicle that acts as a ramp leading up into the sky (maybe these icicles are shot by Clarity all across the realm when she transforms into phase 3). The player must do this in order to see where and when Clarity will attack. Before she attacks, she is straight up a comet flying across the sky. Eventually, she runs into one of many floating glowing ice “stars,” which redirect her trajectory straight towards the target. The player must hit her with the ax to prevent her from landing and immediately freezing them
Idea: Spin
Like an ice skater, Clarity leaps into the air, tucks in her arm and dress shards, and spins rapidly while decelerating to a stop midair. All of her dress shards then fire out in all directions, land, and become ice sprites. She then dives straight down into the ground
Blizzard safezone shrinks to nothing if you take too long to defeat Clarity at the end of phase 2
Idea: occasionally, songbird-like ice creatures will fly onto Clarity and stare at the target. They all fly away when she attacks, but there’s a slight chance they fly away beforehand to explore around
Idea: Cotu can make snowballs and throw them with no stability cost (but making a snowball isn’t fast). Hitting an ice sprite with a snowball triggers its explosion
