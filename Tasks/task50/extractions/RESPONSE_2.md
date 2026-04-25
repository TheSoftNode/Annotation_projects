#### If the first option doesn't work, you can use an alternative approach by using a regular expression with `grep` to match lines that contain 'Z' but not the word 'grep':

#### ps aux | grep '\[Z\]' | grep \-v grep

####

### **Explanation:**

* #### `grep '[Z]'` matches lines containing the letter 'Z' (the square brackets prevent matching the word 'grep').

* #### `grep -v grep` filters out any lines containing the word 'grep'.