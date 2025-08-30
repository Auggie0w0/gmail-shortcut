#!/bin/bash

# Gmail Hotkey Sender - macOS Shell Script
# This script provides hotkey functionality for macOS using Shortcuts app or Raycast

# Configuration - Modify these paths and settings as needed
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
PYTHON_SCRIPT="$PROJECT_DIR/python/send_email.py"
DEFAULT_RECIPIENT="alice@example.com"
DEFAULT_SUBJECT="Quick Message"
DEFAULT_BODY="Hello,

Best regards,
[Your Name]"

# Log file for debugging
LOG_FILE="$HOME/.gmail-hotkey-sender/mac-shortcut.log"

# Ensure log directory exists
mkdir -p "$(dirname "$LOG_FILE")"

# Logging function
log_message() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" >> "$LOG_FILE"
}

# Function to send a quick email with default settings
send_quick_email() {
    log_message "Sending quick email to $DEFAULT_RECIPIENT"
    
    # Check if Python script exists
    if [ ! -f "$PYTHON_SCRIPT" ]; then
        log_message "ERROR: Python script not found at $PYTHON_SCRIPT"
        osascript -e 'display notification "Python script not found" with title "Gmail Hotkey Sender"'
        return 1
    fi
    
    # Execute the Python script
    python3 "$PYTHON_SCRIPT" \
        --to "$DEFAULT_RECIPIENT" \
        --subject "$DEFAULT_SUBJECT" \
        --body "$DEFAULT_BODY"
    
    if [ $? -eq 0 ]; then
        log_message "Quick email sent successfully"
        osascript -e "display notification \"Quick email sent to $DEFAULT_RECIPIENT\" with title \"Gmail Hotkey Sender\""
    else
        log_message "ERROR: Failed to send quick email"
        osascript -e 'display notification "Failed to send email" with title "Gmail Hotkey Sender"'
    fi
}

# Function to compose email with custom recipient
compose_custom_email() {
    log_message "Starting custom email composition"
    
    # Check if Python script exists
    if [ ! -f "$PYTHON_SCRIPT" ]; then
        log_message "ERROR: Python script not found at $PYTHON_SCRIPT"
        osascript -e 'display notification "Python script not found" with title "Gmail Hotkey Sender"'
        return 1
    fi
    
    # Prompt for recipient using AppleScript
    recipient=$(osascript -e 'text returned of (display dialog "Enter recipient email address:" default answer "" buttons {"Cancel", "OK"} default button "OK")')
    if [ $? -ne 0 ] || [ -z "$recipient" ]; then
        log_message "User cancelled recipient input"
        return 1
    fi
    
    # Prompt for subject
    subject=$(osascript -e "text returned of (display dialog \"Enter email subject:\" default answer \"$DEFAULT_SUBJECT\" buttons {\"Cancel\", \"OK\"} default button \"OK\")")
    if [ $? -ne 0 ]; then
        log_message "User cancelled subject input"
        return 1
    fi
    
    # Prompt for body
    body=$(osascript -e "text returned of (display dialog \"Enter email body:\" default answer \"$DEFAULT_BODY\" buttons {\"Cancel\", \"OK\"} default button \"OK\" with icon note)")
    if [ $? -ne 0 ]; then
        log_message "User cancelled body input"
        return 1
    fi
    
    log_message "Sending custom email to $recipient"
    
    # Execute the Python script
    python3 "$PYTHON_SCRIPT" \
        --to "$recipient" \
        --subject "$subject" \
        --body "$body"
    
    if [ $? -eq 0 ]; then
        log_message "Custom email sent successfully"
        osascript -e "display notification \"Email sent to $recipient\" with title \"Gmail Hotkey Sender\""
    else
        log_message "ERROR: Failed to send custom email"
        osascript -e 'display notification "Failed to send email" with title "Gmail Hotkey Sender"'
    fi
}

# Function to open Gmail compose in browser
open_gmail_compose() {
    log_message "Opening Gmail compose in browser"
    
    # URL encode the parameters
    encoded_recipient=$(printf '%s' "$DEFAULT_RECIPIENT" | jq -sRr @uri)
    encoded_subject=$(printf '%s' "$DEFAULT_SUBJECT" | jq -sRr @uri)
    encoded_body=$(printf '%s' "$DEFAULT_BODY" | jq -sRr @uri)
    
    # Build Gmail compose URL
    compose_url="https://mail.google.com/mail/u/0/#compose?to=$encoded_recipient&subject=$encoded_subject&body=$encoded_body"
    
    # Open in default browser
    open "$compose_url"
    
    log_message "Gmail compose opened in browser"
    osascript -e 'display notification "Gmail compose opened in browser" with title "Gmail Hotkey Sender"'
}

# Function to send current email (placeholder for Gmail integration)
send_current_email() {
    log_message "Send current email - Not yet implemented"
    osascript -e 'display notification "Send current email - Not yet implemented" with title "Gmail Hotkey Sender"'
}

# Function to show help/status
show_help() {
    help_text="Gmail Hotkey Sender - Available Functions:

1. send_quick_email - Send email with default settings
2. compose_custom_email - Compose email with custom recipient
3. open_gmail_compose - Open Gmail compose in browser
4. send_current_email - Send current email (Gmail) - Not implemented
5. show_help - Show this help

Current settings:
Python script: $PYTHON_SCRIPT
Default recipient: $DEFAULT_RECIPIENT
Log file: $LOG_FILE

Usage: $0 [function_name]"
    
    echo "$help_text"
    osascript -e "display dialog \"$help_text\" buttons {\"OK\"} default button \"OK\" with title \"Gmail Hotkey Sender Help\""
}

# Function to check dependencies
check_dependencies() {
    log_message "Checking dependencies"
    
    # Check if Python 3 is available
    if ! command -v python3 &> /dev/null; then
        log_message "ERROR: Python 3 is not installed"
        osascript -e 'display notification "Python 3 is not installed" with title "Gmail Hotkey Sender"'
        return 1
    fi
    
    # Check if jq is available (for URL encoding)
    if ! command -v jq &> /dev/null; then
        log_message "WARNING: jq is not installed - URL encoding may not work properly"
    fi
    
    # Check if Python script exists
    if [ ! -f "$PYTHON_SCRIPT" ]; then
        log_message "WARNING: Python script not found at $PYTHON_SCRIPT"
    fi
    
    log_message "Dependency check completed"
}

# Main execution
main() {
    log_message "Script started with arguments: $*"
    
    # Check dependencies
    check_dependencies
    
    # Parse command line arguments
    case "${1:-send_quick_email}" in
        "send_quick_email"|"quick")
            send_quick_email
            ;;
        "compose_custom_email"|"compose")
            compose_custom_email
            ;;
        "open_gmail_compose"|"open")
            open_gmail_compose
            ;;
        "send_current_email"|"send")
            send_current_email
            ;;
        "show_help"|"help"|"-h"|"--help")
            show_help
            ;;
        *)
            log_message "Unknown function: $1"
            echo "Unknown function: $1"
            echo "Use '$0 help' for available functions"
            ;;
    esac
    
    log_message "Script completed"
}

# Run main function with all arguments
main "$@"
