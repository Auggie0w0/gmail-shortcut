use clap::{App, Arg};
use serde::{Deserialize, Serialize};
use std::collections::HashMap;
use std::fs;
use std::path::PathBuf;
use std::process;

// TODO: Add these dependencies to Cargo.toml when implementing Gmail API
// use yup_oauth2::{InstalledFlowAuthenticator, InstalledFlowReturnMethod};
// use gmail_rs::GmailClient;

#[derive(Debug, Serialize, Deserialize)]
struct Config {
    credentials_file: String,
    token_file: String,
    default_subject: String,
    default_body: String,
    rate_limit: u32,
    log_sent_emails: bool,
}

impl Default for Config {
    fn default() -> Self {
        Config {
            credentials_file: "credentials.json".to_string(),
            token_file: "token.json".to_string(),
            default_subject: "".to_string(),
            default_body: "".to_string(),
            rate_limit: 100,
            log_sent_emails: true,
        }
    }
}

struct GmailSender {
    config_path: PathBuf,
    config: Config,
    // TODO: Add Gmail client
    // client: Option<GmailClient>,
}

impl GmailSender {
    fn new(config_path: Option<PathBuf>) -> Self {
        let config_path = config_path.unwrap_or_else(Self::get_default_config_path);
        let config = Self::load_config(&config_path);

        GmailSender {
            config_path,
            config,
        }
    }

    fn get_default_config_path() -> PathBuf {
        let home_dir = dirs::home_dir().expect("Failed to get home directory");
        let config_dir = home_dir.join(".gmail-hotkey-sender");
        fs::create_dir_all(&config_dir).expect("Failed to create config directory");
        config_dir.join("config.json")
    }

    fn load_config(config_path: &PathBuf) -> Config {
        if let Ok(data) = fs::read_to_string(config_path) {
            if let Ok(config) = serde_json::from_str(&data) {
                return config;
            } else {
                eprintln!("Invalid JSON in config file: {:?}", config_path);
            }
        }

        // Create default config
        let config = Config::default();
        Self::save_config(config_path, &config);
        config
    }

    fn save_config(config_path: &PathBuf, config: &Config) {
        if let Ok(data) = serde_json::to_string_pretty(config) {
            if let Err(e) = fs::write(config_path, data) {
                eprintln!("Failed to save config: {}", e);
            }
        }
    }

    async fn authenticate(&mut self) -> Result<(), Box<dyn std::error::Error>> {
        // TODO: Implement Gmail API authentication
        println!("Gmail API authentication not yet implemented");
        println!("Please implement OAuth2 flow with yup-oauth2 and gmail-rs");
        Err("Authentication not implemented".into())
    }

    async fn send_email(
        &mut self,
        to: &str,
        subject: &str,
        body: &str,
        cc: Option<Vec<String>>,
        bcc: Option<Vec<String>>,
        html_body: Option<&str>,
    ) -> Result<(), Box<dyn std::error::Error>> {
        // TODO: Implement actual email sending with Gmail API
        println!("Would send email to: {}", to);
        println!("Subject: {}", subject);
        if body.len() > 100 {
            println!("Body: {}...", &body[..100]);
        } else {
            println!("Body: {}", body);
        }

        // Log the email if enabled
        if self.config.log_sent_emails {
            self.log_email(to, subject, body)?;
        }

        Ok(())
    }

    fn log_email(&self, to: &str, subject: &str, body: &str) -> Result<(), Box<dyn std::error::Error>> {
        let home_dir = dirs::home_dir().expect("Failed to get home directory");
        let log_dir = home_dir.join(".gmail-hotkey-sender").join("logs");
        fs::create_dir_all(&log_dir)?;

        let log_file = log_dir.join("sent_emails.log");
        let timestamp = chrono::Utc::now().format("%Y-%m-%d %H:%M:%S");
        let log_entry = format!("{} | To: {} | Subject: {}\n", timestamp, to, subject);

        fs::OpenOptions::new()
            .create(true)
            .append(true)
            .open(log_file)?
            .write_all(log_entry.as_bytes())?;

        Ok(())
    }

    async fn create_draft(&mut self, to: &str, subject: &str, body: &str) -> Result<(), Box<dyn std::error::Error>> {
        // TODO: Implement draft creation
        println!("Would create draft to: {}", to);
        Ok(())
    }
}

#[tokio::main]
async fn main() {
    let matches = App::new("Gmail Hotkey Sender")
        .version("1.0")
        .about("Send Gmail emails via CLI with hotkey support")
        .arg(
            Arg::with_name("to")
                .short("t")
                .long("to")
                .value_name("EMAIL")
                .help("Recipient email address(es)")
                .required(true)
                .takes_value(true),
        )
        .arg(
            Arg::with_name("subject")
                .short("s")
                .long("subject")
                .value_name("TEXT")
                .help("Email subject")
                .takes_value(true),
        )
        .arg(
            Arg::with_name("body")
                .short("b")
                .long("body")
                .value_name("TEXT")
                .help("Email body")
                .takes_value(true),
        )
        .arg(
            Arg::with_name("cc")
                .long("cc")
                .value_name("EMAILS")
                .help("CC recipient(s) (comma-separated)")
                .takes_value(true),
        )
        .arg(
            Arg::with_name("bcc")
                .long("bcc")
                .value_name("EMAILS")
                .help("BCC recipient(s) (comma-separated)")
                .takes_value(true),
        )
        .arg(
            Arg::with_name("html")
                .long("html")
                .value_name("HTML")
                .help("HTML email body (optional)")
                .takes_value(true),
        )
        .arg(
            Arg::with_name("draft")
                .long("draft")
                .help("Create draft instead of sending"),
        )
        .arg(
            Arg::with_name("config")
                .long("config")
                .value_name("PATH")
                .help("Path to configuration file")
                .takes_value(true),
        )
        .arg(
            Arg::with_name("verbose")
                .short("v")
                .long("verbose")
                .help("Enable verbose logging"),
        )
        .get_matches();

    if matches.is_present("verbose") {
        println!("Verbose mode enabled");
    }

    let to = matches.value_of("to").unwrap();
    let subject = matches.value_of("subject").unwrap_or("");
    let body = matches.value_of("body").unwrap_or("");
    let cc = matches.value_of("cc").map(|s| s.split(',').map(|s| s.to_string()).collect());
    let bcc = matches.value_of("bcc").map(|s| s.split(',').map(|s| s.to_string()).collect());
    let html = matches.value_of("html");
    let draft = matches.is_present("draft");
    let config_path = matches.value_of("config").map(PathBuf::from);

    // Initialize Gmail sender
    let mut sender = GmailSender::new(config_path);

    // Send or create draft
    let result = if draft {
        sender.create_draft(to, subject, body).await
    } else {
        sender.send_email(to, subject, body, cc, bcc, html).await
    };

    match result {
        Ok(_) => {
            println!("Operation completed successfully");
        }
        Err(e) => {
            eprintln!("Operation failed: {}", e);
            process::exit(1);
        }
    }
}
