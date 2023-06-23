function [p_stouff, zr] = fp_stouffer(p,nshuf,tail)
%first dimension of p is the one that will be aggreagated
%tail must be 'left', 'right', or 'both', depending on a two-or one sided
%test is required

nsub = size(p,1);
p(p==1)=0.9999;
p(p==0)= 1/nshuf; 
zsr= norminv(p);
zr = squeeze(sum(zsr,1)./sqrt(nsub));

%ensure that disproportionally high p-values don't lead to low p-values
%after stouffer
p_stouff = normpdf(zr);

if strcmp(tail,'left')
    p_stouff(zr<=0) = 1;
elseif strcmp(tail,'right')
    p_stouff(zr>=0) = 1;
end

