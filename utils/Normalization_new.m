function [ output] = Normalization_new( Input )
options.Nknots = [20 20];
options.NiterMax = 4;
options.flag_display = 0;
options.overs =1;
options.normalize = 1;
options.flag_allknots =1;
options.GainSmooth = 0.2;
options.Bgain = 0.8;
%% whole brain normalization
whole_brain_res= gray2ind(mat2gray(abs(Input)),4096);
M_res=whole_brain_res;
I0 = mean(double(M_res(:,:,1:100)),3);
%% update the outputs
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[mask,V_mean,V_std,Vfad] = NeckBackground(I0,0,1);
corner =  2;
percent = 0;
[Imask,Ibck] = NeckMask(Vfad,[2*V_mean,13*V_mean+V_std],corner,percent);
Imask4 = NeckMaskCLean(Imask);
%% update the outputs
[out,~,~]=PolyMaskFilter(double(I0),4,Imask4,0);
[B,~,~] = BiasCorrLEMSS2D(double(I0),Imask4,V_mean,V_std,options, out);
clear x;
clear p;

MASK=ones(size(Imask4));
idx=find(Imask4==1);
MASK(idx)=abs(B(idx));
for i=1:size(M_res,3)
    cor_M_res(:,:,i) = double(abs(Input(:,:,i)))./(imgaussfilt(MASK,15)+eps);
end
output = squeeze(cor_M_res);
toc

end


