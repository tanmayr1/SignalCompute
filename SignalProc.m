function [sig, mean] = SignalProc(ref, reftime, time, threshold, filename)

    mark = 0;
    state = false;
    sig = zeros(0,2);
    j = 2;
    mean = 0;
    sig(1,1) = 0;

    if(ref(1) > threshold)
        sig(1,2) = 1;
        mark = time;
        state = true;
    end

    % Main Signal Process Logic
    for i = 2:size(ref,1)
    
        if(ref(i) > threshold)
            mark = reftime(i) + time;
            if(~state)
                sig(j,2) = 0;
                sig(j,1) = reftime(i)-0.0001;
                j = j+1;

                sig(j,2) = 1;
                sig(j,1) = reftime(i);
                j = j+1;
                state = true;
            end
        end
    
        if(mark < reftime(i) && state)
            sig(j,2) = 1;
            sig(j,1) = mark;
            
            mean = mean + sig(j,1) - sig(j-1,1);

            j = j+1;

            sig(j,2) = 0;
            sig(j,1) = mark + 0.0001;
            j = j+1;
            state = false;
        end
    end

    if(state)
        sig(j,2) = 1;
    else
        sig(j,2) = 0;
    end

    sig(j,1) = reftime(size(reftime,1));

    if(mean~=0)
        mean = mean/reftime(size(reftime,1));
    end

    % Write to a comma delimited csv file
    writematrix(sig,filename + ".csv");

    writematrix(mean, "PBit_" + filename + ".csv");
end