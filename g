#!/bin/bash
formatage=$(python3 -c "print(\"$*\".replace(\" \", \"+\"))")
firefox https://www.google.com/search?q=$formatage&oq=$formatage&aqs=chrome.0.0j46j69i57j0l5.800j0j7&client=ubuntu&sourceid=chrome&ie=UTF-8
