# ZLens : Zoom Lens for Precise Distant Object Interaction
<br>
## Description
<br>
The following demo includes the implementation of ZLens, a method for selection of objects at any distance in a 3D space, implemented in Godot 4 developed on the Meta Quest 3. 
ZLens is inspired by a combination of the standard Ray-Cast implementation for object selection, and the zoom features presented in SQUAD. 
ZLens addresses the imprecision of ray-casting at long distances and cluttered environments. By holding down the 'a' button our code creates a magnifying glass and switches from
the standard ray-cast to a cone-shape area originating from the user's controller. The release starts the process of computing the average position of selectable objects
within the cone-area, and selecting an appropriate position for a new camera to be created 90% of the distance between the user and this position. This new camera view is displayed using a viewport 
and screen, in which the camera faces in the same direction as the user's headset, and the window is a small distance in front of the user. The interaction operates as follows:
Once the window is created, the original ray-cast now acts as a selection of the window. Any movement in the controller while the ray-cast collides with the window is mapped to the
second camera's orientation, in which a second ray-cast originates from the center of the second camera. Pressing the trigger while the original ray-cast collides with the window, now also
selects with the second ray-cast. This allows for a simple selection mechanic that saves time and requires less precise motions from the user especially for objects at far distances or cluttered environments.
<br>
## Third Party Assets
<br>
Third party code includes the 3D coneshape. This collision object is used to detect objects within range. 
