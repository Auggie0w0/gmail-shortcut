#!/usr/bin/env node
/**
 * Gmail Hotkey Sender - Node.js Implementation
 * 
 * A CLI tool for sending Gmail emails via keyboard shortcuts.
 * This is a starter implementation that requires Gmail API setup.
 */

const fs = require('fs');
const path = require('path');
const os = require('os');

// TODO: Add these imports when implementing Gmail API
// const { google } = require('googleapis');
// const { OAuth2Client } = require('google-auth-library');

/**
 * Gmail email sender using Gmail API
 */
class GmailSender {
    constructor(configPath = null) {
        this.configPath = configPath || this.getDefaultConfigPath();
        this.config = this.loadConfig();
        this.auth = null;
        this.gmail = null;
    }

    /**
     * Get the default configuration file path
     */
    getDefaultConfigPath() {
        const configDir = path.join(os.homedir(), '.gmail-hotkey-sender');
        if (!fs.existsSync(configDir)) {
            fs.mkdirSync(configDir, { recursive: true });
        }
        return path.join(configDir, 'config.json');
    }

    /**
     * Load configuration from file
     */
    loadConfig() {
        if (fs.existsSync(this.configPath)) {
            try {
                const configData = fs.readFileSync(this.configPath, 'utf8');
                return JSON.parse(configData);
            } catch (error) {
                console.warn(`Invalid JSON in config file: ${this.configPath}`);
            }
        }

        // Default configuration
        const defaultConfig = {
            credentialsFile: 'credentials.json',
            tokenFile: 'token.json',
            defaultSubject: '',
            defaultBody: '',
            rateLimit: 100, // emails per day
            logSentEmails: true
        };

        // Save default config
        this.saveConfig(defaultConfig);
        return defaultConfig;
    }

    /**
     * Save configuration to file
     */
    saveConfig(config) {
        try {
            fs.writeFileSync(this.configPath, JSON.stringify(config, null, 2));
        } catch (error) {
            console.error(`Failed to save config: ${error.message}`);
        }
    }

    /**
     * Authenticate with Gmail API
     */
    async authenticate() {
        // TODO: Implement Gmail API authentication
        console.log('Gmail API authentication not yet implemented');
        console.log('Please implement OAuth2 flow with googleapis');
        return false;
    }

    /**
     * Send an email via Gmail API
     */
    async sendEmail(to, subject, body, cc = null, bcc = null, htmlBody = null) {
        if (!this.gmail) {
            if (!(await this.authenticate())) {
                console.error('Failed to authenticate with Gmail API');
                return false;
            }
        }

        try {
            // TODO: Implement actual email sending with Gmail API
            console.log(`Would send email to: ${to}`);
            console.log(`Subject: ${subject}`);
            console.log(`Body: ${body.substring(0, 100)}...`);

            // Log the email if enabled
            if (this.config.logSentEmails) {
                this.logEmail(to, subject, body);
            }

            return true;
        } catch (error) {
            console.error(`Failed to send email: ${error.message}`);
            return false;
        }
    }

    /**
     * Log sent email details
     */
    logEmail(to, subject, body) {
        const logDir = path.join(os.homedir(), '.gmail-hotkey-sender', 'logs');
        if (!fs.existsSync(logDir)) {
            fs.mkdirSync(logDir, { recursive: true });
        }

        const logFile = path.join(logDir, 'sent_emails.log');
        const timestamp = new Date().toISOString();
        const logEntry = `${timestamp} | To: ${to} | Subject: ${subject}\n`;

        fs.appendFileSync(logFile, logEntry);
    }

    /**
     * Create a draft email in Gmail
     */
    async createDraft(to, subject, body) {
        // TODO: Implement draft creation
        console.log(`Would create draft to: ${to}`);
        return true;
    }
}

/**
 * Parse command line arguments
 */
function parseArgs() {
    const args = process.argv.slice(2);
    const parsed = {
        to: null,
        subject: '',
        body: '',
        cc: null,
        bcc: null,
        html: null,
        draft: false,
        config: null,
        verbose: false
    };

    for (let i = 0; i < args.length; i++) {
        const arg = args[i];
        
        switch (arg) {
            case '--to':
            case '-t':
                parsed.to = args[++i];
                break;
            case '--subject':
            case '-s':
                parsed.subject = args[++i];
                break;
            case '--body':
            case '-b':
                parsed.body = args[++i];
                break;
            case '--cc':
                parsed.cc = args[++i].split(',');
                break;
            case '--bcc':
                parsed.bcc = args[++i].split(',');
                break;
            case '--html':
                parsed.html = args[++i];
                break;
            case '--draft':
                parsed.draft = true;
                break;
            case '--config':
                parsed.config = args[++i];
                break;
            case '--verbose':
            case '-v':
                parsed.verbose = true;
                break;
            case '--help':
            case '-h':
                showHelp();
                process.exit(0);
                break;
        }
    }

    return parsed;
}

/**
 * Show help information
 */
function showHelp() {
    console.log(`
Gmail Hotkey Sender - Node.js Implementation

Usage: node send_email.js [options]

Options:
  --to, -t <email>        Recipient email address(es) (required)
  --subject, -s <text>    Email subject
  --body, -b <text>       Email body
  --cc <emails>           CC recipient(s) (comma-separated)
  --bcc <emails>          BCC recipient(s) (comma-separated)
  --html <html>           HTML email body (optional)
  --draft                 Create draft instead of sending
  --config <path>         Path to configuration file
  --verbose, -v           Enable verbose logging
  --help, -h              Show this help message

Examples:
  node send_email.js --to alice@example.com --subject "Test" --body "Hello"
  node send_email.js -t bob@example.com -s "Meeting" -b "Reminder" --draft
`);
}

/**
 * Main function
 */
async function main() {
    const args = parseArgs();

    if (args.verbose) {
        // Enable verbose logging
        console.log('Verbose mode enabled');
    }

    if (!args.to) {
        console.error('Error: --to argument is required');
        showHelp();
        process.exit(1);
    }

    // Initialize Gmail sender
    const sender = new GmailSender(args.config);

    try {
        // Send or create draft
        let success;
        if (args.draft) {
            success = await sender.createDraft(args.to, args.subject, args.body);
        } else {
            success = await sender.sendEmail(
                args.to,
                args.subject,
                args.body,
                args.cc,
                args.bcc,
                args.html
            );
        }

        if (success) {
            console.log('Operation completed successfully');
            process.exit(0);
        } else {
            console.error('Operation failed');
            process.exit(1);
        }
    } catch (error) {
        console.error(`Unexpected error: ${error.message}`);
        process.exit(1);
    }
}

// Run the main function if this file is executed directly
if (require.main === module) {
    main();
}

module.exports = { GmailSender };
