# SecuLinux - Linux Hardening Toolkit

**SecuLinux** is a Linux hardening toolkit that automates the process of securing and hardening Linux systems. It performs essential security tasks, such as disabling unnecessary services, configuring firewalls, enforcing strong password policies, and enabling system auditing. The toolkit also runs a detailed security audit using **Lynis**, cleans the output, and sends the results via email for easy review.

## Features

- **System Hardening**:
  - Disable unnecessary services (e.g., Bluetooth, CUPS).
  - Configure UFW firewall with default deny/allow rules.
  - Enforce strong password policies (max/min days, warning age).
  - Set secure file permissions for critical system files.

- **System Auditing**:
  - Install and configure **Auditd** for system event logging.
  - Apply security updates and patches.
  - Run a **Lynis** security audit for a detailed analysis.

- **Report Generation**:
  - Automatically clean Lynis audit output and send a summary via email.
  
## Prerequisites

- **Lynis**: Used for security auditing. Installed automatically by the script.
- **Auditd**: For logging system events.
- **UFW**: Uncomplicated Firewall for managing firewall rules.
- **Mutt**: To send cleaned Lynis reports via email.
- **Mailutils**: For handling mail sending functionality.
  
## Installation

1. **Clone the repository**:
   ```bash
   git clone https://github.com/yourusername/SecuLinux.git
   cd SecuLinux
