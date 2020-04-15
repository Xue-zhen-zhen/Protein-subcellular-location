function [accuracy,recall,precision,F1_score]=Accuracy(prediction,testtarget)
% Caculate the Accuracy of testing. 
if size(prediction)~=size(testtarget)
     error( 'The sizes of prediction and turth are not match');
else
     [num_class,num_test]= size(testtarget);
     scop=zeros(1,num_test);
     recall_new=zeros(1,num_class);
     precision_new=zeros(1,num_class);
     y_recall=zeros(1,num_class);
     y_precision=zeros(1,num_class);
     for i=1:num_test
         tmp1=testtarget(:,i)';
         tmp2=prediction(:,i)';
         mix=0;
         union=0;
         for j=1:length(tmp1)
             if tmp1(j)==tmp2(j)&&tmp1(j)==1
                mix=mix+1;
                union=union+1;
             end
             if tmp1(j)~=tmp2(j)
                 union=union+1;
             end
         end
         scop(i)=(mix/union);

         for j=1:num_class
             if tmp1(j)==1
                 y_recall(j)=y_recall(j)+1;
                 recall_new(j)=recall_new(j)+scop(i);
             end
             if tmp2(j)==1
                 y_precision(j)=y_precision(j)+1;
                 precision_new(j)=precision_new(j)+scop(i);
             end
         end      
     end
     accuracy=sum(scop)/num_test;
     for i=1:num_class
         recall_new(i)=recall_new(i)/y_recall(i);
         precision_new(i)=precision_new(i)/y_precision(i);
     end
     %calculate F1 score
     for i=1:num_class
         if ~isnan(precision_new(i))
             f1_score(i)=2*recall_new(i)*precision_new(i)/(recall_new(i)+precision_new(i));
         end
     end
     F1_score = mean(f1_score(:, ~isnan(f1_score)));
     recall = mean(recall_new(:, ~isnan(recall_new)));
     precision = mean(precision_new(:, ~isnan(precision_new)));
%      F1_score=sum(f1_score)/(num_class-length(find(isnan(precision_new))));
%      recall=sum(recall_new)/num_class;
%      precision=sum(precision_new(~isnan(precision_new)))/(num_class-length(find(isnan(precision_new)))); 
end