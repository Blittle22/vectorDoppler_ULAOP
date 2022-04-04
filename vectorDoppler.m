% Brandon Little
% 2.21.2022
% ULA_OP 64 Vector Doppler
% copied from MGDmode_AcquireOrig.m V4


fprintf('\n-----  Vector Doppler Initializing ------\n');

% Define Folders
myCfg = %full path for .cfg file
myUla = %full path for .ula file
myAppFolder = %full path for where the execuatable lives
myProbeFile  = 'C:\ProgramData\ULA-OP\Probe\probeLA332E.wks'; %full path where the probe file lives
mySaveFolder = %full path for where the application saves the acquisitons

%Define needed constants
fileNumber = 0; %file enmum integer
timeout = 5000; %[ms] timeout for waitSave 

%Define data
iQData = DataUlaopBaseBand('iQDataFile.uob'); %Use .uob for quadrature data acquisition

%---------------------------------------------------------------
%       ULAOP config, start, acquire, save, close
%---------------------------------------------------------------
fprintf ('Running UOLink\n');
Link = UOLink(MyApplicationFolder, LD.MySaveFolder, 'MatLink','Admin',2);

fprint('Running Link.Open()\n');
r = Link.Open(myCfg, myProbeFile);
DSN = 'MySlice'; %Artibratry naming

r = 0;
h = figure(1);

while(r ~= 1)
    
    %Begin AutoSave
    r = Link.AutoSave(1,0);
    if(r~=0)
        fprint('Link.AutoSave failed');
    end
    
    %Begin Freeze to activate PRF
    r = Link.Freeze(0);
    if(r~=0)
        fprint('Link.Freeze failed');
    end
    
    %Begin WaitSAve to save data when app has it all
    r = Link.WaitSave(timeout);
    if(r~=0)
        fprint('Link.WaitSave failed');
    end
    
    %Use 144 for LA332e - it has 144 elements
    %Acquire quadrature data for vector map
    data = Link.GetAcq(iQData,0, DSN, 144); %count, sliceName, linesPerFrame
    
    %Built-in graphics validation function - use it, don't care about it
    if(~ishandle(h))
        break;
    end
    
    %Displays image with full range of colors
    imagesc(abs(data(:,:,1)));
    
    %Updates figures and processes callbacks
    drawnow;
    
end

fprintf('Stopping Modula\n');
Link.Close;
