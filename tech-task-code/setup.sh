#!/bin/bash
yum update -y
yum install -y httpd perl aws-cli
systemctl start httpd
systemctl enable httpd

# Enable CGI
sed -i 's/Options Indexes FollowSymLinks/Options +ExecCGI/' /etc/httpd/conf/httpd.conf
sed -i 's/#AddHandler cgi-script .cgi/AddHandler cgi-script .cgi/' /etc/httpd/conf/httpd.conf
systemctl restart httpd

# Create HTML page
cat <<'EOF' > /var/www/html/index.html
<html>
  <head><title>Dynamic Page</title></head>
  <body>
    <h1>The saved string is <span id="dynamic"></span></h1>
    <script>
      fetch('/cgi-bin/value.cgi')
        .then(response => response.text())
        .then(data => {
          document.getElementById('dynamic').innerText = data;
        });
    </script>
  </body>
</html>
EOF

# Create CGI endpoint
mkdir -p /var/www/cgi-bin
cat <<'EOF' > /var/www/cgi-bin/value.cgi
#!/bin/bash
echo "Content-type: text/plain"
echo ""
aws ssm get-parameter --name "dynamic_string" --query "Parameter.Value" --output text --region us-east-1
EOF

chmod +x /var/www/cgi-bin/value.cgi

