function [label_accuracy, average_label_accuracy] = L_accuracy(prediction,testtarget)
% Caculate the Label accuracy and average label accuracy of testing
if size(prediction)~=size(testtarget)
      error( 'The sizes of prediction and turth are not match');
else
      [num_class,num_test]= size(testtarget);
       label_accuracy=zeros(1,num_class);
       for m=1:num_class
           temp1=prediction(m,:);
           temp2=testtarget(m,:);
           temp=temp1-temp2;
           correct=length(find(temp==0));
           accuracy=correct/num_test;
           label_accuracy(m)=accuracy;
       end
       average_label_accuracy = sum(label_accuracy)/num_class;
end