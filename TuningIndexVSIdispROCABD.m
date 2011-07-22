% This file has been cross check with B. and is absolutely bug free as
% of 10/16/2009 for the AllABDNeurons.txt for the ABD and cylinder
% obviously.

clear;
clc

DataPath = GetDataPath();

FinishTime = 0;

% ABD
% load /Users/ali/DropBox/Projects/BCode/AllABDNeurons.mat
% AllNeurons = AllABDNeurons;
%  % AllNeurons = AllABDNeurons(57:end); disp ( ' O N L Y   I C A R U S ! ! ! !   B E W A R E ! ! !');
% clear AllABDNeurons;
% FileType = 'ABD';
% StimulusType = 'cylinder';
% StartTime  = 10000;  %10000; % 6500;
% FinishTime = 20000;

% % % DID
% load ../AllDIDNeurons.mat
% AllNeurons = AllDIDNeurons;
% clear AllDIDNeurons
% FileType = 'DID';
% StimulusType = 'cylinder';
% StartTime  = 10000; %10000; % 6500; 
% FinishTime = 20000;


% % % DIDB
% load ../AllDIDBNeurons.mat
% AllNeurons = AllDIDBNeurons;
% clear AllDIDBNeurons
% FileType = 'DIDB';
% StimulusType = 'cylinder';
% StartTime  = 10000; %10000; % 6500; 
% FinishTime = 20000;


% % TWO
% load('../AllTWONeurons.mat');
% AllNeurons = AllTWONeurons;
% clear AllTWONeurons;
% FileType = 'TWO';
% StimulusType = 'cylinder';
% StartTime  = 500; %10000; %5500; 
% FinishTime = 20000;

% % DPI
% load('../AllPursuitNeurons.mat');
% AllNeurons = AllPursuitNeurons;
% clear AllPursuitNeurons;
% FileType = 'DPI';
% StimulusType = 'cylinder';
% StartTime  = 500;% 10000; %500; %10000; 
% FinishTime = 20000;


% % % BDID
load('../AllBDIDNeuronsALL.mat');
AllNeurons = AllBDIDNeuronsALL;
clear AllBDIDNeurons;
FileType = 'BDID';
StimulusType = 'cylinder';
StartTime  = 10000;
FinishTime = 20000;


% AllNeurons =  SelectByMonkey(AllNeurons, 'ic');
 AllNeurons =  SelectByMonkey(AllNeurons, 'dae');
 disp('  O N E   M O N K E Y   A T  A  T I M E ');

