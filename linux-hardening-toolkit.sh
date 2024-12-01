#!/bin/bash

# Log file with a timestamp
LOGFILE="linux_hardening_log_$(date +%Y-%m-%d_%H-%M-%S).txt"
CLEANED_REPORT="cleaned_lynis_audit_report_$(date +%Y-%m-%d_%H-%M-%S).txt"
EMAIL="example@gmail.com"

# Start logging
exec > >(tee -a "$LOGFILE") 2>&1

echo "Linux Hardening Toolkit - Starting..."
echo "Log file: $LOGFILE"
echo "---------------------------------------"

# 1. Disable Unnecessary Services
echo "Disabling unnecessary services..."
sudo systemctl disable bluetooth
sudo systemctl disable cups

# 2. Configure Firewall
echo "Configuring UFW firewall..."
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw enable

# 3. Enforce Strong Password Policies
echo "Setting strong password policies..."
sudo sed -i 's/^PASS_MAX_DAYS.*/PASS_MAX_DAYS   90/' /etc/login.defs
sudo sed -i 's/^PASS_MIN_DAYS.*/PASS_MIN_DAYS   7/' /etc/login.defs
sudo sed -i 's/^PASS_WARN_AGE.*/PASS_WARN_AGE   14/' /etc/login.defs

# 4. Set File Permissions
echo "Securing critical system files..."
sudo chmod 700 /root
sudo chmod 600 /etc/shadow
sudo chmod 600 /etc/gshadow

# 5. Enable System Auditing
echo "Installing and configuring Auditd..."
sudo apt install -y auditd
sudo systemctl enable auditd
sudo systemctl start auditd
sudo auditctl -e 1

# 6. Apply Updates
echo "Checking for and applying updates..."
sudo apt update && sudo apt upgrade -y

# 7. Verify SELinux or AppArmor
echo "Checking AppArmor status..."
sudo systemctl status apparmor

# 8. Run Lynis Audit
echo "Running Lynis security audit..."
sudo lynis audit system | tee lynis_audit_report.txt

# Ensure the report contains actual results
if grep -q "Initializing program" lynis_audit_report.txt; then
    # Clean the Lynis report to remove color codes
    echo "Cleaning Lynis audit report..."
    sed -r "s/\x1B\[[0-9;]*[a-zA-Z]//g" lynis_audit_report.txt > "$CLEANED_REPORT"
    echo "Cleaned report saved to $CLEANED_REPORT."

    # Send the cleaned report via email using mutt 
    echo "Sending cleaned Lynis audit report via email..."
    if command -v mutt > /dev/null; then
        echo "Please find the attached cleaned Lynis audit report." | mutt -s "Lynis Audit Report" -a "$CLEANED_REPORT" -- "$EMAIL"
    else
        echo "Error: mutt is not installed. Please install it using 'sudo apt install mutt'."
    fi
else
    echo "Error: Lynis audit failed. No meaningful report was generated."
fi

echo "Linux Hardening Toolkit - Completed!"
echo "Logs have been saved to $LOGFILE and the Lynis audit report to lynis_audit_report.txt."

