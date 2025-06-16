#!/bin/bash
yum update -y
yum install -y httpd aws-cli
systemctl start httpd
systemctl enable httpd

# Create dynamic HTML page using SSM
cat <<'EOF' > /var/www/html/index.html
<html>
  <head><title>Dynamic Page</title></head>
  <body>
    <h1>The saved string is $(aws ssm get-parameter --name "dynamic_string" --query "Parameter.Value" --output text --region us-east-1)</h1>
  </body>
</html>
EOF

