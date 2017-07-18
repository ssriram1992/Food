% Ying Zhang Jun 2017 calculate pixel CYF

clear all
clc

warning off

%% Read data
load pre.mat
pre = pre*60*60*24; % mm
PPT = squeeze(nansum(pre,3));
[nlon,nlat,~,~,nyr] = size(pre);

load refET.mat
ET0 = squeeze(nanmean(refET,3)); % mm/day

load SOILdata.mat % soil texture parameters [Lat Lon (theta_fc,theta_wp)]
load input_crop_param.mat

%% Loop over crop types

Zs=750;  %max root depth set at 750mm, use different value for different crop may improve results

% calculate number of layers
nls=Zs/delZ;     % no. soil layers, integer by construction
SM=zeros(nls);   % vector of soil layers each of thickness delZ
tic
for icrop = 1:5 %1:maize; 2:millet; 3:teff; 4:wheat; 5:sorghum
    
    field = crop_name{icrop};
    Kc = Kcs.(field);
    Ky = Kys(icrop,:);
    ptab = ptabs(icrop);
    DUR=length(Kc); % crop duration in months
    m = plantingm(icrop);
    
    veg = str2num(crop_cal{icrop,1});
    flower = str2num(crop_cal{icrop,2});
    yield = str2num(crop_cal{icrop,3});
    ripen = str2num(crop_cal{icrop,4});
    
    CYF = NaN*zeros(nlon,nlat,nyr);
    RFDef = NaN*zeros(nlon,nlat,DUR,nyr);
    
    for i = 1:nlon  % loop over spatial elements
        disp([icrop i])
        
        for j = 1:nlat
            FC=SOIL(i,j,1);           % field capacity, mm/mm
            WP=SOIL(i,j,2);           % wilt point, mm/mm
            Sa=FC-WP;               % water available for crop ET
            D=Zs*Sa;                % maximum profile storage in mm
            % fD is used to adjust monthly effective precipitation
            fD=0.53+0.0116*D-0.0000894*(D^2)+0.000000232*(D^3);
            
            for y=1:nyr

                % set antecedent moisture for entire soil profile:
                ETSAtot=0;           % for water balance accounting
                PPTeSeason=0;
                
                PPTe=max((fD*(1.25*(PPT(i,j,m,y)^0.824)-2.93)*10^(0.000955*asm*ET0(i,j,m,y)*NDM(m))),0);
                PPTetot=PPTe;
                count=1;
                
