#!/usr/bin/env python3
"""
Incident Response Automation Script
This script detects and responds to security incidents automatically.

SECURITY ISSUES:
1. No proper error handling
2. Hardcoded credentials
3. Limited incident types
4. No proper logging
5. No integration with SIEM systems
"""

import os
import sys
import json
import time
import logging
import requests
import subprocess
from datetime import datetime

# Configure logging
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(name)s - %(levelname)s - %(message)s',
    filename='incident_response.log'
)
logger = logging.getLogger('incident-response')

# SECURITY ISSUE: Hardcoded credentials
API_KEY = "api_key_12345"
SLACK_WEBHOOK = "https://hooks.slack.com/services/T00000000/B00000000/XXXXXXXXXXXXXXXXXXXXXXXX"

class IncidentResponder:
    def __init__(self):
        self.incident_types = {
            "container_escape": self.handle_container_escape,
            "unauthorized_access": self.handle_unauthorized_access,
            "data_exfiltration": self.handle_data_exfiltration,
            "malware_detected": self.handle_malware,
            "privilege_escalation": self.handle_privilege_escalation
        }

    def detect_incidents(self):
        """Detect security incidents"""
        logger.info("Scanning for security incidents...")
        
        # SECURITY ISSUE: Simplified detection logic without real detection capabilities
        # In a real implementation, this would integrate with security monitoring systems
        
        # Simulate incident detection
        incidents = [
            {
                "type": "unauthorized_access",
                "timestamp": datetime.now().isoformat(),
                "source_ip": "10.0.0.5",
                "user": "suspicious_user",
                "resource": "database-server",
                "details": "Multiple failed login attempts followed by successful login",
                "severity": "high"
            }
        ]
        
        return incidents

    def respond_to_incidents(self, incidents):
        """Respond to detected incidents"""
        if not incidents:
            logger.info("No incidents detected.")
            return
        
        logger.info(f"Found {len(incidents)} incident(s). Responding...")
        
        for incident in incidents:
            incident_type = incident.get("type")
            
            if incident_type in self.incident_types:
                logger.info(f"Handling {incident_type} incident...")
                handler = self.incident_types[incident_type]
                handler(incident)
            else:
                logger.warning(f"Unknown incident type: {incident_type}")
                self.alert_security_team(incident)

    def handle_container_escape(self, incident):
        """Handle container escape incidents"""
        logger.info("Responding to container escape incident...")
        
        # Get the affected node and container
        node = incident.get("node", "unknown")
        container = incident.get("container", "unknown")
        
        # SECURITY ISSUE: No validation of commands
        
        # Isolate the node
        logger.info(f"Isolating affected node: {node}")
        # subprocess.run(["kubectl", "cordon", node])
        
        # Stop the container
        logger.info(f"Stopping affected container: {container}")
        # subprocess.run(["kubectl", "delete", "pod", container, "--force", "--grace-period=0"])
        
        # Alert security team
        self.alert_security_team(incident)
        
        logger.info("Container escape incident handled.")

    def handle_unauthorized_access(self, incident):
        """Handle unauthorized access incidents"""
        logger.info("Responding to unauthorized access incident...")
        
        # Get details
        source_ip = incident.get("source_ip", "unknown")
        user = incident.get("user", "unknown")
        resource = incident.get("resource", "unknown")
        
        # SECURITY ISSUE: No validation of inputs
        
        # Block the source IP
        logger.info(f"Blocking source IP: {source_ip}")
        # subprocess.run(["iptables", "-A", "INPUT", "-s", source_ip, "-j", "DROP"])
        
        # Lock the user account
        logger.info(f"Locking user account: {user}")
        # subprocess.run(["passwd", "--lock", user])
        
        # Alert security team
        self.alert_security_team(incident)
        
        logger.info("Unauthorized access incident handled.")

    def handle_data_exfiltration(self, incident):
        """Handle data exfiltration incidents"""
        logger.info("Responding to data exfiltration incident...")
        
        # Get details
        source_ip = incident.get("source_ip", "unknown")
        destination = incident.get("destination", "unknown")
        data_type = incident.get("data_type", "unknown")
        
        # Block the outbound connection
        logger.info(f"Blocking outbound connection to {destination}")
        # subprocess.run(["iptables", "-A", "OUTPUT", "-d", destination, "-j", "DROP"])
        
        # Revoke active sessions
        logger.info("Revoking active sessions")
        # In a real implementation, this would revoke sessions with IAM or similar
        
        # Alert security team
        self.alert_security_team(incident)
        
        logger.info("Data exfiltration incident handled.")

    def handle_malware(self, incident):
        """Handle malware detection incidents"""
        logger.info("Responding to malware detection incident...")
        
        # Get details
        host = incident.get("host", "unknown")
        file_path = incident.get("file_path", "unknown")
        malware_type = incident.get("malware_type", "unknown")
        
        # Isolate the host
        logger.info(f"Isolating affected host: {host}")
        # In a real implementation, this would use network isolation mechanisms
        
        # Quarantine the file
        logger.info(f"Quarantining malicious file: {file_path}")
        # In a real implementation, this would quarantine the file
        
        # Alert security team
        self.alert_security_team(incident)
        
        logger.info("Malware detection incident handled.")

    def handle_privilege_escalation(self, incident):
        """Handle privilege escalation incidents"""
        logger.info("Responding to privilege escalation incident...")
        
        # Get details
        user = incident.get("user", "unknown")
        process = incident.get("process", "unknown")
        host = incident.get("host", "unknown")
        
        # Kill the suspicious process
        logger.info(f"Killing suspicious process: {process}")
        # subprocess.run(["pkill", "-f", process])
        
        # Lock the user account
        logger.info(f"Locking user account: {user}")
        # subprocess.run(["passwd", "--lock", user])
        
        # Alert security team
        self.alert_security_team(incident)
        
        logger.info("Privilege escalation incident handled.")

    def alert_security_team(self, incident):
        """Send alert to security team"""
        logger.info("Alerting security team...")
        
        # Format the alert message
        severity = incident.get("severity", "unknown").upper()
        incident_type = incident.get("type", "unknown").replace("_", " ").title()
        timestamp = incident.get("timestamp", datetime.now().isoformat())
        details = incident.get("details", "No details available")
        
        message = f"*SECURITY INCIDENT: {severity} - {incident_type}*\n"
        message += f"*Time*: {timestamp}\n"
        message += f"*Details*: {details}\n"
        message += f"*Raw Data*: ```{json.dumps(incident, indent=2)}```"
        
        # SECURITY ISSUE: No error handling for failed alerts
        # In a real implementation, this would use proper error handling and fallback methods
        
        # Send to Slack (simulated)
        logger.info(f"Sending alert to Slack: {SLACK_WEBHOOK[:30]}...")
        
        # SECURITY ISSUE: No verification of SSL/TLS connections
        # requests.post(SLACK_WEBHOOK, json={"text": message})
        
        # Send email alert (simulated)
        logger.info("Sending email alert to security team...")
        # In a real implementation, this would send an email
        
        # Create incident ticket (simulated)
        logger.info("Creating incident ticket...")
        # In a real implementation, this would create a ticket in JIRA or similar
        
        logger.info("Security team alerted.")

def main():
    """Main function"""
    logger.info("Starting incident response automation...")
    
    responder = IncidentResponder()
    
    # SECURITY ISSUE: No proper daemon operation or scheduling
    # In a continuous operation mode, this would be scheduled or run as a daemon
    
    try:
        # Detect and respond to incidents
        incidents = responder.detect_incidents()
        responder.respond_to_incidents(incidents)
    except Exception as e:
        # SECURITY ISSUE: Generic exception handling
        logger.error(f"Error in incident response: {e}")
        # SECURITY ISSUE: No alerting on automation failure
        
    logger.info("Incident response automation completed.")

if __name__ == "__main__":
    main()
