function [] = trace_analysis_plots(input_data, ylimits)

    % ************** Split graphs by cluster **************
    trace_count_by_group_by_minutes = groupcounts(input_data,["cluster","ts_minute"]);
    cluster_count = max(trace_count_by_group_by_minutes.cluster);
    
    % Calculate grid sizes
    plot_count = 8;
    cluster_per_figure = ceil(cluster_count / plot_count);
    subplot_cols = ceil(sqrt(plot_count));
    subplot_rows = ceil(plot_count / subplot_cols);
    
    active_subplot_idx = 0;
    
    % Create new figure to force the plot into a new popup window
    f = figure();
    set(f,'Visible','off');
    for c=1:cluster_count
    
        if mod(c, cluster_per_figure) == 1
            % Start a new sub_plot
            active_subplot_idx = active_subplot_idx + 1;
            active_plot = subplot(subplot_rows, subplot_cols, active_subplot_idx);
            hold(active_plot, 'on');
        end
    
        % Plot into active sub_plot
        data = trace_count_by_group_by_minutes(trace_count_by_group_by_minutes.cluster == c, ["ts_minute", "GroupCount"]);
        label = "C" + num2str(c, "%02i");
        plot(active_plot, data, "ts_minute", "GroupCount", "DisplayName", label);
        ylim(active_plot, ylimits);
        
        if mod(c, cluster_per_figure) == 0
            % Finishing touches to active sub_plot
            hold(active_plot, 'off');
            yscale(active_plot, "log");
            ylabel(active_plot, "Trace Count");
            xlabel(active_plot, "Minute");
            legend(active_plot, 'Location', 'bestoutside');
        end
    end
    set(f,'Visible','on');

end