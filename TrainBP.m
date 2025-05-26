clear;clc;close all;

%%

Name = {'��ֹ������ͨ��','��ֹͣ��','��ֹ��ת��'...
    'T��·��','խ�ţ�����6��','ע������'...
    '���к��','����ת��','�Ҳ���ʻ'}; % �����ź� ��һ���Ͷ�Ӧ 1.png �ڶ�������2.png 

Num = 9; % ��ʶͼƬ����
Image = cell(1,Num); % �������ͼ��

Scale = 40; % ͳһ����ͼƬ��С

Data = zeros(Scale*Scale,Num);

figure
for i = 1:Num
        
    Image{i} = imread(strcat(num2str(i),'.png'));
    
    if size(Image{i},3) ~= 1
        Image{i} = rgb2gray(Image{i});
    end
    Image{i} = imadjust(Image{i}); % �����Աȶ�
    
    Image{i} = imresize(Image{i},[Scale,Scale]); % �����40*40��ͼ��
 
    Image{i} = im2bw(Image{i}); % ��ֵ��
    subplot(4,5,i);
    imshow(Image{i});
   
    Data(:,i) = Image{i}(:); % ת��������
    
end

Dist = dist(Data);

Input = Dist;
Output = -1*ones(Num,Num);
Label = 1:Num;

for i = 1:Num
  
    Output(i,i) = 1;
    
end

% ת��������  ÿ��Num�� ģʽ����Ӧ����һ�е���1 ����Ϊ0

Input = [Input Input Input Input]; % �ظ�ѵ��
Output = [Output Output Output Output];

%% ��������

% �������� epochs
% ѵ��Ŀ�� goal
% ѧϰЧ�� lr

% ѧϰ���� trainFcn

% 'trainrp'   �����ݶ��½�
% 'traingdm'  ���Ӷ���
% 'traingdx'  ����Ӧ
% 'trainlm'   LM�㷨

rng(152,'twister'); % ���� �̶������  ������ֵ�������⻻
% �������˼�������� ÿ���ܳ��� ������̶���� ������������ �������ֵ �ǿ�����㻻�� ��һ�����һ�����


% ���� ����Ҹ��Ƚ���һ��  matlab��ANN һ����һ��Ŀ������ �Ǿ���ֹ�㷨�� 
% ���� ��������������100������ �����Լ��ֳ������� Ȼ��ֱ�ѵ���� ����ϸ����Ҳû����ϸ�о�

ly = [23];  %����ͽڵ���Ŀ [20,5] ����˼�� �������� ��һ��20 �ڶ���5 [3] ����˼���� һ�� 3����Ԫ

net_BP = feedforwardnet(ly);
net_BP.trainParam.epochs = 1e3;   % ѵ����������
net_BP.trainParam.goal = 1e-32;   % ѵ��Ŀ������
net_BP.trainParam.lr = 0.05;      % ѧϰ��
net_BP.trainParam.max_fail = 1e1;      % ������
net_BP.trainParam.min_grad = 1e-15;    % ��С�ݶ�

[net_BP,tr] = train(net_BP,Input,Output);
%nntraintool('close'); % �ر�ѵ������

% �������

% ѵ�����

T = sim(net_BP,Input);

Lab = zeros(1,Num); % ����ÿһ����ӽ�1��

for i = 1:Num
    
    [~,id] = min(abs(T(:,i)-1));
    Lab(i) = id(1);
    
end

E1 = (Lab-Label);

% ��ͼ

% �������ͼ

figure;
plot(tr.perf);
title('�������');

% ������

clc;

fprintf('\n\n>>ѵ�����:\n'); % ѵ�����
fprintf('  %d\n',sqrt(sum(E1.^2)/(numel(E1)-1)));

fprintf('\n\n>>��������:\n'); % ��������
fprintf('  %d\n',numel(tr.perf));

% ��ͼ

figure; % ��ʵ���ݸ��������ݶԱ�

plot(Lab,'ro');
hold on;
plot(Label,'.b');
legend('��������','��ʵ����');
xlim([1 Num]);

title(strcat('ʶ����������',num2str(sum(Lab~=Label))));

% ����ѵ���õ������Ա������õ�GUI��

Trained_BP = net_BP;

save Trained_BP Trained_BP
save Name Name
save Data Data