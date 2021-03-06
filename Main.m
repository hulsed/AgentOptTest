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

learnmode='best' %or 'rl'

params = [0.1, 0.5, 1, 1];
Qinit= -10000;
myMode=6;
useD=0;

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
func=@(x1,x2) -((1-x1).^2+100*(x2-x1.^2).^2);
[Var1,Var2]=meshgrid(var1,var2);
%funcv=((Var1-5).^2+(Var2-5).^2);
funcv=-((1-Var1).^2+100*(Var2-Var1.^2).^2);
subplot(2,2,1)
contour(Var1,Var2,funcv)
hold on
maxG=zeros(numRuns,1);
for r=1:numRuns
agents=create_agents(var1choices,var2choices, Qinit);
    
subplot(2,2,1)
loc_agent=plot(1,1, '*');
subplot(2,2,3)
agent1plot=bar(var1,agents{1});
xlim([min(var1),max(var1)])
subplot(2,2,2)
agent2plot=bar(var2,agents{2});
%rotate(agent2plot,[0 0 1],90)
xlim([min(var2),max(var2)])
camroll(90)


for e=1:numEpochs
   exploration.completion=e/numEpochs;
   actions=choose_actions(agents,exploration);
   action_hist(r,e,:)=actions;
   x1=var1(actions(1));
   x2=var2(actions(2));
   
   set(loc_agent, 'Xdata',x1, 'Ydata',x2)
   drawnow
   %pause(0.5)
   
   rewards=compute_rewards(useD,x1,x2,var1,var2, func);
   reward_hist(e,:)=rewards;
   G(r,e)=func(x1,x2);
   agents=update_values(agents,rewards,actions,alpha,learnmode);
   set(agent1plot,'Ydata',agents{1});
   drawnow
   set(agent2plot,'Ydata',agents{2});
   drawnow

if G(r,e)>maxG(r)
    maxG(r)=G(r,e);
    bestactions(r,:)=actions;
    bestE(r)=e;
end
end

end
figure
avgG=mean(G);
pos=max(G)-avgG;
neg=avgG-min(G);
plot(avgG)
errorbar(1:length(G),avgG,neg,pos)
hold on
plot(bestE,maxG,'o')

bestruns=find(action_hist(:,numEpochs,1)==bestactions(1) & action_hist(:,numEpochs,2)==bestactions(2));
numbest=length(bestruns);
