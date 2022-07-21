%% Use the trained network to classify images

clc;
close;
clear;

% Set up the Acquisition Object
mycam = videoinput('winvideo','USB Camera','MJPG_1280x720');

% Configure the object for manual trigger mode
triggerconfig(mycam,'manual');

% Configure the number of frames to log
mycam.FramesPerTrigger = 180;

% Skip the first few frames the device provides
% before logging data.
mycam.TriggerFrameDelay = 3;

% Access the device's video source
src = getselectedsource(mycam);

% Determine the device specific frame rates (frames per second) available
frameRates = set(src, 'FrameRate');

% Configure the device's frame rate to the highest available setting
src.FrameRate = frameRates{1};
actualRate = str2num( frameRates{1} );

% Now that the device is configured for manual triggering, call START.
% This will cause the device to send data back to MATLAB, but will not log
% frames to memory at this point.
start(mycam)
preview(mycam)

load facenet;
faceDetector = vision.CascadeObjectDetector;

% Measure the time to acquire 180 frames
tic
for i = 1:180
    % Take a snapshot from the webcam
    e = getsnapshot(mycam);
    bboxes = step(faceDetector,e);
    painter = insertObjectAnnotation(e,'Rectangle',bboxes,'Face');


    if(sum(sum(bboxes)) ~= 0)
        % Adjust input images
        face = imcrop(e,bboxes(1,:));
        face = imresize(face,[227 227]); % The AlexNet network needs an image input size of 227-by-227
       
        % Use our pretrained AlexNet (loaded as the variable mynet) to classify the contents of all the images in the data set
        % Note that the classify function will be running many images through AlexNet
        % It may take a few seconds to execute
        label = classify(facenet,face);

        imshow(painter);
        image(e); % Display the data in array e as an image
        title(char(label)); % Add the specified title to the current axes or standalone visualization
        drawnow; % Update figures and processes any pending callbacks. Use this command if you modify graphics objects and want to see the updates on the screen immediately
    else
        imshow(painter);
        image(e);
        title('No Face Detected');
        drawnow;
    end
end

elapsedTime = toc

% Compute the time per frame and effective frame rate.
timePerFrame = elapsedTime/20
effectiveFrameRate = 1/timePerFrame

% Call the STOP function to stop the device.
stop(mycam)

% Cleanup once the video input object is no longer needed
delete(mycam)