%par
for iN= [1:length(AllNeurons)] %[1:33 40:length(AllNeurons)], 
    if iN == 38
        debug = 1;
    end
    IdColor{iN} = [1 0.5 0.1];
    DotSizes(iN) = 100;
    toolowFR = 0;
    NeuronNumber = AllNeurons(iN);
    [MonkeyName, NeuronNumber, ClusterName] = NeurClus(NeuronNumber); 
    TI(iN) = TuningIndex(MonkeyName, NeuronNumber, ClusterName, StimulusType, FileType);
    disp(strcat('iN: ' ,num2str(iN) , ' , Neuron: ', num2str(NeuronNumber, '%-04.3d'), ' - ' , MonkeyName));
    
    filename = strcat(MonkeyAb(MonkeyName), num2str(NeuronNumber, '%-04.3d'), ClusterName, StimulusType,'.', FileType,'.mat');
    Neuron = load(strcat(DataPath, MonkeyName, '/', num2str(NeuronNumber, '%-04.3d'), '/' ,filename));
    Expt = Neuron.Expt;
    fileNames{iN} = filename; 
    
    pD      = PreferredCylinderRotationDirection(MonkeyName, NeuronNumber, ClusterName, FileType, 0);
    %if TI(iN) > 0, pD = 1; else pD = 2; end
    pDs(iN) = pD;

    if (pD == -1) 
        disp('Ohoooy! pD? what are you D O I N G ! ? ');
    end
    
    %conditions = GetConditions(Expt, FileType, pD);

    conditions = logical([]);
    
    if strcmpi(FileType, 'DPI')
        if isfield(Expt.Trials,'dfx')
            deltafxy = [Expt.Trials(:).dfx] - [Expt.Trials(:).fx];
        else
            deltafxy = [Expt.Trials(:).dfy] - [Expt.Trials(:).fy];
        end
        tempdelta = fix(deltafxy);
        for td = 1: length(tempdelta)
            if tempdelta(td) == 0
                tempdelta(td) = 0.5 * sign(deltafxy(td));
            end
        end
        deltafxy = tempdelta; % fix(deltafxy);  %  0.2 * fix(5*deltafxy); %0.1 * round(10*deltafxy);


        Speeds = unique(abs(deltafxy));
        %disp(length(Speeds));
        %disp(Speeds);
       if(Expt.Stimvals.or>0)
            if(pD==2)
                conditions(1,:) = (deltafxy>0 & [Expt.Trials(:).dx]==0);
                conditions(2,:) = (deltafxy<0 & [Expt.Trials(:).dx]==0);
                conditions(3,:) = (deltafxy>0 & [Expt.Trials(:).dx]>0);
                conditions(4,:) = (deltafxy<0 & [Expt.Trials(:).dx]>0);
                conditions(5,:) = (deltafxy<0 & [Expt.Trials(:).dx]<0);
                conditions(6,:) = (deltafxy>0 & [Expt.Trials(:).dx]<0);
            else
                conditions(1,:) = (deltafxy<0 & [Expt.Trials(:).dx]==0);
                conditions(2,:) = (deltafxy>0 & [Expt.Trials(:).dx]==0);
                conditions(3,:) = (deltafxy<0 & [Expt.Trials(:).dx]>0);
                conditions(4,:) = (deltafxy>0 & [Expt.Trials(:).dx]>0);
                conditions(5,:) = (deltafxy>0 & [Expt.Trials(:).dx]<0);
                conditions(6,:) = (deltafxy<0 & [Expt.Trials(:).dx]<0);
            end
       else
            if(pD==1)
                conditions(1,:) = (deltafxy>0 & [Expt.Trials(:).dx]==0);
                conditions(2,:) = (deltafxy<0 & [Expt.Trials(:).dx]==0);
                conditions(3,:) = (deltafxy>0 & [Expt.Trials(:).dx]>0);
                conditions(4,:) = (deltafxy<0 & [Expt.Trials(:).dx]>0);
                conditions(5,:) = (deltafxy<0 & [Expt.Trials(:).dx]<0);
                conditions(6,:) = (deltafxy>0 & [Expt.Trials(:).dx]<0);
            else
                conditions(1,:) = (deltafxy<0 & [Expt.Trials(:).dx]==0);
                conditions(2,:) = (deltafxy>0 & [Expt.Trials(:).dx]==0);
                conditions(3,:) = (deltafxy<0 & [Expt.Trials(:).dx]>0);
                conditions(4,:) = (deltafxy>0 & [Expt.Trials(:).dx]>0);
                conditions(5,:) = (deltafxy>0 & [Expt.Trials(:).dx]<0);
                conditions(6,:) = (deltafxy<0 & [Expt.Trials(:).dx]<0);
            end
       end

    else
      if strcmpi(FileType, 'BDID')
        if(mean([Expt.Trials([Expt.Trials(:).Id]>0).RespDir])>0)
            ResponseToPositive = 1;
            ResponseToNegative = -1;
        else
            ResponseToPositive = -1;
            ResponseToNegative = 1;
        end
            else
        if(mean([Expt.Trials([Expt.Trials(:).dx]>0).RespDir])>0)
            ResponseToPositive = 1;
            ResponseToNegative = -1;
        else
            ResponseToPositive = -1;
            ResponseToNegative = 1;
        end
      end    
    

        % 10/14/09 we added the [Expt.Trials(:).RespDir]~=0 to all conditions
        % (firstly to match is with Bruces secondly to exclude those in which
        % monkey has not taken a side. 
        if strcmp(FileType, 'TWO')
            if(pD == 2)
                conditions(1,:) = [Expt.Trials(:).bd]<0 & [Expt.Trials(:).dx]==0 & [Expt.Trials(:).RespDir]~=0;
                conditions(2,:) = [Expt.Trials(:).bd]>0 & [Expt.Trials(:).dx]==0 & [Expt.Trials(:).RespDir]~=0;
                conditions(3,:) = [Expt.Trials(:).bd]<0 & [Expt.Trials(:).dx]<0 & [Expt.Trials(:).RespDir]~=0;
                conditions(4,:) = [Expt.Trials(:).bd]>0 & [Expt.Trials(:).dx]<0 & [Expt.Trials(:).RespDir]~=0;
                conditions(5,:) = [Expt.Trials(:).bd]<0 & [Expt.Trials(:).dx]>0 & [Expt.Trials(:).RespDir]~=0;
                conditions(6,:) = [Expt.Trials(:).bd]>0 & [Expt.Trials(:).dx]>0 & [Expt.Trials(:).RespDir]~=0;
                conditions(7,:) = [Expt.Trials(:).bd]== max([Expt.Trials(:).bd]) & [Expt.Trials(:).dx]== min([Expt.Trials(:).bd]) & [Expt.Trials(:).RespDir]~=0; %flip
                conditions(8,:) = [Expt.Trials(:).bd]== min([Expt.Trials(:).bd]) & [Expt.Trials(:).dx]== min([Expt.Trials(:).bd]) & [Expt.Trials(:).RespDir]~=0; %flip pair to compare 
                conditions(9,:) = [Expt.Trials(:).bd]>0 & [Expt.Trials(:).dx]>0 & [Expt.Trials(:).RespDir]~=0;
                conditions(10,:)= [Expt.Trials(:).bd]== min([Expt.Trials(:).bd]) & [Expt.Trials(:).dx]== max([Expt.Trials(:).bd]) & [Expt.Trials(:).RespDir]~=0; %flip
                conditions(11,:)= [Expt.Trials(:).bd]== max([Expt.Trials(:).bd]) & [Expt.Trials(:).dx]== max([Expt.Trials(:).bd]) & [Expt.Trials(:).RespDir]~=0; %flip pair to copmare
            else
                conditions(1,:) = [Expt.Trials(:).bd]>0 & [Expt.Trials(:).dx]==0 & [Expt.Trials(:).RespDir]~=0;
                conditions(2,:) = [Expt.Trials(:).bd]<0 & [Expt.Trials(:).dx]==0 & [Expt.Trials(:).RespDir]~=0;
                conditions(3,:) = [Expt.Trials(:).bd]<0 & [Expt.Trials(:).dx]<0 & [Expt.Trials(:).RespDir]~=0;
                conditions(4,:) = [Expt.Trials(:).bd]>0 & [Expt.Trials(:).dx]<0 & [Expt.Trials(:).RespDir]~=0;
                conditions(5,:) = [Expt.Trials(:).bd]<0 & [Expt.Trials(:).dx]>0 & [Expt.Trials(:).RespDir]~=0;
                conditions(6,:) = [Expt.Trials(:).bd]>0 & [Expt.Trials(:).dx]>0 & [Expt.Trials(:).RespDir]~=0;
                conditions(7,:) = [Expt.Trials(:).bd]== min([Expt.Trials(:).bd]) & [Expt.Trials(:).dx]== max([Expt.Trials(:).bd]) & [Expt.Trials(:).RespDir]~=0; %flip
                conditions(8,:) = [Expt.Trials(:).bd]== max([Expt.Trials(:).bd]) & [Expt.Trials(:).dx]== max([Expt.Trials(:).bd]) & [Expt.Trials(:).RespDir]~=0; %flip pair to copmare
                conditions(9,:) = [Expt.Trials(:).bd]>0 & [Expt.Trials(:).dx]>0 & [Expt.Trials(:).RespDir]~=0;
                conditions(10,:)= [Expt.Trials(:).bd]== max([Expt.Trials(:).bd]) & [Expt.Trials(:).dx]== min([Expt.Trials(:).bd]) & [Expt.Trials(:).RespDir]~=0; %flip
                conditions(11,:)= [Expt.Trials(:).bd]== min([Expt.Trials(:).bd]) & [Expt.Trials(:).dx]== min([Expt.Trials(:).bd]) & [Expt.Trials(:).RespDir]~=0; %flip pair to compare 
            end
     else if strcmp(FileType, 'BDID')
             conditions = GetConditions(Expt, FileType, pD);
%              if(pD == 2)
%                     conditions(1,:) = [Expt.Trials(:).bd]<0 & [Expt.Trials(:).Id]<0 & [Expt.Trials(:).RespDir]~=0;
%                     conditions(2,:) = [Expt.Trials(:).bd]<0 & [Expt.Trials(:).Id]>0 & [Expt.Trials(:).RespDir]~=0;
%                     conditions(3,:) = [Expt.Trials(:).bd]<0 & [Expt.Trials(:).Id]<0 & [Expt.Trials(:).RespDir]==ResponseToNegative;
%                     conditions(4,:) = [Expt.Trials(:).bd]<0 & [Expt.Trials(:).Id]<0 & [Expt.Trials(:).RespDir]==ResponseToPositive;
%                     conditions(5,:) = [Expt.Trials(:).bd]>0 & [Expt.Trials(:).Id]>0 & [Expt.Trials(:).RespDir]==ResponseToPositive;
%                     conditions(6,:) = [Expt.Trials(:).bd]>0 & [Expt.Trials(:).Id]>0 & [Expt.Trials(:).RespDir]==ResponseToNegative;
%                     conditions(7,:) = [Expt.Trials(:).Id]<0 & [Expt.Trials(:).RespDir]~=0; 
%                     conditions(8,:) = [Expt.Trials(:).Id]>0 & [Expt.Trials(:).RespDir]~=0; 
%                     conditions(9,:) = [Expt.Trials(:).bd]<0 & [Expt.Trials(:).RespDir]~=0; 
%                     conditions(10,:)= [Expt.Trials(:).bd]>0 & [Expt.Trials(:).RespDir]~=0; 
%                 else
%                     conditions(1,:) = [Expt.Trials(:).bd]>0 & [Expt.Trials(:).Id]>0 & [Expt.Trials(:).RespDir]~=0;
%                     conditions(2,:) = [Expt.Trials(:).bd]>0 & [Expt.Trials(:).Id]<0 & [Expt.Trials(:).RespDir]~=0;
%                     conditions(3,:) = [Expt.Trials(:).bd]>0 & [Expt.Trials(:).Id]>0 & [Expt.Trials(:).RespDir]==ResponseToNegative;
%                     conditions(4,:) = [Expt.Trials(:).bd]>0 & [Expt.Trials(:).Id]>0 & [Expt.Trials(:).RespDir]==ResponseToPositive;
%                     conditions(5,:) = [Expt.Trials(:).bd]<0 & [Expt.Trials(:).Id]<0 & [Expt.Trials(:).RespDir]==ResponseToNegative;
%                     conditions(6,:) = [Expt.Trials(:).bd]<0 & [Expt.Trials(:).Id]<0 & [Expt.Trials(:).RespDir]==ResponseToPositive;
%                     conditions(7,:) = [Expt.Trials(:).Id]>0 & [Expt.Trials(:).RespDir]~=0;
%                     conditions(8,:) = [Expt.Trials(:).Id]<0 & [Expt.Trials(:).RespDir]~=0;
%                     conditions(9,:) = [Expt.Trials(:).bd]>0 & [Expt.Trials(:).RespDir]~=0; 
%                     conditions(10,:)= [Expt.Trials(:).bd]<0 & [Expt.Trials(:).RespDir]~=0; 
%              end
         else
             conditions = GetConditions(Expt, FileType, pD);
%             if(pD == 2) % DID , ...
%                 conditions(1,:) = [Expt.Trials(:).Id]<0 & [Expt.Trials(:).dx]==0 & [Expt.Trials(:).RespDir]~=0;
%                 conditions(2,:) = [Expt.Trials(:).Id]>0 & [Expt.Trials(:).dx]==0 & [Expt.Trials(:).RespDir]~=0;
%                 conditions(7,:) = [Expt.Trials(:).Id]<0 & [Expt.Trials(:).dx]==0 & [Expt.Trials(:).RespDir]==ResponseToNegative;
%                 conditions(8,:) = [Expt.Trials(:).Id]>0 & [Expt.Trials(:).dx]==0 & [Expt.Trials(:).RespDir]==ResponseToPositive;
%                 conditions(9,:) = [Expt.Trials(:).Id]<0 & [Expt.Trials(:).dx]==0 & [Expt.Trials(:).RespDir]==ResponseToNegative;
%                 conditions(10,:)= [Expt.Trials(:).Id]<0 & [Expt.Trials(:).dx]==0 & [Expt.Trials(:).RespDir]==ResponseToPositive;
%                 conditions(11,:)= [Expt.Trials(:).Id]>0 & [Expt.Trials(:).dx]==0 & [Expt.Trials(:).RespDir]==ResponseToPositive;
%                 conditions(12,:)= [Expt.Trials(:).Id]>0 & [Expt.Trials(:).dx]==0 & [Expt.Trials(:).RespDir]==ResponseToNegative;
%             else 
%                 conditions(1,:) = [Expt.Trials(:).Id]>0 & [Expt.Trials(:).dx]==0 & [Expt.Trials(:).RespDir]~=0;
%                 conditions(2,:) = [Expt.Trials(:).Id]<0 & [Expt.Trials(:).dx]==0 & [Expt.Trials(:).RespDir]~=0;
%                 conditions(7,:) = [Expt.Trials(:).Id]>0 & [Expt.Trials(:).dx]==0 & [Expt.Trials(:).RespDir]==ResponseToPositive;
%                 conditions(8,:) = [Expt.Trials(:).Id]<0 & [Expt.Trials(:).dx]==0 & [Expt.Trials(:).RespDir]==ResponseToNegative;
%                 conditions(9,:) = [Expt.Trials(:).Id]>0 & [Expt.Trials(:).dx]==0 & [Expt.Trials(:).RespDir]==ResponseToPositive;
%                 conditions(10,:)= [Expt.Trials(:).Id]>0 & [Expt.Trials(:).dx]==0 & [Expt.Trials(:).RespDir]==ResponseToNegative;
%                 conditions(11,:)= [Expt.Trials(:).Id]<0 & [Expt.Trials(:).dx]==0 & [Expt.Trials(:).RespDir]==ResponseToNegative;
%                 conditions(12,:)= [Expt.Trials(:).Id]<0 & [Expt.Trials(:).dx]==0 & [Expt.Trials(:).RespDir]==ResponseToPositive;
%             end
        end
    end
    end    
    
    if(sum(conditions(1,:))<7 || sum(conditions(2,:))<7)
        disp(strcat(num2str(iN) , ' - ', num2str(NeuronNumber, '%-4.3d') , ' - ', num2str(size([Expt.Trials(:)],1)), ' - TOO LOW TRIAL COUNT - BEWARE ! ! ! ', num2str(sum(conditions(1,:))), ' - ',num2str(sum(conditions(2,:)))));
        toolowFR = 1;
        continue;
    end
    

    if (FinishTime == 0)
        if(isfield(Expt.Trials, 'dur'))
            FinishTime = round(median([Expt.Trials(:).dur])) + 500;
        else
            FinishTime = round(median([Expt.Trials(:).End] - [Expt.Trials(:).Start])) + 500;
        end
    end
    SpikeCounts = zeros(length([Expt.Trials]),1);
    for tr = 1: length([Expt.Trials]), 
        SpikeCounts(tr) = sum([Expt.Trials(tr).Spikes]>=StartTime & [Expt.Trials(tr).Spikes]<=FinishTime);
    end
    
    if (strcmpi(FileType, 'DPI'))
        dprs = []; dprsdxp=[]; dprsdxn=[];
        for ss = 1: length(Speeds),
            cs = (abs(deltafxy) == Speeds(ss));
            dprs(ss) = dPrime(SpikeCounts(conditions(1,:) & cs), SpikeCounts(conditions(2,:) & cs));
            dprsdxp(ss) = dPrime(SpikeCounts(conditions(3,:) & cs), SpikeCounts(conditions(4,:) & cs));
            dprsdxn(ss) = dPrime(SpikeCounts(conditions(6,:) & cs), SpikeCounts(conditions(5,:) & cs));
        end
        dprs(1+ length(Speeds)) = dPrime(SpikeCounts(conditions(1,:)), SpikeCounts(conditions(2,:)));
        dprsdxp(1+ length(Speeds)) = dPrime(SpikeCounts(conditions(3,:)), SpikeCounts(conditions(4,:)));
        dprsdxn(1+ length(Speeds)) = dPrime(SpikeCounts(conditions(6,:)), SpikeCounts(conditions(5,:)));

        dprimes{iN} = [dprs dprsdxp dprsdxn];

        NS{iN} = {SpikeCounts, conditions, deltafxy};
 
    else

    if (strcmpi(FileType, 'BDID'))
        %IdBiasROC1(iN) = ROCAUC(SpikeCounts(conditions(3,:)|conditions(4,:)), SpikeCounts(conditions(5,:)|conditions(6,:)));
        IdBiasROC1(iN) = ROCAUC(SpikeCounts(conditions(1,:)), SpikeCounts(conditions(5,:)|conditions(6,:)));
        [rr, pp] = ROCAUCSignificance(SpikeCounts(conditions(1,:)), SpikeCounts(conditions(5,:)|conditions(6,:)));
        IdBiasROCSig(iN) = pp;
        
        IdBiasROC2(iN) = ROCAUC(SpikeCounts(conditions(7,:)), SpikeCounts(conditions(8,:)));
        [rr, pp] = ROCAUCSignificance(SpikeCounts(conditions(7,:)), SpikeCounts(conditions(8,:)));
        IdBiasROCSig2(iN) = pp;
        ROCpairs1{iN} = {SpikeCounts(conditions(7,:)), SpikeCounts(conditions(8,:))};
        
        
        IdBiasROC3(iN) = ROCAUC(SpikeCounts(conditions(9,:)), SpikeCounts(conditions(10,:)));
        [rr, pp] = ROCAUCSignificance(SpikeCounts(conditions(9,:)), SpikeCounts(conditions(10,:)));
        IdBiasROCSig3(iN) = pp;    
        
        bdCrossTalk(iN) = 0.5 * abs( (sum(conditions(16,:)) - sum(conditions(17,:))) / (sum(conditions(16,:)) + sum(conditions(17,:))) + ...
                                     (sum(conditions(18,:)) - sum(conditions(19,:))) / (sum(conditions(18,:)) + sum(conditions(19,:))) );

        bdCrossTalk2(iN)= 0.5 * abs( (sum(conditions(16,:)) - sum(conditions(19,:))) / (sum(conditions(16,:)) + sum(conditions(19,:))) + ...
                                     (sum(conditions(18,:)) - sum(conditions(17,:))) / (sum(conditions(18,:)) + sum(conditions(17,:))) );

        bdCrossTalk3(iN)= 0.5 *    ( (sum(conditions(16,:)) - sum(conditions(19,:))) / (sum(conditions(16,:)) + sum(conditions(19,:))) + ...
                                     (sum(conditions(18,:)) - sum(conditions(17,:))) / (sum(conditions(18,:)) + sum(conditions(17,:))) );                                 

        bdCrossTalk4(iN)= 0.5 * abs( (sum(conditions(16,:)) - sum(conditions(19,:))) / (sum(conditions(16,:)) + sum(conditions(19,:))))+ ...
                                abs( (sum(conditions(18,:)) - sum(conditions(17,:))) / (sum(conditions(18,:)) + sum(conditions(17,:))));
                            
        orS(iN) = ExperimentProperties(MonkeyName, NeuronNumber, ClusterName, StimulusType, FileType);
         if (orS(iN)==90)
             c1 = ([Expt.Trials(:).Id] > 0) & ([Expt.Trials(:).RespDir] > 0);
             c2 = ([Expt.Trials(:).Id] > 0) & ([Expt.Trials(:).RespDir] < 0);
             c3 = ([Expt.Trials(:).Id] < 0) & ([Expt.Trials(:).RespDir] > 0);
             c4 = ([Expt.Trials(:).Id] < 0) & ([Expt.Trials(:).RespDir] > 0);
         elseif (orS(iN)==-90)
             c1 = ([Expt.Trials(:).Id] < 0) & ([Expt.Trials(:).RespDir] > 0);
             c2 = ([Expt.Trials(:).Id] < 0) & ([Expt.Trials(:).RespDir] < 0);
             c3 = ([Expt.Trials(:).Id] > 0) & ([Expt.Trials(:).RespDir] > 0);
             c4 = ([Expt.Trials(:).Id] > 0) & ([Expt.Trials(:).RespDir] < 0);             
         elseif (orS(iN)==0)
             c1 = ([Expt.Trials(:).Id] > 0) & ([Expt.Trials(:).RespDir] > 0);
             c2 = ([Expt.Trials(:).Id] > 0) & ([Expt.Trials(:).RespDir] < 0);
             c3 = ([Expt.Trials(:).Id] < 0) & ([Expt.Trials(:).RespDir] > 0);
             c4 = ([Expt.Trials(:).Id] < 0) & ([Expt.Trials(:).RespDir] < 0);             
         elseif (orS(iN)==180)
             c1 = ([Expt.Trials(:).Id] < 0) & ([Expt.Trials(:).RespDir] > 0);
             c2 = ([Expt.Trials(:).Id] < 0) & ([Expt.Trials(:).RespDir] < 0);
             c3 = ([Expt.Trials(:).Id] > 0) & ([Expt.Trials(:).RespDir] > 0);
             c4 = ([Expt.Trials(:).Id] > 0) & ([Expt.Trials(:).RespDir] < 0);             
         else 
             c1 = 0; c2 = 0; c3 = 0; c4 = 0;
             disp(['ORIENTATION IS :  ', num2str(orS(iN)), '  WWHHAATT CCAANN II DDOO == == == == == == == =='])
         end
         bdCrossTalk5(iN) = 0.5 * ( ...
                            ((sum(c1) - sum(c2)) / (sum(c1) + sum(c2))) + ...
                            ((sum(c4) - sum(c3)) / (sum(c4) + sum(c3))) );
        
        % Choice Probability for Id trials
        IdCP1(iN) = ROCAUC(SpikeCounts(conditions(16,:)), SpikeCounts(conditions(17,:)));
        IdCP2(iN) = ROCAUC(SpikeCounts(conditions(19,:)), SpikeCounts(conditions(18,:)));
        IdCP3(iN) = 0.5 * (IdCP1(iN) + IdCP2(iN));
        IdCP4(iN) = ROCAUC(SpikeCounts(conditions(16,:) | conditions(19,:)), SpikeCounts(conditions(17,:) | conditions(18,:)));
 
    else % DID, ABD, TWO, DIDB, ...
        IdBiasROC1(iN) = ROCAUC(SpikeCounts(conditions(1,:)), SpikeCounts(conditions(2,:)));
        [rr, pp] = ROCAUCSignificance(SpikeCounts(conditions(1,:)), SpikeCounts(conditions(2,:))); 
        IdBiasROCSig(iN) = pp;
        ROCpairs1{iN} = {SpikeCounts(conditions(1,:)), SpikeCounts(conditions(2,:))};
        
        Next2ZeroROC1(iN) = ROCAUC(SpikeCounts(conditions(13,:)), SpikeCounts(conditions(14,:)));
        % next to zero z scored
        a = zscore(SpikeCounts(conditions(16,:)|conditions(17,:)));
        b = zscore(SpikeCounts(conditions(18,:)|conditions(19,:)));
        aa = [a(1 : sum(conditions(16,:))) ; b(1 : sum(conditions(18,:)))];
        bb = [a(sum(conditions(16,:))+1 : sum(conditions(16,:))+sum(conditions(17,:))) ; b(sum(conditions(18,:))+1 : sum(conditions(18,:))+sum(conditions(19,:)))];
        Next2ZeroROCZScored(iN) = ROCAUC(aa, bb);
        Next2ZeroROCPref(iN) = ROCAUC(SpikeCounts(conditions(16,:)), SpikeCounts(conditions(17,:)));
        Next2ZeroROCNull(iN) = ROCAUC(SpikeCounts(conditions(18,:)), SpikeCounts(conditions(19,:)));
        w1 = min(sum(conditions(16,:)),sum(conditions(17,:))); if (w1==0), w1 = max(sum(conditions(16,:)),sum(conditions(17,:))); end
        w2 = min(sum(conditions(18,:)),sum(conditions(19,:))); if (w2==0), w2 = max(sum(conditions(18,:)),sum(conditions(19,:))); end
        Next2ZeroROCPNWeigh(iN)= ((Next2ZeroROCNull(iN) * w1) + (Next2ZeroROCNull(iN) * w2)) / (w1 + w2);
        orS(iN) = ExperimentProperties(MonkeyName, NeuronNumber, ClusterName, StimulusType, FileType);
            end
    switch FileType
        case {'TWO', 'BDID'}
            if Expt.Stimvals.bo == Expt.Stimvals.or
                Manip(iN) = 1;
            else
                Manip(iN) = 2;
            end
        otherwise
            %CP(iN)      = ROCAUC(SpikeCounts(conditions(7,:)), SpikeCounts(conditions(8,:)));
            CP(iN)      = ROCAUC(SpikeCounts(conditions(20,:)), SpikeCounts(conditions(21,:)));
            CPPref(iN)  = ROCAUC(SpikeCounts(conditions(3,:)), SpikeCounts(conditions(5,:))); %CPPref(iN)  = ROCAUC(SpikeCounts(conditions(9,:)), SpikeCounts(conditions(10,:)));
            CPNull(iN)  = ROCAUC(SpikeCounts(conditions(4,:)), SpikeCounts(conditions(6,:))); %CPNull(iN)  = ROCAUC(SpikeCounts(conditions(11,:)), SpikeCounts(conditions(12,:)));
            %CP1(iN)     = ROCAUC(SpikeCounts(conditions(3,:)), SpikeCounts(conditions(5,:)));
            %CP2(iN)     = ROCAUC(SpikeCounts(conditions(6,:)), SpikeCounts(conditions(4,:)));
            %CPm(iN)     = mean([CP1(iN) CP2(iN)]);
            %CPeffect(iN)= CP1(iN) - CP2(iN);
    end
    if strcmp(FileType,'TWO')
        fa = ROCAUC(SpikeCounts(conditions(8,:)), SpikeCounts(conditions(7,:)));
        fb = ROCAUC(SpikeCounts(conditions(10,:)), SpikeCounts(conditions(11,:)));
        if abs(fa * fb ) ~= (fa * fb)
            disp('Fishy - - - - - - - - - - - 9 9 9 9 9 9 8  8 8 8( ( ((  ** * * * ');
            fa = 0; fb = 0;
        end
        FlipROC(iN) = 0.5 * ( fa + fb );
        ROCpairsFlip{iN} = {SpikeCounts(conditions(8,:)), SpikeCounts(conditions(7,:))};
        ROCpairsFlip{iN+ length(AllNeurons)} = {SpikeCounts(conditions(10,:)), SpikeCounts(conditions(11,:))};
    end

        % Bias Effectiveness 
        if ~strcmp(FileType, 'BDID')
            if(mean([Expt.Trials([Expt.Trials(:).dx]>0).RespDir])>0)
                ResponseToPositive = 1;
                ResponseToNegative = -1;
            else
                ResponseToPositive = -1;
                ResponseToNegative = 1;
            end
        
        if strcmp(FileType,'TWO')
            BiaEff(iN) = 100 * sum([Expt.Trials(:).dx] == 0 & [Expt.Trials(:).bd]<0 & [Expt.Trials(:).RespDir] == ResponseToNegative) / sum([Expt.Trials(:).dx] == 0 & [Expt.Trials(:).bd]<0 & [Expt.Trials(:).RespDir] ~= 0) ...
               - 100 * sum([Expt.Trials(:).dx] == 0 & [Expt.Trials(:).bd]>0 & [Expt.Trials(:).RespDir] == ResponseToNegative) / sum([Expt.Trials(:).dx] == 0 & [Expt.Trials(:).bd]>0 & [Expt.Trials(:).RespDir] ~= 0);
            BiaEffFlip(iN) = 0.5 * ( ...
                             100 * sum([Expt.Trials(:).dx] == max([Expt.Trials(:).dx]) & [Expt.Trials(:).bd] == [Expt.Trials(:).dx] & [Expt.Trials(:).RespDir] == ResponseToPositive) / sum([Expt.Trials(:).dx] == max([Expt.Trials(:).dx]) & [Expt.Trials(:).bd] == [Expt.Trials(:).dx] & [Expt.Trials(:).RespDir] ~= 0) ...
                           - 100 * sum([Expt.Trials(:).dx] == max([Expt.Trials(:).dx]) & [Expt.Trials(:).bd] ~= [Expt.Trials(:).dx] & [Expt.Trials(:).RespDir] == ResponseToPositive) / sum([Expt.Trials(:).dx] == max([Expt.Trials(:).dx]) & [Expt.Trials(:).bd] ~= [Expt.Trials(:).dx] & [Expt.Trials(:).RespDir] ~= 0) ...
                           + 100 * sum([Expt.Trials(:).dx] == min([Expt.Trials(:).dx]) & [Expt.Trials(:).bd] == [Expt.Trials(:).dx] & [Expt.Trials(:).RespDir] == ResponseToNegative) / sum([Expt.Trials(:).dx] == min([Expt.Trials(:).dx]) & [Expt.Trials(:).bd] == [Expt.Trials(:).dx] & [Expt.Trials(:).RespDir] ~= 0) ...
                           - 100 * sum([Expt.Trials(:).dx] == min([Expt.Trials(:).dx]) & [Expt.Trials(:).bd] ~= [Expt.Trials(:).dx] & [Expt.Trials(:).RespDir] == ResponseToNegative) / sum([Expt.Trials(:).dx] == min([Expt.Trials(:).dx]) & [Expt.Trials(:).bd] ~= [Expt.Trials(:).dx] & [Expt.Trials(:).RespDir] ~= 0) );
                       if isnan(BiaEffFlip(iN))
                           debug = 1;
                       end
            xo = Expt.Stimvals.xo;
            yo = Expt.Stimvals.yo;
            if (0<sum(NeuronNumber==[ 130 128 125 324 330]))
                RFproximity(iN) = -1;
                FxProximity(iN) = sqrt(xo^2 + yo^2); % - (szrf);
                disp(['----------------------------------------', num2str([FxProximity(iN),xo, yo])]);
            else
                if (isfield(Expt.Trials,'backxo')) 
                    bx = median([Expt.Trials(:).backxo]);
                else
                    bx = median([Expt.Stimvals.backxo]);
                end
                if (isfield(Expt.Trials,'backyo')) 
                    by = median([Expt.Trials(:).backyo]);
                else
                    by = median([Expt.Stimvals.backyo]);
                end
                sz = median([Expt.Trials(:).sz]);
                rf = RFFit(MonkeyName, NeuronNumber, ClusterName, 0);
                szrf = rf(1) + sz;
                RFproximity(iN) = sqrt((xo - bx )^2 + (yo - by) ^2 ) - (szrf);
                FxProximity(iN) = sqrt(xo^2 + yo^2); % - (szrf);
                disp(['----------------------------------------', num2str([FxProximity(iN), xo, yo])]);
            end
        else
            BiaEff(iN) = 100 * sum([Expt.Trials(:).dx] == 0 & [Expt.Trials(:).Id]<0 & [Expt.Trials(:).RespDir] == ResponseToNegative) / sum([Expt.Trials(:).dx] == 0 & [Expt.Trials(:).Id]<0 & [Expt.Trials(:).RespDir] ~= 0) ...
               - 100 * sum([Expt.Trials(:).dx] == 0 & [Expt.Trials(:).Id]>0 & [Expt.Trials(:).RespDir] == ResponseToNegative) / sum([Expt.Trials(:).dx] == 0 & [Expt.Trials(:).Id]>0 & [Expt.Trials(:).RespDir] ~= 0);
        end
        end
    end    

    if IdBiasROC1(iN) > 0.7
        disp( IdBiasROC1(iN));
        debug = 1;
    end
    if (strcmp(FileType, 'BDID') & abs(Expt.Stimvals.bo - Expt.Stimvals.or)~=90)% & (  Expt.Stimvals.or == 0 | Expt.Stimvals.or == 180 | Expt.Stimvals.or == -180))
        disp('Are you kidding! this is a * TWO Experiment');
        disp([IdBiasROC1(iN) Expt.Stimvals.or Expt.Stimvals.bo ]);
