x1 = Izmit_data(:,1) .* 1000; % x1 Izmit data in meters
x3 = Izmit_data(:,2); % x3 Izmit data

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% (a)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% defining values of s and d1 for part a
part_a_s = 1;
part_a_d1 = [1000; 10000; 20000];

arctans_1a = zeros(22, 3);
arctans_2a = zeros(22, 3);
u3a = zeros(22, 3);

% calculating u3 for 1km, 10km, and 20km
for i = 1:3
    arctans_1a(:,i) = atan(x1 / part_a_d1(i));
    arctans_2a(:,i) = atan(x1 / 0);
    u3a(:,i) = (-part_a_s/pi) * (arctans_1a(:,i) - (arctans_2a(:,i)));
end

% plotting u3 at varying depths against x1
% also plots real Izmit data over model projections
close('all')
figure1 = figure;
axes1 = axes('Parent', figure1);
hold(axes1, 'all')

% converts x1 values back to km for plotting
plot(x1/1000, u3a, 'LineWidth', 2);
scatter(x1/1000, x3, 'LineWidth', 2);

title("u_3 versus x_1");
xlabel("x_1 (km)")
ylabel("u_3 (m)");
legend('1 km', '10 km', '20 km', 'Real Data');

% saves plot as a jpg, uncomment if plot is updated
% saveas(figure1,'../ProblemSet5/PartAFig.jpg')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% (b)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% defining values of s and d1 for part b
part_b_s = [1; 4; 7];
part_b_d1 = 10000;

arctans_1b = atan(x1 / part_b_d1);
arctans_2b = atan(x1 / 0);
u3b = zeros(22, 3);

% calcuating u3 at varying values of s
for i = 1:3
    u3b(:,i) = (-part_b_s(i)/pi) * (arctans_1b - (arctans_2b));
end

% plotting u3 at varying values of slip against x1
% also plots real Izmit data over model projections
figure2 = figure;
axes2 = axes('Parent', figure2);
hold(axes2, 'all')

plot(x1/1000, u3b, 'LineWidth', 2);
scatter(x1/1000, x3, 'LineWidth', 2);

title("u_3 versus x_1");
xlabel("x_1 (km)")
ylabel("u_3 (m)");
legend('1 m', '4 m', '7 m', 'Real Data');

% saves plot as a jpg, uncomment if plot is updated
% saveas(figure2,'../ProblemSet5/PartBFig.jpg') 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% (c)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

n = 100;

% calculates arctans of ratio between x1 and d2
arctans_2c = atan(x1 / 0);

% allocates room for values of u3 and errors between model and real data
u3c = zeros(22, n^2);
rmses = zeros(n^2, 3);

% creates ranges of values for s and d1
part_c_s = linspace(1, 10, n);
part_c_d1 = linspace(1000, 10000, n);


i = 1;
for s=part_c_s
    for d1=part_c_d1
        arctans_1c = atan(x1 / d1);

        % calculates values of u3 with each combination of s and d1
        u3c(:,i) = (-s/pi) * (arctans_1c - (arctans_2c));

        % finding root mean square error between our model and the data
        diffs = u3c(:,i) - x3;
        diffs_squared = diffs .^ 2;
        summed = sum(diffs_squared);
        mean = summed / 22;
        rmses(i, 1) = sqrt(mean);

        % to keep track of values of s and d1 associated with error
        rmses(i, 2) = s;
        rmses(i, 3) = round(d1/1000, 2);

        i = i + 1;
    end
end

% determines the index of the combination of values with least error
min_index = find(rmses(:,1) == min(rmses(:,1)));

% determines what combo produced least error
min_combo = [rmses(min_index, 2); rmses(min_index, 3)];

figure3 = figure;
axes3 = axes('Parent', figure3);
hold(axes3, 'all');

% plots values of u3 with the least error against x1
% overlays real data with our model
plot(x1/1000, u3c(:,min_index), 'LineWidth', 2);
scatter(x1/1000, x3, 'LineWidth', 2);

title("u_3 versus x_1 (s = " + string(rmses(min_index, 2)) + "m, d1 = " + string(rmses(min_index, 3)) + "km)");
xlabel("x_1 (km)")
ylabel("u_3 (m)");
legend('Model', 'Real Data');

% saves plot as a jpg, uncomment if plot is updated
% saveas(figure3,'../ProblemSet5/PartCFig.jpg') 