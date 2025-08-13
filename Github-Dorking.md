Finding **unclaimed internal package names** for use in **dependency confusion testing** is a powerful recon strategy in bug bounty. Below is a guide on how to search GitHub for potential targets in **npm (JavaScript), pip (Python), and gem (Ruby)** — and verify if they’re unclaimed.

---

## 🚨 Ethical Reminder

Use these methods **only** in authorized environments (e.g., bug bounty programs that allow supply chain attacks). Unauthorized testing is illegal and unethical.

---

## 🔍 1. **GitHub Dorking for Package Names**

GitHub search syntax can help extract private-looking package names from public repos.

### 🔹 For **npm (Node.js)**

Search for internal packages in `package.json` or `yarn.lock`:

```text
filename:package.json "internal-" OR "private-" OR "@company/"
filename:package-lock.json "resolved"
filename:yarn.lock "resolved"
```

Example:

```text
filename:package.json "amazon-internal"
```

Look for custom-scoped packages:

* `@amazon/internal-logger`
* `@internal/my-lib`
* `"internal-utils": "^1.0.0"`

### 🔹 For **pip (Python)**

Search in `requirements.txt` or `setup.py`:

```text
filename:requirements.txt "internal" OR "private"
filename:setup.py "install_requires"
```

Example:

```text
filename:requirements.txt "company-internal-lib"
```

Also search for extra index usage:

```text
"--extra-index-url" "internal"
```

### 🔹 For **Ruby gems**

Search in `Gemfile` or `gemspec`:

```text
filename:Gemfile "gem"
filename:*.gemspec "s.add_dependency"
```

Example:

```text
filename:Gemfile "mycompany-private-gem"
```

---

## ⚙️ 2. **Extract and Collect Package Names**

Once you find repos with internal packages:

1. Collect package names from the files.
2. Filter those that **sound private/internal** (e.g., `internal-api`, `@corp/logger`, `company-lib-x`).
3. Store them in a list (e.g., `suspicious_packages.txt`).

---

## 🧪 3. **Check If Packages Are Claimed on Registries**

You can manually or programmatically check if a package exists.

### 🟩 **npm:**

```bash
npm view <package-name>
```

If unclaimed:

```
npm ERR! 404 Not Found
```

Or try:

```bash
curl -s https://registry.npmjs.org/<package-name>
```

If it returns a 404 or empty `{}`, it's likely unclaimed.

---

### 🟨 **pip (PyPI):**

```bash
pip install <package-name>
```

Or test with:

```bash
curl -s https://pypi.org/pypi/<package-name>/json
```

Look for `"Not Found"` or HTTP 404.

---

### 🟥 **RubyGems:**

```bash
gem search ^<package-name>$ --remote
```

Or test with:

```bash
curl -s https://rubygems.org/api/v1/gems/<package-name>.json
```

404 = unclaimed.

---

## ⚡ Optional: Automate It

Would you like a small script to:

* Take a list of package names
* Check them against npm, PyPI, and RubyGems
* Output which are unclaimed?

I can generate that in Python or Bash for you.

Let me know what language you prefer, and I’ll set you up.
