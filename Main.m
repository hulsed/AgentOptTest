clear all
close all
clc
expModes = {'const', 'decay', 'softmax', 'softmaxDecay', 'softmaxAdaptiveExp', 'softmaxAdaptiveLin'};
exploration.epsConst=0.1;
exploration.decayepsMax=0.5;
exploration.decayepsMin=0.01;
exploration.tempConst=100;
exploration.tempMin=500;
exploration.tempMax=10000;
exploration.biasMin=0.05;
exploration.biasMax=1;


params = [0.1, 0.5, 1, 1];
Qinit= 200;
myMode=6;
useD=1;

alpha=0.1;
numEpochs=100;
numRuns=20;


exploration.mode = expModes{myMode};
x1min=-2;
x1max=2;
x2min=-1;
x2max=3;

var1choices=9;
var2choices=9;

var1=linspace(x1min, x1max,var1choices);
var2=linspace(x2min, x2max,var2choices);

%func=@(x1,x2) 100-((x1-5).^2+(x2-5).^2);
func=@(x1,x2) 1000-((1-x1).^2+100*(x2-x1.^2).^2);
[Var1,Var2]=meshgrid(var1,var2);
%funcv=((Var1-5).^2+(Var2-5).^2);
funcv=1000-((1-Var1).^2+100*(Var2-Var1.^2).^2);
contour(Var1,Var2,funcv)
hold on
maxG=0;
for r=1:numRuns
loc_agent=plot(1,1, '*');
agents=create_agents(var1choices,var2choices, Qinit);
for e=1:numEpochs
   exploration.completion=e/numEpochs;
   actions=choose_actions(agents,exploration);
   action_hist(r,e,:)=actions;
   x1=var1(actions(1));
   x2=var2(actions(2));
   
   set(loc_agent, 'Xdata',x1, 'Ydata',x2)
   drawnow
   %pause(0.01)
   
   rewards=compute_rewards(useD,x1,x2,var1,var2, func);
   reward_hist(e,:)=rewards;
   G(r,e)=func(x1,x2);
   agents=update_values(agents,rewards,actions,alpha);
end
if G(r,e)>maxG
    maxG=G(r,e);
    bestactions=actions;
end
end
figure
plot(mean(G))
errorbar(mean(G),std(G))
bestruns=find(action_hist(:,numEpochs,1)==bestactions(1) & action_hist(:,numEpochs,2)==bestactions(2));
numbest=length(bestruns);
