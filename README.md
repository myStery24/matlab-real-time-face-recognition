# Real-Time Face Recognition Using AlexNet-Based Transfer Learning and Stochastic Gradient Descent with Momentum Optimizer
A MATLAB program that detects and recognises faces through the live webcam.

### Files
| Name                       | Description                                                                                                                                                                                                                                                                           |
|----------------------------|---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| Faces                      | A root folder for face images. Need to create this folder manually.                                                                                                                                                                                                                   |
| Faces\sub-folder           | A sub-folder inside the 'Faces' folder to store/save the collected face images. Need to create this folder and place all the face images in this sub-folder manually. I.e., Faces\Your Name will store all your face images and Faces\Name 2 will store another person's face images. |                     
| collect_faces.m            | Open webcam and capture 150 face images.                                                                                                                                                                                                                                              |
| examine_network_layers.mlx | A live script to examine the AlexNet layers.                                                                                                                                                                                                                                          |
| test.m                     | Run this file to test your trained network with the live webcam.                                                                                                                                                                                                                      |
| train.m                    | Run this file to train your network.                                                                                                                                                                                                                                                  |
| trainfaces.mlx             | A live script to test the training result.                                                                                                                                                                                                                                            |
| trainfaces_ex2.mlx         | Another live script to test the training result.                                                                                                                                                                                                                                      |
| license.txt                | A license document.                                                                                                                                                                                                                                                                   |

### Steps
1. Run **collect_faces.m** to capture 150 face images (You will get 0 - 149 images).
2. Create a folder named Faces.
3. Create a sub-folder to store your face images and place inside the folder named Faces. 
4. Repeat Step 3 if you are collecting more face images of different person.
5. Delete and remove undesirable collected face images.
6. Open **train.m** and look for the line ly(23) = fullyConnectedLayer(2), change the number 2 in the fullyConnectedLayer() function to the number of sub-folder you have. I.e., 12 folders, then fullyConnectedLayer(12) 
7. Run **train.m** to train a new network. You will get a trained network named **facenet**.
8. Run **test.m** to test the new network.

### References
| No. | Website                                                                                                             |
|-----|---------------------------------------------------------------------------------------------------------------------|
| 1.  | [Complete Face Recognition Project Using MATLAB by Knowledge Amplifier](https://youtu.be/BU4NHgxPyLE)               |
| 2.  | [Deep Learning Onramp](https://www.mathworks.com/learn/tutorials/deep-learning-onramp.html)                         |
| 3.  | [Acquiring a Single Image in a Loop](https://www.mathworks.com/help/imaq/acquiring-a-single-image-in-a-loop.html)   |
| 4.  | [Determining the Rate of Acquisition](https://www.mathworks.com/help/imaq/determining-the-rate-of-acquisition.html) |