%                 % count daily pre distribution over month (WBAL not 0 - need investigation)
%                 predist = squeeze(pre(i,j,:,m,y));
%                 distf = predist./sum(predist); % distribution factor
%                 PPTd = PPTe.*distf;
                PPTd=PPTe/NDM(m);    % assume daily ppte uniformity
                
                ETS = squeeze(refET(i,j,:,m,y)*asm);
                % ETS=ET0(i,j,m,y)*asm;   % maximum bare soil evaporation rate
                
                % initialize "day 0" soil moisture vector to WP:
                SM(:)=WP*delZ;       % this also resets for each plant date
                SMinit=sum(SM(:));   % total initial soil profile moisture
                DP=0;                % initializing value, deep percolation
                DDP=0;               % deep perc exiting profile (for WB calc)
                ASW=sum(SM(1:nls0)); % mm of H2O in evaporation zone
                TEW=(FC-0.5*WP)*Ze;  % total evaporable water in mm (constant)
                
                % daily loop - Kr values based on BOP moisture levels
                for d=1:NDM(m)
                    ASW0=ASW;
                    % Kr is the supply restiction coefficient on ETS:
                    Kr=min((max((ASW-0.5*(WP*Ze)),0)/((1-pe)*TEW)),1);
                    ETSA=Kr*ETS(d);    % actual soil evaporation
                    ETSAtot=ETSAtot+ETSA;
                    ASW=min(max((ASW+PPTd-ETSA),0),FC*Ze);
                    delASW=ASW-ASW0;  % change in profile storage, mm
                    % DP is surplus precip, assumed percolated down
                    delDP=max(PPTd-ETSA-delASW,0);
                    DP=DP+delDP;
                end   % end daily (d) loop
                
                % now, algorithm to redistribute DP below Ze:
                % Ze layers are uniform as calculated above
                SM(1:nls0)=((ASW/Ze)*delZ);
                if DP>0        % calculate only if percolation > 0
                    for l=nls0+1:nls
                        SM0=SM(l);
                        SM(l)=min((SM0+DP),(FC*delZ));
                        DP=max((DP-(SM(l)-SM0)),0);
                    end
                end
                DDP=DDP+DP;
                DP=0;    % any "unused" DP assumed lost
                
                % begin planting period
                Zr=50;         % initial root zone depth in mm
                % begin loop over growing period
                ETCM = NaN*zeros(1,DUR);
                ETAM = NaN*zeros(1,DUR);
                
                for im=1:DUR  % i maps to month of growing season, i=m+1
                    % set parameters for daily loop
                    ETC=ET0(i,j,m+im,y)*Kc(im);    % crop-specific demand mm/day
                    ETCM(im)=ETC*NDM(m+im);     % equiv. monthly pot. ETC
                    ETAM(im)=0;                % monthly initializing value
                    PPTe=max((fD*(1.25*(PPT(i,j,m+im,y)^0.824)-2.93)*10^(0.000955*ETCM(im))),0);
                    PPTetot=PPTetot+PPTe;
                    count=count+1;
                    
