classdef creditsGUI < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        CreditsUIFigure  matlab.ui.Figure
        Image_9          matlab.ui.control.Image
        Image_8          matlab.ui.control.Image
        Image_7          matlab.ui.control.Image
        Image_6          matlab.ui.control.Image
        Image_4          matlab.ui.control.Image
        Label_7          matlab.ui.control.Label
        Label_6          matlab.ui.control.Label
        Label_5          matlab.ui.control.Label
        Label_4          matlab.ui.control.Label
        Label_3          matlab.ui.control.Label
        Label_2          matlab.ui.control.Label
        Label            matlab.ui.control.Label
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Get the file path for locating images
            pathToMLAPP = fileparts(mfilename('fullpath'));

            % Create CreditsUIFigure and hide until all components are created
            app.CreditsUIFigure = uifigure('Visible', 'off');
            app.CreditsUIFigure.Color = [0.9412 0.9412 0.9412];
            app.CreditsUIFigure.Position = [100 100 784 432];
            app.CreditsUIFigure.Name = 'Credits';

            % Create Label
            app.Label = uilabel(app.CreditsUIFigure);
            app.Label.FontWeight = 'bold';
            app.Label.FontColor = [0.3098 0.3098 0.3098];
            app.Label.Position = [190 1 406 29];
            app.Label.Text = 'Copyright (C) 2022 BIM33203: Image Processing Section 7 Group 6';

            % Create Label_2
            app.Label_2 = uilabel(app.CreditsUIFigure);
            app.Label_2.Position = [212 219 131 40];
            app.Label_2.Text = 'LEE ZI HUI (AI190244)';

            % Create Label_3
            app.Label_3 = uilabel(app.CreditsUIFigure);
            app.Label_3.Position = [94 61 137 40];
            app.Label_3.Text = 'LIEW JIA YU (AI190235)';

            % Create Label_4
            app.Label_4 = uilabel(app.CreditsUIFigure);
            app.Label_4.Position = [387 219 253 40];
            app.Label_4.Text = 'NUR SYAHIRAH BINTI SHAROMI (AI190140)';

            % Create Label_5
            app.Label_5 = uilabel(app.CreditsUIFigure);
            app.Label_5.Position = [315 61 156 40];
            app.Label_5.Text = 'TAN QIAN YING (AI190236)';

            % Create Label_6
            app.Label_6 = uilabel(app.CreditsUIFigure);
            app.Label_6.Position = [498 61 230 40];
            app.Label_6.Text = 'ZAFIRAA BINTI ZULNURAINI (AI190101)';

            % Create Label_7
            app.Label_7 = uilabel(app.CreditsUIFigure);
            app.Label_7.HorizontalAlignment = 'center';
            app.Label_7.FontName = 'Bahnschrift';
            app.Label_7.FontSize = 18;
            app.Label_7.FontWeight = 'bold';
            app.Label_7.Position = [327 377 131 40];
            app.Label_7.Text = 'Author(s)';

            % Create Image_4
            app.Image_4 = uiimage(app.CreditsUIFigure);
            app.Image_4.Position = [464 258 100 120];
            app.Image_4.ImageSource = fullfile(pathToMLAPP, 'AuthorImages', 'AI190140.jpg');

            % Create Image_6
            app.Image_6 = uiimage(app.CreditsUIFigure);
            app.Image_6.Position = [113 100 100 120];
            app.Image_6.ImageSource = fullfile(pathToMLAPP, 'AuthorImages', 'AI190235.jpg');

            % Create Image_7
            app.Image_7 = uiimage(app.CreditsUIFigure);
            app.Image_7.Position = [343 100 100 120];
            app.Image_7.ImageSource = fullfile(pathToMLAPP, 'AuthorImages', 'AI190236.jpg');

            % Create Image_8
            app.Image_8 = uiimage(app.CreditsUIFigure);
            app.Image_8.Position = [563 100 100 120];
            app.Image_8.ImageSource = fullfile(pathToMLAPP, 'AuthorImages', 'AI190101.jpeg');

            % Create Image_9
            app.Image_9 = uiimage(app.CreditsUIFigure);
            app.Image_9.Position = [228 258 100 120];
            app.Image_9.ImageSource = fullfile(pathToMLAPP, 'AuthorImages', 'AI190244.jpg');

            % Show the figure after all components are created
            app.CreditsUIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = creditsGUI

            % Create UIFigure and components
            createComponents(app)

            % Register the app with App Designer
            registerApp(app, app.CreditsUIFigure)

            if nargout == 0
                clear app
            end
        end

        % Code that executes before app deletion
        function delete(app)

            % Delete UIFigure when app is deleted
            delete(app.CreditsUIFigure)
        end
    end
end