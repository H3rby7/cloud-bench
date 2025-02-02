function [] = metrics_requests_analysis_plots(input_data, metric, yformat)
    y_limits = yformat{1};
    y_scale = yformat{2};
    
    ms_names = unique(input_data.ms_name);
    ms_count = height(ms_names);
    
    % Calculate grid sizes
    max_ms_inst_per_figure = 5;
    plot_count = ceil(ms_count / max_ms_inst_per_figure);
    subplot_cols = ceil(sqrt(plot_count));
    subplot_rows = ceil(plot_count / subplot_cols);
    
    active_subplot_idx = 0;
    
    % Create new figure to force the plot into a new popup window
    f = figure();
    set(f,'Visible','off');
    for c=1:ms_count
        if mod(c, max_ms_inst_per_figure) == 1
            % Start a new sub_plot
            active_subplot_idx = active_subplot_idx + 1;
            active_plot = subplot(subplot_rows, subplot_cols, active_subplot_idx);
            hold(active_plot, 'on');
        end

        ms_name = ms_names{c};
    
        % Plot into active sub_plot
        data = input_data(strcmp(input_data.ms_name, ms_name), :);
        plot(active_plot, data, "requests", "mean_"+metric+"_utilization", "DisplayName", ms_name);
        
        if mod(c, max_ms_inst_per_figure) == 0 || c == ms_count
            % Finishing touches to active sub_plot
            ylim(active_plot, y_limits);
            hold(active_plot, 'off');
            yscale(active_plot, y_scale);
            ylabel(active_plot, "norm. " + upper(metric) + " util");
            xlabel(active_plot, "Requests");
            legend(active_plot, 'Location', 'bestoutside', 'FontSize', 4, 'Visible','off');
        end
    end
    set(f,'Visible','on');

end