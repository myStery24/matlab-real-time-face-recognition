# Real-Time Face Recognition Using AlexNet-Based Transfer Learning and Stochastic Gradient Descent with Momentum Optimizer
A MATLAB program that detects and recognises faces through the live webcam.

<img src="https://github.com/myStery24/matlab-real-time-face-recognition/blob/3c2125271529485f046782be350e2f2e3235ec8d/App.png" width="400" height="400" alt="Real-time face recognition GUI" title="Real-time face recognition GUI">

### Folder and Files
| Name                                | Description                                                                                                                                                                                         |
|-------------------------------------|-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| AuthorImages                        | Images of authors/contributors of this image processing group project.                                                                                                                              |
| Faces                               | A root folder for face images. This folder will be automatically created during the process of taking face images.                                                                                  |
| Faces\[sub-folder-name]             | A sub-folder inside the 'Faces' folder to store/save the collected face images. I.e., 'Faces\Your Name' will store all your face images and 'Faces\Name 2' will store another person's face images. |
| Icons                               | Images of icon to decorate the buttons.                                                                                                                                                             |
| TestCode                            | All the source codes before merging into the MATLAB App Designer.                                                                                                                                   |
| TestCode\collect_faces.m            | Open webcam and capture face images.                                                                                                                                                                |
| TestCode\examine_network_layers.mlx | A live script to examine the AlexNet layers.                                                                                                                                                        |
| TestCode\test.m                     | Run this file to test your trained network with the live webcam.                                                                                                                                    |
| TestCode\train.m                    | Run this file to train your network.                                                                                                                                                                |
| TestCode\trainfaces.mlx             | A live script to test the training result.                                                                                                                                                          |
| TestCode\trainfaces_ex2.mlx         | Another live script to test the training result.                                                                                                                                                    |
| facenet.mat                         | The newly trained network (Not provided in this file as you need to train and generate your own network).                                                                                           |
| credits.mlapp                       | Build the credits UI in MATLAB App Designer.                                                                                                                                                        |
| creditsGUI.m                        | Exported from credits.mlapp                                                                                                                                                                         |
| faceRecognition.mlapp               | Build the application UI in MATLAB App Designer.                                                                                                                                                    |
| faceRecognitionGUI.m                | Exported from faceRecognitionGUI.mlapp                                                                                                                                                              |
| license.txt                         | A license document.                                                                                                                                                                                 |

### Steps
1. Run the **faceRecognitionGUI.m** in MATLAB.
2. Click the Capture Face Image button to capture 500 face images (You will get 0 - 499 images). The face images are saved in a separate folder under the root folder Faces.
3. Repeat Step 2 if you are collecting more face images (more than 1 person).
4. Click the Train Model button to train your network. Wait for this process to finish.
5. If you are satisfied with the training result, click the Begin Face Recognition button to test your newly trained network.
6. If you would like to retrain the network, repeat Step 2 - Step 5. (Note: facenet.mat will be OVERWRITTEN, SAVE the file in somewhere else before proceeding).
7. Click the File > Exit to exit the application/program.

## Change Log
**7/22/2022**
- Updated folders and files.
- Release v0.1.0 Beta.

**5/10/2022**
- Start the project.
- Release v0.0.1.

### References
| No. | Website                                                                                                             |
|-----|---------------------------------------------------------------------------------------------------------------------|
| 1.  | [Complete Face Recognition Project Using MATLAB by Knowledge Amplifier](https://youtu.be/BU4NHgxPyLE)               |
| 2.  | [Deep Learning Onramp](https://www.mathworks.com/learn/tutorials/deep-learning-onramp.html)                         |
| 3.  | [Acquiring a Single Image in a Loop](https://www.mathworks.com/help/imaq/acquiring-a-single-image-in-a-loop.html)   |
| 4.  | [Determining the Rate of Acquisition](https://www.mathworks.com/help/imaq/determining-the-rate-of-acquisition.html) |
