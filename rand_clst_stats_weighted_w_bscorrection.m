function [h_corrected,h_real,crit_val,k] = rand_clst_stats_weighted_w_bscorrection(mat1,mat2,rand_num,time,ttl,a1,a2,bs,bs_corr_or_not)
%% rand stats

% rand_num = 1000;
% time = [5000:5800];

% rand dim is first dim so manually flipping these ones
% mat1 = mat1';
% mat2 = mat2';

k = nan(1,rand_num);

all = cat(1,mat1,mat2);
all_short = all(:,time);
mat1_short = mat1(:,time);
mat2_short = mat2(:,time);

[h_real,~,~,s] = ttest2(mat1_short,mat2_short,'Alpha',a1);

num1 = size(mat1,1);
num2 = size(mat2,1);


parfor rep = 1:rand_num
    rand = all_short(randperm(size(all_short,1)),:);
    
    [h_sim,~,~,s_sim] = ttest2(rand(1:num1,:),rand(num1+1:num1+num2,:));
    
    highest = 1;
    [L,Num]=spm_bwlabel(h_sim,18);
    for clst=1:Num
        curr_size = sum(abs(s_sim.tstat(L==clst)),'all');
        %curr_size = abs(trapz(s_sim.tstat(L==clst)));
        %curr_size = abs(trapz(s_sim.tstat(L==clst)));
%         curr_size = sum(L==clst,'all');
        if curr_size>highest
            highest = curr_size;
        end
    end
    k(rep)=highest;
    
end


alpha_corrected =  a2;
critbin = alpha_corrected * rand_num;
critbin = round(critbin);

[val,~]=sort(k,'descend');
crit_val = val(critbin);

if bs_corr_or_not==1
    %baseline correction
    [h_bs,~,~,s_bs] = ttest2(mat1(:,bs),mat2(:,bs));
    [L_bs,Num_bs]=spm_bwlabel(h_bs,18);
    highest = 0;
    for clst=1:Num_bs
        curr_size = abs(trapz(s_bs.tstat(L_bs==clst)));
%         curr_size = sum(L==clst,'all');
        if curr_size>highest
            highest = curr_size;
        end
    end
    
    crit_val = max([crit_val,highest]);
end
% h_corrected = h_real;

[L_real,Num_real] = spm_bwlabel(h_real,18);
h_corrected = L_real;

for clst=1:Num_real
    if sum(abs(s.tstat(L_real==clst)),'all')<crit_val
%     if abs(trapz(s.tstat(L_real==clst)))<crit_val
%     if sum(L_real==clst,'all')<crit_val
        h_corrected(L_real==clst)=0;
    end
    
end

% figure;plot(h_corrected);colorbar
% ylim([-0.5,1.5])
% legend
% title(ttl)

%save([ttl,'clst_stats.mat'],'h_corrected','h_real','rand_num','crit_val','k')