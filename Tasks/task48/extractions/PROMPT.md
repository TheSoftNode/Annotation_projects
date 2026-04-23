What's wrong with this code

#!/bin/bash

# **Purpose: Perform basic arithmetic operations (+, -, *, /)**

# **Ask user for the input**

read number1
read number2
read operation

# **Check if the operation is valid**

if [ "

operation"="+"];thenresult=

*operation*"="+"];*thenresult*=$((number1 + number2))
echo "$result"

elif [ "

operation"="−"];thenresult=

*operation*"="−"];*thenresult*=$((number1 - number2))
echo "$result"

elif [ "

operation"="∗"];thenresult=

*operation*"="∗"];*thenresult*=$((number1 * number2))
echo "$result"

elif [ "

operation"="/"];thenif["

*operation*"="/"];*thenif*["number2" -eq 0 ]; then
echo "Error: Cannot divide by zero."
else
result=

((number1/number2))echo"

((*number*1/*number*2))*echo*"result"
fi

else
echo "Invalid choice"
fi
