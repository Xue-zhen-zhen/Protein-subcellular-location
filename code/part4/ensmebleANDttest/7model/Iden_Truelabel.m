function trueLabel_N = Iden_Truelabel (TrueLabel_N)
if length(TrueLabel_N)==1
    if TrueLabel_N==1
        trueLabel_N = 'Cytoplasmic&membranous';
    elseif TrueLabel_N==2
        trueLabel_N = 'Cytoplasmic&membranous&nuclear';
    elseif TrueLabel_N==3
        trueLabel_N = 'Nuclear';
    end
else
    a1 = find(TrueLabel_N==1);a2 = find(TrueLabel_N==2);a3 = find(TrueLabel_N==3);
    if ~isempty(a1)
        temp{1,1}= 'Cytoplasmic&membranous';
    else
        temp{1,1}='';
    end
    if ~isempty(a2)
        temp{1,2}= 'Cytoplasmic&membranous&nuclear';
    else
        temp{1,2}='';
    end
    if ~isempty(a3)
        temp{1,3}= 'Nuclear';
    else
        temp{1,3}='';
    end
    trueLabel_N = strjoin(temp,';');
end
