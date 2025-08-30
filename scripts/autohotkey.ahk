#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
#Warn   ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

; Gmail Hotkey Sender - AutoHotkey Script for Windows
; This script provides global hotkeys to trigger Gmail email sending

; Configuration - Modify these paths and settings as needed
GMAIL_PYTHON_SCRIPT := "C:\path\to\gmail-hotkey-sender\python\send_email.py"
DEFAULT_RECIPIENT := "alice@example.com"
DEFAULT_SUBJECT := "Quick Message"
DEFAULT_BODY := "Hello,`n`nBest regards,`n[Your Name]"

; Hotkey: Ctrl + Alt + G - Send quick email
^!g::
    SendQuickEmail()
return

; Hotkey: Ctrl + Alt + Shift + G - Compose email with custom recipient
^!+g::
    ComposeCustomEmail()
return

; Hotkey: Ctrl + Alt + S - Send current email (if in Gmail)
^!s::
    SendCurrentEmail()
return

; Function to send a quick email with default settings
SendQuickEmail() {
    global GMAIL_PYTHON_SCRIPT, DEFAULT_RECIPIENT, DEFAULT_SUBJECT, DEFAULT_BODY
    
    ; Build the command
    command := "python """ . GMAIL_PYTHON_SCRIPT . """"
    command .= " --to """ . DEFAULT_RECIPIENT . """"
    command .= " --subject """ . DEFAULT_SUBJECT . """"
    command .= " --body """ . DEFAULT_BODY . """"
    
    ; Execute the command
    Run, %command%, , Hide
    
    ; Show notification
    TrayTip, Gmail Hotkey Sender, Quick email sent to %DEFAULT_RECIPIENT%, 2
}

; Function to compose email with custom recipient
ComposeCustomEmail() {
    global GMAIL_PYTHON_SCRIPT, DEFAULT_SUBJECT, DEFAULT_BODY
    
    ; Prompt for recipient
    InputBox, recipient, Gmail Hotkey Sender, Enter recipient email address:,, 400, 150
    if (ErrorLevel) {
        return  ; User cancelled
    }
    
    ; Prompt for subject
    InputBox, subject, Gmail Hotkey Sender, Enter email subject:,, 400, 150, , , , , , %DEFAULT_SUBJECT%
    if (ErrorLevel) {
        return  ; User cancelled
    }
    
    ; Prompt for body
    InputBox, body, Gmail Hotkey Sender, Enter email body:,, 400, 300, , , , , , %DEFAULT_BODY%
    if (ErrorLevel) {
        return  ; User cancelled
    }
    
    ; Build the command
    command := "python """ . GMAIL_PYTHON_SCRIPT . """"
    command .= " --to """ . recipient . """"
    command .= " --subject """ . subject . """"
    command .= " --body """ . body . """"
    
    ; Execute the command
    Run, %command%, , Hide
    
    ; Show notification
    TrayTip, Gmail Hotkey Sender, Email sent to %recipient%, 2
}

; Function to send current email (placeholder for Gmail integration)
SendCurrentEmail() {
    ; TODO: Implement Gmail web interface automation
    ; This could use browser automation or Gmail API
    
    TrayTip, Gmail Hotkey Sender, Send current email - Not yet implemented, 2
}

; Function to open Gmail compose in browser
OpenGmailCompose() {
    global DEFAULT_RECIPIENT, DEFAULT_SUBJECT, DEFAULT_BODY
    
    ; Build Gmail compose URL
    composeUrl := "https://mail.google.com/mail/u/0/#compose"
    composeUrl .= "?to=" . UriEncode(DEFAULT_RECIPIENT)
    composeUrl .= "&subject=" . UriEncode(DEFAULT_SUBJECT)
    composeUrl .= "&body=" . UriEncode(DEFAULT_BODY)
    
    ; Open in default browser
    Run, %composeUrl%
}

; Hotkey: Ctrl + Alt + O - Open Gmail compose in browser
^!o::
    OpenGmailCompose()
return

; Function to encode URI components
UriEncode(str) {
    ; Simple URI encoding - replace spaces and special characters
    str := RegExReplace(str, " ", "%%20")
    str := RegExReplace(str, "`n", "%%0A")
    str := RegExReplace(str, "`r", "%%0D")
    return str
}

; Function to show help/status
ShowHelp() {
    global GMAIL_PYTHON_SCRIPT, DEFAULT_RECIPIENT
    helpText := "Gmail Hotkey Sender - Available Hotkeys:`n`n"
    helpText .= "Ctrl + Alt + G: Send quick email`n"
    helpText .= "Ctrl + Alt + Shift + G: Compose custom email`n"
    helpText .= "Ctrl + Alt + S: Send current email (Gmail)`n"
    helpText .= "Ctrl + Alt + O: Open Gmail compose in browser`n"
    helpText .= "Ctrl + Alt + H: Show this help`n`n"
    helpText .= "Current settings:`n"
    helpText .= "Python script: " . GMAIL_PYTHON_SCRIPT . "`n"
    helpText .= "Default recipient: " . DEFAULT_RECIPIENT
    
    MsgBox, %helpText%
}

; Hotkey: Ctrl + Alt + H - Show help
^!h::
    ShowHelp()
return

; Auto-execute section - runs when script starts
#SingleInstance Force  ; Ensure only one instance runs

; Show startup notification
TrayTip, Gmail Hotkey Sender, Script loaded successfully!`nPress Ctrl+Alt+H for help, 3

; TODO: Add configuration file support
; TODO: Add logging functionality
; TODO: Add error handling for missing Python script
; TODO: Add support for different email templates
; TODO: Add rate limiting to prevent spam
