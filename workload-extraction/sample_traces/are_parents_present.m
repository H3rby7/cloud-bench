function [pass] = are_parents_present(trace)
    % as soon as one trace entry is falsy we drop the whole trace_id
    pass = true;
    
    for i=1:height(trace)
        rpc_id = trace.rpc_id{i};
        if rpc_id == '0'
            % entrypoint, the user call
            continue;
        end

        last_dot = find(rpc_id=='.',1,'last');
        last_digit = rpc_id(last_dot+1:end);
        if last_digit == '0'
            % numbering error (should never be 0)
            % drop trace, because last digit of rpc_id is '0'
            pass=false;
            break
        end

        rpc_id_parent = rpc_id(1:last_dot-1);
        if isempty(find(strcmp(trace.rpc_id,rpc_id_parent),1))
            % parent doesn't exist
            % drop trace, because parent ms rpc_id is not present
            pass=false;
            break
        end

        % in the original impl there is a sibling-rpc_id check that
        % complicatedly reconstructs its own rpc_id and looks for that
        % in the trace, where it will always find itself and be happy.
        % We skip that step.
    end
end