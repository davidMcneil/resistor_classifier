
function collect_data

% Collect input
[fileName, filePath] = uigetfile('*', 'Select the image to use collect data');
[filePath, fileName, fileExt] = fileparts(strcat(filePath, fileName));

% Open image
img = imread(strcat(filePath, '/', fileName, fileExt));
hFig = figure('Toolbar','none','Menubar','none', ...
              'CloseRequestFcn', @ImageCloseCallback,...
              'KeyPressFcn', @dispkeyevent);
hIm = imshow(img);
hSP = imscrollpanel(hFig, hIm);
api = iptgetapi(hSP);
api.setMagnification(2)
set(hIm, 'ButtonDownFcn', @ImageClickCallback);

label = uint8(11);
count = 0;

try
    [labels features] = libsvmread('color_data.unscaled')
    labels = uint8(labels);
catch exception
    features = [];
    labels = uint8([]);
end

function ImageClickCallback(objectHandle, eventData)
    axesHandle = get(objectHandle, 'Parent');
    coordinates = get(axesHandle, 'CurrentPoint'); 
    coordinates = uint32(coordinates(1, 1:2));
    feature = get_data(img, coordinates(1), coordinates(2));
    
    % fprintf('%.0f %.0f\n', coordinates);
    fprintf('%.0f %.4f %.4f\n', label, feature);
    features = cat(1, features, feature);
    labels = cat(1, labels, label);
    count = count + 1
end

function dispkeyevent(~, event)
    key = event.Key
    if strcmp(key, 'k');
        label = uint8(1);
        fprintf('black\n');
    elseif strcmp(key, 'b');
        label = uint8(2);
        fprintf('brown\n');
    elseif strcmp(key, 'r');
        label = uint8(3);
        fprintf('red\n');
    elseif strcmp(key, 'o');
        label = uint8(4);
        fprintf('orange\n');
    elseif strcmp(key, 'y');
        label = uint8(5);
        fprintf('yellow\n');
    elseif strcmp(key, 'g');
        label = uint8(6);
        fprintf('green\n');
    elseif strcmp(key, 'u');
        label = uint8(7);
        fprintf('blue\n');
    elseif strcmp(key, 'v');
        label = uint8(8);
        fprintf('violet\n');
    elseif strcmp(key, 'e');
        label = uint8(9);
        fprintf('grey\n');
    elseif strcmp(key, 'w');
        label = uint8(10);
        fprintf('white\n');
    else
        label = uint8(11);
        fprintf('other\n');
    end
end

function ImageCloseCallback(src, callbackdata)
    libsvmwrite('color_data.unscaled',  sparse(double(labels)), sparse(features))
    libsvmscaledwrite('color_data', double(labels), features);
    delete(gcf)
end

end
