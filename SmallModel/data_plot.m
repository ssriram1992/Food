function data_plot(s,pars,node,plot_info)

% manipulate and plot data from GAMS model

month_length = [28;31;30;31;30;31;31;30;31;30;31;31];

% get all of the parameters indexed by # of months from the start and get
% rid of advisory year data
q_food_market = zeros(s.f_n,s.n_n,s.I_n,s.y_n*s.m_n);
q_food_market_tot = zeros(s.f_n,s.n_n,s.y_n*s.m_n);
p_food_market = zeros(s.f_n,s.n_n,s.y_n*s.m_n);
q_food_store = zeros(s.f_n,s.n_n,s.y_n*s.m_n);
Q_food = zeros(s.c_n,s.n_n,s.y_n*s.m_n);
N_cattle = zeros(s.n_n,s.y_n*s.m_n);
A_crop = zeros(s.c_n,s.s_n*s.y_n);
food_loss_frac = zeros(s.c_n,s.n_n,s.y_n*s.m_n);

for f = 1:s.f_n
    for n = 1:s.n_n
        for y = 1:s.y_n
            for m = 1:s.m_n
                for I = 1:s.I_n
                    q_food_market(f,n,I,m+(y-1)*s.m_n) = ...
                        s.q_food_market(f,n,I,m,y,1)/month_length(m);
                end
                q_food_market_tot(f,n,m+(y-1)*s.m_n) = ...
                    s.q_food_market_tot(f,n,m,y,1)/month_length(m);
                p_food_market(f,n,m+(y-1)*s.m_n) = ...
                    s.p_food_market(f,n,m,y,1);
                q_food_store(f,n,m+(y-1)*s.m_n) = ...
                    s.q_food_store(f,n,m,y,1);
                if f <= s.c_n
                    Q_food(f,n,m+(y-1)*s.m_n) = s.Q_food(f,n,m,y,1);
                    food_loss_frac(f,n,m+(y-1)*s.m_n) = pars.r_loss_storage(f,s.node_nums(n),m,y,1);
                end
            end
        end
    end
end

for n = 1:s.n_n
    for y = 1:s.y_n
        for m = 1:s.m_n
            N_cattle(n,m+(y-1)*s.m_n) = s.N_cattle(n,m,y,1);
        end
    end
end

