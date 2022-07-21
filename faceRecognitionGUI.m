classdef faceRecognitionGUI < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure                      matlab.ui.Figure
        FileMenu                      matlab.ui.container.Menu
        ExitMenu_2                    matlab.ui.container.Menu
        CreditsMenu                   matlab.ui.container.Menu
        GridLayout                    matlab.ui.container.GridLayout
        LeftPanel                     matlab.ui.container.Panel
        Label_2                       matlab.ui.control.Label
        AccuracyEditField             matlab.ui.control.NumericEditField
        AccuracyLabel                 matlab.ui.control.Label
        NewClassesEditField           matlab.ui.control.NumericEditField
        NewClassesEditFieldLabel      matlab.ui.control.Label
        TrainingLamp                  matlab.ui.control.Lamp
        TrainingLampLabel             matlab.ui.control.Label
        CapturingLamp                 matlab.ui.control.Lamp
        CapturingLampLabel            matlab.ui.control.Label
        TrainModelButton              matlab.ui.control.Button
        CaptureFaceImagesButton       matlab.ui.control.Button
        TrainYourNetworkLabel         matlab.ui.control.Label
        UIAxes                        matlab.ui.control.UIAxes
        RightPanel                    matlab.ui.container.Panel
        LiveLamp                      matlab.ui.control.Lamp
        Label                         matlab.ui.control.Label
        BeginFaceRecognitionButton    matlab.ui.control.Button
        NameEditField                 matlab.ui.control.EditField
        NameEditFieldLabel            matlab.ui.control.Label
        RealTimeFaceRecognitionLabel  matlab.ui.control.Label
        UIAxes2                       matlab.ui.control.UIAxes
    end

    % Properties that correspond to apps with auto-reflow
    properties (Access = private)
        onePanelWidth = 576;
    end

    properties (Access = private)
        % Create a webcam object called mycam
        mycam = webcam; %mycam = webcam('USB Camera'); % For using the USB camera
        training = true;
    end

    % Callbacks that handle component events
    methods (Access = private)

        % Button pushed function: CaptureFaceImagesButton
        function CaptureFaceImagesButtonPushed(app, event)
            clc;
            close all;
            warning('off','all');

            app.mycam;
            faceDetector = vision.CascadeObjectDetector;

            temp = 0; % Index for looping
            c = 500; % Counter
    
            imagefilename ='face_'; % Will append the captured face images, i.e., face_0.bmp, face_1.bmp
            
            % Create dialog box to gather user input
            prompt = {'Enter the person name'};
            dlgtitle = 'Name';
            definput = {'name'};
            opts.Interpreter = 'tex';
            x = inputdlg(prompt,dlgtitle,[1 40],definput,opts);
            x = char(x);
            
            % Replace your file path for storing the images
            % To be used for training
            ImageFolder = sprintf('C:/Real-Time_Face_Recognition/Faces/%s',x);
            mkdir(ImageFolder);
            fprintf('The face images file path is %s \n', ImageFolder);
            %%
            % Take 500 images (0-499) & extract the face part using viola-jones algorithm and resize to 227 *227
            app.CapturingLamp.Color = [1 0 0];
            while true
                % Acquire image
                e = app.mycam.snapshot;
                e2 = rgb2gray(e); % colour to gray image
                bboxes = step(faceDetector,e2);
                painter = insertObjectAnnotation(e,'Rectangle',bboxes,'Face'); 
    
                if(sum(sum(bboxes)) ~= 0)
                    if(temp >= c)
                        break;
                    else
                        % Adjust input images and save as gray image
                        face = imcrop(e2,bboxes(1,:)); %face = imcrop(e,bboxes(1,:)); %rgb

                        % Resize an image to match the expected input size. This resizes face to be numrows-by-numcols. That is, face has a width of numcols pixels and a height of numrows pixels
                        face = imresize(face,[227 227]); % The AlexNet network needs an image input size of 227-by-227
                        % filename = strcat(num2str(temp),'.bmp'); 
                        sprintf('%d.bmp', temp); % Save the images with a sequence of number, i.e., 1.bmp, 2.bmp etc
                        filename = [imagefilename, num2str(temp),'.bmp']; % Save the image as a BMP format
                        fullfilename = fullfile(ImageFolder,filename);
                        imwrite(face,fullfilename); % Write to folder
                        temp = temp+1;
    
                        % Display the image
                        %imshow(face,'Parent',app.UIAxes); % imshow(face);
                        imshow(painter,'Parent',app.UIAxes); 
                        drawnow;
                    end
                else
                    % Display the image
                    imshow(painter,'Parent',app.UIAxes); % imshow(e);
                    drawnow;
                end
            end
            app.CapturingLamp.Color = [0 1 0];
            %clear(app.mycam);
        end

        % Button pushed function: TrainModelButton
        function TrainModelButtonPushed(app, event)
            clc;
            % clear;
            warning off;
            close all;

            app.TrainingLamp.Color = [1 0 0];
            uiwait(msgbox('This operation may take a longer time to complete.', 'Message'));

            if(app.training)
                % Count the number of folder in Faces (root folder)
                path = 'C:/Real-Time_Face_Recognition/Faces';
                k = dir(path);
                class = sum([k.isdir]) - 2;
                fprintf('Number of folder to train: %d \n', class);
                app.NewClassesEditField.Value = class;
                %% Transfer Learning
                deepnet = alexnet; % The variable deepnet represents a deep convolutional network

                % See details of the architecture
                % Extract the Layers property of deepnet into a variable called ly
                ly = deepnet.Layers; % The variable ly is an array of network layers

                % Create dialog box to gather user input
                % prompt = {'How many new identity (number of folder in integer)'};
                % dlgtitle = 'New classes';
                % definput = {'2'};
                % opts.Interpreter = 'tex';
                % class = inputdlg(prompt,dlgtitle,[1 40],definput,opts);
                % class = str2double(class);

                % For transfer learning, the input and output layers are the most relevant layers
                % Here we will modify two layers for transfer learning - fully connected layer and classification layer
                % Extract the twenty-third layer which is the fully connected layer
                % i.e., classify two faces, then set as 2
                ly(23) = fullyConnectedLayer(class); % Returns a fully connected layer and specifies the OutputSize property
                ly(25) = classificationLayer;  % Extract the twenty-fifth layer which is the classification/output layer
                %% Get training images
                % Create a datastore named 'faceds' to store face images
                % 'Faces' is the folder name
                % 'IncludeSubfolders' option to look for images within subfolders of the given folder
                faceds = imageDatastore('Faces','IncludeSubfolders',true,'LabelSource','foldernames'); % Manage a collection of image files
               
                % Split into training and testing sets
                % Split images into two datastores, select 70% to put in faceTrain
                [faceTrain, faceTest] = splitEachLabel(faceds,0.7,"randomized");
                %% Set training algorithm options
                % Lower the learning rate for transfer learning
                % Use the stochastic gradient descent with momentum for optimization
                opts = trainingOptions('sgdm','InitialLearnRate',0.001,'MaxEpochs',20,'MiniBatchSize',64);
                %% Perform training
                % Train new network
                % Insert data, layers, options to the trainNetwork function
                facenet = trainNetwork(faceTrain,ly,opts);
                %% Use the trained network to classify test images
                testpreds = classify(facenet,faceTest);
                % Evaluate the results by calculating the accuracy
                accuracy = nnz(testpreds == faceTest.Labels)/numel(testpreds)
                app.AccuracyEditField.Value = accuracy;
                % Visualize the confusion matrix
                confusionchart(faceTest.Labels,testpreds);
                % imshow(cfmatrix,'Parent',app.UIAxes3); % Error: not showing
                % in UIAxes3
                %% Save the new trained network
                save facenet;
                app.TrainingLamp.Color = [0 1 0];
                msgbox(["The training is completed";"Network: facenet.mat"], 'Success');
            end
        end

        % Button pushed function: BeginFaceRecognitionButton
        function BeginFaceRecognitionButtonPushed(app, event)
            %% Use the trained network to classify images
            % Set up the Acquisition Object
            cam = videoinput('winvideo',1); %cam = videoinput('winvideo','USB Camera','MJPG_1280x720');
            
            % Configure the object for manual trigger mode
            triggerconfig(cam,'manual');
            % Configure the number of frames to log
            cam.FramesPerTrigger = 180;

            % Skip the first few frames the device provides before logging data.
            cam.TriggerFrameDelay = 3;
                
            % Access the device's video source
            src = getselectedsource(cam);
            
            % Determine the device specific frame rates (frames per second) available
            frameRates = set(src, 'FrameRate');

            % Configure the device's frame rate to the highest available setting
            src.FrameRate = frameRates{1};
            actualRate = str2num( frameRates{1} );

            % Now that the device is configured for manual triggering, call START.
            % This will cause the device to send data back to MATLAB, but will not log frames to memory at this point.
            start(cam)
            app.LiveLamp.Color = [1 0 0];
            % preview(cam)
            %%
            load facenet;
            faceDetector = vision.CascadeObjectDetector;

            % Measure the time to acquire 180 frames
            tic
            for i = 1:180
                % Take a snapshot from the webcam
                e = getsnapshot(cam);
                bboxes = step(faceDetector,e);
                painter = insertObjectAnnotation(e,'Rectangle',bboxes,'Face'); % A yellow box that marks around any detected face
                % imshow(painter); % The screen keeps flickering when painting the yellow box

                if(sum(sum(bboxes)) ~= 0)
                    % Adjust input images
                    face = imcrop(e,bboxes(1,:));
                    face = imresize(face,[227 227]); % The AlexNet network needs an image input size of 227-by-227
                  
                    % Use our pretrained AlexNet (loaded as the variable mynet) to classify the contents of all the images in the data set
                    % Note that the classify function will be running many images through AlexNet
                    % It may take a few seconds to execute
                    label = classify(facenet,face);
                    app.NameEditField.Value = char(label); % title(char(label)); % Add the specified title to the currect axes or standalone visualization
                    imshow(painter,'Parent',app.UIAxes2); % image(e); % Display the data in array e as an image
                    drawnow; % Update figures and processes any pending callbacks. Use this command if you modify graphics objects and want to see the updates on the screen immediately
                else
                    % image(e);
                    % title('No Face Detected');
                    app.NameEditField.Value = 'No Face Detected';
                    imshow(painter,'Parent',app.UIAxes2); % imshow(e,'Parent',app.UIAxes2,zeros(size(e),'unit8'));
                    drawnow;
                end
            end

            app.LiveLamp.Color = [1 1 1];
            elapsedTime = toc

            % Compute the time per frame and effective frame rate.
            timePerFrame = elapsedTime/20
            effectiveFrameRate = 1/timePerFrame

            % Call the STOP function to stop the device.
            stop(cam)
                
            % Cleanup once the video input object is no longer needed
            delete(cam)
        end

        % Menu selected function: FileMenu
        function FileMenuSelected(app, event)
            
        end

        % Menu selected function: ExitMenu_2
        function ExitMenu_2Selected(app, event)
            opts.Interpreter = 'tex';
            opts.Default = 'Yes';
            Q=questdlg('Are you sure to exit the program？','Close program','Yes','No',opts); % Exit
            switch Q
                case 'Yes'
                    close all force;
                case 'No'
                    quit cancel;
            end
        end

        % Menu selected function: CreditsMenu
        function CreditsMenuSelected(app, event)
            app.UIFigure.Visible = 'on';
            creditsGUI
        end

        % Changes arrangement of the app based on UIFigure width
        function updateAppLayout(app, event)
            currentFigureWidth = app.UIFigure.Position(3);
            if(currentFigureWidth <= app.onePanelWidth)
                % Change to a 2x1 grid
                app.GridLayout.RowHeight = {593, 593};
                app.GridLayout.ColumnWidth = {'1x'};
                app.RightPanel.Layout.Row = 2;
                app.RightPanel.Layout.Column = 1;
            else
                % Change to a 1x2 grid
                app.GridLayout.RowHeight = {'1x'};
                app.GridLayout.ColumnWidth = {322, '1x'};
                app.RightPanel.Layout.Row = 1;
                app.RightPanel.Layout.Column = 2;
            end
        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Get the file path for locating images
            pathToMLAPP = fileparts(mfilename('fullpath'));

            % Create UIFigure and hide until all components are created
            app.UIFigure = uifigure('Visible', 'off');
            app.UIFigure.AutoResizeChildren = 'off';
            app.UIFigure.Position = [100 100 783 593];
            app.UIFigure.Name = 'MATLAB App';
            app.UIFigure.SizeChangedFcn = createCallbackFcn(app, @updateAppLayout, true);

            % Create FileMenu
            app.FileMenu = uimenu(app.UIFigure);
            app.FileMenu.MenuSelectedFcn = createCallbackFcn(app, @FileMenuSelected, true);
            app.FileMenu.Text = 'File';

            % Create ExitMenu_2
            app.ExitMenu_2 = uimenu(app.FileMenu);
            app.ExitMenu_2.MenuSelectedFcn = createCallbackFcn(app, @ExitMenu_2Selected, true);
            app.ExitMenu_2.Text = 'Exit';

            % Create CreditsMenu
            app.CreditsMenu = uimenu(app.UIFigure);
            app.CreditsMenu.MenuSelectedFcn = createCallbackFcn(app, @CreditsMenuSelected, true);
            app.CreditsMenu.Text = 'Credits';

            % Create GridLayout
            app.GridLayout = uigridlayout(app.UIFigure);
            app.GridLayout.ColumnWidth = {322, '1x'};
            app.GridLayout.RowHeight = {'1x'};
            app.GridLayout.ColumnSpacing = 0;
            app.GridLayout.RowSpacing = 0;
            app.GridLayout.Padding = [0 0 0 0];
            app.GridLayout.Scrollable = 'on';

            % Create LeftPanel
            app.LeftPanel = uipanel(app.GridLayout);
            app.LeftPanel.Layout.Row = 1;
            app.LeftPanel.Layout.Column = 1;

            % Create UIAxes
            app.UIAxes = uiaxes(app.LeftPanel);
            title(app.UIAxes, 'Images for training')
            app.UIAxes.XTick = [];
            app.UIAxes.XTickLabel = '';
            app.UIAxes.YTick = [];
            app.UIAxes.YTickLabel = '';
            app.UIAxes.FontSize = 16;
            app.UIAxes.Position = [41 316 220 191];

            % Create TrainYourNetworkLabel
            app.TrainYourNetworkLabel = uilabel(app.LeftPanel);
            app.TrainYourNetworkLabel.FontSize = 24;
            app.TrainYourNetworkLabel.Position = [60 534 220 31];
            app.TrainYourNetworkLabel.Text = 'Train Your Network';

            % Create CaptureFaceImagesButton
            app.CaptureFaceImagesButton = uibutton(app.LeftPanel, 'push');
            app.CaptureFaceImagesButton.ButtonPushedFcn = createCallbackFcn(app, @CaptureFaceImagesButtonPushed, true);
            app.CaptureFaceImagesButton.Icon = fullfile(pathToMLAPP, 'Icons', 'camera.png');
            app.CaptureFaceImagesButton.BackgroundColor = [1 1 1];
            app.CaptureFaceImagesButton.FontSize = 16;
            app.CaptureFaceImagesButton.Position = [51 268 199 30];
            app.CaptureFaceImagesButton.Text = 'Capture Face Images';

            % Create TrainModelButton
            app.TrainModelButton = uibutton(app.LeftPanel, 'push');
            app.TrainModelButton.ButtonPushedFcn = createCallbackFcn(app, @TrainModelButtonPushed, true);
            app.TrainModelButton.Icon = fullfile(pathToMLAPP, 'Icons', 'deep-learning.png');
            app.TrainModelButton.BackgroundColor = [1 1 1];
            app.TrainModelButton.FontSize = 16;
            app.TrainModelButton.Position = [51 202 199 30];
            app.TrainModelButton.Text = 'Train Model';

            % Create CapturingLampLabel
            app.CapturingLampLabel = uilabel(app.LeftPanel);
            app.CapturingLampLabel.HorizontalAlignment = 'right';
            app.CapturingLampLabel.Position = [253 247 58 22];
            app.CapturingLampLabel.Text = 'Capturing';

            % Create CapturingLamp
            app.CapturingLamp = uilamp(app.LeftPanel);
            app.CapturingLamp.HandleVisibility = 'callback';
            app.CapturingLamp.Position = [273 272 20 20];
            app.CapturingLamp.Color = [1 1 1];

            % Create TrainingLampLabel
            app.TrainingLampLabel = uilabel(app.LeftPanel);
            app.TrainingLampLabel.HorizontalAlignment = 'right';
            app.TrainingLampLabel.Position = [257 183 48 22];
            app.TrainingLampLabel.Text = 'Training';

            % Create TrainingLamp
            app.TrainingLamp = uilamp(app.LeftPanel);
            app.TrainingLamp.Position = [271 207 20 20];
            app.TrainingLamp.Color = [1 1 1];

            % Create NewClassesEditFieldLabel
            app.NewClassesEditFieldLabel = uilabel(app.LeftPanel);
            app.NewClassesEditFieldLabel.HorizontalAlignment = 'right';
            app.NewClassesEditFieldLabel.Position = [42 142 79 22];
            app.NewClassesEditFieldLabel.Text = 'New Classes:';

            % Create NewClassesEditField
            app.NewClassesEditField = uieditfield(app.LeftPanel, 'numeric');
            app.NewClassesEditField.Position = [134 142 38 22];

            % Create AccuracyLabel
            app.AccuracyLabel = uilabel(app.LeftPanel);
            app.AccuracyLabel.HorizontalAlignment = 'right';
            app.AccuracyLabel.Position = [182 142 58 22];
            app.AccuracyLabel.Text = 'Accuracy:';

            % Create AccuracyEditField
            app.AccuracyEditField = uieditfield(app.LeftPanel, 'numeric');
            app.AccuracyEditField.Position = [248 142 54 22];

            % Create Label_2
            app.Label_2 = uilabel(app.LeftPanel);
            app.Label_2.FontSize = 14;
            app.Label_2.Position = [27 24 275 84];
            app.Label_2.Text = {'Root folder:'; 'C:\Real-Time_Face_Recognition\'; ''; 'Folder of datastore: '; 'C:\Real-Time_Face_Recognition\Faces\'};

            % Create RightPanel
            app.RightPanel = uipanel(app.GridLayout);
            app.RightPanel.Layout.Row = 1;
            app.RightPanel.Layout.Column = 2;

            % Create UIAxes2
            app.UIAxes2 = uiaxes(app.RightPanel);
            title(app.UIAxes2, 'Real-time camera view')
            app.UIAxes2.XTick = [];
            app.UIAxes2.YTick = [];
            app.UIAxes2.FontSize = 16;
            app.UIAxes2.Position = [21 104 421 300];

            % Create RealTimeFaceRecognitionLabel
            app.RealTimeFaceRecognitionLabel = uilabel(app.RightPanel);
            app.RealTimeFaceRecognitionLabel.HorizontalAlignment = 'center';
            app.RealTimeFaceRecognitionLabel.FontSize = 24;
            app.RealTimeFaceRecognitionLabel.Position = [64 497 312 42];
            app.RealTimeFaceRecognitionLabel.Text = 'Real-Time Face Recognition';

            % Create NameEditFieldLabel
            app.NameEditFieldLabel = uilabel(app.RightPanel);
            app.NameEditFieldLabel.HorizontalAlignment = 'right';
            app.NameEditFieldLabel.Position = [79 447 44 22];
            app.NameEditFieldLabel.Text = 'Name: ';

            % Create NameEditField
            app.NameEditField = uieditfield(app.RightPanel, 'text');
            app.NameEditField.Position = [138 447 223 22];

            % Create BeginFaceRecognitionButton
            app.BeginFaceRecognitionButton = uibutton(app.RightPanel, 'push');
            app.BeginFaceRecognitionButton.ButtonPushedFcn = createCallbackFcn(app, @BeginFaceRecognitionButtonPushed, true);
            app.BeginFaceRecognitionButton.Icon = fullfile(pathToMLAPP, 'Icons', 'user.png');
            app.BeginFaceRecognitionButton.BackgroundColor = [1 1 1];
            app.BeginFaceRecognitionButton.FontSize = 24;
            app.BeginFaceRecognitionButton.Position = [71 33 328 54];
            app.BeginFaceRecognitionButton.Text = 'Begin Face Recognition';

            % Create Label
            app.Label = uilabel(app.RightPanel);
            app.Label.HorizontalAlignment = 'right';
            app.Label.Position = [410 71 27 22];
            app.Label.Text = 'Live';

            % Create LiveLamp
            app.LiveLamp = uilamp(app.RightPanel);
            app.LiveLamp.Position = [414 49 20 20];
            app.LiveLamp.Color = [1 1 1];

            % Show the figure after all components are created
            app.UIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = faceRecognitionGUI

            % Create UIFigure and components
            createComponents(app)

            % Register the app with App Designer
            registerApp(app, app.UIFigure)

            if nargout == 0
                clear app
            end
        end

        % Code that executes before app deletion
        function delete(app)

            % Delete UIFigure when app is deleted
            delete(app.UIFigure)
        end
    end
end