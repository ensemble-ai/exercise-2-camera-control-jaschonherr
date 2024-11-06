# Code Review for Programming Exercise 2 #
## Description ##

For this assignment, you will be giving feedback on the completeness of Exercise 2.  To do so, we will be giving you a rubric to provide feedback on. For the feedback, please provide positive criticism and suggestions on how to fix segments of code.

You only need to review code modified or created by the student you are reviewing. You do not have to review the code and project files that were given out by the instructor.

Abusive or hateful language or comments will not be tolerated and will result in a grade penalty or be considered a breach of the UC Davis Code of Academic Conduct.

If there are any questions at any point, please email the TA.

## Due Date and Submission Information ##
See the official course schedule for due date.

A successful submission should consist of a copy of this markdown document template that is modified with your peer-review. The file name should be the same as in the template: PeerReview-Exercise1.md. You also need to include your name and email address in the Peer-reviewer Information section below. This review document should be placed into the base folder of the repo you are reviewing in the master branch. This branch should be on the origin of the repository you are reviewing.

If you are in the rare situation where there are two peer-reviewers on a single repository, append your UC Davis user name before the extension of your review file. An example: PeerReview-Exercise1-username.md. Both reviewers should submit their reviews in the master branch.  

## Solution Assessment ##

## Peer-reviewer Information

* *name:* [Maxim Saschin] 
* *email:* [mnsaschin@ucdavis.edu]

### Description ###

To assess the solution, you will be choosing ONE choice from unsatisfactory, satisfactory, good, great, or perfect. Place an x character inside of the square braces next to the appropriate label.

The following are the criteria by which you should assess your peer's solution of the exercise's stages.

#### Perfect #### 
    Cannot find any flaws concerning the prompt. Perfectly satisfied all stage objectives.

#### Great ####
    Minor flaws in one or two objectives. 

#### Good #####
    A major flaw and some minor flaws.

#### Satisfactory ####
    A couple of major flaws. Heading towards a solution, however, did not fully realize the solution.

#### Unsatisfactory ####
    Partial work, but not really converging to a solution. Pervasive major flaws. Objective largely unmet.


### Stage 1 ###

- [x] Perfect
- [ ] Great
- [ ] Good
- [ ] Satisfactory
- [ ] Unsatisfactory

#### Justification #####
The position lock camera works fully as expected. The camera locks onto the vessel at the center of the screen and stays in this position while the vessel moves. The student has also properly added a cross that shows that the camera is locked onto the vessel. 

### Stage 2 ###

- [ ] Perfect
- [ ] Great
- [x] Good
- [ ] Satisfactory
- [ ] Unsatisfactory

#### Justification ##### 
The autoscrolling camera works mostly as expected, however I have noticed a potential major and minor flaw. Major flaw: The camera is moving the frame to the right while also moving the vessel to the right. As stated in the project description: "If the player is lagging behind and is touching the left edge of the box, the player should be pushed forward by that box edge." This means that the player should have to move in the rightward direction in order to stay ahead or keep up with the camera frame. The current implementation on the other hand, pushes the entire vessel, never allowing it to lag behind or require the pushing of the vessel. In essence, the vessel should not be moved in the right or left direction unless the user inputs that direction. Otherwise, the vessel should stay in its place while the frame moves to the right. Minor flaw: When pressing 'f' input to remove the outline border of the frame, the entire speed of the frame (camera) and vessel seems to increase to a super high velocity with the camera moving quickly in the rightward direction.

### Stage 3 ###

- [x] Perfect
- [ ] Great
- [ ] Good
- [ ] Satisfactory
- [ ] Unsatisfactory

#### justification ##### 
The position lock and lerp smoothing camera works entirely as expected. The player is able to move the vessel in a direction, ahead of the camera, and the camera catches up to the vessel at a smooth and consistent rate, not allowing the vessel to move out of the leash range. The student also correctly implemented a cross at the center of the screen to indicate that the camera is moving behind (slower) than the player/vessel. 

### Stage 4 ###

- [x] Perfect
- [ ] Great
- [ ] Good
- [ ] Satisfactory
- [ ] Unsatisfactory

