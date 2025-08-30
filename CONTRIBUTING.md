# 🤝 Contributing to gmail-hotkey-sender

Thank you for your interest in contributing! This project is an open, multi-language scaffold intended to demonstrate how Gmail email automation could be triggered via keyboard shortcuts across different platforms.

We're building a community-driven repo that supports various implementations, so your ideas, code, or documentation are very welcome!

---

## 🧠 What You Can Help With

- ✨ Implement email sending in:
  - Python (`python/send_email.py`)
  - Node.js (`nodejs/send_email.js`)
  - Go (`go/main.go`)
  - Rust (`rust/src/main.rs`)
- 🧪 Add OAuth2 + Gmail API integration
- 📚 Improve documentation (`README.md`, `specs/`)
- 🖱️ Add GUI wrappers (e.g., Tkinter, Electron)
- 🌐 Enhance the browser extension version
- ⌨️ Add or improve platform-specific hotkey support
- 🧪 Write tests (where applicable)
- 🐛 Fix bugs or refactor existing code

---

## 📦 Project Structure

Each language-specific folder contains a basic stub. You can pick one and:
- Add full email-sending logic using the Gmail API
- Write a CLI interface with flags or inputs
- Log sent messages or errors
- Securely store and refresh credentials (OAuth2)

---

## 🧰 Tools by Language (Suggested)

| Language | Suggested Tools |
|----------|------------------|
| Python   | `google-api-python-client`, `argparse` |
| Node.js  | `googleapis`, `commander` |
| Go       | `google.golang.org/api/gmail/v1`, `spf13/cobra` |
| Rust     | `clap`, `yup-oauth2`, `gmail-rs` |
| JS (Web) | Chrome Extensions, `manifest.json`, `chrome.runtime.*` |

---

## 🛡️ Guidelines

- Keep your code clean and commented
- Use placeholder credentials — never upload secrets
- Make sure your scripts can run standalone (`python send_email.py`)
- Match the file layout and naming conventions already in place
- Submit PRs to relevant folders only (don't cross language folders)

---

## 🧪 Testing (Optional for Now)

There are no formal tests yet, but you may include test files in a `/tests/` subfolder in your language's directory.

---

## 📥 Submitting Changes

1. Fork the repo
2. Create a new branch (`git checkout -b feature/my-contribution`)
3. Commit your changes (`git commit -am 'Add X feature'`)
4. Push to your fork (`git push origin feature/my-contribution`)
5. Open a Pull Request

---

Thanks for helping build the foundation for a flexible, multi-language Gmail automation toolkit!
