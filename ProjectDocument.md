# Green Reaper #

## Summary ##

**A paragraph-length pitch for your game.**

## Project Resources

[Web-playable version of your game.](https://itch.io/)  
[Trailor](https://youtube.com)  
[Press Kit](https://dopresskit.com/)  
[Proposal: make your own copy of the linked doc.](https://docs.google.com/document/d/1qwWCpMwKJGOLQ-rRJt8G8zisCa2XHFhv6zSWars0eWM/edit?usp=sharing)  

## Gameplay Explanation ##

**In this section, explain how the game should be played. Treat this as a manual within a game. Explaining the button mappings and the most optimal gameplay strategy is encouraged.**


**Add it here if you did work that should be factored into your grade but does not fit easily into the proscribed roles! Please include links to resources and descriptions of game-related material that does not fit into roles here.**

# External Code, Ideas, and Structure #

If your project contains code that: 1) your team did not write, and 2) does not fit cleanly into a role, please document it in this section. Please include the author of the code, where to find the code, and note which scripts, folders, or other files that comprise the external contribution. Additionally, include the license for the external code that permits you to use it. You do not need to include the license for code provided by the instruction team.

If you used tutorials or other intellectual guidance to create aspects of your project, include reference to that information as well.

[Godot 4 — An Overview of Control Nodes | Easy UI (Tutorial)](https://www.youtube.com/watch?v=KfydpMuTBvA)

[Godot Control Node (UI) Masterclass](https://www.youtube.com/watch?v=5Hog6a0EYa0)

# Main Roles #

Your goal is to relate the work of your role and sub-role in terms of the content of the course. Please look at the role sections below for specific instructions for each role.

Below is a template for you to highlight items of your work. These provide the evidence needed for your work to be evaluated. Try to have at least four such descriptions. They will be assessed on the quality of the underlying system and how they are linked to course content. 

*Short Description* - Long description of your work item that includes how it is relevant to topics discussed in class. [link to evidence in your repository](https://github.com/dr-jam/ECS189L/edit/project-description/ProjectDocumentTemplate.md)

Here is an example:  
*Procedural Terrain* - The game's background consists of procedurally generated terrain produced with Perlin noise. The game can modify this terrain at run-time via a call to its script methods. The intent is to allow the player to modify the terrain. This system is based on the component design pattern and the procedural content generation portions of the course. [The PCG terrain generation script](https://github.com/dr-jam/CameraControlExercise/blob/513b927e87fc686fe627bf7d4ff6ff841cf34e9f/Obscura/Assets/Scripts/TerrainGenerator.cs#L6).

You should replay any **bold text** with your relevant information. Liberally use the template when necessary and appropriate.

## Minigame Lead (Christopher Phan)

We had a shared [Google Sheets](https://docs.google.com/spreadsheets/d/12mCzZi8sv8D7Ga9r-oDEVJ3HBns_-IhfT880fozEuVY/edit?usp=sharing) that had a list of minigame ideas. Many of these changed during development. Most of the minigames from this list involved using a mouse and interacting with the game through a UI instead of through controlling a character. The minigames that I implemented kept the core functionality of the minigames in the list, but I decided to make the player interact with the game through controlling a character to make the experience feel more like a game. I felt that if a lot of the games just used the mouse and didn’t have a character, it would feel like an online quiz and wouldn’t be as fun. I didn’t get the chance to implement every game in the list, but I focused on implementing the ones that I felt would be the most engaging.

### Minigame manager
The [minigame manager](https://github.com/chris-phan/ecs179-final-project/blob/b67a9534f8ce1002b99159326979195c9940da21/green_reaper/scripts/minigame_manager.gd#L1) retrieves [all the relevant data](https://github.com/chris-phan/ecs179-final-project/blob/b67a9534f8ce1002b99159326979195c9940da21/green_reaper/scripts/minigame_manager.gd#L89) from the minigame. The UI scripts [pull](https://github.com/chris-phan/ecs179-final-project/blob/b67a9534f8ce1002b99159326979195c9940da21/green_reaper/scripts/minigame_result_ui.gd#L42) relevant data from the minigame manager and [displays](https://github.com/chris-phan/ecs179-final-project/blob/b67a9534f8ce1002b99159326979195c9940da21/green_reaper/scripts/minigame_ui.gd#L71) it dynamically. The minigame manager also handles switching between the instructions and wager screen to the actual minigame and finally from the minigame to the result screen through [signals](https://github.com/chris-phan/ecs179-final-project/blob/b67a9534f8ce1002b99159326979195c9940da21/green_reaper/scripts/minigame_manager.gd#L27). All the minigames are kept in a list and [shuffled](https://github.com/chris-phan/ecs179-final-project/blob/b67a9534f8ce1002b99159326979195c9940da21/green_reaper/scripts/minigame_manager.gd#L51). Minigames are popped off the list as they’re played. When all the minigames are played, the list is recreated and shuffled again. The minigame manager relies on the minigame to contain all the relevant information necessary for the UI to display. To do this, all minigames inherit from a Minigame superclass. Then, [polymorphism](https://github.com/chris-phan/ecs179-final-project/blob/b67a9534f8ce1002b99159326979195c9940da21/green_reaper/scripts/minigame_manager.gd#L104) is used to treat all the minigames the same.

### Minigame Superclass
The [minigame superclass](https://github.com/chris-phan/ecs179-final-project/blob/b67a9534f8ce1002b99159326979195c9940da21/green_reaper/scripts/minigame.gd#L1) provides basic functionality, shared variables that are used by the minigame manager, and child nodes that must be present. Also, it provides functions that should be overridden. Some [methods are implemented](https://github.com/chris-phan/ecs179-final-project/blob/b67a9534f8ce1002b99159326979195c9940da21/green_reaper/scripts/minigame.gd#L84) and they’re used by the derived classes by invoking [super](https://github.com/chris-phan/ecs179-final-project/blob/b67a9534f8ce1002b99159326979195c9940da21/green_reaper/scripts/time_platforming_minigame.gd#L64). This is basically the bare bones of a minigame, and all minigames inherit from this class.

A minigame needs to contain the following [information](https://github.com/chris-phan/ecs179-final-project/blob/b67a9534f8ce1002b99159326979195c9940da21/green_reaper/scripts/minigame.gd#L26): a path to its scene, a name, a path to its image, instructions, tooltips for each difficulty, a list of relevant controls, and a payout multiplier. After the minigame ends, there’s a 2.5 second [timer](https://github.com/chris-phan/ecs179-final-project/blob/b67a9534f8ce1002b99159326979195c9940da21/green_reaper/scripts/minigame.gd#L39) before the results show up. This is done since we want to fully show the minigame player’s win/lose animation before switching to the result scene. Minigames also have to implement a [luck mechanic](https://github.com/chris-phan/ecs179-final-project/blob/b67a9534f8ce1002b99159326979195c9940da21/green_reaper/scripts/minigame.gd#L38) specific to its game. Players can only get [lucky once](https://github.com/chris-phan/ecs179-final-project/blob/b67a9534f8ce1002b99159326979195c9940da21/green_reaper/scripts/minigame.gd#L70) in a minigame. Luck is based on the player’s luck stat on the board. If the player has 30% luck, they have a 30% chance of being lucky in the minigame. See the individual minigames section below for a description of how luck impacts each game.

### Platforming Player
A better name for this would be minigame character since the minigames changed from being mouse oriented to all being character oriented. The character’s sprite has the following animations: fall, idle, kick, jump, land, lose, walk, and win. The jump, fall, and land animations are separated into 3 different animations to give more control over how they’re played. For example, the player doesn’t have to jump in order for the fall animation to start playing since they can walk off a ledge and start falling. Similarly, when the player transitions from the air to the ground, the land animation should play. These animations are controlled by the [animation tree’s state machine](https://github.com/chris-phan/ecs179-final-project/blob/b67a9534f8ce1002b99159326979195c9940da21/green_reaper/scripts/platforming_player.gd#L87). This was also leveraged to prevent the player from kicking while in the air. The character uses the command pattern. There’s a command for [moving left](https://github.com/chris-phan/ecs179-final-project/blob/b67a9534f8ce1002b99159326979195c9940da21/green_reaper/scripts/comands/platforming_player/platforming_player_move_left.gd#L1), [moving right](https://github.com/chris-phan/ecs179-final-project/blob/b67a9534f8ce1002b99159326979195c9940da21/green_reaper/scripts/comands/platforming_player/platforming_player_move_right.gd#L1), [jumping](https://github.com/chris-phan/ecs179-final-project/blob/b67a9534f8ce1002b99159326979195c9940da21/green_reaper/scripts/comands/platforming_player/platforming_player_jump.gd#L1), and [idling](https://github.com/chris-phan/ecs179-final-project/blob/b67a9534f8ce1002b99159326979195c9940da21/green_reaper/scripts/comands/platforming_player/platforming_player_idle.gd#L1). The majority of the player’s code is adapted from the character in the first exercise.

### Instructions and Wager UI
![Minigame UI Instructions](project_document_images/minigame_ui_instructions.png)
The instruction and wager UI uses a tab container to have an instructions and wager tab that the user can easily navigate between. This is important since our game revolves around wagering, so it’s helpful for the player to be able to go back and reread the instructions before selecting a difficulty and starting the minigame. The instructions screen has a picture of the minigame, the relevant controls, and instructions on how to play the game.

![Minigame UI Wager](project_document_images/minigame_ui_wager.png)
On the wager page, they can select a difficulty. If you hover over one of the difficulty buttons, it will display a tooltip that tells you what constraints are imposed by the difficulty. The buttons also change color when hovered in order to make it more obvious that they are buttons and also to subtly encourage the user to keep their mouse hovered over the button. This way, they’ll be more likely to figure out that hovering over the difficulty button shows you what to expect. The wagering is in increments of 1000. The minimum wager is 0 and the maximum is how much cash they currently have. The increase and decrease buttons can be held to increase it faster. Buttons in Godot don’t have a signal for a mouse click being held down, so the [trick](https://github.com/chris-phan/ecs179-final-project/blob/b67a9534f8ce1002b99159326979195c9940da21/green_reaper/scripts/minigame_ui.gd#L175) is to have a timer that counts down as soon as a mouse down event is triggered. When that timer goes down to 0, a [second shorter timer starts](https://github.com/chris-phan/ecs179-final-project/blob/b67a9534f8ce1002b99159326979195c9940da21/green_reaper/scripts/minigame_ui.gd#L201). Every time this second timer has a timeout, the wager will be increased and the second timer gets restarted. This repeats until a [mouse up event occurs](https://github.com/chris-phan/ecs179-final-project/blob/b67a9534f8ce1002b99159326979195c9940da21/green_reaper/scripts/minigame_ui.gd#L180). This interaction of holding down the increase or decrease button is intuitive for the user and makes it easy to quickly change their wager.

### Result UI
![Minigame Result UI](project_document_images/minigame_result_ui.png)
When the game is over, the user should be able to see the outcome. Showing everything at the same time could feel overwhelming and it also doesn’t feel as impactful. So, we have a delay between each stat which [staggers](https://github.com/chris-phan/ecs179-final-project/blob/b67a9534f8ce1002b99159326979195c9940da21/green_reaper/scripts/minigame_result_ui.gd#L94) how they’re shown.

A [tween](https://github.com/chris-phan/ecs179-final-project/blob/b67a9534f8ce1002b99159326979195c9940da21/green_reaper/scripts/minigame_result_ui.gd#L108) is used to show the players total amount of cash after the minigame. Showing the money accumulating makes the gain more impactful. And similarly, seeing the money decreasing, makes the loss more painful. When the tween finishes, [a button shows up](https://github.com/chris-phan/ecs179-final-project/blob/b67a9534f8ce1002b99159326979195c9940da21/green_reaper/scripts/minigame_result_ui.gd#L124) to exit the minigame.

Depending on the outcome, the minigame player has a [win and lose animation that plays](https://github.com/chris-phan/ecs179-final-project/blob/b67a9534f8ce1002b99159326979195c9940da21/green_reaper/scripts/minigame_result_ui.gd#L101). The character is shown after the player’s new cash is shown since we want the illusion of the character reacting to the outcome.

### Minigame Design
The intent behind wagering in minigames is to make the easy difficulties really easy and something that the player should be able to win each time. The payout for selecting easy is relatively low and the multiplier never exceeds 2. The hard difficulties are very challenging and the player isn’t expected to win each time, but the payouts are at least 3 times the original wager. We want to encourage taking risks, so the player only loses the amount they wager. In other words, the punishment for losing is the same, regardless of difficulty.

### Time Platforming
The Time Platforming games have the same [superclass](https://github.com/chris-phan/ecs179-final-project/blob/b67a9534f8ce1002b99159326979195c9940da21/green_reaper/scripts/time_platforming_minigame.gd#L1). The goal is to get to the heart sprite before the time runs out. The difficulties determine the amount of time you have. If the player runs out of time, they have a chance of being lucky. If they’re lucky, they [gain 3 additional seconds](https://github.com/chris-phan/ecs179-final-project/blob/b67a9534f8ce1002b99159326979195c9940da21/green_reaper/scripts/time_platforming_minigame.gd#L95). The payout is 1.25x for easy, 2x for medium, and 3x for hard. Since a timed platforming gaming is very general, we have many different versions that rely on the existing superclass framework. To [make a new platforming game](https://github.com/chris-phan/ecs179-final-project/blob/b67a9534f8ce1002b99159326979195c9940da21/green_reaper/scripts/time_platforming_minigame2.gd#L1), all you have to do is extend the superclass and change the image and scene paths. Then, you can define the difficulties. The original timed platforming game can be duplicated and the [camera can optionally be given a script](https://github.com/chris-phan/ecs179-final-project/blob/b67a9534f8ce1002b99159326979195c9940da21/green_reaper/scripts/pushbox_camera.gd#L1).

#### Timed Platforming Game 1
![Timed Platforming Game 1](green_reaper/assets/minigame_images/time_platforming_game_img.png)
The challenge is getting up through a very narrow space. Camera is locked in place and captures the entire level.

#### Timed Platforming Game 2
![Timed Platforming Game 2](green_reaper/assets/minigame_images/time_platforming_game2_img.png)
The challenge is doing many consecutive jumps in a row, if you mess up and fall, you get teleported back to the start. The camera is a [push box camera](https://github.com/chris-phan/ecs179-final-project/blob/b67a9534f8ce1002b99159326979195c9940da21/green_reaper/scripts/pushbox_camera.gd#L21) adapted from Exercise 2 and specialized for this level. It also lerps back to the player when they are teleported back to the start after touching a spike. This is done to make the sudden change in the player’s position less jarring.

#### Timed Platforming Game 3
![Timed Platforming Game 3](green_reaper/assets/minigame_images/time_platforming_game3_img.png)
There are two different routes the player can take. The route on the left is safe but slow. The route on the right is dangerous since touching a spike will cause you to go back to the start, but it is faster. The hard difficulty requires you to choose the risky path in order to win since the safe path is too slow. The stage is about getting to the bottom. You can see the immediate floor below you. Each time you clear a floor, the [camera lerps downward](https://github.com/chris-phan/ecs179-final-project/blob/70a917b7b2f7094186c4e4d9be61be966b503ba3/green_reaper/scripts/hlock_camera.gd#L31) to show the bottom of the next floor below you. The camera also [lerps back to the player](https://github.com/chris-phan/ecs179-final-project/blob/70a917b7b2f7094186c4e4d9be61be966b503ba3/green_reaper/scripts/hlock_camera.gd#L26) if they touch a spike.

#### Timed Platforming Game 4
![Timed Platforming Game 4](green_reaper/assets/minigame_images/time_platforming_game4_img.png)
The challenge is performing a max distance jump. The timing on this is really tight and hard difficulty gives you 2-3 attempts. The camera is fixed in place and shows the entire level.

For the 2nd and 3rd platforming games, since they are bigger than one screen width, there are arrows showing the player where to go to beat the minigame.

### Memory
![Memory Minigame](green_reaper/assets/minigame_images/memory_minigame_img.png)
The [memory minigame](https://github.com/chris-phan/ecs179-final-project/blob/b67a9534f8ce1002b99159326979195c9940da21/green_reaper/scripts/memory_minigame.gd#L1) shows the text of a color after each round. The player has to remember the previous colors and repeat the sequence in order. The added difficulty is that the text stays on screen for less than a second. And the font color of the text might not be the same as what the text is saying. For example, the player might be shown “BLUE” with a red font color. The difficulty changes how many rounds the player has to beat. The payout is 1.5x for easy, 2x for medium, and 5x for hard. There are 7 rounds for easy, 10 rounds for medium, and 15 rounds for hard.

### Internal Timer
![Internal Timer Minigame](green_reaper/assets/minigame_images/internal_timer_minigame_img.png)
The [internal timer minigame](https://github.com/chris-phan/ecs179-final-project/blob/b67a9534f8ce1002b99159326979195c9940da21/green_reaper/scripts/internal_timer_minigame.gd#L1) tests the player’s ability to keep track of time in their head. There’s a timer display that counts down. It starts at 10 seconds and counts down. When it reaches 7.5 seconds, the display disappears and the user has to count in their head. They have to stop the timer as close to 0 seconds as possible. The difficulty determines how much leeway the player is given over or under 0 seconds. For example, the Easy difficulty gives you 0.75 seconds above or below 0 seconds. If you stop the timer any time in between 0.75 to -0.75 seconds, you win. If the player is lucky, the timer display doesn’t disappear, so the player can see the timer the whole time. The tolerance is 0.5 seconds for medium and 0.15 seconds for hard. We learned that 0.15 seconds is perceived as instant for humans, but since there’s 0.15 seconds of leeway on either side of 0, there’s really a 0.3 second window, which makes it a little easier. The payout is 1.25x for easy, 2x for medium, and 3x for hard.

### Observation
![Observation Minigame](green_reaper/assets/minigame_images/observation_minigame_img.png)
The [observation minigame](https://github.com/chris-phan/ecs179-final-project/blob/b67a9534f8ce1002b99159326979195c9940da21/green_reaper/scripts/observation_minigame.gd#L1) is about counting the various moving objects. The objects move around for 10 seconds and then they disappear. The player then has to answer a question about how many of a particular object they saw. Each round, a new type of object is added and the minimum number of objects increases. The question can be about any of the objects in the round, so the player has to keep track of the number of each object. The difficulty determines how many rounds there are. The maximum difficulty, hard, has 3 rounds, and medium and easy have 2 rounds and 1 round respectively. The payout is 1.5x for easy, 2.5x for medium, and 4x for hard.




## User Interface and Input

**Describe your user interface and how it relates to gameplay. This can be done via the template.**
**Describe the default input configuration.**

**Add an entry for each platform or input style your project supports.**

## Movement/Physics

**Describe the basics of movement and physics in your game. Is it the standard physics model? What did you change or modify? Did you make your movement scripts that do not use the physics system?**

## Animation and Visuals

**List your assets, including their sources and licenses.**

**Describe how your work intersects with game feel, graphic design, and world-building. Include your visual style guide if one exists.**

## Game Logic

**Document the game states and game data you managed and the design patterns you used to complete your task.**

# Sub-Roles

## Audio (Christopher Phan)
The main source of audio comes from the [SFXPlayer class](https://github.com/chris-phan/ecs179-final-project/blob/b67a9534f8ce1002b99159326979195c9940da21/green_reaper/scripts/sfx_player.gd#L1). This is a singleton and is autoloaded. It contains sounds for game actions and the background music. Each sound is attached to an AudioStreamPlayer2D and has its volume tuned to work well with all the other sounds. Each sound is also added to a bus. There’s a separate sound effect and background music bus. This makes it easy to adjust the volume for all the sounds.

### Sound effects
Some sounds aren’t played through the SFXPlayer since it was easier to time the sound with an animation inside an AnimationPlayer. The PlatformingPlayer’s kick and land sound are played through an AnimationPlayer.

**Attributions**:
- [Kick sound](https://pixabay.com/sound-effects/soccer-ball-kick-37625/)
- [Land sound](https://pixabay.com/sound-effects/jump-landing-30946/)
- [License](https://pixabay.com/service/license-summary/)

Background music tracks are imported to allow looping, so they automatically repeat whenever they end.

### The following sounds use the SFXPlayer:
#### PlatformingPlayer’s Walk Sound
Called by the minigame player’s move left and right commands when they’re executed.

**Attributions**:
- [Walk sound](https://pixabay.com/sound-effects/walking-snow-31224/)
- [License](https://pixabay.com/service/license-summary/)

#### Button Click Sound
Plays for all the button clicks in the game.

**Attributions**:
- [Button Click](https://pixabay.com/sound-effects/button-press-40018/)
- [License](https://pixabay.com/service/license-summary/)

#### Number Increase and Decrease Sound
Since it plays for each increase and decrease, if there were only one AudioStreamPlayer2D and were played multiple times in quick succession, it would try to repeat the first few milliseconds of the sound. To get around this, a new [AudioSteamPlayer2D is dynamically created](https://github.com/chris-phan/ecs179-final-project/blob/b67a9534f8ce1002b99159326979195c9940da21/green_reaper/scripts/sfx_player.gd#L47) each time the sound is played. Then, this is added to the scene and is [removed](https://github.com/chris-phan/ecs179-final-project/blob/b67a9534f8ce1002b99159326979195c9940da21/green_reaper/scripts/sfx_player.gd#L50) using `queue_free` after the sound is done playing. The actual sound is a page flip, and is trimmed to only include a small part of the flip.

**Attributions**:
- [Number Increase/Decrease Sound](https://pixabay.com/sound-effects/book-page-flip-28603/)
- [License](https://pixabay.com/service/license-summary/)

#### Dice Roll Sound
The same trick is used for the [dice roll sound](https://github.com/chris-phan/ecs179-final-project/blob/b67a9534f8ce1002b99159326979195c9940da21/green_reaper/scripts/sfx_player.gd#L138) to handle quickly playing consecutive sounds. The sound is taken from a cork pop, and is trimmed to only include a small part of the pop.

**Attributions**:
- [Dice Roll](https://pixabay.com/sound-effects/cork-pop-35952/)
- [License](https://pixabay.com/service/license-summary/)

#### Countdown Sound
There are 2 sounds that are extracted from the original audio file, which contains many different countdown sounds. The first sound is for the countdown from 3 to 1. The second sound is a higher pitch and is used for the final “GO”.

**Attributions**:
- [Countdown](https://pixabay.com/sound-effects/countdown-beep-104007/)
- [License](https://pixabay.com/service/license-summary/)

#### Show Result
This uses a trimmed camera shutter sound and plays in a minigame result or event result screen.

**Attributions**:
- [Show Result](https://pixabay.com/sound-effects/film-camera-shutter-1-sec-272601/)
- [License](https://pixabay.com/service/license-summary/)

#### Heartbeat
This sound plays during the internal timer minigame after the timer is hidden from the player. Where in the audio file the sound starts playing and the `pitch_scale` is [randomized](https://github.com/chris-phan/ecs179-final-project/blob/b67a9534f8ce1002b99159326979195c9940da21/green_reaper/scripts/sfx_player.gd#L69) in order to make it harder to use the heartbeats as an audio cue for the internal timer game. This sound also starts playing in the timed platforming games when there are less than 3 seconds left.

**Attributions**:
- [Heartbeat](https://pixabay.com/sound-effects/heartbeat-02-225103/)
- [License](https://pixabay.com/service/license-summary/)

#### Correct Observation
Used in the observation minigame to signify that the answer was correct. Also used in the memory game to signify the next round.

**Attributions**:
- [Correct Observation](https://pixabay.com/sound-effects/training-program-correct1-105916/)
- [License](https://pixabay.com/service/license-summary/)

#### Correct Memory
Used in memory minigame to signify that the correct color in the sequence was picked. Edited and taken from an audio file with lots of menu select sounds.

**Attributions**:
- [Correct Memory](https://pixabay.com/sound-effects/menu-select-button-182476/)
- [License](https://pixabay.com/service/license-summary/)

#### Lucky
Plays in all the minigames when the player is lucky.

**Attributions**:
- [Lucky](https://pixabay.com/sound-effects/retro-coin-1-236677/)
- [License](https://pixabay.com/service/license-summary/)


#### Board Positive
Plays on the board whenever the player gets money or luck from landing on a space.

**Attributions**:
- [Board Positive](https://pixabay.com/sound-effects/arcade-ui-18-229517/)
- [License](https://pixabay.com/service/license-summary/)

#### Board Negative
Plays on the board whenever the player loses money or luck from landing on a space.

**Attributions**:
- [Board Negative](https://pixabay.com/sound-effects/classic-game-action-negative-3-224421/)
- [License](https://pixabay.com/service/license-summary/)

#### Board Move:
Plays on the board whenever the player goes past or lands on a space.

**Attributions**:
- [Board Move](https://pixabay.com/sound-effects/pop-268648/)
- [License](https://pixabay.com/service/license-summary/)

### Background Music:
There are 4 different tracks for the board. Depending on how much cash the player currently has, the background music changes. The first track is gloomy and depressing and then they progressively become more happy. This is done with respect to the narrative since the player is getting closer to escaping the Green Reaper and getting a second chance at life. The changes in music also align with the checkpoints’ cash thresholds.

All the background music tracks come from Youtube Audio Library. The license states:
<blockquote>
You can use this audio track in any of your videos, including videos that you monetize. No attribution is required.
<br><br>
YouTube may credit the artist and link the Audio Library from your video.
<br><br>
You may not make available, distribute or perform the music files from this library separately from videos and other content into which you have incorporated these music files (e.g., standalone distribution of these files is not permitted).
</blockquote>

### Board Tracks
#### Orbit - Corbyn Kites
Plays when the player has less than 250,000 points.

**Attribution**:
[Orbit](https://www.youtube.com/watch?v=eX4AB8P0BfQ)


#### Called Upon - Silent Partner
Plays when the player has between 250,000 to 499,999 points.

**Attribution**: [Called Upon](https://www.youtube.com/watch?v=viRJOYHF7b4)


#### Icelandic Arpeggios - DivKid
Plays when the player has between 500,000 to 749,999 points.

**Attribution**: [Icelandic Arpeggios](https://www.youtube.com/watch?v=pxoq8jEGbBo)


#### Clean Living - Everet Almond
Plays when the player has 750,000 points or more.

**Attribution**: [Clean Living](https://www.youtube.com/watch?v=ZkTDCOmT-qw)

### Events
When the player enters an event, the background music from the board continues playing since they’re still considered to be on the board. Once they go into a minigame, the music changes to convey a transition.

### Minigame Tracks
In the narrative, the minigames take place in the Green Reaper’s special dimension where everything is in black and white. I wanted it to feel peaceful and calm to not distract the player. I also thought that it would be interesting to juxtapose the intensity of wagering cash which is essentially the equivalent of your in-game life on difficult minigames while a chill song is playing in the background as if this happens all the time. All the minigames use the same track. When the minigame ends, depending on the outcome, a track is selected. If the player wins, a happy song is played, and if the player loses, a sad song is played. This carries into the result screen to make the transition feel seamless.

#### Sunday Drive - Silent Partner
Plays during all minigames.

**Attribution**: [Sunday Drive](https://www.youtube.com/watch?v=T8Ay7Xz0mEQ)


#### Every Step - Silent Partner
Plays when the player loses the minigame.

**Attribution**: [Every Step](https://www.youtube.com/watch?v=_WfmldfpkKE)


#### Shadowing - Corbyn Kites
Plays when the player wins the minigame.

**Attribution**: [Shadowing](https://www.youtube.com/watch?v=aqsIy0YRZXA)



## Gameplay Testing

**Add a link to the full results of your gameplay tests.**

**Summarize the key findings from your gameplay tests.**

## Narrative Design

**Document how the narrative is present in the game via assets, gameplay systems, and gameplay.** 

## Press Kit and Trailer

**Include links to your presskit materials and trailer.**

**Describe how you showcased your work. How did you choose what to show in the trailer? Why did you choose your screenshots?**

## Game Feel and Polish

**Document what you added to and how you tweaked your game to improve its game feel.**