crop_legend = cell(s.s_n*s.y_n,1);
for y = 1:s.y_n
    for i = 1:s.s_n
        A_crop(:,i + s.s_n*(y-1)) = s.A_crop(:,i,node,y,1);
        crop_legend{i + s.s_n*(y-1)} = [char(s.season_names{i}(:)'), ...
            ' ', char(s.year_names{y}(:)')];
    end
end

% calculate imports, exports
cattle_imp = zeros(s.m_n*s.y_n,1);
cattle_exp = zeros(s.m_n*s.y_n,1);

for y = 1:s.y_n
    for m = 1:s.m_n
        cattle_imp(m + (y-1)*s.m_n) = sum(s.q_cattle_transp(:,6).*...
            (s.q_cattle_transp(:,2) == s.node_nums(node)).*...
            (s.q_cattle_transp(:,3) == m).*...
            (s.q_cattle_transp(:,4) == y).*...
            (s.q_cattle_transp(:,5) == 1));
        cattle_exp(m + (y-1)*s.m_n) = sum(s.q_cattle_transp(:,6).*...
            (s.q_cattle_transp(:,1) == s.node_nums(node)).*...
            (s.q_cattle_transp(:,3) == m).*...
            (s.q_cattle_transp(:,4) == y).*...
            (s.q_cattle_transp(:,5) == 1));
    end
    
end

food_imp = zeros(s.f_n,s.m_n*s.y_n);
food_exp = zeros(s.f_n,s.m_n*s.y_n);

for f = 1:(s.f_n)
    for m = 1:s.m_n
        for y = 1:s.y_n
            food_imp(f,m+(y-1)*s.m_n) = sum(s.q_food_transp(:,7).*...
                (s.q_food_transp(:,1) == f).*...
                (s.q_food_transp(:,3) == s.node_nums(node)).*...
                (s.q_food_transp(:,4) == m).*...
                (s.q_food_transp(:,5) == y).*...
                (s.q_food_transp(:,6) == 1));
            food_exp(f,m+(y-1)*s.m_n) = sum(s.q_food_transp(:,7).*...
                (s.q_food_transp(:,1) == f).*...
                (s.q_food_transp(:,2) == s.node_nums(node)).*...
                (s.q_food_transp(:,4) == m).*...
                (s.q_food_transp(:,5) == y).*...
                (s.q_food_transp(:,6) == 1));
        end
   end
end


if s.f_n < 6
    pars.gamma_nut = pars.gamma_nut(:,[1:4,6]);
end

% calculate nutrition
nuts = pars.r_loss_utilization*...
    permute(q_food_market_tot(:,node,:),[3 1 2])*pars.gamma_nut';

for I = 1:s.I_n
    for g = 1:2        
        nuts_adult_Ig(:,:,I,g) = pars.r_loss_utilization*pars.w(4,g)/pars.mu_w*...
            permute(q_food_market(:,node,I,:),[4 1 2 3])*pars.gamma_nut';
    end
end

% calculate average diet (consumption) composition
diets = zeros(s.f_n,s.I_n);
diets_cal = zeros(s.f_n,s.I_n);
diets_pro = zeros(s.f_n,s.I_n);

for f = 1:s.f_n
    for I = 1:s.I_n
        
        if s.y_n > 1
            diets(f,I) = sum(q_food_market(f,node,I,13:s.y_n*s.m_n));
        else
            diets(f,I) = sum(q_food_market(f,node,I,:));
        end
        diets_cal(f,I) = diets(f,I)*pars.gamma_nut(2,f);
        diets_pro(f,I) = diets(f,I)*pars.gamma_nut(1,f);
    end
end

for I = 1:s.I_n
    diets(:,I) = 100*round(diets(:,I)/sum(diets(:,I)),3);
    diets_cal(:,I) = 100*round(diets_cal(:,I)/sum(diets_cal(:,I)),3);
    diets_pro(:,I) = 100*round(diets_pro(:,I)/sum(diets_pro(:,I)),3);
end

% start plotting figures
figure
hold on
for f = 1:s.f_n
    plot(permute(p_food_market(f,node,:),[3 2 1]));
end
title('Food Prices')
legend(s.food_names);
xlabel('months');
ylabel('$/kg');
xlim([0 s.y_n*s.m_n])
ax = gca;
ax.XTick = 0:12:s.y_n*s.m_n;
grid on
hold off

figure
hold on
for f = 1:s.f_n
    plot(permute(q_food_market_tot(f,node,:),[3 2 1]));
end
title('Food Consumption (Average per day)');
legend(s.food_names);
xlabel('months');
ylabel('million kg');
xlim([0 s.y_n*s.m_n])
ax = gca;
ax.XTick = 0:12:s.y_n*s.m_n;
grid on
hold off

figure
hold on
for f = 1:s.c_n
    plot(permute(Q_food(f,node,:),[3 2 1]));
end
title('Food in Storage');
legend(s.food_names{1:s.c_n});
xlabel('months');
ylabel('million kg');
xlim([0 s.y_n*s.m_n])
ax = gca;
ax.XTick = 0:12:s.y_n*s.m_n;
grid on
hold off

figure
hold on
for n = 1:s.n_n
    plot(N_cattle(n,:)/1e3);
end
title('Total Cattle');
legend(num2str([1:s.n_n]'));
xlabel('months');
ylabel('million cattle')
legend(num2str(s.node_nums))
xlim([0 s.y_n*s.m_n])
ax = gca;
ax.XTick = 0:12:s.y_n*s.m_n;
grid on
hold off

figure
bar(A_crop);
title('Crop Area');
legend(crop_legend{:});
ax = gca;
set(ax,'XTickLabel',s.food_names(1:s.c_n))
xlabel('crop');
ylabel('million m^2')
grid on

% focus on specific plots of interest
switch plot_info
    
    case 'income'
        
        figure
        hold on        
        for g = 1:2
            for I = 1:s.I_n      
                plot(nuts_adult_Ig(:,2,I,g))
            end
            plot(permute(nuts_adult_Ig(:,2,:,g),[1 3 2 4])*pars.rho_I,...
                'LineWidth',3)
        end
        legend('male low','male medium','male high','male average','female low',...
            'female medium','female high','female average')
        title('Adult Caloric Intake (disaggregated by gender, income)')
        xlabel('months')
        ylabel('1000 kilocalories per day')
        xlim([0 s.y_n*s.m_n])
        ax = gca;
        ax.XTick = 0:12:s.y_n*s.m_n;
        grid on
        hold off
        
        figure
        hold on        
        for g = 1:2
            for I = 1:s.I_n      
                plot(nuts_adult_Ig(:,1,I,g))
            end
            plot(permute(nuts_adult_Ig(:,1,:,g),[1 3 2 4])*pars.rho_I,...
                'LineWidth',3)
        end
        legend('male low','male medium','male high','male average','female low',...
            'female medium','female high','female average')
        title('Adult Protein Intake (disaggregated by gender, income)')
        xlabel('months')
        ylabel('100 g protein per day')
        xlim([0 s.y_n*s.m_n])
        ax = gca;
        ax.XTick = 0:12:s.y_n*s.m_n;
        grid on
        hold off
        
        figure
        hold on
        for I = 1:s.I_n
            plot(permute(q_food_market(5,node,I,:)/pars.mu_w,[4 3 2 1]))
        end
        legend('low','medium','high')
        title('Daily Adult Male Average Meat Consumption')
        xlim([0 s.y_n*s.m_n])
        ax = gca;
        ax.XTick = 0:12:s.y_n*s.m_n;
        grid on
        hold off
        
        
    case 'diet_comp'
        
        for I = 1:s.I_n
            figure
            p = pie(diets(:,I));
            title('Average diet composition (by mass)')
            legend(s.food_names);
            for f = 1:s.f_n
                p(2*f).String = [num2str(diets(f,I)) '%'];
            end
            
        end
        
        for I = 1:s.I_n
            figure
            p = pie(diets_cal(:,I));
            title('Average diet composition (by calories)')
            legend(s.food_names);
            for f = 1:s.f_n
                p(2*f).String = [num2str(diets_cal(f,I)) '%'];
            end
        end
        
        for I = 1:s.I_n
            figure
            p = pie(diets_pro(:,I));
            title('Average diet composition (by protein)')
            legend(s.food_names);
            for f = 1:s.f_n
                p(2*f).String = [num2str(diets_pro(f,I)) '%'];
            end
        end
        
    case 'trade'
        figure
        hold on
        for f = 1:(s.f_n)
            plot(food_imp(f,:));
        end
        title('Total Food Imports')
        legend(s.food_names)
        xlabel('month');
        ylabel('million kg')
        xlim([0 s.y_n*s.m_n])
        ax = gca;
        ax.XTick = 0:12:s.y_n*s.m_n;
        grid on
        hold off

        figure
        hold on
        for f = 1:(s.f_n)
            plot(food_exp(f,:));
        end
        title('Total Food Exports')
        legend(s.food_names)
        xlabel('month');
        ylabel('million kg')
        xlim([0 s.y_n*s.m_n])
        ax = gca;
        ax.XTick = 0:12:s.y_n*s.m_n;
        grid on
        hold off
        
        figure
        hold on
        plot(cattle_imp/1e3);
        plot(cattle_exp/1e3);
        title('Total Cattle Trade')
        legend('Cattle Imported','Cattle Exported')
        xlabel('month');
        ylabel('million cattle')
        xlim([0 s.y_n*s.m_n])
        ax = gca;
        ax.XTick = 0:12:s.y_n*s.m_n;
        grid on
        hold off
        
    case 'waste'
        figure
        hold on
        for f = 1:(s.c_n)
            plot(permute(food_loss_frac(f,node,:),[3 2 1]));
        end
        title('Food Losses (as a % of storage)')
        legend('wheat','potatoes','peppers')
        xlabel('month');
        ylabel('percentage lost')
        xlim([0 s.y_n*s.m_n])
        ax = gca;
        ax.XTick = 0:12:s.y_n*s.m_n;
        grid on
        hold off

        figure
        hold on
        for f = 1:(s.c_n)
            plot(2:(s.m_n*s.y_n),permute(food_loss_frac(f,node,2:(s.m_n*s.y_n)).*...
                Q_food(f,node,1:(s.m_n*s.y_n-1)),[3 2 1]));
        end
        title('Food Losses')
        legend(s.food_names{1:s.c_n})
        xlabel('month');
        ylabel('total food lost (million kg)')
        xlim([0 s.y_n*s.m_n])
        ax = gca;
        ax.XTick = 0:12:s.y_n*s.m_n;
        grid on
        hold off
        
    case 'nutrition'
        figure
        hold on
        nuts(:,1) = nuts(:,1)*10;
        for nut = 1:3
            plot(nuts(:,nut)/pars.N_pop(s.node_nums(node)));
        end
        title('Average Nutrition per Day')
        legend('100g protein',' 1000 kcal','micronutrient measure')
        xlim([0 s.y_n*s.m_n])
        ax = gca;
        ax.XTick = 0:12:s.y_n*s.m_n;
        grid on
        hold off
        

end
