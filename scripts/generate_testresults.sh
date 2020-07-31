#!/bin/bash
results=$(source "tests.sh")
echo -e "\`\`\`\n${results}\n\`\`\`" > .testresults.log
