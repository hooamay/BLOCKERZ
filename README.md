<p align="center">
  <img src="browser.png" alt="Website Blocker Logo" width="80" />
</p>

<h1 align="center">Website Blocker v2.1</h1>

<p align="center">
  A powerful Windows batch script that blocks and unblocks websites using the <code>hosts</code> file.<br>
  Built for offline control, simple deployment, and full administrative access — all in a single terminal interface.
</p>

<hr>

## 🛠️ Features

- **Block or Unblock Specific Websites**  
  Control access to sites like `facebook.com`, `youtube.com`, etc., directly via hosts file.

- **Wildcard Support**  
  Block both `example.com` and `www.example.com` using `*.example.com`.

- **Show All Blocked Domains**  
  Instantly list all currently blocked domains with a total count.

- **Backup and Restore Hosts File**  
  Automatically backup and restore your hosts file with date-stamped versions.

- **Flush DNS After Changes**  
  Automatically flush DNS cache after blocking or unblocking for immediate effect.

- **Clear All Blocked Entries**  
  Restore your hosts file to default Windows-safe content.

- **Valid Domain Checker**  
  Prevents malformed input with built-in domain format validation.

---

## ⚙️ How to Use

### 🧰 Requirements
- Windows machine (tested on Windows 10/11)
- Run script as **Administrator**
- Console (CMD or PowerShell)

### 🚀 Installation
1. Download or clone this repo.
2. Place `website_blocker.bat` anywhere.
3. Right-click → **Run as administrator**.
4. Use the numbered menu to block/unblock websites.

---

## 🔢 Menu Options


---

## 💡 Usage Examples

- Block only `facebook.com`:  
  → Input: `facebook.com`

- Block both `facebook.com` and `www.facebook.com`:  
  → Input: `*.facebook.com`

- Unblock any site:  
  → Use the **Unblock** option and enter the domain as you blocked it.

- Exit from input prompt:  
  → Type `exit` or `e` at any prompt to cancel.

---

## ⚠️ Disclaimer

This tool edits the Windows system hosts file. Misuse may cause connectivity issues or DNS failures. Always use the **backup** and **restore** features before modifying system files. Built for **educational and personal use only**.

---

## Developer

> Developed by **huwamee**   
> Contributions welcome — fork, modify, and improve!

---

## 📜 License

MIT License © 2025 huwamee

Permission is hereby granted, free of charge, to any person obtaining a copy  
of this software and associated documentation files (the "Software"), to deal  
in the Software without restriction, including without limitation the rights  
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell  
copies of the Software, and to permit persons to whom the Software is  
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in  
all copies or substantial portions of the Software.

**THE SOFTWARE IS PROVIDED "AS IS"**, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR  
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,  
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE  
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER  
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,  
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN  
THE SOFTWARE.
