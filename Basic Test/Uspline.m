function U = Uspline(K)

U = (K.^2).*log(K.^2);
U(K==0) = 0;

end