%                     %count daily pre distribution over month (WBAL not 0 - need investigation)
%                     predist = squeeze(pre(i,j,:,m+im,y));
%                     distf = predist./sum(predist); % distribution factor
%                     PPTd = PPTe.*distf;
                    PPTd=PPTe/NDM(m+im);       % assume daily ppte uniformity
                    
                    
                    p=ptab+0.04*(5-ETC);      % p is ETc-dependent
                    SW=sum(SM(1:(Zr/delZ)));  % mm of H2O in root zone
                    
                    % begin daily loop to estimate ETA via stress coefficient
                    for d=1:NDM(m+im)
                        
                        SW0=SW;        % for subsequent calc (mm)
                        Z0=Zr;         % "day 0" root depth (mm)
                        TAW=Zr*Sa;     % total available water (mm)
                        % Ks is stress coefficient
                        Ks=min(max((SW-(WP*Zr)),0)/((1-p)*TAW),1);
                        ETA=Ks*ETC;          % actual ETC mm
                        ETAM(im)=ETAM(im)+ETA; % additive over month (mm)
                        % now allow root to grow to EOD value
                        Zr=min(Zr+delZ,Zs);  % limit Zr=Zs
                        del=(Zr-Z0)/delZ;    % 1 if growth, 0 if no growth
                        % note must be modified if Zr not int. multiple of delZ
                        delSM=del*SM((Z0/delZ)+1); % moisture in added layer
                        SW=min(max((SW+delSM+PPTd-ETA),0),FC*Zr);
                        delSW=SW-SW0;  % change in profile storage, mm
                        delDP=max(PPTd+delSM-ETA-delSW,0);
                        DP=DP+delDP;
                        
                    end   % end daily (d) loop
                    
                    % algorithm to redistribute DP below Zr:
                    %
                    nlsr=Zr/delZ;      % number of layers in root zone
                    SM(1:nlsr)=((SW/Zr)*delZ);  % mm per layer
                    if (DP>0 && nlsr<nls) % calculate only if required
                        for l=nlsr+1:nls
                            SM0=SM(l);     % for subsequent calculation
                            SM(l)=min((SM0+DP),(FC*delZ));
                            DP=max((DP-(SM(l)-SM0)),0);
                        end
                    end
                    DDP=DDP+DP;
                    DP=0;    % any "unused" DP assumed lost
                    %RAINFALL DEFICIT COMPUTATION - MONTHLY
                    RFDef(i,j,im,y)=max((ETAM(im)-PPTe),0); %CANNOT BE NEG; NO "CARRYOVER" TO NEXT MONTH
                end        % end growing season (i) loop
                
                % extract summary statistics for planting date & calc water bal
                ETCP=sum(ETCM);        % potential crop water ET demand
                ETCA=sum(ETAM);        % actual (supply limited) crop ET
                RET=ETCA/ETCP;         % relative ET
                
                %RAINFALL DEFICIT COMPUTATION - SUMMATION FOR SEASON
                RFDeficit=sum(RFDef,3);
                
                % introduce cropstage yield response coefficients
                % note that the number of such intermediate calculations will
                % depend on the total duration of the crop in quesiton
                
                ETC1=ETCM(veg);   % vegetative stage - 2 months (maize)
                ETC2=ETCM(flower);          % flowering - 1 month (maize)
                ETC3=ETCM(yield);          % yield formation - 2 month (maize)
                ETC4=ETCM(ripen);          % ripening - 1 month (maize)
                ETA1=ETAM(veg);   % actual vegetative
                ETA2=ETAM(flower);          % actual flowering
                ETA3=ETAM(yield);         % actual yield formation
                ETA4=ETAM(ripen);          % actual ripening
                RET1=max((1-Ky(2)*(1-(ETA1/ETC1))),0);
                RET2=max((1-Ky(3)*(1-(ETA2/ETC2))),0);
                RET3=max((1-Ky(4)*(1-(ETA3/ETC3))),0);
                if icrop~=4
                    RET4=max((1-Ky(5)*(1-(ETA4/ETC4))),0);
                end
                YAF0=max((1-Ky(1)*(1-RET)),0); % whole season
                YAFS=min(RET1,RET2);
                YAFS=min(YAFS,RET3);
                if icrop~=4
                    YAFS=min(YAFS,RET4);
                end
                YAF=min(YAF0,YAFS);          % choose limiting stage
                %Y_WH_4(z,(Zs/50-6),y)=YAF;  % output: Y_CROPNAME_STARTMONTH
                CYF(i,j,y)=YAF; %only for 750mm, at a given planting month
                % note that the above assumes soil depth starts at 350 mm
                
                % following are water balance accounting diagnostics
                SMfinal=sum(SM(:));         % final soil moisture storage
                deltaSM=SMfinal-SMinit;     % change in profile soil moisture
                WBAL=deltaSM-(PPTetot-ETSAtot-ETCA-DDP);  % should be 0
                if abs(WBAL) > 1e-6
                    disp(WBAL)
                end
                % following are diagnostic output files
                %dSMTEST((Zs/50-6),y)=deltaSM;    % diagnostic
                %PPTeTEST((Zs/50-6),y)=PPTetot;   % diagnostic
                %ETSATEST((Zs/50-6),y)=ETSAtot;   % diagnostic
                %ETCPTEST((Zs/50-6),y)=ETCP;      % diagnostic
                %ETCATEST((Zs/50-6),y)=ETCA;      % diagnostic
                %ETMATEST((Zs/50-6),y,1)=ETSAtot; % diagnostic
                %ETMATEST((Zs/50-6),y,2:6)=ETAM;  % diagnostic
                %DDPTEST((Zs/50-6),y)=DDP;        % diagnostic
                %WBALTEST((Zs/50-6),y)=WBAL;      % diagnostic
                              
            end            % end yearly (y) loop  
                        
        end
    end                    % end zonal (z) loop
    
    filename = strcat('CYF',field);
    save(filename, 'CYF','-v7.3')
    
%     if icrop<5
%         clearvars -except PPT ET0 SOIL Kcs  Kys  NDM Ze asm crop_cal crop_name delZ nls0 pe plantingm ptabs Zs nls SM
%     end
%     
end
toc