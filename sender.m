message = [0 1 1];
% Simple handler to convert to PAM
codesymbol = @(x)x.*2-1;
codesymbol(message)
