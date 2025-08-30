# 📬 gmail-hotkey-sender

**A cross-platform, language-agnostic automation scaffold for sending Gmail emails using global keyboard shortcuts.**

This project is designed as a multi-language starter repository for automating Gmail email sending via hotkey-triggered scripts. It's intended for developers and automation enthusiasts who want to streamline their outbound email workflows — from productivity to high-volume (spam-like) use cases.

> ⚠️ NOTE: This project is a **conceptual starter kit** — not a working application. You will need to implement authentication and Gmail API integration to make it functional.

---

## 🚀 Project Goals

- ⌨️ Trigger email sending with a **keyboard shortcut**
- 📨 Use **Gmail API** to send messages directly
- 🔄 Support **auto-composing** with prefilled subjects and bodies
- ⚙️ Modular implementations in Python, Node.js, Go, Rust, and JavaScript
- 📦 Easily extensible for GUI wrappers or custom templates
- 🛠️ Enable contributors to build their own senders using OAuth2

---

## 🔧 Languages & Platforms

| Language   | Status   | Notes |
|------------|----------|-------|
| Python     | ✅ Starter added | `google-api-python-client` planned |
| Node.js    | ✅ Starter added | `googleapis` planned |
| Go         | ✅ Starter added | `gmail/v1` API planned |
| Rust       | ✅ Starter added | Uses `clap`, `gmail` crates |
| Web Extension | ✅ Manifest & JS placeholder | Opens Gmail in browser |
| Shell / AHK | ✅ Hotkey scripts for macOS & Windows | CLI triggers |

---

## 💻 Example Usage (Future)

```bash
# Trigger an email with CLI
python send_email.py --to "alice@example.com" --subject "Test" --body "Hi from script"

# Bind this to a hotkey on Windows (AutoHotkey) or macOS (Shortcuts)
```

---

## 🧩 Folder Structure

```
gmail-hotkey-sender/
├── python/             # Python CLI script
├── nodejs/             # Node.js script
├── go/                 # Go implementation
├── rust/               # Rust binary scaffold
├── web-extension/      # Chrome extension starter
├── scripts/            # OS-level hotkey triggers
├── specs/              # Architecture and vision docs
```

---

## 🛠️ Planned Features

- OAuth2 Gmail authentication setup
- Rate-limiting control
- HTML body support
- Logging of sent messages
- Email template system
- GUI wrapper

---

## 🤝 Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) for how to add new implementations, improve existing ones, or submit design ideas.

---

## 📜 License

MIT — see [LICENSE](LICENSE) for full text.