%         disp(Expt.Stimvals.xo);
%         disp(Expt.Stimvals.yo);
        thisisTWO(iN) = 1;
        debug = 1;
    end
    
    if(TI(iN)>0.077)
        IdColor{iN} = [1 0 0];
        DotSizes(iN) = 70; 
    else if (TI(iN)<-0.077)
            IdColor{iN} = [0 0 1];
            DotSizes(iN) = 70;
        else if(TI(iN) < 0)
                IdColor{iN} = [0.3 0.6 1];
                DotSizes(iN) = 40;
            else if(TI(iN) > 0)
                    IdColor{iN} = [1 0.6 0.3];
                    DotSizes(iN) = 40;
                else if (TI(iN) == 0 || isnan(TI(iN)))
                    IdColor{iN} = [0 0 0];
                    DotSizes(iN) = 100;
                    end
                end
            end
        end
    end
    if strcmpi(MonkeyName, 'icarus')
        IdColor{iN} = [0 0 0];
    end
    if toolowFR == 1
        DotSizes(iN) = 120;
    else
        DotSizes(iN) = 40;
    end
end

%% crosstalk

figure, hist(bdCrossTalk5(abs(orS)==90))
hold on , hist(bdCrossTalk5((orS==0) | (abs(orS)==180)))

%% or

