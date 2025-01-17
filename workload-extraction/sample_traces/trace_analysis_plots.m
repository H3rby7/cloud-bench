function [] = trace_analysis_plots(input_data, yformat)
    y_limits = yformat{1};
    y_scale = yformat{2};
    
    % ************** Split graphs by cluster **************
    trace_count_by_group_by_minutes = groupcounts(input_data,["cluster","ts_minute"]);
    clusters = unique(input_data.cluster);
    cluster_count = height(clusters);
    
    % Calculate grid sizes
    max_cluster_per_figure = 5;
    plot_count = ceil(cluster_count / max_cluster_per_figure);
    subplot_cols = ceil(sqrt(plot_count));
    subplot_rows = ceil(plot_count / subplot_cols);
    
    active_subplot_idx = 0;
    
    % Create new figure to force the plot into a new popup window
    f = figure();
    set(f,'Visible','off');
    for c=1:cluster_count
        if mod(c, max_cluster_per_figure) == 1
            % Start a new sub_plot
            active_subplot_idx = active_subplot_idx + 1;
            active_plot = subplot(subplot_rows, subplot_cols, active_subplot_idx);
            hold(active_plot, 'on');
        end

        cluster = clusters(c);
    
        % Plot into active sub_plot
        data = trace_count_by_group_by_minutes(trace_count_by_group_by_minutes.cluster == cluster, ["ts_minute", "GroupCount"]);
        label = "C" + num2str(cluster, "%02i");
        plot(active_plot, data, "ts_minute", "GroupCount", "DisplayName", label);
        
        if mod(c, max_cluster_per_figure) == 0 || c == cluster_count
            % Finishing touches to active sub_plot
            ylim(active_plot, y_limits);
            hold(active_plot, 'off');
            yscale(active_plot, y_scale);
            ylabel(active_plot, "Trace Count");
            xlabel(active_plot, "Minute");
            legend(active_plot, 'Location', 'bestoutside');
        end
    end
    set(f,'Visible','on');

end