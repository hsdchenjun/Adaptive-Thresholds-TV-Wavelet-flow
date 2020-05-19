
close all;
clear;

% load settings
st = parameter_settings();


    st.pyramid_factor = 0.5; % downsampling factor
  
    st.warps = 5; % the numbers of warps per level
  
    st.max_its = 30; % the number of equation iterations per warp
    
    st.lambda = 11;  % a weught that controls the influence of  the data term and the regularization term.
    
    st.lowc = 0.2;   %  the weigh for the means of low frequency component ¦Á-CA 
    
    st.highc = 1.5; % the weigh for the means of high frequency components ¦Á-CH, ¦Á-CV , and ¦Á-CD.


    
show_flow = 1; % 1 = display the evolution of the flow, 0 = do not show
h = figure('Name', 'Optical flow');

I1 = double(imread('data/other-data/Hydrangea/frame10.png'))/255;
I2 = double(imread('data/other-data/Hydrangea/frame11.png'))/255;

floPath = 'data/other-gt-flow/Hydrangea/flow10.flo';


[flow] = coarse_to_fine(I1, I2, st, show_flow, h);
u = flow(:, :, 1);
v = flow(:, :, 2);

gtflow = readFlowFile(floPath);
gtu = gtflow(:, :, 1);
gtv = gtflow(:, :, 2);
gtflowImg = uint8(robust_flowToColor(gtflow));
figure; imshow(gtflowImg)
% compute the mean end-point error (mepe) and the mean angular error (mang)
UNKNOWN_FLOW_THRESH = 1e9;
[mang, mepe] = flowError(gtu, gtv, u, v, ...
    0, 0.0, UNKNOWN_FLOW_THRESH);
disp(['Mean end-point error: ', num2str(mepe)]);
disp(['Mean angular error: ', num2str(mang)]);

% display the flow
flowImg = uint8(robust_flowToColor(flow));
figure; imshow(flowImg);