bb = [0 45 90 135 ];
for i = 1: length(orS), 
    switch round(orS(i)) 
        case {-90, 80, 110, 115}, orSm(i) = 90; 
        case 180, orSm(i) = 0; 
        case {-135, -160, 30}, orSm(i) = 45; 
        case {-30, -45, 120}, orSm(i) = 135; 
        otherwise orSm(i) = orS(i); 
    end, 
end
g = zeros(length(orSm),1);
for i = 1: length(bb), g(orSm==bb(i)) = i; end

for i = 1:length(bb), m(i) = mean(IdBiasROC1(round(orSm) == round(bb(i)))); end
for i = 1:length(bb), e(i) = std(IdBiasROC1(round(orSm) == round(bb(i)))); end
figure(856), clf
errorbar(bb, m, e)
figure(678), scatter(orSm, IdBiasROC1, 'filled')
figure(698), scatter(orSm, BiaEff, 'filled')

[p,table,stats] = anova1(IdBiasROC1(abs(TI)>0.1), g(abs(TI)>0.1))
[p,table,stats] = anova1(BiaEff(abs(TI)>0.1), g(abs(TI)>0.1))




%% Graphics

switch(FileType)
    case 'DPi'
        for i = 1: length(dprimes),
            if(~isempty(dprimes{i}))
                if(~isnan(dprimes{i}(1)))
                    for j = 1: length(dprimes{i})
                        dps(i,j) = dprimes{i}(j);
                    end
                end
            end
        end

        figure, clf,
        clickscatter(TI, dps(:,4)') %, DotSizes, reshape(([IdColor{:}]), 3,length(IdColor))', 'filled');
        refline(0, 0); reflinexy(0,100);

        % d prime shift
        figure, clf,
        clickscatter(TI, (dps(:,4) - ((dps(:,8) + dps(:,12))./2))'); %, DotSizes, reshape(([IdColor{:}]), 3,length(IdColor))', 'filled');
        refline(0, 0); reflinexy(0,100);
        %  normalized d prime shift
        figure, clf,
        scatter(TI, ((dps(:,8) - dps(:,12))./ (dps(:,8) + dps(:,12)))', DotSizes, reshape(([IdColor{:}]), 3,length(IdColor))', 'filled');
        refline(0, 0); reflinexy(0,100);
   
    case 'BDID'
        figure(1123), clf, hist(IdBiasROC2);
        figure(1145), clf, clickscatter(TI, IdBiasROC2, 1, 7, fileNames); refline(0, 0.5);
    case 'TWO'
        figure(190), clf, clickscatter(IdBiasROC1, FlipROC, 1+(BiaEff>BiaEffFlip), 7, fileNames); %, DotSizes, reshape(([IdColor{:}]), 3,length(IdColor))', 'filled');
        refline(0, 0.5);
        ylabel('Flip ROC');
        xlabel('Main ROC');
        ylim([0.3 0.8]);
        xlim([0.2 0.9])
        
        
        figure(842), clf, 
        clickscatter(RFproximity, FlipROC, 1+(BiaEff>BiaEffFlip), 7, fileNames); %, DotSizes, reshape(([IdColor{:}]), 3,length(IdColor))', 'filled');
        refline(0, 0.5);
        ylabel('Flip ROC');
        xlabel('RF proximity');
        ylim([0.3 0.8]);
        %xlim([0.2 0.9])
        
    otherwise
        figure(17), clf, clickscatter(TI, IdBiasROC1, pDs, 7, fileNames) %, DotSizes, reshape(([IdColor{:}]), 3,length(IdColor))', 'filled');
        refline(0, 0.5);
        %figure, scatter(abs(TI), IdBiasROC1, [], reshape(([IdColor{:}]), 3,length(IdBiasROC1))', 'filled');

        sum(BiaEff>0) / length(BiaEff) % percentage inclusion for Correctly biased thing
        figure(23), clf, clickscatter(TI(BiaEff>0), IdBiasROC1(BiaEff>0),1, 7, fileNames); %, DotSizes(BiaEff>0), reshape(([IdColor{BiaEff>0}]), 3, sum(BiaEff>0))', 'filled');
        refline(0, 0.5);
        reflinexy(0,1);
  
end


%% ROC distribution analysis
% is our ROCs come from a single distribution or two or more groups of neurons

ROCvarTest(ROCpairs1);
if strcmp(FileType, 'TWO')
    ROCvarTest(ROCpairsFlip);
% else
%     if strcmp(FileType, 'BDID')
%         ROCvarTest(ROCpairsFlip);
%     end
end


%% Compaare with Bruce's
% figure, scatter(IdBiasROC1, flipud(data(:,2)), DotSizes, reshape(([IdColor{:}]), 3,63)', 'filled');
% 
% data = flipud(data);
% figure, scatter(TI, data(:,1), DotSizes, reshape(([IdColor{:}]), 3, 63)', 'filled')

