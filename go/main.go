package main

import (
	"encoding/json"
	"fmt"
	"log"
	"os"
	"path/filepath"
	"strings"
	"time"

	// TODO: Add these imports when implementing Gmail API
	// "golang.org/x/oauth2"
	// "golang.org/x/oauth2/google"
	// "google.golang.org/api/gmail/v1"
	// "google.golang.org/api/option"
)

// Config represents the application configuration
type Config struct {
	CredentialsFile string `json:"credentials_file"`
	TokenFile       string `json:"token_file"`
	DefaultSubject  string `json:"default_subject"`
	DefaultBody     string `json:"default_body"`
	RateLimit       int    `json:"rate_limit"`
	LogSentEmails   bool   `json:"log_sent_emails"`
}

// GmailSender handles Gmail email operations
type GmailSender struct {
	configPath string
	config     Config
	// TODO: Add Gmail service client
	// service *gmail.Service
}

// NewGmailSender creates a new Gmail sender instance
func NewGmailSender(configPath string) *GmailSender {
	if configPath == "" {
		configPath = getDefaultConfigPath()
	}

	return &GmailSender{
		configPath: configPath,
		config:     loadConfig(configPath),
	}
}

// getDefaultConfigPath returns the default configuration file path
func getDefaultConfigPath() string {
	homeDir, err := os.UserHomeDir()
	if err != nil {
		log.Fatal("Failed to get home directory:", err)
	}

	configDir := filepath.Join(homeDir, ".gmail-hotkey-sender")
	if err := os.MkdirAll(configDir, 0755); err != nil {
		log.Fatal("Failed to create config directory:", err)
	}

	return filepath.Join(configDir, "config.json")
}

// loadConfig loads configuration from file
func loadConfig(configPath string) Config {
	// Default configuration
	defaultConfig := Config{
		CredentialsFile: "credentials.json",
		TokenFile:       "token.json",
		DefaultSubject:  "",
		DefaultBody:     "",
		RateLimit:       100, // emails per day
		LogSentEmails:   true,
	}

	// Try to load existing config
	data, err := os.ReadFile(configPath)
	if err != nil {
		// Config file doesn't exist, save default config
		saveConfig(configPath, defaultConfig)
		return defaultConfig
	}

	// Parse existing config
	var config Config
	if err := json.Unmarshal(data, &config); err != nil {
		log.Printf("Invalid JSON in config file: %s", configPath)
		saveConfig(configPath, defaultConfig)
		return defaultConfig
	}

	return config
}

// saveConfig saves configuration to file
func saveConfig(configPath string, config Config) {
	data, err := json.MarshalIndent(config, "", "  ")
	if err != nil {
		log.Printf("Failed to marshal config: %v", err)
		return
	}

	if err := os.WriteFile(configPath, data, 0644); err != nil {
		log.Printf("Failed to save config: %v", err)
	}
}

// authenticate authenticates with Gmail API
func (g *GmailSender) authenticate() error {
	// TODO: Implement Gmail API authentication
	fmt.Println("Gmail API authentication not yet implemented")
	fmt.Println("Please implement OAuth2 flow with google.golang.org/api/gmail/v1")
	return fmt.Errorf("authentication not implemented")
}

// SendEmail sends an email via Gmail API
func (g *GmailSender) SendEmail(to, subject, body string, cc, bcc []string, htmlBody string) error {
	// TODO: Implement actual email sending with Gmail API
	fmt.Printf("Would send email to: %s\n", to)
	fmt.Printf("Subject: %s\n", subject)
	if len(body) > 100 {
		fmt.Printf("Body: %s...\n", body[:100])
	} else {
		fmt.Printf("Body: %s\n", body)
	}

	// Log the email if enabled
	if g.config.LogSentEmails {
		g.logEmail(to, subject, body)
	}

	return nil
}

// logEmail logs sent email details
func (g *GmailSender) logEmail(to, subject, body string) {
	homeDir, err := os.UserHomeDir()
	if err != nil {
		log.Printf("Failed to get home directory: %v", err)
		return
	}

	logDir := filepath.Join(homeDir, ".gmail-hotkey-sender", "logs")
	if err := os.MkdirAll(logDir, 0755); err != nil {
		log.Printf("Failed to create log directory: %v", err)
		return
	}

	logFile := filepath.Join(logDir, "sent_emails.log")
	timestamp := time.Now().Format("2006-01-02 15:04:05")
	logEntry := fmt.Sprintf("%s | To: %s | Subject: %s\n", timestamp, to, subject)

	file, err := os.OpenFile(logFile, os.O_APPEND|os.O_CREATE|os.O_WRONLY, 0644)
	if err != nil {
		log.Printf("Failed to open log file: %v", err)
		return
	}
	defer file.Close()

	if _, err := file.WriteString(logEntry); err != nil {
		log.Printf("Failed to write to log file: %v", err)
	}
}

// CreateDraft creates a draft email in Gmail
func (g *GmailSender) CreateDraft(to, subject, body string) error {
	// TODO: Implement draft creation
	fmt.Printf("Would create draft to: %s\n", to)
	return nil
}

// CLI arguments structure
type Args struct {
	To      string
	Subject string
	Body    string
	CC      []string
	BCC     []string
	HTML    string
	Draft   bool
	Config  string
	Verbose bool
}

// parseArgs parses command line arguments
func parseArgs() Args {
	args := Args{}

	for i := 1; i < len(os.Args); i++ {
		arg := os.Args[i]

		switch arg {
		case "--to", "-t":
			if i+1 < len(os.Args) {
				args.To = os.Args[i+1]
				i++
			}
		case "--subject", "-s":
			if i+1 < len(os.Args) {
				args.Subject = os.Args[i+1]
				i++
			}
		case "--body", "-b":
			if i+1 < len(os.Args) {
				args.Body = os.Args[i+1]
				i++
			}
		case "--cc":
			if i+1 < len(os.Args) {
				args.CC = strings.Split(os.Args[i+1], ",")
				i++
			}
		case "--bcc":
			if i+1 < len(os.Args) {
				args.BCC = strings.Split(os.Args[i+1], ",")
				i++
			}
		case "--html":
			if i+1 < len(os.Args) {
				args.HTML = os.Args[i+1]
				i++
			}
		case "--draft":
			args.Draft = true
		case "--config":
			if i+1 < len(os.Args) {
				args.Config = os.Args[i+1]
				i++
			}
		case "--verbose", "-v":
			args.Verbose = true
		case "--help", "-h":
			showHelp()
			os.Exit(0)
		}
	}

	return args
}

// showHelp displays help information
func showHelp() {
	fmt.Println(`
Gmail Hotkey Sender - Go Implementation

Usage: go run main.go [options]

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
  go run main.go --to alice@example.com --subject "Test" --body "Hello"
  go run main.go -t bob@example.com -s "Meeting" -b "Reminder" --draft
`)
}

func main() {
	args := parseArgs()

	if args.Verbose {
		fmt.Println("Verbose mode enabled")
	}

	if args.To == "" {
		fmt.Println("Error: --to argument is required")
		showHelp()
		os.Exit(1)
	}

	// Initialize Gmail sender
	sender := NewGmailSender(args.Config)

	// Send or create draft
	var err error
	if args.Draft {
		err = sender.CreateDraft(args.To, args.Subject, args.Body)
	} else {
		err = sender.SendEmail(args.To, args.Subject, args.Body, args.CC, args.BCC, args.HTML)
	}

	if err != nil {
		fmt.Printf("Operation failed: %v\n", err)
		os.Exit(1)
	}

	fmt.Println("Operation completed successfully")
}