#### justification ##### 
The lerp smoothing target focus (ahead) camera works entirely as expected. The player is able to press an input in a direction, and the camera moves in that direction, ahead of the vessel at a quicker rate and consistently stays in front of the vessel until the player input is disengaged. The camera also does not move too far ahead of the vessel (outside of leash range). The student also correctly implemented a cross at the center of the screen to indicate that the camera is moving ahead (faster) than the player/vessel. 

### Stage 5 ###

- [x] Perfect
- [ ] Great
- [ ] Good
- [ ] Satisfactory
- [ ] Unsatisfactory

#### justification ##### 
The 4-way speedup push zone camera has been fully implemented with no noticable flaws. The player can move freely within the inner box without the camera moving, when in between the inner and outer frame the speed ratio is applied to the camera logic to slightly move the camera in the direction the player is heading, and then the outermost frame (box) acts as a barrier so that the entire frame (with camera) is pushed when the player is traveling in that direction against the frame. In addition, the student has properly drawn the frames of both of these boxes to indiate where the barrier and zones are located in relation to the vessel. 

## Code Style ##

### Description ###
Check the scripts to see if the student code follows the Godot style guide.

If sections don't adhere to the style guide, please permalink the line of code from GitHub and justify why the line of code has infractions of the style guide.

It should look something like this:

* [description of infraction](https://github.com/dr-jam/ECS189L) - this is the justification.

Here is an example of the permalink drop-down on GitHub.

![Permalink option](../images/permalink_example.png)

Here is another example as well.

* [I go to Github and look at the ICommand script in the ECS189L repo!](https://github.com/dr-jam/ECS189L/blob/1618376092e85ffd63d3af9d9dcc1f2078df2170/Projects/CommandPatternExample/Assets/Scripts/ICommand.cs#L5)

### Code Style Review ###

#### Style Guide Infractions ####

* Line length - Some lines within the code [like the one linked here](https://github.com/ensemble-ai/exercise-2-camera-control-jaschonherr/blob/007024ead157d3f934a9d8134b9c25f4cfe0477b/Obscura/scripts/camera_controllers/look_ahead_lerp.gd#L84) exceed the recommended 100 characters limit for ease of readability. 

#### Style Guide Exemplars ####

* The structure used for setting up the [mesh_instance, immediate_mesh, and material in draw_logic](https://github.com/ensemble-ai/exercise-2-camera-control-jaschonherr/blob/007024ead157d3f934a9d8134b9c25f4cfe0477b/Obscura/scripts/camera_controllers/position_lock.gd#L21) is well-organized and consistently applied across different classes, making it easy to understand the flow.

## Best Practices ##

### Description ###

If the student has followed best practices as seen in the style guide lecture, then feel free to point at these segments of code as examples. 

If the student has breached the best practices and has done something that should be noted, please add the infracture.

This should be similar to the Code Style justification.

* [description of infraction](https://github.com/dr-jam/ECS189L) - this is the justification.

### Best Practices Review ###

Overall, there are not many Best Practices that the student has infracted upon. The code is easy to read and proper coding techniques are well represented across all files. The main thing that I noticed was a lack of comments in some areas that can cause confusion or unclearness for a code reader who is unfamiliar with the project. 

#### Best Practices Infractions ####

* [Lack of comments for complex sections](https://github.com/ensemble-ai/exercise-2-camera-control-jaschonherr/blob/007024ead157d3f934a9d8134b9c25f4cfe0477b/Obscura/scripts/camera_controllers/look_ahead_lerp.gd#L36) - The code could benefit from more comments, especially for complex calculations in the _process functions. Adding comments in these areas can clarify the calculations for the boundaries and speeds.

#### Best Practices Exemplars ####

* The student has committed many times throughout the submittion of their work which is a best practice

* [Comments like these](https://github.com/ensemble-ai/exercise-2-camera-control-jaschonherr/blob/007024ead157d3f934a9d8134b9c25f4cfe0477b/Obscura/scripts/camera_controllers/look_ahead_lerp.gd#L28) are very helpful to the reader when viewing the code and are considered best practices

