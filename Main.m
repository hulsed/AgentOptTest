clear all
close all
clc

modes = {'const', 'decay', 'softmax', 'softmaxDecay'};

params = [0.1, 0.5, 1, 10];
Qinit= 200;
myMode=4;
useD=1;

alpha=0.1;
numEpochs=100;
numRuns=20;


AS.mode = modes{myMode};
AS.param1 = params(myMode);
AS.param2 = 0;

var1choices=10;
var2choices=10;

var1=linspace(1,10,var1choices);
var2=linspace(1,10,var2choices);

func=@(x1,x2) 100-((x1-5).^2+(x2-5).^2);
[Var1,Var2]=meshgrid(var1,var2);
funcv=((Var1-5).^2+(Var2-5).^2);

contour(Var1,Var2,funcv)
hold on

agents=create_agents(var1choices,var2choices, Qinit);
for r=1:numRuns
loc_agent=plot(1,1, '*');
for e=1:numEpochs
   AS.param2=e/numEpochs;
   actions=choose_actions(agents,AS);
   x1=var1(actions(1));
   x2=var2(actions(2));
   
   set(loc_agent, 'Xdata',x1, 'Ydata',x2)
   drawnow
   %pause(0.01)
   
   
   rewards=compute_rewards(useD,x1,x2,var1,var2, func);
   reward_hist(e,:)=rewards;
   agents=update_values(agents,rewards,actions,alpha);
   
end

end