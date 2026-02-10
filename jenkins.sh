#!/bin/bash

# ----------------------------------------
# STEP-1: System update
# ----------------------------------------
yum update -y

# ----------------------------------------
# STEP-2: Install required tools (Git + Maven)
# ----------------------------------------
yum install -y git maven wget

# ----------------------------------------
# STEP-3: Install Java 17 (Required for Jenkins)
# ----------------------------------------
yum install -y java-17-amazon-corretto

# Verify Java
java -version

# ----------------------------------------
# STEP-4: Add Jenkins Repository
# ----------------------------------------
wget -O /etc/yum.repos.d/jenkins.repo \
https://pkg.jenkins.io/redhat-stable/jenkins.repo

rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key

# ----------------------------------------
# STEP-5: Install Jenkins
# ----------------------------------------
yum install -y jenkins

# ----------------------------------------
# STEP-6: Start & Enable Jenkins Service
# ----------------------------------------
systemctl daemon-reload
systemctl start jenkins
systemctl enable jenkins

# ----------------------------------------
# STEP-7: Check Jenkins Status
# ----------------------------------------
systemctl status jenkins --no-pager

# ----------------------------------------
# STEP-8: Open Jenkins Port (8080)
# ----------------------------------------
if systemctl is-active firewalld >/dev/null 2>&1; then
    firewall-cmd --permanent --add-port=8080/tcp
    firewall-cmd --reload
fi

# ----------------------------------------
# STEP-9: Show Initial Admin Password
# ----------------------------------------
echo "----------------------------------------"
echo "Jenkins Initial Admin Password:"
cat /var/lib/jenkins/secrets/initialAdminPassword
echo "----------------------------------------"

echo "Access Jenkins at: http://<SERVER-IP>:8080"
