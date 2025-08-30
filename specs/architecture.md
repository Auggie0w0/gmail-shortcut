# 📐 Architecture: gmail-hotkey-sender

## Overview

This project is a **multi-language scaffold** for building tools that allow users to send Gmail emails using a **global keyboard shortcut**. It's intended to be modular, platform-agnostic, and extensible — allowing developers to build their own versions across CLI, GUI, and browser contexts.

The project consists of language-specific folders, cross-platform hotkey scripts, and a shared architecture goal: trigger Gmail email sending via **pre-filled input**, with as little manual interaction as possible.

---

## 🧱 Core Components

### 1. 🔑 **Auth Layer**
- Uses **Gmail API** with **OAuth2** credentials
- Each language implementation will handle:
  - `credentials.json` from Google Cloud Console
  - Storing and refreshing `access_token`
  - Sending messages via Gmail's `messages.send` endpoint

### 2. ⌨️ **Hotkey Trigger Layer**
- Platform-specific:
  - **AutoHotkey** on Windows
  - **Shortcuts app or Raycast** on macOS
  - **xdotool or sxhkd** on Linux
- These call scripts in `/python`, `/nodejs`, etc., via command-line

### 3. 📬 **Email Composition Layer**
- Arguments passed into CLI or defined statically in script
  - Example: `--to alice@example.com --subject "Ping" --body "Message"`
- Future plan: use templates, external JSON/YAML config, or GUI prompt

### 4. 🚀 **Email Send Layer**
- Constructs the MIME message
- Base64 encodes it
- Sends it via Gmail API:

```
POST https://gmail.googleapis.com/gmail/v1/users/me/messages/send
```

---

## 🌐 Language Modules

Each language is sandboxed inside its folder:

| Language | Key Libraries | Notes |
|----------|---------------|-------|
| Python | `google-api-python-client`, `argparse` | Simplest starting point |
| Node.js | `googleapis`, `commander` | Ideal for async web flows |
| Go | `gmail/v1`, `spf13/cobra` | Great for speed, binaries |
| Rust | `clap`, `yup-oauth2`, `gmail-rs` | Best for performance |
| JS (Web Ext) | Chrome extension APIs | Only supports "Compose", not send |

---

## 🔐 Gmail API Scopes

```json
[
  "https://www.googleapis.com/auth/gmail.send"
]
```

---

## 🚦 Rate Limiting & Abuse

To avoid being flagged as spam by Gmail:
- Implement minimum delay between messages
- Rotate subject/body slightly
- Limit recipients (e.g. max 10 per minute)
- Use labels to tag sent messages

---

## 🧪 Future Add-ons
- Message logging
- Configurable templates
- Auto-reply / schedule-sending
- OAuth2 GUI helper
- In-app settings menu (GUI wrapper)

---

## 🔗 References
- Gmail API: https://developers.google.com/gmail/api
- OAuth2: https://developers.google.com/identity/protocols/oauth2
- MIME standards: https://tools.ietf.org/html/rfc2045

---

This doc is stored at: `specs/architecture.md`
