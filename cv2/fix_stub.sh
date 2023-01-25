#!/bin/zsh

gsed -i -E \
    -e "s/^\s+[\"'](.*)[\"']$/    \"\"\"\n    \1\n    \"\"\"/g" \
    -e "s/\\\n\./\n /g;s/dts:/dst:/g" \
    -e "s/@brief /\n    **brief**\n\n    /g" \
    -e "s/@param (\w+)/:param \1:/g" \
    -e "s/@return/\n\n    :return:/g" \
    -e "s/@(\w+)/\n\n    - **\1** :/g" \
    __init__.pyi

mv __init__.pyi __init__.pyi.backup

gsed -En '
/^\s+:param.*$/! {
    p; b
}
h
:X
n
/^\s+"""$/ {
    x; s/\n//g; 
    s/:param/\n    :param/g
    s/:return:/\n\n    :return:/g
    s/- \*\*/\n\n    - \*\*/g
    p;
    g; p; 
    b
}
H
bX
' __init__.pyi.backup > __init__.pyi