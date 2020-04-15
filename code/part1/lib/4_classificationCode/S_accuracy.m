function subset_accuracy = S_accuracy(prediction,testtarget)
% Caculate the Subset accuracy of testing.
if size(prediction)~=size(testtarget)
    error( 'The sizes of prediction and turth are not match');
else
    num_test= size(testtarget,2);
    num=0;
    for i=1:num_test
       if prediction(:,i)==testtarget(:,i)
          num=num+1;
       end  
    end
    subset_accuracy = num/num_test;
end