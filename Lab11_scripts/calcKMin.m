%%
%==========================================================================
% This function calculates the minimum # of eigenvalues representing
% signals activity vs. noise, using the minimum descriptive length (MDL)
% criterion. The input parameters are the following:
% eigenVals         sample covariance matrix eigenvalues
% nObs              # of examples used to generate covariance matrix
% obsLen            dimension of examples used to generate covariance
%                   matrix
%
% A.Adams 21 January 2021
%==========================================================================

function [kVal, kMin] = calcKMin(sortEigVals, nObs, obsLen)

   %%
   %=======================================================================
   % Begin main loop
   %=======================================================================  
   allK = zeros(obsLen,1);
   allPhi = zeros(obsLen,1);
   allTheta = zeros(obsLen,1); 
   for kIdx = 0:obsLen-1 
       
       % Calculate phi
       geomMean = 1.0;
       for iIdx = kIdx+1:obsLen
            geomMean = geomMean*(sortEigVals(iIdx)^(1.0/(obsLen-kIdx)));
       end
       phi = geomMean;
       allPhi(kIdx+1) = phi; 
             
       % Calculate theta
       arithMean = 0;
       for iIdx = kIdx+1:obsLen
            arithMean = arithMean+sortEigVals(iIdx);
       end
       theta = arithMean/(obsLen-kIdx);
       allTheta(kIdx+1) = theta; 
       
       % Calculate new K value
       allK(kIdx+1) = -(obsLen-kIdx)*nObs*log(phi/theta)+0.5*kIdx*(2*obsLen-kIdx)*log(nObs); 
             
   end
   [kVal, tmp] = min(allK);  
   kMin = tmp-1; 
   
   %%
   %=======================================================================
   % Plot variables if desired
   %=======================================================================
   figure
   subplot(3,1,1)
   plot(allPhi, '*-')
   title('Phi'); 
   grid on
   subplot(3,1,2)
   plot(allTheta, '*-')
   grid on
   title('Theta'); 
   subplot(3,1,3); 
   plot(allK, '*-')
   grid on
   title('K'); 
      
end