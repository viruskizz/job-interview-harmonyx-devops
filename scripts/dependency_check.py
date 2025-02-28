#!/usr/bin/env python3
"""
Dependency vulnerability checker script.
This script scans Python dependencies for known vulnerabilities.

SECURITY ISSUES:
1. Does not set exit code for CI/CD pipeline integration
2. No integration with central security monitoring
3. No remediation actions
4. Limited to one language (Python)
"""

import os
import sys
import json
import subprocess
import requests

def scan_requirements_file(filepath):
    """Scan requirements file for vulnerable dependencies"""
    if not os.path.exists(filepath):
        print(f"Error: {filepath} does not exist")
        return False
    
    try:
        # Get dependencies from requirements file
        with open(filepath, 'r') as f:
            dependencies = [line.strip() for line in f if line.strip() and not line.startswith('#')]
        
        vulnerable_deps = []
        
        # For each dependency, check if it has vulnerabilities
        for dep in dependencies:
            # Parse package name and version
            if '==' in dep:
                pkg_name, version = dep.split('==')
            else:
                pkg_name = dep
                # SECURITY ISSUE: Not checking unpinned dependencies properly
                version = 'latest'
            
            # SECURITY ISSUE: Using a fictional API without proper error handling
            # In a real implementation, use OSV or other vulnerability databases
            try:
                response = requests.get(f"https://example.com/api/vulnerabilities/{pkg_name}/{version}")
                if response.status_code == 200:
                    vulns = response.json()
                    if vulns:
                        vulnerable_deps.append({
                            'package': pkg_name,
                            'version': version,
                            'vulnerabilities': vulns
                        })
            except requests.exceptions.RequestException as e:
                print(f"Error checking {pkg_name}: {e}")
                continue
        
        # Output results
        if vulnerable_deps:
            print(f"Found {len(vulnerable_deps)} vulnerable dependencies in {filepath}:")
            for dep in vulnerable_deps:
                print(f"  {dep['package']}=={dep['version']}")
                for vuln in dep['vulnerabilities']:
                    print(f"    - {vuln['id']}: {vuln['description']}")
            return False
        else:
            print(f"No vulnerabilities found in {filepath}")
            return True
            
    except Exception as e:
        print(f"Error scanning dependencies: {e}")
        return False

def main():
    if len(sys.argv) != 2:
        print("Usage: python dependency_check.py <requirements_file>")
        # SECURITY ISSUE: Not setting proper exit code for automation
        return
    
    requirements_file = sys.argv[1]
    scan_result = scan_requirements_file(requirements_file)
    
    # SECURITY ISSUE: Not integrating with CI/CD pipeline through exit codes
    print("Scan completed.")

if __name__ == "__main__":
    main()
