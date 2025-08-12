i=0
choice=0
x=0
y=0
while [ i -l 0 ]
    do
        echo "enter first number"
        read x
        echo "enter second number"
        read y
        ./choice.sh
        echo "enter selected no : "
                read choice
                case "$choice" in
                        1)
                            echo "$x + $y = $((x+y))"
                        ;;
                        2)
                            echo "$x - $y = $((x-y))"
                        ;;
                        3)
                            echo "$x * $y = $((x*y))"
                        ;;
                        4)
                            echo "$x / $y = $((x/y))"
                        ;;
                        5) 
                            ./power.sh $x $y
                        *)
                            echo "kcuh bhi !!"
                        ;;
                esac
        done