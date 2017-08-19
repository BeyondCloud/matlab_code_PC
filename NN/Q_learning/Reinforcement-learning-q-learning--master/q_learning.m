%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Project <  Q_learning implement >
% Motive  : This is a very simple example show how q_learning works
% Date    : 2016/09/06
% Author  : Kun Da Lin
% Comments: Language: Matlab. 

% This is the most important formula of q_learning
% Q(state,x1)=  oldQ + alpha * (R(state,x1)+ (gamma * MaxQ(x1)) - oldQ);

% Here is state information
% (1,1) (1,2) (1,3) (1,4) (1,5) (1,6)     wall wall wall wall wall wall
% (2,1) (2,2) (2,3) (2,4) (2,5) (2,6)     wall                     wall
% (3,1) (3,2) (3,3) (3,4) (3,5) (3,6)     wall                     wall
% (4,1) (4,2) (4,3) (4,4) (4,5) (4,6)     wall                     wall
% (5,1) (5,2) (5,3) (5,4) (5,5) (5,6)     wall                     wall
% (6,1) (6,2) (6,3) (6,4) (6,5) (6,6)     wall wall wall wall wall wall

% start pos:(2,2)
% goal  pos:(5,5)

% Through this program you can see how agent learn to find a best way to
% reach it's goal. If agent bump into the wall, we will give -1 as the
% negative reward. On the controry, if agent hit the goal, we will give +1
% as the positive reward. You will see the q table gradually being an
% optimizing value and converge to the opitimal value.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear;
clc;
qtable = zeros(6,6,4);
round = 0;

while round<1
    map_matrix = [1,1,1,1,1,1;
                  1,0,1,0,0,1;
                  1,0,1,0,0,1;
                  1,0,0,0,0,1;
                  1,0,0,1,0,1;
                  1,1,1,1,1,1];
    round=round+1;
    pos_x=2;
    pos_y=2;
    count=0;

    while ~(pos_x==5 && pos_y==5) 
        a=0.9;
        b=0.8;
        % You can uncomment this code to see the visualization of q table.
        %plot_action(qtable,pos_x,pos_y);
        
        reward=0;
        count=count+1;
        rand_action = floor(mod(rand*4,4))+1; 
        [max_q, max_index] = max([qtable(pos_x,pos_y,1) ...
                                  qtable(pos_x,pos_y,2) ...
                                  qtable(pos_x,pos_y,3) ...
                                  qtable(pos_x,pos_y,4)]);

        if(qtable(pos_x,pos_y,rand_action)>=qtable(pos_x,pos_y,max_index))
            action = rand_action;
        else
            action = max_index;
        end
        map_matrix(pos_x,pos_y)=count;

        pre_pos_x=pos_x;
        pre_pos_y=pos_y;

        switch action

            case 1
                pos_x = pre_pos_x-1;   %up
            case 2
                pos_x = pre_pos_x+1;  %down
            case 3
                pos_y = pre_pos_y-1;  %left
            case 4
                pos_y = pre_pos_y+1;  %right

        end



        if(map_matrix(pos_x,pos_y)==1)
            pos_x = pre_pos_x;
            pos_y = pre_pos_y;
            reward=0;
            b=0;
            %disp('wall');
        end

        if(pos_x==5 && pos_y==5)
            reward=1;
            b=0;
        end

        [max_qtable, max_qtable_index] = max([qtable(pos_x,pos_y,1) ...
                                              qtable(pos_x,pos_y,2) ...
                                              qtable(pos_x,pos_y,3) ...
                                              qtable(pos_x,pos_y,4)]);

        % You can also uncomment this to see step by step how agen move
        % disp(['pos_x: ',num2str(pos_x),'  pos_y: ',num2str(pos_y)]); 
                %% This is how magic happened

       old_q=qtable(pre_pos_x,pre_pos_y,action);
       new_q=old_q+a*(reward+b*max_qtable-old_q);
       qtable(pre_pos_x,pre_pos_y,action)=new_q;


    end
    
    disp(['round:',num2str(round),' step:',num2str(count)]);
      
end
disp('If you can see the least step:6 in the end, then it');
disp('means the agent have already found the best way');
disp('to reach the goal');
disp('');
disp('Here is how agent move:');
disp(map_matrix);

plot_action(qtable,pos_x,pos_y);