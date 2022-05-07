%% Collect 150 face images from webcam

clc;
clear;
close all;
warning off;

% Find the cameras that are connected to your system, and make sure MATLAB can detect them
% webcamlist

% Create a webcam object called mycam, using the USB camera.
mycam = webcam('USB Camera'); % https://www.mathworks.com/help/supportpkg/usbwebcams/ug/webcam.html
faceDetector = vision.CascadeObjectDetector;

temp = 0; % Index for looping
c = 150; % Counter

imagefilename ='face_'; % Will append the captured face images, i.e., face_0.bmp, face_1.bmp

% Take 150 images (0-149) & extract the face part using viola-jones algorithm and resize to 227 *227
while true
    % Acquire image
    e = mycam.snapshot;
    bboxes = step(faceDetector,e);

    if(sum(sum(bboxes)) ~= 0)
        if(temp >= c)
            break;
        else
            % Adjust input images
            face = imcrop(e,bboxes(1,:));

            % Resize an image to match the expected input size
            % This resizes face to be numrows-by-numcols
            % That is, face has a width of numcols pixels and a height of numrows pixels
            face = imresize(face,[227 227]); % The AlexNet network needs an image input size of 227-by-227

            % filename = strcat(num2str(temp),'.bmp'); 
            imgname = sprintf('%d.bmp', temp); % Save the images with a sequence of number, i.e., 1.bmp, 2.bmp etc
            filename = [imagefilename, num2str(temp),'.bmp']; % Save the image as a BMP format
            imwrite(face,filename); % Write to folder
            temp = temp+1;

            % Display the image
            imshow(face);
            drawnow;
        end
    else
        % Display the image
        imshow(e);
        drawnow;
    end
end

% Clean up by clearing the object
clear('mycam');
